-- EFL LuaJIT bindings: Eina (list module)
-- For use with Elua

local ffi = require("ffi")

local iterator = require("eina.iterator")

ffi.cdef [[
    typedef unsigned char Eina_Bool;

    typedef struct _Eina_List            Eina_List;
    typedef struct _Eina_List_Accounting Eina_List_Accounting;

    typedef struct _Eina_List_T {
        void                 *data;
        Eina_List            *next;
        Eina_List            *prev;
        struct {
            Eina_List   *last;
            unsigned int count;
        } *accounting;
    } Eina_List_T;

    Eina_List            *eina_list_append(Eina_List *list, const void *data);
    Eina_List            *eina_list_prepend(Eina_List *list, const void *data);
    Eina_List            *eina_list_append_relative(Eina_List *list, const void *data, const void *relative);
    Eina_List            *eina_list_append_relative_list(Eina_List *list, const void *data, Eina_List *relative);
    Eina_List            *eina_list_prepend_relative(Eina_List *list, const void *data, const void *relative);
    Eina_List            *eina_list_prepend_relative_list(Eina_List *list, const void *data, Eina_List *relative);
    Eina_List            *eina_list_sorted_insert(Eina_List *list, Eina_Compare_Cb func, const void *data);
    Eina_List            *eina_list_remove(Eina_List *list, const void *data);
    Eina_List            *eina_list_remove_list(Eina_List *list, Eina_List *remove_list);
    Eina_List            *eina_list_promote_list(Eina_List *list, Eina_List *move_list);
    Eina_List            *eina_list_demote_list(Eina_List *list, Eina_List *move_list);
    void                 *eina_list_data_find(const Eina_List *list, const void *data);
    Eina_List            *eina_list_data_find_list(const Eina_List *list, const void *data);
    Eina_Bool             eina_list_move(Eina_List **to, Eina_List **from, void *data);
    Eina_Bool             eina_list_move_list(Eina_List **to, Eina_List **from, Eina_List *data);
    Eina_List            *eina_list_free(Eina_List *list);
    void                 *eina_list_nth(const Eina_List *list, unsigned int n);
    Eina_List            *eina_list_nth_list(const Eina_List *list, unsigned int n);
    Eina_List            *eina_list_reverse(Eina_List *list);
    Eina_List            *eina_list_reverse_clone(const Eina_List *list);
    Eina_List            *eina_list_clone(const Eina_List *list);
    Eina_List            *eina_list_sort(Eina_List *list, unsigned int limit, Eina_Compare_Cb func);
    Eina_List            *eina_list_shuffle(Eina_List *list, Eina_Random_Cb func);
    Eina_List            *eina_list_merge(Eina_List *left, Eina_List *right);
    Eina_List            *eina_list_sorted_merge(Eina_List *left, Eina_List *right, Eina_Compare_Cb func);
    Eina_List            *eina_list_split_list(Eina_List *list, Eina_List *relative, Eina_List **right);
    Eina_List            *eina_list_search_sorted_near_list(const Eina_List *list, Eina_Compare_Cb func, const void *data, int *result_cmp);
    Eina_List            *eina_list_search_sorted_list(const Eina_List *list, Eina_Compare_Cb func, const void *data);
    void                 *eina_list_search_sorted(const Eina_List *list, Eina_Compare_Cb func, const void *data);
    Eina_List            *eina_list_search_unsorted_list(const Eina_List *list, Eina_Compare_Cb func, const void *data);
    void                 *eina_list_search_unsorted(const Eina_List *list, Eina_Compare_Cb func, const void *data);
    Eina_Iterator        *eina_list_iterator_new(const Eina_List *list);
    Eina_Iterator        *eina_list_iterator_reversed_new(const Eina_List *list);
//  Eina_Accessor        *eina_list_accessor_new(const Eina_List *list);
]]

local cutil = require("cutil")
local util  = require("util")

local M = {}

local eina

local init = function()
    eina = util.lib_load("eina")
end

local shutdown = function()
    util.lib_unload("eina")
end

cutil.init_module(init, shutdown)

local Iterator = iterator.Iterator

M.Iterator = Iterator:clone {
    __ctor = function(self, list)
        self.__list = list
        return Iterator.__ctor(self, eina.eina_list_iterator_new(list.__list))
    end,

    next = function(self)
        local  v = Iterator.next(self)
        if not v then return nil end
        return self.__list:data_get(v)
    end
}

M.Reverse_Iterator = Iterator:clone {
    __ctor = function(self, list)
        self.__list = list
        return Iterator.__ctor(self, eina.eina_list_iterator_reversed_new(
            list.__list))
    end,

    next = function(self)
        local  v = Iterator.next(self)
        if not v then return nil end
        return self.__list:data_get(v)
    end
}

local get_list_t = function(list)
    return ffi.cast("Eina_List_T*", list)
end

local List = ffi.metatype("Eina_List", {
    __len = function(self)
        return get_list_t(self).accounting.count
    end,

    __index = {
        data_get = function(self, ptr)
            if ptr ~= nil then return ptr end
            local v = get_list_t(self).data
            if v == nil then return nil end
            return v
        end,

        nth = function(self, n)
            local v = eina.eina_list_nth(self, n - 1)
            if v == nil then return nil end
            return self:data_get(v)
        end,

        nth_list = function(self, n)
            local v = eina.eina_list_nth_list(self, n - 1)
            if v == nil then return nil end
            return v
        end,

        last = function(self)
            local v = get_list_t(self).accounting.last
            if v == nil then return nil end
            return v
        end,

        next = function(self)
            local v = get_list_t(self).next
            if v == nil then return nil end
            return v
        end,

        prev = function(self)
            local v = get_list_t(self).prev
            if v == nil then return nil end
            return v
        end
    }
})

M.List = util.Object:clone {
    __ctor = function(self, list, freefunc)
        if list and freefunc then
            list = ffi.gc(list, freefunc)
            self.__free = freefunc
        end
        self.__list = list
    end,

    free = function(self)
        local  ffunc, l = self.__free, self.__list
        if not ffunc or l == nil then return end
        ffunc(ffi.gc(self.__list, nil))
    end,

    count = function(self)
        local l = self.__list
        if l == nil then return 0 end
        return #l
    end,

    nth = function(self, n)
        local l = self.__list
        if l == nil then return nil end
        return l:nth()
    end,

    nth_list = function(self, n)
        local l = self.__list
        if l == nil then return nil end
        return self.__index(l:nth_list())
    end,

    last = function(self, n)
        local l = self.__list
        if l == nil then return nil end
        return self.__index(l:last())
    end,

    next = function(self, n)
        local l = self.__list
        if l == nil then return nil end
        return self.__index(l:next())
    end,

    prev = function(self, n)
        local l = self.__list
        if l == nil then return nil end
        return self.__index(l:prev())
    end,

    data_get = function(self, ptr)
        local l = self.__list
        if l == nil then return nil end
        return l:data_get(ptr)
    end,

    to_array = function(self)
        local l = self.__list
        if l == nil then return {}, 0 end
        local n = 0
        local r = {}
        while l ~= nil do
            n = n + 1
            local d = l:data_get()
            if d ~= nil then
                r[n] = self:data_get(d)
            end
            l = l:next()
        end
        return r, n
    end
}

return M