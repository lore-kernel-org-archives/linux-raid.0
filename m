From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raidstart program device detect problem
Date: Wed, 1 Dec 2004 12:23:35 -0500
Message-ID: <200412011723.iB1HNf904973@www.watkins-home.com>
References: <20041201201025B.kenji@miyake.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041201201025B.kenji@miyake.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Kenji Miyake' <kenji@miyake.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As far as I know raidtools is not supported anymore.
But raidtools2 is new to me.  So, not sure.
mdadm is the preferred tool.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Kenji Miyake
Sent: Wednesday, December 01, 2004 6:10 AM
To: linux-raid@vger.kernel.org
Subject: raidstart program device detect problem

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
 			fprintf(stderr, "%s: active -- run raidstop\n",
p->md_name);
 			fclose(fp);
 			return 1;
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

