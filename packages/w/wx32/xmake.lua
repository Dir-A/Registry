package("wx32")
    set_homepage("https://github.com/Dir-A/Wx32/")
    set_description("a win32 api wrapper using utf-8 and modern c++")
    
    -- locale test
    set_sourcedir("D:/Space/Code/Git/Wx32")

    -- remote
    -- add_urls("https://github.com/Dir-A/Wx32.git")
    -- add_versions("v1.0", "ff70a51ca602762030604d96f6314bec46b0f584")

    -- link system lib
    if is_plat("windows", "mingw") then
        add_syslinks("user32")
    end

    -- on load, get and set configs
    on_load("macosx", "linux", "windows", "mingw", "android", "iphoneos", function (package)
        --
    end)

    -- on install, check configs and compile
    on_install("windows", "mingw", function (package)
        local configs = {}
        if package:config("shared") then
            configs.kind = "shared"
        end
        import("package.tools.xmake").install(package, configs)
    end)

    -- on test
    on_test(function (package)
        -- 
    end)
package_end()
