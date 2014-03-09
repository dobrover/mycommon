require 'env'

local string = common.string

module( "test_string", package.seeall, lunit.testcase )

function test_interpolate()
    local f = string.interpolate
    assert_equal("test", f("test"))
    assert_equal("test", f("test", {}))
    assert_equal("test a b", f("test %s %s", {'a', 'b'}))
    assert_equal("test % %%", f("test %% %%%%"))
    assert_equal("test % %x%", f("test %% %%%s%%", {'x'}))
    -- Keyword arguments
    assert_equal("test x y", f("test %(a)s %(b)s", {a='x', b='y'}))
    assert_equal("test %(a)s", f("test %%(a)s"))
    assert_equal("test %(a)s !x!", f("test %%(a)s !%(a)s!", {a='x'}))
    assert_equal("test %(a)s !&!", f("test %%(a)s !%(a)s!", {a='&'}))
    assert_equal("test %(a)s !&&!", f("test %%(a)s !%(a)s!", {a='&&'}))
    assert_equal('test %%42', f("test %%%%%(a)d", {a=42}))
    assert_equal('y x', f("%(b)s %(a)s", {a='x', b='y'}))
    -- If we forget to add format type, it won't be replaced
    assert_equal('%(a) x', f('%(a) %(b)s', {a='y', b='x'}))
    -- Mixed format not allowed
    assert_error('Interpolate should not allow mixed keys!',
                 function () f( '%(a) %(b)', {1, a='b'}) end)
end