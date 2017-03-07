#include "pch.h"
#include "vcpkg_Commands.h"
#include "vcpkglib.h"
#include "vcpkg_Environment.h"
#include "vcpkg_Files.h"
#include "vcpkg_System.h"
#include "vcpkg_Dependencies.h"
#include "vcpkg_Input.h"
#include "vcpkg_Chrono.h"
#include "Paragraphs.h"

namespace vcpkg::Commands::CI
{
    using Dependencies::package_spec_with_install_plan;
    using Dependencies::install_plan_type;
    using Build::BuildResult;

    static std::vector<package_spec> load_all_package_specs(const fs::path& ports_directory, const triplet& target_triplet)
    {
        std::vector<SourceParagraph> ports = Paragraphs::load_all_ports(ports_directory);
        std::vector<package_spec> specs;
        for (const SourceParagraph& p : ports)
        {
            specs.push_back(package_spec::from_name_and_triplet(p.name, target_triplet).get_or_throw());
        }

        return specs;
    }

    void perform_and_exit(const vcpkg_cmd_arguments& args, const vcpkg_paths& paths, const triplet& default_target_triplet)
    {
        static const std::string example = Commands::Help::create_example_string("ci x64-windows");
        args.check_max_arg_count(1, example);
        const triplet target_triplet = args.command_arguments.size() == 1 ? triplet::from_canonical_name(args.command_arguments.at(0)) : default_target_triplet;
        Input::check_triplet(target_triplet, paths);
        args.check_and_get_optional_command_arguments({});
        const std::vector<package_spec> specs = load_all_package_specs(paths.ports, target_triplet);

        StatusParagraphs status_db = database_load_check(paths);
        const std::vector<package_spec_with_install_plan> install_plan = Dependencies::create_install_plan(paths, specs, status_db);
        Checks::check_exit(!install_plan.empty(), "Install plan cannot be empty");

        Environment::ensure_utilities_on_path(paths);

        std::vector<BuildResult> results;
        std::vector<std::chrono::milliseconds::rep> timing;
        const ElapsedTime timer = ElapsedTime::createStarted();
        size_t counter = 0;
        const size_t package_count = install_plan.size();
        for (const package_spec_with_install_plan& action : install_plan)
        {
            const ElapsedTime build_timer = ElapsedTime::createStarted();
            counter++;
            System::println("Starting package %d/%d: %s", counter, package_count, action.spec.toString());

            timing.push_back(-1);
            results.push_back(BuildResult::NULLVALUE);

            try
            {
                if (action.plan.plan_type == install_plan_type::ALREADY_INSTALLED)
                {
                    results.back() = BuildResult::SUCCEEDED;
                    System::println(System::color::success, "Package %s is already installed", action.spec);
                }
                else if (action.plan.plan_type == install_plan_type::BUILD_AND_INSTALL)
                {
                    const BuildResult result = Commands::Build::build_package(*action.plan.source_pgh, action.spec, paths, paths.port_dir(action.spec), status_db);
                    timing.back() = build_timer.elapsed<std::chrono::milliseconds>().count();
                    results.back() = result;
                    if (result != BuildResult::SUCCEEDED)
                    {
                        System::println(System::color::error, Build::create_error_message(result, action.spec));
                        continue;
                    }
                    const BinaryParagraph bpgh = Paragraphs::try_load_cached_package(paths, action.spec).get_or_throw();
                    Install::install_package(paths, bpgh, &status_db);
                    System::println(System::color::success, "Package %s is installed", action.spec);
                }
                else if (action.plan.plan_type == install_plan_type::INSTALL)
                {
                    results.back() = BuildResult::SUCCEEDED;
                    Install::install_package(paths, *action.plan.binary_pgh, &status_db);
                    System::println(System::color::success, "Package %s is installed from cache", action.spec);
                }
                else
                    Checks::unreachable();
            }
            catch (const std::exception& e)
            {
                System::println(System::color::error, "Error: Could not install package %s: %s", action.spec, e.what());
                results.back() = BuildResult::NULLVALUE;
            }
            System::println("Elapsed time for package %s: %s", action.spec, build_timer.toString());
        }

        System::println("Total time taken: %s", timer.toString());

        for (size_t i = 0; i < results.size(); i++)
        {
            System::println("%s: %s: %dms", install_plan[i].spec.toString(), Build::to_string(results[i]), timing[i]);
        }

        std::map<BuildResult, int> summary;
        for (const BuildResult& v : Build::BuildResult_values)
        {
            summary[v] = 0;
        }

        for (const BuildResult& r : results)
        {
            summary[r]++;
        }

        System::println("\n\nSUMMARY");
        for (const std::pair<const BuildResult, int>& entry : summary)
        {
            System::println("    %s: %d", Build::to_string(entry.first), entry.second);
        }

        exit(EXIT_SUCCESS);
    }
}
