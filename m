From: Doug Ledford <dledford@redhat.com>
Subject: [Patch mdadm-2.6.7.1 3/3] Make incremental mode work with partitionable arrays
Date: Wed, 29 Oct 2008 15:05:37 -0400
Message-ID: <c9389e3df675e805befb98a05927318f7f206031.1225306892.git.dledford@redhat.com>
References: <cover.1225306892.git.dledford@redhat.com>
 <c82952743d7177261512b107adcb101ecd035a21.1225306892.git.dledford@redhat.com>
 <7c468095f2afc12245eb2988457f87440b3882e9.1225306892.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.5.6.5"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7c468095f2afc12245eb2988457f87440b3882e9.1225306892.git.dledford@redhat.com>
In-Reply-To: <cover.1225306892.git.dledford@redhat.com>
References: <cover.1225306892.git.dledford@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------1.5.6.5
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


There were multiple problems with incremental mode and partitionable
arrays.  Change the logic to pay more attention to what it finds in
mdadm.conf when setting up incremental arrays.  Modify is_standard to
differentiate between a required partitioned name format and an optionally
partitioned named format.  Modify open_mddev() to know about change to
is_standard.  Make Incremental differentiate between create default
autof setting, command line autof setting, and array specific autof
setting, with order of preference being command line, conf file, default.
Disable the homehost test in the event there is no match for an array
so we can hotplug new arrays into a running machine without them having
to exist in mdadm.conf first (a random array number will be picked for
the hot plugged array).  Honor any name from mdadm.conf that matches the
UUID of a device, not just standard names.  Verify that the array name
as matched in mdadm.conf allows the requested mode of operation and reject
attempts to start non-partitionable arrays as partitioned and vice versa.

Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 Incremental.c |  122 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 mdopen.c      |    4 +-
 util.c        |    2 +-
 3 files changed, 117 insertions(+), 11 deletions(-)
--------------1.5.6.5
Content-Type: text/x-patch; name="c9389e3df675e805befb98a05927318f7f206031.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="c9389e3df675e805befb98a05927318f7f206031.diff"

diff --git a/Incremental.c b/Incremental.c
index 9c6524f..806d192 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -87,9 +87,6 @@ int Incremental(char *devname, int verbose, int runstop,
 
 	struct createinfo *ci = conf_get_create_info();
 
-	if (autof == 0)
-		autof = ci->autof;
-
 	/* 1/ Check if devices is permitted by mdadm.conf */
 
 	if (!conf_test_dev(devname)) {
@@ -204,6 +201,10 @@ int Incremental(char *devname, int verbose, int runstop,
 	}
 
 	/* 3a/ if not, check for homehost match.  If no match, reject. */
+	/* We want to support hot plugged arrays that aren't listed in
+	 * /etc/mdadm.conf, so we need to skip the homehost test and allow
+	 * unmatched devices through so we can simply pick a random entry
+	 * to start them under
 	if (!match) {
 		if (homehost == NULL ||
 		    st->ss->match_home(st, homehost) == 0) {
@@ -212,23 +213,128 @@ int Incremental(char *devname, int verbose, int runstop,
 	      ": not found in mdadm.conf and not identified by homehost.\n");
 			return 2;
 		}
-	}
+	} */
 	/* 4/ Determine device number. */
-	/* - If in mdadm.conf with std name, use that */
+	/* - If in mdadm.conf with any name, use that */
 	/* - UUID in /var/run/mdadm.map  use that */
 	/* - If name is suggestive, use that. unless in use with */
 	/*           different uuid. */
 	/* - Choose a free, high number. */
 	/* - Use a partitioned device unless strong suggestion not to. */
 	/*         e.g. auto=md */
-	if (match && is_standard(match->devname, &devnum))
-		/* We have devnum now */;
-	else if ((mp = map_by_uuid(&map, info.uuid)) != NULL)
+	if (match) {
+		int use_partitions;
+		if (autof != 0)
+			/* command line overrides config file */
+			match->autof = autof;
+		else if (match->autof == 0)
+			/* no specific autof setting in config for this */
+			/* array, so use the ci->autof instead */
+			match->autof = ci->autof;
+		switch(is_standard(match->devname, &devnum)) {
+		case 0: /* non-standard name */
+			/* Need to find a free devnum to use */
+			/* Need to know if we are supposed to be partitioned */
+			/* or not to find a free devnum in the right major */
+			switch(match->autof & 0x7) {
+			case 3:
+			case 5:
+				autof = match->autof;
+			case 0: /* this is what you get when you */
+				/* don't specify anything, leave it */
+				/* defaulting to non-partitioned for */
+				/* back compatibility */
+				use_partitions = 0;
+				break;
+			default:
+				autof = match->autof;
+				use_partitions = 1;
+			}
+			/* If we already have an assigned devnum find it */
+			if ((mp = map_by_uuid(&map, info.uuid)) != NULL)
+				devnum = mp->devnum;
+			else
+				devnum = find_free_devnum(use_partitions);
+
+			if (devnum == NoMdDev) {
+				fprintf(stderr, Name
+					": No spare md devices!!\n");
+				return 2;
+			}
+			break;
+		case -1: /* standard, non-partitioned name */
+			switch(match->autof & 0x7) {
+			case 3:
+			case 5:
+			case 0:
+				/* all good */
+				use_partitions = 0;
+				break;
+			default:
+				/* oops, attempting to set things to */
+				/* an invalid state */
+				fprintf(stderr, Name
+				": can't be a partitioned device by naming standards!!\n");
+				return 2;
+			}
+			break;
+		case 1: /* standard, partitioned name */
+			switch(match->autof & 0x7) {
+			case 3:
+			case 5:
+				/* oops, attempting to set things to */
+				/* an invalid state */
+				fprintf(stderr, Name
+				": must be a partitioned device by naming standards!!\n");
+				return 2;
+			case 0:
+				/* we haven't been told how many */
+				/* partitions to make on either the */
+				/* command line or the config file, */
+				/* set to the default and enable */
+				/* partitioned mode due to our name */
+				autof = match->autof = (4 << 3) | 2;
+			default:
+				/* all good */
+				use_partitions = 1;
+				break;
+			}
+			break;
+		case 2: /* may be either partitioned or not, devnum is set */
+			switch(match->autof & 0x7) {
+			case 0:
+				/* not specified in any way, default to */
+				/* unpartitioned for back compatibility */
+			case 1:
+			case 3:
+			case 5:
+				use_partitions = 0;
+				break;
+			case 2:
+				/* partitioned, but we didn't get a number */
+				/* of parititions, so use the default */
+				match->autof = autof |= 4 << 3;
+			case 4:
+			case 6:
+				/* the number of partitions is already in */
+				/* autof */
+				use_partitions = 1;
+				break;
+			}
+			break;
+		}
+		/* We have devnum now */
+		if (use_partitions && devnum > 0)
+			devnum = (-1-devnum);
+	} else if ((mp = map_by_uuid(&map, info.uuid)) != NULL)
 		devnum = mp->devnum;
 	else {
 		/* Have to guess a bit. */
 		int use_partitions = 1;
 		char *np, *ep;
+
+		if (autof == 0 && ci->autof)
+			autof = ci->autof;
 		if ((autof&7) == 3 || (autof&7) == 5)
 			use_partitions = 0;
 		np = strchr(info.name, ':');
diff --git a/mdopen.c b/mdopen.c
index 448a9eb..36233cf 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -147,8 +147,8 @@ int open_mddev(char *dev, int autof)
 				return -1;
 			}
 			break;
-		case 3: /* create md, reject std>0 */
-			if (std > 0) {
+		case 3: /* create md, reject std==1 */
+			if (std == 1) {
 				fprintf(stderr, Name ": that --auto option "
 				"not compatable with device named %s\n", dev);
 				return -1;
diff --git a/util.c b/util.c
index 75f3706..baa1690 100644
--- a/util.c
+++ b/util.c
@@ -396,7 +396,7 @@ int is_standard(char *dev, int *nump)
 	if (!d)
 		return 0;
 	if (strncmp(d, "/d",2)==0)
-		d += 2, type=1; /* /dev/md/dN{pM} */
+		d += 2, type=2; /* /dev/md/dN{pM} */
 	else if (strncmp(d, "/md_d", 5)==0)
 		d += 5, type=1; /* /dev/md_dNpM */
 	else if (strncmp(d, "/md", 3)==0)

--------------1.5.6.5--


