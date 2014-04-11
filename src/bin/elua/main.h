#ifndef LUAR_MAIN_H
#define LUAR_MAIN_H

#ifdef HAVE_CONFIG_H
# include <config.h>
#endif

#ifndef ELUA_DATA_DIR
#define ELUA_DATA_DIR "."
#endif

#include <stdio.h>
#include <stdlib.h>

#include <Eina.h>
#include <Ecore.h>
#include <Ecore_Getopt.h>

#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

extern int el_log_domain;

#define DBG(...) EINA_LOG_DOM_DBG(el_log_domain, __VA_ARGS__)
#define INF(...) EINA_LOG_DOM_INFO(el_log_domain, __VA_ARGS__)
#define WRN(...) EINA_LOG_DOM_WARN(el_log_domain, __VA_ARGS__)
#define ERR(...) EINA_LOG_DOM_ERR(el_log_domain, __VA_ARGS__)
#define CRT(...) EINA_LOG_DOM_CRITICAL(el_log_domain, __VA_ARGS__)

int elua_loadfilex(lua_State *L, const char *fname, const char *mode);
int elua_loadfile(lua_State *L, const char *fname);
int elua_loadfilex_mmap(lua_State *L, const char *fname, const char *mode);
int elua_loadfile_mmap(lua_State *L, const char *fname);
void elua_register_cache(lua_State *L);

#endif