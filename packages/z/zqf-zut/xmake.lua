package(zqf-zut)
    set_homepage(https://github.com/Dir-A/Zut)
    set_description(a personal cpp utility library)
    add_urls(https://github.com/Dir-A/Zut.git)

    add_versions(v1.0, 37741d6306208c2fc894911fcde4a859a28846fa)

    -- on load, get and set configs
    on_load(windows, mingw, function (package)
        --
    end)

    -- on install, check configs and compile
    on_install(windows, mingw, function (package)
        local configs = {}
        if packageconfig(shared) then
            configs.kind = shared
        end
        import(package.tools.xmake).install(package, configs)
    end)

    -- on test
    on_test(function (package)
        -- 
    end)
package_end()