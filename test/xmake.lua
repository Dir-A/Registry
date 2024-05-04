-- locale repo
set_policy("package.install_locally", true)
add_repositories("Drepo ../")

-- remot repo
-- add_repositories("Drepo https://github.com/Dir-A/Drepo.git")

-- rules
add_rules("mode.debug", "mode.release")

-- language
set_languages("c++20")

-- requires
-- add_requires("c",{alias = "c_lib",configs = {shared = true}})
add_requires("wx32")
-- add_requires("wx32",{configs = {shared = true}})
-- add_requires("c",{alias = "c_lib",configs = {shared = true, runtimes = "MD"}})
-- add_requires("c",{alias = "c_lib", debug = true, configs = {shared = true}})

-- targets
target("test")
    add_packages("wx32")
    -- add_packages("c_lib")
    set_kind("binary")
    add_files("src/*.cpp")
