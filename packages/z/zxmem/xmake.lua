package("zxmem")
    set_homepage("https://github.com/Dir-A/ZxMem ")
    add_urls("https://github.com/Dir-A/ZxMem.git")

    add_versions("v1.0", "af8b10dfbd392a448fdd5589276c72e7d0e867eb")

    -- on load, get and set configs
    on_load("windows", "mingw", function (package)
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
