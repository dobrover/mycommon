require 'env'

local table_m = common.table

module( "test_table", package.seeall, lunit.testcase )

-- function assert_tbl_equal(tbl1, tbl2)
--     for 
-- end

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

function test_kw()
    tbl = {}
    kwtbl = table_m.kw(tbl)
    assert_equal(tbl, kwtbl.value)
    assert_true(table_m.is_kw(kwtbl))
    assert_false(table_m.is_kw(tbl))
end

function test_unpacked_vararg_check()
    tbl = {}
    vatbl = table_m.unpacked_vararg(tbl)
    assert_equal(tbl, vatbl)
    assert_true(table_m.is_unpacked_vararg(vatbl))
    assert_false(table_m.is_unpacked_vararg({}))
end

function test_update()
    tbl = {}
    assert_equal(tbl, table_m.update(tbl))
    tbl2 = table_m.update(tbl, {a=1,b=2}, {c=3})
    assert_equal(tbl, tbl2)
    assert_equal(1, tbl.a)
    assert_equal(2, tbl.b)
    assert_equal(3, tbl.c)
end

function test_vararg_to_table()
    vtt = table_m.vararg_to_table
    tbl = vtt()
    assert_equal('{}', table_m.tostring(tbl))
    assert_true(table_m.is_unpacked_vararg(tbl))

    tbl2 = vtt(tbl)
    assert_equal(tbl2, tbl)
    assert_true(table_m.is_unpacked_vararg(tbl2))
    assert_table(tbl2.kw)

    tbl3 = vtt(1, 2, 3)
    assert_equal(3, tbl3.n)
    for i = 1,tbl3.n do
        assert_equal(i, tbl3[i])
    end

    sometbl = {a=1}
    tbl4 = vtt(sometbl)
    assert_equal(1, tbl4.n)
    assert_equal(sometbl, tbl4[1])

    kw = table_m.kw

    tbl5 = vtt("hello", kw{a=1, b=2})
    assert_equal(1, tbl5.kw.a)
    assert_equal(2,tbl5.kw.b)
    assert_equal(1, tbl5.n)
    assert_equal("hello", tbl5[1])

    tbl6 = vtt("a", "b", kw{exc_info=true, log_exc=true}, kw{exc_info=false})
    assert_false(tbl6.kw.exc_info)
    assert_true(tbl6.kw.log_exc)

    tbl7 = vtt(nil)
    assert_equal(1, tbl7.n)
    assert_nil(tbl7[1])

    valtbl = {value=42}
    tbl8 = vtt(nil, valtbl, nil, kw{a=1})
    assert_equal(3, tbl8.n)
    assert_nil(tbl8[1])
    assert_equal(valtbl, tbl8[2])
    assert_nil(tbl8[3])
    assert_equal(1, tbl8.kw.a)

    tbl9a = vtt(1,2,3)
    tbl9b = vtt(4,5,6)
    assert_equal(tbl9a, vtt(tbl9a))
    tbl9c = vtt(tbl9a, tbl9b)
    assert_equal(tbl9a, tbl9c[1])
    assert_equal(tbl9b, tbl9c[2])

    -- Docstring example
    tbldoc = vtt(41, nil, 43, {value=42}, kw{a=1, b=2}, kw{c=3})
    assert_equal(41, tbldoc[1])
    assert_equal(nil, tbldoc[2])
    assert_equal(43, tbldoc[3])
    assert_equal(42, tbldoc[4].value)
    assert_equal(1, tbldoc.kw.a)
    assert_equal(2, tbldoc.kw.b)
    assert_equal(3, tbldoc.kw.c)

end