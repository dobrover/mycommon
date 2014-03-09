require 'env'

local table_m = common.table

module( "test_table", package.seeall, lunit.testcase )

function test_index()
    index = table_m.index
    tbl = {1, 2, 3, 4, 6, 2}
    assert_equal(1, index(tbl, 1))
    assert_equal(nil, index(tbl, 5))
    assert_equal(2, index(tbl, 2))
    table.remove(tbl, 2)
    assert_equal(5, index(tbl, 2))
end

function test_tostring()
    local tostr = table_m.tostring
    assert_equal('{1, 2, 3}', tostr{1, 2, 3})
    assert_equal('{}', tostr{})
    -- TODO: String repr
end