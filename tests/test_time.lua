require 'env'

local time = common.time

module( "test_time", package.seeall, lunit.testcase )

function test_time()
    assert_equal('number', type(time.time()))
end