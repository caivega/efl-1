#ifndef __EOLIAN_COMMON_FUNCS_H
#define __EOLIAN_COMMON_FUNCS_H

#include <Eina.h>

#define EO

extern int _eolian_gen_log_dom;

#ifdef ERR
# undef ERR
#endif
#define ERR(...) EINA_LOG_DOM_ERR(_eolian_gen_log_dom, __VA_ARGS__)

#ifdef DBG
# undef DBG
#endif
#define DBG(...) EINA_LOG_DOM_DBG(_eolian_gen_log_dom, __VA_ARGS__)

#ifdef INF
# undef INF
#endif
#define INF(...) EINA_LOG_DOM_INFO(_eolian_gen_log_dom, __VA_ARGS__)

#ifdef WRN
# undef WRN
#endif
#define WRN(...) EINA_LOG_DOM_WARN(_eolian_gen_log_dom, __VA_ARGS__)

#ifdef CRIT
# undef CRIT
#endif
#define CRIT(...) EINA_LOG_DOM_CRIT(_eolian_gen_log_dom, __VA_ARGS__)

void _template_fill(Eina_Strbuf *buf, const char* templ, const char* classname, const char *funcname, Eina_Bool reset);

char *_nextline(char *str, unsigned int lines);

char *_startline(char *str, char *pos);

char *_source_desc_get(const char *str);

void _class_func_names_fill(const char *classname, const char *funcname);

char current_eo_prefix_lower[256];

char current_eo_prefix_upper[256];

char capobjclass[0xFF];
char lowobjclass[0xFF];
char capclass[0xFF];
char lowclass[0xFF];
char normclass[0xFF];
char capfunc[0xFF];
#endif
