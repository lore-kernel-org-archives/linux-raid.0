From: rgp@rich-paul.net
Subject: [another-patch] Real bugfix for raidtools
Date: Mon, 10 Mar 2003 06:26:20 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030310112620.GA14093@io.masterlinkcorp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey, y'all, here's another small patch for the latest raidtools (that I
know of).  It removes a problem in lsraid:  if a line from
/proc/partitions was >100 characters, it would be partially read, and
it's back end could cause segfaults or other nasties on the next
iteration.

The copyright on this patch is hereby abandoned.

It expects to be applied without my other patch, and visa versa, so some
munging may be in order.  The solution is not optimal anyway, but it was
quick.  If I get a line from fgets that does not have a newline, I
print a warning, discard it, and discard everything else until I DO get
a newline;

I also enlarged the buffer, but the best built buffers of mice and men
etc...



--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch2

diff -r -u --minimal -w --new-file ../raidtools-1.00.3.orig/lsraid.c ./lsraid.c
--- ../raidtools-1.00.3.orig/lsraid.c	2003-01-15 03:58:25.000000000 -0500
+++ ./lsraid.c	2003-03-10 06:12:50.000000000 -0500
@@ -1029,6 +1029,10 @@
 
 static int load_partitions(LSRContext *ctxt)
 {
+//FIXME: use some factor of PATH_MAX or something.
+#undef MAX_LINE_LENGTH
+//#define MAX_LINE_LENGTH 20
+#define MAX_LINE_LENGTH 4096
     FILE *proc;
     int major, minor, rc;
     char line[MAX_LINE_LENGTH], name[MAX_LINE_LENGTH];
@@ -1047,6 +1051,16 @@
         rc = 0;
         if ((fgets(line, MAX_LINE_LENGTH, proc)) == NULL)
             break;
+		if (line[strlen(line)-1] != '\n') {
+			fprintf(stderr, "skipping long line: %s", line);
+			do {
+				if ((fgets(line, MAX_LINE_LENGTH, proc)) == NULL)
+					break;
+				fprintf(stderr,"%s", line);
+			} while (line[strlen(line)-1] != '\n');
+			continue;
+		};
+
 
         name[0] = 0;
         major = minor = 0;

--0OAP2g/MAC+5xKAE--
