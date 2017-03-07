#include "pch.h"
#include "vcpkg_Chrono.h"
#include "vcpkg_Checks.h"

namespace vcpkg
{
    static std::string format_time_userfriendly(const std::chrono::nanoseconds& nanos)
    {
        using std::chrono::hours;
        using std::chrono::minutes;
        using std::chrono::seconds;
        using std::chrono::milliseconds;
        using std::chrono::microseconds;
        using std::chrono::nanoseconds;
        using std::chrono::duration_cast;

        const double nanos_as_double = static_cast<double>(nanos.count());

        if (duration_cast<hours>(nanos) > hours())
        {
            auto t = nanos_as_double / duration_cast<nanoseconds>(hours(1)).count();
            return Strings::format("%.4g h", t);
        }

        if (duration_cast<minutes>(nanos) > minutes())
        {
            auto t = nanos_as_double / duration_cast<nanoseconds>(minutes(1)).count();
            return Strings::format("%.4g min", t);
        }

        if (duration_cast<seconds>(nanos) > seconds())
        {
            auto t = nanos_as_double / duration_cast<nanoseconds>(seconds(1)).count();
            return Strings::format("%.4g s", t);
        }

        if (duration_cast<milliseconds>(nanos) > milliseconds())
        {
            auto t = nanos_as_double / duration_cast<nanoseconds>(milliseconds(1)).count();
            return Strings::format("%.4g ms", t);
        }

        if (duration_cast<microseconds>(nanos) > microseconds())
        {
            auto t = nanos_as_double / duration_cast<nanoseconds>(microseconds(1)).count();
            return Strings::format("%.4g us", t);
        }

        return Strings::format("%.4g ns", nanos_as_double);
    }

    ElapsedTime ElapsedTime::createStarted()
    {
        ElapsedTime t;
        t.m_startTick = std::chrono::high_resolution_clock::now();
        return t;
    }

    std::string ElapsedTime::toString() const
    {
        return format_time_userfriendly(elapsed<std::chrono::nanoseconds>());
    }
}
