From: rgp@rich-paul.net
Subject: [really-patch] Small improvement to raidtools
Date: Mon, 10 Mar 2003 04:44:42 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030310094442.GA11361@io.masterlinkcorp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey, y'all, here's a small patch for the latest raidtools (that I know
of).  It removes a couple little annoyances and trivial bugs, and adds a
ChangeLog, which enumerates them. :)

The copyright on this patch is hereby abandoned.

|    An you be mine, I'll give you to my friend;
|    An you be not, hang, beg, starve, die in the streets,
|    For, by my soul, I'll ne'er acknowledge thee,
|    Nor what is mine shall never do thee good.
|
|						Capulet
|						Romeo and Juliet


If it burns down your house or seduces your wife, you asked for it. I'm
not subscribed, so please cc me on replies.

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch

diff -r -u --minimal -w --new-file ../raidtools-1.00.3.orig/ChangeLog ./ChangeLog
--- ../raidtools-1.00.3.orig/ChangeLog	1969-12-31 19:00:00.000000000 -0500
+++ ./ChangeLog	2003-03-10 03:38:51.000000000 -0500
@@ -0,0 +1,24 @@
+2002-10-03  Rich Paul  <rgp@rich-paul.net>
+
+	* minor cleanups in mkraid
+
+	* no longer require root for --help or --version
+
+	* reformatted mkraid --help, and removed lies (-v ...)
+
+	* exit(0) from usage or version, except when there is an error
+
+	* usage to stdout if it's requested, otherwise stderr
+
+	* add 'compiled for md ...' to version
+
+	* report program name used to invoke in usage
+
+	* removed lots of dead code, aparently left from when there
+		was one multipurpose binary.
+
+	* added this nifty ChangeLog :)
+
+	* changed suggestion from 'read the lsraid HOWTO' to 'read the
+		lsraid man page', as I am unable to locate the former document.
+
diff -r -u --minimal -w --new-file ../raidtools-1.00.3.orig/common.h ./common.h
--- ../raidtools-1.00.3.orig/common.h	2003-01-15 03:58:25.000000000 -0500
+++ ./common.h	2003-03-10 01:48:51.000000000 -0500
@@ -46,7 +46,7 @@
 #include <linux/unistd.h>
 
 #define DEBUG				(0)
-#define EXIT_USAGE			(EXIT_FAILURE)
+#define EXIT_USAGE			(0)
 #define EXIT_VERSION			(0)
 #define MAX_LINE_LENGTH			(100)
 #define ZERO_BUFFER_SIZE		(64)	/* 64kB */
diff -r -u --minimal -w --new-file ../raidtools-1.00.3.orig/lsraid.c ./lsraid.c
--- ../raidtools-1.00.3.orig/lsraid.c	2003-01-15 03:58:25.000000000 -0500
+++ ./lsraid.c	2003-03-10 03:16:20.000000000 -0500
@@ -215,9 +215,11 @@
  */
 
 
-static void print_version()
+static void print_version(const char *prog)
 {
-    fprintf(stdout, "lsraid version " LSRAID_VERSION "\n");
+	printf("%s version %s compiled for md %s\n",
+		prog, LSRAID_VERSION, MD_VERSION
+	);
     exit(0);
 }  /* print_version() */
 
@@ -338,7 +340,7 @@
                 else if (strcmp(argv[i], "--help") == 0)
                     print_usage_long();
                 else if (strcmp(argv[i], "--version") == 0)
-                    print_version();
+                    print_version(argv[0]);
                 else
                 {
                     fprintf(stderr, "lsraid: Invalid option: %s\n",
@@ -353,7 +355,7 @@
                 break;
 
             case 'V':
-                print_version();
+                print_version(argv[0]);
                 break;
 
             case 'A':
diff -r -u --minimal -w --new-file ../raidtools-1.00.3.orig/mkraid.c ./mkraid.c
--- ../raidtools-1.00.3.orig/mkraid.c	2003-01-15 03:58:25.000000000 -0500
+++ ./mkraid.c	2003-03-10 03:20:04.000000000 -0500
@@ -21,9 +21,19 @@
 
 void printcfg (md_cfg_entry_t * cfg);
 
-void usage (void) {
-    printf("usage: mkraid [--configfile] [--version] [--force] [--upgrade]\n");
-    printf("       [--dangerous-no-resync] [-acfhuv] </dev/md?>*\n");
+#define ELEMENTS(array)  (sizeof(array)/sizeof(array[0]))
+void usage (int error, struct poptOption *opt) {
+	FILE *stream = error?stderr:stdout;
+	fprintf(stream,"usage: mkraid\n");
+	for(;opt->longName || opt->shortName;opt++) {
+		if ( opt->shortName == 'R' )
+			continue;
+		fprintf(stream,"    %c%c --%s\n",
+			opt->shortName?'-':' ',
+			opt->shortName?opt->shortName:' ',
+			opt->longName);
+	}
+	exit(error);
 }
 
 static int makeOneRaid(mdu_version_t * ver, enum mkraidFunc func,
@@ -61,7 +71,6 @@
 
 int main (int argc, char *argv[])
 {
-    char *namestart=argv[0];
     FILE *fp = NULL;
     md_cfg_entry_t *p;
     int exit_status=0;
@@ -96,57 +105,33 @@
 	fprintf(stderr, "%s: %s\n", 
 		poptBadOption(optCon, POPT_BADOPTION_NOALIAS),
 		poptStrerror(i));
-	usage();
-	return EXIT_FAILURE;
+		usage(1,optionsTable);
+	}
+
+	if (help)
+		usage(0,optionsTable);
+
+	if (version) {
+		printf("%s version %d.%d.%d compiled for md " MD_VERSION "\n",
+			argv[0],
+			MKRAID_MAJOR_VERSION, MKRAID_MINOR_VERSION,
+			MKRAID_PATCHLEVEL_VERSION
+		);
+		return EXIT_VERSION;
     }
 
+	args = (char **)poptGetArgs(optCon);
+	if (!args)
+		usage(1,optionsTable);
+
     if (prepare_raidlib())
          return EXIT_FAILURE;
 
-    namestart = strrchr(argv[0], '/');
-    if (!namestart)
-        namestart = argv[0];
-    else
-        namestart++;
-
-    if (!strcmp (namestart, "mkraid")) {
         func = mkraid;
 	if (all_flag) {
         	fprintf (stderr, "--all not possible for mkraid!\n");
         	return (EXIT_FAILURE);
 	}
-    } else if (!strcmp (namestart, "raid0run")) {
-        func = raid0run;
-	if (old_force_flag) {
-        	fprintf (stderr, "--force not possible for raid0run!\n");
-        	return (EXIT_FAILURE);
-	}
-	if (force_flag) {
-        	fprintf (stderr, "--really-force not possible for raid0run!\n");
-        	return (EXIT_FAILURE);
-	}
-	if (upgrade_flag) {
-        	fprintf (stderr, "--upgrade not possible for raid0run!\n");
-        	return (EXIT_FAILURE);
-	}
-	if (no_resync_flag) {
-        	fprintf (stderr, "--dangerous-no-resync not possible for raid0run!\n");
-        	return (EXIT_FAILURE);
-	}
-    } else {
-        fprintf (stderr, "Unknown command %s\n", argv[0]);
-        usage();
-        return (EXIT_FAILURE);
-    }
-
-    if (help) {
-	usage();
-	return EXIT_FAILURE;
-    } else if (version) {
-	printf("mkraid version %d.%d.%d\n", MKRAID_MAJOR_VERSION,
-			MKRAID_MINOR_VERSION, MKRAID_PATCHLEVEL_VERSION);
-	return EXIT_VERSION;
-    }
 
     fp = fopen(configFile, "r");
     if (fp == NULL) {
@@ -159,24 +144,17 @@
     if (parse_config(fp))
 	goto abort;
 
-    args = (char **)poptGetArgs(optCon);
-    if (!all_flag && !args) {
-	usage();
-	return EXIT_FAILURE;
-    }
-
     if (getMdVersion(&ver))
 	return EXIT_FAILURE;
 
-    if (old_force_flag && (func == mkraid)) {
+	if (old_force_flag) {
 	fprintf(stderr, 
-
 "
  WARNING!
 
  NOTE: if you are recovering a double-disk error or some other failure mode
  that made your array unrunnable but data is still intact then it's strongly
- recommended to use the lsraid utility and to read the lsraid HOWTO.
+ recommended to use the lsraid utility and to read the lsraid man page.
 
  If your RAID array holds useful and not yet backed up data then --force
  and the hot-add/hot-remove functionality should be used with extreme care!
@@ -219,49 +197,16 @@
 	return 0;
     }
 
-    if (all_flag) {
-	for (p = cfg_head; p; p = p->next) {
-	    printf("considering %s...\n", p->md_name);
-	    if ((p->array.param.level != 0) &&
-			(p->array.param.level != -1)) {
-		fprintf(stderr, "%s is not a RAID0 or LINEAR array, skipping.\n", p->md_name);
-		continue;
-	    }
-	    if (!p->array.param.not_persistent) {
-		fprintf(stderr, "%s is persistent, skipping.\n", p->md_name);
-		return EXIT_FAILURE;
-	    }
-	    /*
-	     * Invert the meaning of no_resync_flag from this point on
-	     * to avoid confusion.
-	     */
-	    if (makeOneRaid(&ver, func, p, force_flag, upgrade_flag,
-			!no_resync_flag))
-		goto abort;
-	}
-    } else {
-
     while (*args) {
 	for (p = cfg_head; p; p = p->next) {
-	    if (strcmp(p->md_name, *args)) continue;
+			if (strcmp(p->md_name, *args))
+				continue;
 	    if (check_active(cfg)) 
 		goto abort;
 	    if (force_flag) {
 		fprintf(stderr, "DESTROYING the contents of %s in 5 seconds, Ctrl-C if unsure!\n", *args);
 		sleep(5);
 	    }
-	    if (func == raid0run) {
-		if ((p->array.param.level != 0) &&
-			(p->array.param.level != -1)) {
-			fprintf(stderr, "%s is not a RAID0 or LINEAR array!\n",
-					p->md_name);
-			return EXIT_FAILURE;
-		}
-		if (!p->array.param.not_persistent) {
-			fprintf(stderr, "%s must be a nonpersistent RAID0 or LINEAR array!\n", p->md_name);
-			return EXIT_FAILURE;
-		}
-	    }
 	    if (makeOneRaid(&ver, func, p, force_flag, upgrade_flag, !no_resync_flag))
 		goto abort;
 	    break;
@@ -272,13 +217,16 @@
 	}
 	args++;
     }
-    }
 
     fclose(fp);
     return 0;
 
 abort:
-    fprintf(stderr, "mkraid: aborted.\n(In addition to the above messages, see the syslog and /proc/mdstat as well\n for potential clues.)\n");
+	fprintf(stderr, 
+		"mkraid: aborted.\n"
+		"(In addition to the above messages, see the syslog and\n"
+		"  /proc/mdstat for potential clues.)\n"
+	);
     exit_status = 1;
     if (fp)
 	fclose(fp);
diff -r -u --minimal -w --new-file ../raidtools-1.00.3.orig/raidreconf.c ./raidreconf.c
--- ../raidtools-1.00.3.orig/raidreconf.c	2003-01-15 03:58:25.000000000 -0500
+++ ./raidreconf.c	2003-03-10 03:07:02.000000000 -0500
@@ -84,9 +84,6 @@
 		return EXIT_FAILURE;
 	}
 
-	if (!test && prepare_raidlib ())
-		return EXIT_FAILURE;
-
 	if (help) {
 		usage ();
 		return EXIT_FAILURE;
@@ -99,6 +96,9 @@
 		return EXIT_VERSION;
 	}
 
+	if (!test && prepare_raidlib ())
+		return EXIT_FAILURE;
+
 	if (test) {
 		printf
 		    ("test mode - plain files are used, no kernel RAID interaction\n");

--ikeVEW9yuYc//A+q--
