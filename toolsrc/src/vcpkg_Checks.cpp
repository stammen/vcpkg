#include "pch.h"
#include "vcpkg_Checks.h"
#include "vcpkg_System.h"

namespace vcpkg::Checks
{
    __declspec(noreturn) void unreachable()
    {
        System::println(System::color::error, "Error: Unreachable code was reached");
#ifndef NDEBUG
        std::abort();
#else
        exit(EXIT_FAILURE);
#endif
    }

    __declspec(noreturn) void exit_with_message(const char* errorMessage)
    {
        System::println(System::color::error, errorMessage);
        exit(EXIT_FAILURE);
    }

    __declspec(noreturn) void throw_with_message(const char* errorMessage)
    {
        throw std::runtime_error(errorMessage);
    }

    void check_throw(bool expression, const char* errorMessage)
    {
        if (!expression)
        {
            throw_with_message(errorMessage);
        }
    }

    void check_exit(bool expression)
    {
        if (!expression)
        {
            exit(EXIT_FAILURE);
        }
    }

    void check_exit(bool expression, const char* errorMessage)
    {
        if (!expression)
        {
            exit_with_message(errorMessage);
        }
    }
}
