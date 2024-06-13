package("zxjson")
    set_homepage("https://github.com/Dir-A/ZxJson ")
    add_urls("https://github.com/Dir-A/ZxJson.git")

    add_versions("v1.0", "1658c537e823da0b0ddcef6667fa6170997d5ddd")

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
