require 'env'

module( "test_package", package.seeall, lunit.testcase )

local old_path = nil

function setup()
    old_path = package.path
    package.path = package.path ..  ";?/init.lua;"

end

function teardown()
    package.path = old_path
end

function test_package()
    local packageA = require('packageA')
    local moduleB = packageA.moduleB
    assert_equal('packageA.foo', packageA.foo())
    assert_equal('packageA.moduleB.bar', moduleB.bar())
end