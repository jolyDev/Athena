workspace "Athena"
	architecture "x64"

	configurations {
		"Debug",
		"Release",
		"Dist"
	}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

--include directories relative to root filter (solution directory)
IncludeDir = {}
IncludeDir["GLFW"] = "Athena/vendor/GLFW/include"

include "Athena/vendor/GLFW"

project "Athena"
	location "Athena"
	kind "SharedLib"
	language "C++"
	
	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin/intermediate/" .. outputdir .. "/%{prj.name}")

	pchheader "ath_pch.h"
	pchsource "Athena/src/ath_pch.cpp"

	files {
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs {
		"%{prj.name}/src",
		"%{prj.name}/vendor/spdlog/include/",
		"%{IncludeDir.GLFW}"
	}

	links {
		"GLFW",
		"opengl32.lib"
	}

	filter "system:windows"
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"
		defines {
			"ATH_BUILD_DLL",
			"ATH_PLATFORM_WINDOWS"
		}

	postbuildcommands{
		("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox" )
	}

	filter"configurations:Debug"
		defines "ATH_DEBUG"
		buildoptions "/MDd"
		symbols "On"

	filter"configurations:Release"
		defines "ATH_RELEASE"
		buildoptions "/MD"
		optimize "On"

	filter"configurations:Dist"
		defines "ATH_DIST"
		buildoptions "/MD"
		optimize "On"

project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"
	language "C++"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin/intermediate/" .. outputdir .. "/%{prj.name}")

	files {
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	links {
		"Athena"
	}

	includedirs {
		"Athena/vendor/spdlog/include",
		"Athena/src"
	}

	filter "system:windows"
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"

		defines {
			"ATH_PLATFORM_WINDOWS"
		}

	filter"configurations:Debug"
		defines "ATH_DEBUG"
		buildoptions "/MDd"
		symbols "On"

	filter"configurations:Release"
		defines "ATH_RELEASE"
		buildoptions "/MD"
		optimize "On"

	filter"configurations:Dist"
		defines "ATH_DIST"
		buildoptions "/MD"
		optimize "On"