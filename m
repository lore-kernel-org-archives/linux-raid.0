From: Kenji Miyake <kenji@miyake.org>
Subject: raidstart program device detect problem
Date: Wed, 01 Dec 2004 20:10:25 +0900
Message-ID: <20041201201025B.kenji@miyake.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
 I found some problem in raidtools2.

raiddevice md1 cannot start if raiddevice md10 was setup and running.

raidstart program check running device partially.

--- 1/raidtools2-0.90.20010914/raid_io.c	Wed Dec  1 19:30:26 2004
+++ raidtools2-0.90.20010914/raid_io.c	Wed Nov 24 19:41:42 2004
@@ -528,12 +528,14 @@
 	if ((ch = strstr(p->md_name, "/md")) == NULL)
 		return 0;
 	strcpy(buffer, ch+1);
+	strcat(buffer, " : active");
 	if ((fp = fopen("/proc/mdstat", "r")) == NULL)
 		return 0;
 	while (1) {
 		if ((fgets(line, MAX_LINE_LENGTH, fp)) == NULL)
 			break;
-		if (strstr(line, buffer) && !strstr(line, "inactive")) {
+		if (strstr(line, buffer))
+		{
 			fprintf(stderr, "%s: active -- run raidstop\n", p->md_name);
 			fclose(fp);
 			return 1;
