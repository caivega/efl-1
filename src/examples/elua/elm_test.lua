local log = require("eina.log")

local dom = log.Domain("elm_test", log.color.LIGHTRED)

local win = elm.Window("test", "Hello World")

dom:log(log.level.INFO, "created window")
dom:log(log.level.ERR, "error test!")

log.log_err("test with default log domain")

local foo = function()
    for i = 1, 4 do
        log.log_err("testing: " .. i)
    end
end

foo()
log.set_default_domain(dom)
foo()

win:smart_callback_add("delete,request", function()
    elm.exit()
end)

local bg = elm.Background(win)
bg:size_hint_weight_set(1.0, 1.0)
win:resize_object_add(bg)
bg:show()

local bx = elm.Box(win)
bx:size_hint_weight_set(1.0, 1.0)
win:resize_object_add(bx)
bx:show()

local lbl = elm.Label(win)
lbl:text_set("Lua runtime test")
bx:pack_end(lbl)
lbl:show()

local entry

local btn = elm.Button(win)
btn:text_set("Reset counter")
bx:pack_end(btn)
btn:smart_callback_add("clicked", function()
    lbl:text_set(entry:entry_get())
end)
btn:show()

entry = elm.Entry(win)
entry:single_line_set(true)
entry:scrollable_set(true)
entry:focus_set(true)
entry:entry_set("Hello world")
entry:size_hint_weight_set(1.0, 1.0)
entry:size_hint_align_set(-1.0, -1.0)
entry:show()
bx:pack_end(entry)

win:resize(360, 360)
win:show()

dom:log(log.level.INFO, "done initing")
dom:unregister()