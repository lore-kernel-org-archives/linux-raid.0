From: Luca Berra <bluca@comedia.it>
Subject: small patches to mdadm
Date: Wed, 25 Aug 2004 09:22:36 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040825072235.GB5851@percy.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

Neil,
i made some small patches to mdadm 1.7.0
the first is just some makefile cleanup
the second adds a -i (pid) option to monitor mode which causes mdadm to
write its own pid to the specified file, this comes useful to simplify
init scripts that call mdadm --monitor --daemonize.

Regards,
L.



-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-1.7.0-makefile.patch"

--- mdadm-1.7.0/Makefile.makefile	2004-08-11 03:28:50.000000000 +0200
+++ mdadm-1.7.0/Makefile	2004-08-25 09:17:36.993441628 +0200
@@ -31,6 +31,11 @@
 # e.g.  make CXFLAGS=-O to optimise
 TCC = tcc
 UCLIBC_GCC = $(shell for nm in i386-uclibc-linux-gcc i386-uclibc-gcc; do which $$nm > /dev/null && { echo $$nm ; exit; } ; done; echo false No uclibc found )
+DIET_GCC = diet gcc
+
+KLIBC=/home/src/klibc/klibc-0.77
+
+KLIBC_GCC = gcc -nostdinc -iwithprefix include -I$(KLIBC)/klibc/include -I$(KLIBC)/linux/include -I$(KLIBC)/klibc/arch/i386/include -I$(KLIBC)/klibc/include/bits32
 
 CC = gcc
 CXFLAGS = -ggdb
@@ -52,11 +57,9 @@
 MAN5DIR = $(MANDIR)/man5
 MAN8DIR = $(MANDIR)/man8
 
-
-KLIBC=/home/src/klibc/klibc-0.77
-
 OBJS =  mdadm.o config.o mdstat.o  ReadMe.o util.o Manage.o Assemble.o Build.o Create.o Detail.o Examine.o Grow.o Monitor.o dlink.o Kill.o Query.o
 SRCS =  mdadm.c config.c mdstat.c  ReadMe.c util.c Manage.c Assemble.c Build.c Create.c Detail.c Examine.c Grow.c Monitor.c dlink.c Kill.c Query.c
+ASSEMBLE_SRCS = mdassemble.c Assemble.c config.c dlink.c util.c
 
 all : mdadm mdadm.man md.man mdadm.conf.man
 
@@ -66,7 +69,7 @@
 	$(CC) $(LDFLAGS) -o mdadm $^
 
 mdadm.static : $(OBJS)
-	$(CC) $(LDFLAGS) --static -o mdadm.static $^
+	$(CC) $(LDFLAGS) -static -o mdadm.static $^
 
 mdadm.tcc : $(SRCS) mdadm.h
 	$(TCC) -o mdadm.tcc $(SRCS)
@@ -78,15 +81,22 @@
 	rm -f $(OBJS) 
 	gcc -nostdinc -iwithprefix include -I$(KLIBC)/klibc/include -I$(KLIBC)/linux/include -I$(KLIBC)/klibc/arch/i386/include -I$(KLIBC)/klibc/include/bits32 $(CFLAGS) $(SRCS)
 
-mdassemble : mdassemble.c Assemble.c config.c dlink.c util.c mdadm.h
+mdassemble : $(ASSEMBLE_SRCS) mdadm.h
 	rm -f $(OBJS)
-	diet gcc -o mdassemble mdassemble.c Assemble.c config.c dlink.c util.c
+	$(DIET_GCC) -o mdassemble $(ASSEMBLE_SRCS) 
 
-# This doesn't work
-mdassemble.klibc : mdassemble.c Assemble.c config.c dlink.c util.c mdadm.h
+mdassemble.static : $(ASSEMBLE_SRCS) mdadm.h
+	rm -f $(OBJS)
+	$(CC) $(LDFLAGS) -static -o mdassemble $(ASSEMBLE_SRCS)
+
+mdassemble.uclibc : $(ASSEMBLE_SRCS) mdadm.h
 	rm -f $(OBJS)
-	gcc -nostdinc -iwithprefix include -I$(KLIBC)/klibc/include -I$(KLIBC)/linux/include -I$(KLIBC)/klibc/arch/i386/include -I$(KLIBC)/klibc/include/bits32 $(CFLAGS) -o mdassemble mdassemble.c Assemble.c config.c dlink.c util.c
+	$(UCLIBC_GCC) -DUCLIBC -static -o mdassemble.uclibc $(ASSEMBLE_SRCS) 
 
+# This doesn't work
+mdassemble.klibc : $(ASSEMBLE_SRCS) mdadm.h
+	rm -f $(OBJS)
+	$(KLIBC_GCC) $(CFLAGS) -o mdassemble $(ASSEMBLE_SRCS)
 
 mdadm.man : mdadm.8
 	nroff -man mdadm.8 > mdadm.man
@@ -106,7 +116,8 @@
 	$(INSTALL) -D -m 644 mdadm.conf.5 $(DESTDIR)$(MAN5DIR)/mdadm.conf.5
 
 clean : 
-	rm -f mdadm $(OBJS) core *.man mdadm.tcc mdadm.uclibc mdadm.static *.orig *.porig *.rej *.alt
+	rm -f mdadm $(OBJS) core *.man mdadm.tcc mdadm.uclibc mdadm.static *.orig *.porig *.rej *.alt \
+	mdassemble mdassemble.static mdassemble.uclibc mdassemble.klibc
 
 dist : clean
 	./makedist

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mdadm-1.7.0-pidfile.patch"

--- mdadm-1.7.0/ReadMe.c.pidfile	2004-08-11 04:05:15.000000000 +0200
+++ mdadm-1.7.0/ReadMe.c	2004-08-25 07:59:23.224003584 +0200
@@ -90,7 +90,7 @@
  *     At the time if writing, there is only minimal support.
  */
 
-char short_options[]="-ABCDEFGQhVvbc:l:p:m:n:x:u:c:d:z:U:sa::rfRSow1t";
+char short_options[]="-ABCDEFGQhVvbc:i:l:p:m:n:x:u:c:d:z:U:sa::rfRSow1t";
 struct option long_options[] = {
     {"manage",    0, 0, '@'},
     {"misc",      0, 0, '#'},
@@ -157,6 +157,7 @@
     {"daemonise", 0, 0, 'f'},
     {"daemonize", 0, 0, 'f'},
     {"oneshot",   0, 0, '1'},
+    {"pid",   1, 0, 'i'},
     
     {0, 0, 0, 0}
 };
@@ -418,6 +419,7 @@
 "  --config=     -c   : specify a different config file\n"
 "  --scan        -s   : find mail-address/program in config file\n"
 "  --daemonise   -f   : Fork and continue in child, parent exits\n"
+"  --pid=        -i   : In daemon mode write pid to specified file instead of stdout\n"
 "  --oneshot     -1   : Check for degraded arrays, then exit\n"
 "  --test        -t   : Generate a TestMessage event against each array at startup\n"
 ;
--- mdadm-1.7.0/Monitor.c.pidfile	2004-08-11 03:52:40.000000000 +0200
+++ mdadm-1.7.0/Monitor.c	2004-08-25 08:25:14.554960895 +0200
@@ -47,7 +47,7 @@
 int Monitor(mddev_dev_t devlist,
 	    char *mailaddr, char *alert_cmd,
 	    int period, int daemonise, int scan, int oneshot,
-	    char *config, int test)
+	    char *config, int test, char* pidfile)
 {
 	/*
 	 * Every few seconds, scan every md device looking for changes
@@ -127,7 +127,18 @@
 	if (daemonise) {
 		int pid = fork();
 		if (pid > 0) {
-			printf("%d\n", pid);
+			if (!pidfile)
+				printf("%d\n", pid);
+			else {
+				FILE *pid_file;
+				pid_file=fopen(pidfile, "w");
+				if (!pid_file)
+					perror("cannot create pid file");
+				else {
+					fprintf(pid_file,"%d\n", pid);
+					fclose(pid_file);
+				}
+			}
 			return 0;
 		}
 		if (pid < 0) {
@@ -428,6 +439,8 @@
 		}
 		test = 0;
 	}
+	if (pidfile)
+		unlink(pidfile);
 	return 0;
 }
 
--- mdadm-1.7.0/mdadm.c.pidfile	2004-08-11 03:35:16.000000000 +0200
+++ mdadm-1.7.0/mdadm.c	2004-08-25 07:59:23.226003626 +0200
@@ -233,6 +233,7 @@
 	char *program = NULL;
 	int delay = 0;
 	int daemonise = 0;
+	char *pidfile = NULL;
 	int oneshot = 0;
 
 	int copies;
@@ -677,6 +678,13 @@
 		case O(MONITOR,'f'): /* daemonise */
 			daemonise = 1;
 			continue;
+		case O(MONITOR,'i'): /* pid */
+			if (pidfile)
+				fprintf(stderr, Name ": only specify one pid file. %s ignored.\n",
+					optarg);
+			else
+				pidfile = optarg;
+			continue;
 		case O(MONITOR,'1'): /* oneshot */
 			oneshot = 1;
 			continue;
@@ -963,8 +971,13 @@
 			rv = 1;
 			break;
 		}
+		if (pidfile && !daemonise) {
+			fprintf(stderr, Name ": Cannot write a pid file when not in daemon mode\n");
+			rv = 1;
+			break;
+		}
 		rv= Monitor(devlist, mailaddr, program,
-			    delay?delay:60, daemonise, scan, oneshot, configfile, test);
+			    delay?delay:60, daemonise, scan, oneshot, configfile, test, pidfile);
 		break;
 
 	case GROW:
--- mdadm-1.7.0/mdadm.h.pidfile	2004-08-11 03:28:50.000000000 +0200
+++ mdadm-1.7.0/mdadm.h	2004-08-25 07:59:23.227003647 +0200
@@ -187,7 +187,7 @@
 extern int Monitor(mddev_dev_t devlist,
 		   char *mailaddr, char *alert_cmd,
 		   int period, int daemonise, int scan, int oneshot,
-		   char *config, int test);
+		   char *config, int test, char *pidfile);
 
 extern int Kill(char *dev, int force);
 
--- mdadm-1.7.0/mdadm.8.pidfile	2004-08-11 04:05:28.000000000 +0200
+++ mdadm-1.7.0/mdadm.8	2004-08-25 08:11:28.142831013 +0200
@@ -540,6 +540,13 @@
 is found in the config file.
 
 .TP
+.BR -i ", " --pid
+When
+.B mdadm
+is running in daemon mode, write the pid of the daemon process to
+the specified file, instead of printing it on standard output.
+
+.TP
 .BR -1 ", " --oneshot
 Check arrays only once.  This will generate
 .B NewArray

--/04w6evG8XlLl3ft--
