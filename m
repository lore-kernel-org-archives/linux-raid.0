From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Suggested patch against raidtools
Date: Mon, 10 Mar 2003 00:54:49 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E6C28A9.74798DF6@SteelEye.com>
References: <000601c2e696$2a24e8a0$05eb10ac@bongo2>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------678D1CF7CD7F43B3A9639059"
Return-path: <linux-raid-owner@vger.kernel.org>
To: Simon Edwards <simon.edwards@proprius.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------678D1CF7CD7F43B3A9639059
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Simon Edwards wrote:

> if you try and use "md1" and "md10"
> you'll get an error saying the device is already running.

Hmm...coincidentally, I just reported this same bug to Red Hat a couple
of days ago. The patch that I came up with is attached...although, yours
seems to be a little simpler.

--
Paul
--------------678D1CF7CD7F43B3A9639059
Content-Type: text/plain; charset=us-ascii;
 name="raidtools.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="raidtools.diff"

diff -urN raidtools-1.00.2/raid_io.c raidtools-1.00.2steeleye/raid_io.c
--- raidtools-1.00.2/raid_io.c	Mon Apr 15 04:09:11 2002
+++ raidtools-1.00.2steeleye/raid_io.c	Thu Feb 27 15:22:07 2003
@@ -515,8 +515,10 @@
 }
 
 
+
 int check_active (md_cfg_entry_t *p)
 {
+	char md_dev_chars[] = "0123456789md";
 	char buffer[MAX_LINE_LENGTH], line[MAX_LINE_LENGTH], *ch;
 	FILE *fp;
 
@@ -528,11 +530,15 @@
 	while (1) {
 		if ((fgets(line, MAX_LINE_LENGTH, fp)) == NULL)
 			break;
-		if (strstr(line, buffer) && !strstr(line, "inactive")) {
-			fprintf(stderr, "%s: array is active -- run raidstop first.\n", p->md_name);
-			fclose(fp);
-			return 1;
-		}
+		if (!(ch = strstr(line, buffer)))
+			continue;
+		if (strspn(ch, md_dev_chars) != strspn(buffer, md_dev_chars))
+			continue;
+		if (strstr(line, "inactive"))
+			continue;
+		fprintf(stderr, "%s: array is active -- run raidstop first.\n", p->md_name);
+		fclose(fp);
+		return 1;
 	}
 	fclose(fp);
 	return 0;

--------------678D1CF7CD7F43B3A9639059--

