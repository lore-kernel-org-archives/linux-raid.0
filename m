From: Artur Wojcik <artur.wojcik@intel.com>
Subject: [mdadm PATCH 1/2] Improvement: new logging facility.
Date: Thu, 28 Jan 2010 17:04:10 +0100
Message-ID: <20100128160410.32091.12925.stgit@awojcik-linux>
References: <20100128155922.32091.12709.stgit@awojcik-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100128155922.32091.12709.stgit@awojcik-linux>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

This patch introduces the new method of message logging for
mdadm and mdmon applications.

The new logging library allows redirecting log messages to
terminal console, log file and syslog, simultaneously with
a single function call. The library defines 6 log levels and
10 log hives. The log levels are: ALERT, FATAL, ERROR, WARNING,
NOTICE, INFO and DEBUG. The log hive is an object to ease
operations on group of log messages e.g. form a module of an
application or from a certain functionality.

Each hive has verbosity level and a mask determining where to
redirect the log messages. The mask is useful, for example,
in quiet mode: an application will stop logging messages on
terminal console but it will keep logging to a file and/or
syslog. The log hive is similar to facility parameter of syslog.

The default location of a log file is /var/log/<binname>.log.
The format of log messages differs depending on output. Sylog
and log file outputs have messages prefixed with timestamp and
pid information. Additionally debug logs have messages prefixed
with file name, function name and line in source code. Terminal
console output has message format as close as it is possible to
original format.

Debug messages can be redirected to different log file then
rest of log messages.

Signed-off-by: Artur Wojcik <artur.wojcik@intel.com>
---
 Makefile |    6 -
 log.c    |  625 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 log.h    |  148 +++++++++++++++
 3 files changed, 776 insertions(+), 3 deletions(-)
 create mode 100644 log.c
 create mode 100644 log.h

diff --git a/Makefile b/Makefile
index 901b3e0..ae9f95c 100644
--- a/Makefile
+++ b/Makefile
@@ -81,19 +81,19 @@ OBJS =  mdadm.o config.o mdstat.o  ReadMe.o util.o Manage.o Assemble.o Build.o \
 	Incremental.o \
 	mdopen.o super0.o super1.o super-ddf.o super-intel.o bitmap.o \
 	restripe.o sysfs.o sha1.o mapfile.o crc32.o sg_io.o msg.o \
-	platform-intel.o probe_roms.o
+	platform-intel.o probe_roms.o log.o
 
 SRCS =  mdadm.c config.c mdstat.c  ReadMe.c util.c Manage.c Assemble.c Build.c \
 	Create.c Detail.c Examine.c Grow.c Monitor.c dlink.c Kill.c Query.c \
 	Incremental.c \
 	mdopen.c super0.c super1.c super-ddf.c super-intel.c bitmap.c \
 	restripe.c sysfs.c sha1.c mapfile.c crc32.c sg_io.c msg.c \
-	platform-intel.c probe_roms.c
+	platform-intel.c probe_roms.c log.c
 
 MON_OBJS = mdmon.o monitor.o managemon.o util.o mdstat.o sysfs.o config.o \
 	Kill.o sg_io.o dlink.o ReadMe.o super0.o super1.o super-intel.o \
 	super-ddf.o sha1.o crc32.o msg.o bitmap.o \
-	platform-intel.o probe_roms.o
+	platform-intel.o probe_roms.o log.o
 
 
 STATICSRC = pwgr.c
diff --git a/log.c b/log.c
new file mode 100644
index 0000000..5f0220a
--- /dev/null
+++ b/log.c
@@ -0,0 +1,625 @@
+/*
+ * Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+ */
+
+#include <unistd.h>
+#include <stdio.h>
+#include <stdarg.h>
+#include <errno.h>
+#include <syslog.h>
+#include <assert.h>
+#include <limits.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdlib.h>
+#include <ctype.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+
+#include "log.h"
+
+/* */
+#define DEFAULT_LOG_NAME	"/var/log/%s.log"
+
+/* */
+#define PREFIX_ALERT		"ALERT"
+#define PREFIX_FATAL		"CRITICAL"
+#define PREFIX_ERROR		"ERROR"
+#define PREFIX_WARN		"WARNING"
+#define PREFIX_NOTICE		NULL
+#define PREFIX_INFO		NULL
+#define PREFIX_DEBUG		"DEBUG"
+
+/* */
+static FILE *stdlog = NULL;
+
+/* */
+static volatile struct __log_hive {
+	unsigned int mask;
+	char *name;
+	enum log_level level;
+	FILE *stream;
+} log_hive[LOG_HIVE_ALL] = {
+	[LOG_HIVE_GENERIC]	= {
+		.mask	= LOG_B_ALL,
+		.name	= NULL,
+		.level	= LOG_LEVEL_ALL,
+		.stream	= NULL},
+	[LOG_HIVE_0]		= {
+		.mask	= LOG_B_ALL,
+		.name	= NULL,
+		.level	= LOG_LEVEL_ALL,
+		.stream	= NULL},
+	[LOG_HIVE_1]		= {
+		.mask	= LOG_B_ALL,
+		.name	= NULL,
+		.level	= LOG_LEVEL_ALL,
+		.stream	= NULL},
+	[LOG_HIVE_2]		= {
+		.mask	= LOG_B_ALL,
+		.name	= NULL,
+		.level	= LOG_LEVEL_ALL,
+		.stream	= NULL},
+	[LOG_HIVE_3]		= {
+		.mask	= LOG_B_ALL,
+		.name	= NULL,
+		.level	= LOG_LEVEL_ALL,
+		.stream	= NULL},
+	[LOG_HIVE_4]		= {
+		.mask	= LOG_B_ALL,
+		.name	= NULL,
+		.level	= LOG_LEVEL_ALL,
+		.stream	= NULL},
+	[LOG_HIVE_5]		= {
+		.mask	= LOG_B_ALL,
+		.name	= NULL,
+		.level	= LOG_LEVEL_ALL,
+		.stream	= NULL},
+	[LOG_HIVE_6]		= {
+		.mask	= LOG_B_ALL,
+		.name	= NULL,
+		.level	= LOG_LEVEL_ALL,
+		.stream	= NULL},
+	[LOG_HIVE_7]		= {
+		.mask	= LOG_B_ALL,
+		.name	= NULL,
+		.level	= LOG_LEVEL_ALL,
+		.stream	= NULL},
+	[LOG_HIVE_DAEMON]	= {
+		.mask	= LOG_B_FILE | LOG_B_SYSLOG,
+		.name	= NULL,
+		.level	= LOG_LEVEL_ALL,
+		.stream	= NULL}
+};
+
+/* */
+static char * const log_prefix[LOG_LEVEL_ALL] = {
+	[LOG_LEVEL_ALERT]	= PREFIX_ALERT,
+	[LOG_LEVEL_FATAL]	= PREFIX_FATAL,
+	[LOG_LEVEL_ERROR]	= PREFIX_ERROR,
+	[LOG_LEVEL_WARNING]	= PREFIX_WARN,
+	[LOG_LEVEL_NOTICE]	= PREFIX_NOTICE,
+	[LOG_LEVEL_INFO]	= PREFIX_INFO,
+	[LOG_LEVEL_DEBUG]	= PREFIX_DEBUG
+};
+
+/* */
+static int const syslog_facil[LOG_HIVE_ALL] = {
+	[LOG_HIVE_GENERIC]	= LOG_USER,
+	[LOG_HIVE_0]		= LOG_LOCAL0,
+	[LOG_HIVE_1]		= LOG_LOCAL1,
+	[LOG_HIVE_2]		= LOG_LOCAL2,
+	[LOG_HIVE_3]		= LOG_LOCAL3,
+	[LOG_HIVE_4]		= LOG_LOCAL4,
+	[LOG_HIVE_5]		= LOG_LOCAL5,
+	[LOG_HIVE_6]		= LOG_LOCAL6,
+	[LOG_HIVE_7]		= LOG_LOCAL7,
+	[LOG_HIVE_DAEMON]	= LOG_DAEMON
+};
+
+/* */
+static int const syslog_prio[LOG_LEVEL_ALL] = {
+	[LOG_LEVEL_NONE]	= -1,
+	[LOG_LEVEL_ALERT]	= LOG_ALERT,
+	[LOG_LEVEL_FATAL]	= LOG_CRIT,
+	[LOG_LEVEL_ERROR]	= LOG_ERR,
+	[LOG_LEVEL_WARNING]	= LOG_WARNING,
+	[LOG_LEVEL_NOTICE]	= LOG_NOTICE,
+	[LOG_LEVEL_INFO]	= LOG_INFO,
+	[LOG_LEVEL_DEBUG]	= LOG_DEBUG
+};
+
+/* */
+static char *progname = NULL;
+
+/* */
+static int _log_mkdir(const char *path)
+{
+	int result = -1;
+	char *p, *t;
+
+	p = canonicalize_file_name(path);
+	t = p;
+	while (t) {
+		t = strchr(t + 1, '/');
+		if (t) *t = '\0';
+		errno = 0;
+		result = mkdir(p, 0640);
+		if (t) *t = '/';
+		if ((result < 0) && (errno != EEXIST))
+			break;
+		result = 0;
+
+	}
+	if (p)
+		free(p);
+
+	return result;
+}
+
+/* */
+static FILE * _log_open(const char *path)
+{
+	int result = 0;
+	FILE *log_strm = NULL;
+	char *t;
+
+	t = rindex(path, '/');
+	if (t) {
+		*t = '\0';
+		result = _log_mkdir(path);
+		*t = '/';
+	}
+	if (result == 0)
+		log_strm = fopen(path, "a");
+
+	return log_strm;
+}
+
+/* */
+static FILE * _log_open_default(void)
+{
+	FILE *result = NULL;
+	char *path;
+	assert(progname);
+	if (asprintf(&path, DEFAULT_LOG_NAME, progname) >= 0) {
+		result = _log_open(path);
+		free(path);
+	}
+	return result;
+}
+
+/* */
+static unsigned int _log_update(enum log_hive index)
+{
+	/* TODO: check environmental variables and update log_mask
+	         approprietally. */
+	return log_hive[index].mask;
+}
+
+/* */
+static void _log_close(FILE *stream)
+{
+	if (stream) {
+		fflush(stream);
+		fclose(stream);
+	}
+}
+
+/* */
+static void _vlog(FILE *stream, const char *tmstamp, const char *prefix,
+	int pid, const char *fmt, va_list vl)
+{
+	char *temp;
+
+	if (stream == NULL) {
+		if (stdlog == NULL)
+			stdlog = _log_open_default();
+		stream = stdlog;
+		if (stream == NULL)
+			return;
+	}
+	if (tmstamp)
+		fprintf(stream, "%s ", tmstamp);
+	assert(progname);
+	fprintf(stream, "%s", progname);
+	if (pid >= 0)
+		fprintf(stream, "[%d]", pid);
+	fprintf(stream, ": ");
+	if (prefix)
+		fprintf(stream, "%s: ", prefix);
+	if (vasprintf(&temp, fmt, vl) >= 0) {
+		fprintf(stream, "%s", temp);
+		if (temp[strlen(temp) - 1] != '\n')
+			fprintf(stream, "\n");
+		free(temp);
+	}
+	fflush(stream);
+}
+
+/* */
+static void _vsys(const char *prefix, int priority, int facility,
+	const char *fmt, va_list vl)
+{
+	assert(progname);
+	char *buffer;
+	if (vasprintf(&buffer, fmt, vl) >= 0) {
+		openlog(progname, LOG_PID | LOG_NDELAY, facility);
+		syslog(priority, "%s%s%s", prefix ? : "", prefix ? ": " : "", buffer);
+		closelog();
+		free(buffer);
+	}
+}
+
+/* */
+static char * _dbg_hdr(const char *file, int line, const char *fn)
+{
+	char *buffer;
+	if (asprintf(&buffer, "%s %s@%d, %s()", PREFIX_DEBUG, file, line, fn) < 0)
+		buffer = NULL;
+	return buffer;
+}
+
+/* */
+static char * _log_timestamp(void)
+{
+	static int index = 0;
+	static suseconds_t usec = 0;
+
+	char *result;
+	struct timeval current_time;
+
+	gettimeofday(&current_time, NULL);
+	if (usec == current_time.tv_usec) {
+		index++;
+	} else {
+		index = 0;
+		usec = current_time.tv_usec;
+	}
+	if (asprintf(&result, "%08x_%04x", (unsigned int)usec, index) < 0)
+		result = NULL;
+
+	return result;
+}
+
+/* */
+static char * _log_prefix(enum log_hive index, enum log_level level)
+{
+	char *result;
+	char *name = log_hive[index].name;
+	char *prefix = log_prefix[level];
+
+	if (asprintf(&result, "%s%s%s", name && prefix ? name : "", name && prefix ? " " : "", prefix ? : "") < 0)
+		return NULL;
+
+	if (*result == '\0') {
+		free(result);
+		result = NULL;
+	}
+	return result;
+}
+
+/* */
+static void _log_debug_close(enum log_hive index)
+{
+	FILE *stream;
+
+	stream = log_hive[index].stream;
+	log_hive[index].stream = NULL;
+
+	if (log_hive[LOG_HIVE_GENERIC].stream == stream)
+		return;
+	if (log_hive[LOG_HIVE_0].stream == stream)
+		return;
+	if (log_hive[LOG_HIVE_1].stream == stream)
+		return;
+	if (log_hive[LOG_HIVE_2].stream == stream)
+		return;
+	if (log_hive[LOG_HIVE_3].stream == stream)
+		return;
+	if (log_hive[LOG_HIVE_4].stream == stream)
+		return;
+	if (log_hive[LOG_HIVE_5].stream == stream)
+		return;
+	if (log_hive[LOG_HIVE_6].stream == stream)
+		return;
+	if (log_hive[LOG_HIVE_7].stream == stream)
+		return;
+	if (log_hive[LOG_HIVE_DAEMON].stream == stream)
+		return;
+
+	fclose(stream);
+}
+
+/* */
+static void _log_hive_free(enum log_hive index)
+{
+	if (log_hive[index].name)
+		free(log_hive[index].name);
+
+	_log_debug_close(index);
+}
+
+/* */
+static void _log_debug_redir(enum log_hive index, const char *path)
+{
+	FILE * stream;
+
+	if ((stream = _log_open(path)) == NULL)
+		return;
+
+	if (index < LOG_HIVE_ALL) {
+		log_hive[index].stream = stream;
+	}  else {
+		log_hive[LOG_HIVE_GENERIC].stream = stream;
+		log_hive[LOG_HIVE_0].stream = stream;
+		log_hive[LOG_HIVE_1].stream = stream;
+		log_hive[LOG_HIVE_2].stream = stream;
+		log_hive[LOG_HIVE_3].stream = stream;
+		log_hive[LOG_HIVE_4].stream = stream;
+		log_hive[LOG_HIVE_5].stream = stream;
+		log_hive[LOG_HIVE_6].stream = stream;
+		log_hive[LOG_HIVE_7].stream = stream;
+		log_hive[LOG_HIVE_DAEMON].stream = stream;
+	}
+}
+
+/* */
+const char * log_get_progname(void)
+{
+	assert(progname);
+	return progname;
+}
+
+/* */
+void log_fini(void)
+{
+	_log_hive_free(LOG_HIVE_GENERIC);
+	_log_hive_free(LOG_HIVE_0);
+	_log_hive_free(LOG_HIVE_1);
+	_log_hive_free(LOG_HIVE_2);
+	_log_hive_free(LOG_HIVE_3);
+	_log_hive_free(LOG_HIVE_4);
+	_log_hive_free(LOG_HIVE_5);
+	_log_hive_free(LOG_HIVE_6);
+	_log_hive_free(LOG_HIVE_7);
+	_log_hive_free(LOG_HIVE_DAEMON);
+
+	_log_close(stdlog);
+	closelog();
+
+	if (progname)
+		free(progname);
+}
+
+/* */
+void log_init(const char *pname)
+{
+	if (pname) {
+		char *t = rindex(pname, '/');
+		if (t)
+			progname = strdup(t + 1);
+		else
+			progname = strdup(pname);
+	}
+}
+
+/* */
+void log_debug_redirect(enum log_hive index, const char *path)
+{
+	if (path) {
+		_log_debug_redir(index, path);
+	} else {
+		if (index < LOG_HIVE_ALL) {
+			_log_debug_close(index);
+		} else {
+			_log_debug_close(LOG_HIVE_GENERIC);
+			_log_debug_close(LOG_HIVE_0);
+			_log_debug_close(LOG_HIVE_1);
+			_log_debug_close(LOG_HIVE_2);
+			_log_debug_close(LOG_HIVE_3);
+			_log_debug_close(LOG_HIVE_4);
+			_log_debug_close(LOG_HIVE_5);
+			_log_debug_close(LOG_HIVE_6);
+			_log_debug_close(LOG_HIVE_7);
+			_log_debug_close(LOG_HIVE_DAEMON);
+		}
+	}
+}
+
+/* */
+void log_redirect(const char *path)
+{
+	_log_close(stdlog);
+	if (path == NULL)
+		stdlog = _log_open_default();
+	else
+		stdlog = _log_open(path);
+}
+
+/* */
+unsigned int log_get_mask(enum log_hive index)
+{
+	if (index < LOG_HIVE_ALL)
+		return log_hive[index].mask;
+	else
+		return (unsigned int)(-1);
+}
+
+/* */
+void log_set_mask(enum log_hive index, unsigned int mask)
+{
+	mask &= 0x07;
+	if (index < LOG_HIVE_ALL) {
+		log_hive[index].mask |= mask;
+	} else {
+		log_hive[LOG_HIVE_GENERIC].mask |= mask;
+		log_hive[LOG_HIVE_0].mask |= mask;
+		log_hive[LOG_HIVE_1].mask |= mask;
+		log_hive[LOG_HIVE_2].mask |= mask;
+		log_hive[LOG_HIVE_3].mask |= mask;
+		log_hive[LOG_HIVE_4].mask |= mask;
+		log_hive[LOG_HIVE_5].mask |= mask;
+		log_hive[LOG_HIVE_6].mask |= mask;
+		log_hive[LOG_HIVE_7].mask |= mask;
+		log_hive[LOG_HIVE_DAEMON].mask |= mask;
+	}
+}
+
+/* */
+void log_reset_mask(enum log_hive index, unsigned int mask)
+{
+	mask = ~(mask & 0x07);
+	if (index < LOG_HIVE_ALL) {
+		log_hive[index].mask &= mask;
+	} else {
+		log_hive[LOG_HIVE_GENERIC].mask &= mask;
+		log_hive[LOG_HIVE_0].mask &= mask;
+		log_hive[LOG_HIVE_1].mask &= mask;
+		log_hive[LOG_HIVE_2].mask &= mask;
+		log_hive[LOG_HIVE_3].mask &= mask;
+		log_hive[LOG_HIVE_4].mask &= mask;
+		log_hive[LOG_HIVE_5].mask &= mask;
+		log_hive[LOG_HIVE_6].mask &= mask;
+		log_hive[LOG_HIVE_7].mask &= mask;
+		log_hive[LOG_HIVE_DAEMON].mask &= mask;
+	}
+}
+
+/* */
+void log_set_name(enum log_hive index, char *name)
+{
+	if (index < LOG_HIVE_ALL) {
+		if (log_hive[index].name)
+			free(log_hive[index].name);
+		if (name)
+			name = strdup(name);
+		log_hive[index].name = name;
+	}
+}
+
+/* */
+void log_set_level(enum log_hive index, enum log_level level)
+{
+	if (level >= LOG_LEVEL_ALL)
+		return;
+
+	if (index < LOG_HIVE_ALL) {
+		log_hive[index].level = level;
+	} else {
+		log_hive[LOG_HIVE_GENERIC].level = level;
+		log_hive[LOG_HIVE_0].level = level;
+		log_hive[LOG_HIVE_1].level = level;
+		log_hive[LOG_HIVE_2].level = level;
+		log_hive[LOG_HIVE_3].level = level;
+		log_hive[LOG_HIVE_4].level = level;
+		log_hive[LOG_HIVE_5].level = level;
+		log_hive[LOG_HIVE_6].level = level;
+		log_hive[LOG_HIVE_7].level = level;
+		log_hive[LOG_HIVE_DAEMON].level = level;
+	}
+}
+
+/* */
+enum log_level log_get_level(enum log_hive index)
+{
+	if (index < LOG_LEVEL_ALL)
+		return log_hive[index].level;
+	else
+		return LOG_LEVEL_NONE;
+}
+
+/* */
+void log_msg(enum log_hive index, enum log_level level, const char *fmt, ...)
+{
+	va_list vl;
+	char *timestamp, *prefix;
+	unsigned int mask;
+
+	if (index >= LOG_HIVE_ALL || fmt == NULL)
+		return;
+
+	mask = _log_update(index);
+
+	if (log_hive[index].level < level || level == LOG_LEVEL_DEBUG)
+		return;
+
+	timestamp = _log_timestamp();
+	prefix = _log_prefix(index, level);
+
+	if ((mask & LOG_B_SYSLOG) == LOG_B_SYSLOG) {
+		va_start(vl, fmt);
+		_vsys(prefix, syslog_prio[level], syslog_facil[index], fmt, vl);
+		va_end(vl);
+	}
+	if ((mask & LOG_B_FILE) == LOG_B_FILE) {
+		va_start(vl, fmt);
+		_vlog(stdlog, timestamp, prefix, getpid(), fmt, vl);
+		va_end(vl);
+	}
+	if ((mask & LOG_B_CONSOLE) == LOG_B_CONSOLE) {
+		va_start(vl, fmt);
+		_vlog(stderr, NULL, prefix, -1, fmt, vl);
+		va_end(vl);
+	}
+	if (prefix)
+		free(prefix);
+	if (timestamp)
+		free(timestamp);
+}
+
+/* */
+void log_dbg(enum log_hive index, const char *file, int ln, const char *fn,
+	const char *fmt, ...)
+{
+	va_list vl;
+	char *timestamp, *hdr;
+	unsigned int mask;
+
+	if (index >= LOG_HIVE_ALL || fmt == NULL)
+		return;
+
+	mask = _log_update(index);
+
+	if (log_hive[index].level < LOG_LEVEL_DEBUG)
+		return;
+
+	timestamp = _log_timestamp();
+	hdr = _dbg_hdr(file, ln, fn);
+
+	if ((mask & LOG_B_SYSLOG) == LOG_B_SYSLOG) {
+		va_start(vl, fmt);
+		_vsys(timestamp, LOG_DEBUG, syslog_facil[index], fmt, vl);
+		va_end(vl);
+	}
+	if ((mask & LOG_B_FILE) == LOG_B_FILE) {
+		va_start(vl, fmt);
+		_vlog(log_hive[index].stream ? : stdlog, timestamp,
+			hdr ? : PREFIX_DEBUG, getpid(), fmt, vl);
+		va_end(vl);
+	}
+	if ((mask & LOG_B_CONSOLE) == LOG_B_CONSOLE) {
+		va_start(vl, fmt);
+		_vlog(stderr, NULL, hdr ? : PREFIX_DEBUG, -1, fmt, vl);
+		va_end(vl);
+	}
+	if (hdr)
+		free(hdr);
+	if (timestamp)
+		free(timestamp);
+}
+
diff --git a/log.h b/log.h
new file mode 100644
index 0000000..c8d3471
--- /dev/null
+++ b/log.h
@@ -0,0 +1,148 @@
+/*
+ * Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+ */
+
+#ifndef _LOG_H
+#define _LOG_H		1
+
+/* */
+enum log_level {
+	LOG_LEVEL_QUIET = 0,
+	LOG_LEVEL_NONE = LOG_LEVEL_QUIET,
+	LOG_LEVEL_ALERT,
+	LOG_LEVEL_FATAL,
+	LOG_LEVEL_ERROR,
+	LOG_LEVEL_WARNING,
+	LOG_LEVEL_NOTICE,
+	LOG_LEVEL_INFO,
+	LOG_LEVEL_DEBUG,
+	LOG_LEVEL_ALL
+};
+
+/* */
+enum log_hive {
+	LOG_HIVE_GENERIC = 0,
+	LOG_HIVE_0,
+	LOG_HIVE_1,
+	LOG_HIVE_2,
+	LOG_HIVE_3,
+	LOG_HIVE_4,
+	LOG_HIVE_5,
+	LOG_HIVE_6,
+	LOG_HIVE_7,
+	LOG_HIVE_DAEMON,
+	LOG_HIVE_ALL
+};
+
+/* */
+#define LOG_B_CONSOLE	0x01
+
+/* */
+#define LOG_B_FILE	0x02
+
+/* */
+#define LOG_B_SYSLOG	0x04
+
+/* */
+#define LOG_B_ALL	(LOG_B_CONSOLE | LOG_B_SYSLOG | LOG_B_FILE)
+
+/* */
+#define log_alert(__hive, __fmt, ...) \
+	do { if (log_get_level(__hive) >= LOG_LEVEL_ALERT) \
+		log_msg(__hive, LOG_LEVEL_ALERT, __fmt, ## __VA_ARGS__); \
+	} while (0)
+
+/* */
+#define log_fatal(__hive, __fmt, ...) \
+	do { if (log_get_level(__hive) >= LOG_LEVEL_FATAL) \
+		log_msg(__hive, LOG_LEVEL_FATAL, __fmt, ## __VA_ARGS__); \
+	} while (0)
+
+/* */
+#define log_error(__hive, __fmt, ...) \
+	do { if (log_get_level(__hive) >= LOG_LEVEL_ERROR) \
+		log_msg(__hive, LOG_LEVEL_ERROR, __fmt, ## __VA_ARGS__); \
+	} while (0)
+
+/* */
+#define log_warn(__hive, __fmt, ...) \
+	do { if (log_get_level(__hive) >= LOG_LEVEL_WARNING) \
+		log_msg(__hive, LOG_LEVEL_WARNING, __fmt, ## __VA_ARGS__); \
+	} while (0)
+/* */
+#define log_notice(__hive, __fmt, ...) \
+	do { if (log_get_level(__hive) >= LOG_LEVEL_NOTICE) \
+		log_msg(__hive, LOG_LEVEL_NOTICE, __fmt, ## __VA_ARGS__); \
+	} while (0)
+
+/* */
+#define log_info(__hive, __fmt, ...) \
+	do { if (log_get_level(__hive) >= LOG_LEVEL_INFO) \
+		log_msg(__hive, LOG_LEVEL_INFO, __fmt, ## __VA_ARGS__); \
+	} while (0)
+
+/* */
+#define log_debug(__hive, __fmt, ...) \
+	do { if (log_get_level(__hive) >= LOG_LEVEL_DEBUG) \
+		log_dbg(__hive, __FILE__, __LINE__, __func__, __fmt, ## __VA_ARGS__); \
+	} while (0)
+
+/* */
+void log_init(const char *path);
+
+/* */
+void log_fini(void);
+
+/* */
+void log_set_progname(const char *path);
+
+/* */
+const char * log_get_progname(void);
+
+/* */
+void log_debug_redirect(enum log_hive hive, const char *path);
+
+/* */
+void log_redirect(const char *path);
+
+/* */
+void log_set_name(enum log_hive index, char *name);
+
+/* */
+void log_set_mask(enum log_hive hive, unsigned int mask);
+
+/* */
+unsigned int log_get_mask(enum log_hive hive);
+
+/* */
+void log_reset_mask(enum log_hive hive, unsigned int mask);
+
+/* */
+void log_set_level(enum log_hive hive, enum log_level level);
+
+/* */
+enum log_level log_get_level(enum log_hive hive);
+
+/* */
+void log_dbg(enum log_hive hive, const char *file, int ln, const char *fname,
+	const char *fmt, ...) __attribute__((format(printf,5,6)));
+
+/* */
+void log_msg(enum log_hive index, enum log_level level, const char *fmt, ...)
+	__attribute__((format(printf,3,4)));
+
+#endif /* _LOG_H */
+

