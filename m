From: Neil Brown <neilb@suse.de>
Subject: Re: [Patch mdadm-2.6.7.1 0/3] Misc fixes for mdadm-2.6.7.1
Date: Thu, 30 Oct 2008 09:56:30 +1100
Message-ID: <18696.59934.872875.299706@notabene.brown>
References: <cover.1225306892.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Wednesday October 29
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday October 29, dledford@redhat.com wrote:
> 
> This can also be pulled directly from
> 
> git://fedorapeople.org/~dledford/mdadm.git for-neil
> 
> Doug Ledford (3):
>   Fix bad metadata formatting
>   Fix NULL pointer oops
>   Make incremental mode work with partitionable arrays


Thanks for these Doug.

The first two are definitely good and I've applied them.

The third I'm less comfortable with.  It combines a number of things
and I'm a bit confused by some.  So I've split it up a bit.

First there is the fix to use the autof setting from the ARRAY line in
mdadm.conf.  That is certainly a bug so I've got one patch for that.
Then there is the fact that the devnum returned by is_standard is used
even though it doesn't properly encode the 'partition-or-not'
information.  So I have a separate patch the fixes that bug.

Then there is the removal of the 'homehost' test.  I'm not comfortable
with simply removing it.  So I have a patch which changes the homehost
test so that instead of causing failure, it causes the name to be
ignored, and the array to be assembled 'read-auto'.
These three patches are below (I'll push them out later today I
suspect).

That leaves a largish slab of your code that I wasn't really sure
what it was adding.
And there is the bit about /dev/md_d0 having a different meaning to
/dev/md/d0.  I have never seen any difference between those other than
the obvious syntax.  There was a comment in is_standard that made them
look slightly different.  That was unintentional and has been fixed.

If you still need something more that what my three patches provide,
please explain what I missed.

Thanks again!

NeilBrown


From 2b4ca8f079335c1b3f345ec13da58699aaa0269d Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 30 Oct 2008 09:34:04 +1100
Subject: [PATCH] Fix --incremental assembly of partitions arrays.

If incremental assembly finds an array mentioned in mdadm.conf,
with a 'standard partitioned' name like /dev/md_d0 or /dev/md/d0,
it will not create a partitioned array like it should.
This is because it mishandled the 'devnum' returned by
is_standard.
That is a devnum that does not have the partition-or-not encoded
into it.  So we need to check the actual return value of
is_standard and encode the partition-or-not info into the devnum.

Also fix a couple of comments.


Signed-off-by: NeilBrown <neilb@suse.de>
---
 Incremental.c |   10 +++++-----
 util.c        |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 9c6524f..5d26b77 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -214,16 +214,16 @@ int Incremental(char *devname, int verbose, int runstop,
 		}
 	}
 	/* 4/ Determine device number. */
-	/* - If in mdadm.conf with std name, use that */
-	/* - UUID in /var/run/mdadm.map  use that */
+	/* - If in mdadm.conf with std name, get number from name. */
+	/* - UUID in /var/run/mdadm.map  get number from mapping */
 	/* - If name is suggestive, use that. unless in use with */
 	/*           different uuid. */
 	/* - Choose a free, high number. */
 	/* - Use a partitioned device unless strong suggestion not to. */
 	/*         e.g. auto=md */
-	if (match && is_standard(match->devname, &devnum))
-		/* We have devnum now */;
-	else if ((mp = map_by_uuid(&map, info.uuid)) != NULL)
+	if (match && (rv = is_standard(match->devname, &devnum))) {
+		devnum = (rv > 0) ? (-1-devnum) : devnum;
+	} else if ((mp = map_by_uuid(&map, info.uuid)) != NULL)
 		devnum = mp->devnum;
 	else {
 		/* Have to guess a bit. */
diff --git a/util.c b/util.c
index 2d51de0..a50036c 100644
--- a/util.c
From 4ef2f11e28800373f045e1f0c1336f13f89b79c9 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 30 Oct 2008 09:34:06 +1100
Subject: [PATCH] Incremental:  fix setting of 'autof' flag.

When doing auto-assembly, the 'autof' flag from array lines
in mdadm.conf was being ignored.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 Incremental.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 5d26b77..d61518a 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -83,12 +83,8 @@ int Incremental(char *devname, int verbose, int runstop,
 	int dfd, mdfd;
 	char *avail;
 	int active_disks;
-
-
 	struct createinfo *ci = conf_get_create_info();
 
-	if (autof == 0)
-		autof = ci->autof;
 
 	/* 1/ Check if devices is permitted by mdadm.conf */
 
@@ -221,6 +217,16 @@ int Incremental(char *devname, int verbose, int runstop,
 	/* - Choose a free, high number. */
 	/* - Use a partitioned device unless strong suggestion not to. */
 	/*         e.g. auto=md */
+
+	/* There are three possible sources for 'autof':  command line,
+	 * ARRAY line in mdadm.conf, or CREATE line in mdadm.conf.
+	 * They have precedence in that order.
+	 */
+	if (autof == 0 && match)
+		autof = match->autof;
+	if (autof == 0)
+		autof = ci->autof;
+
 	if (match && (rv = is_standard(match->devname, &devnum))) {
 		devnum = (rv > 0) ? (-1-devnum) : devnum;
 	} else if ((mp = map_by_uuid(&map, info.uuid)) != NULL)
-- 
1.5.6.5

+++ b/util.c
@@ -398,7 +398,7 @@ int is_standard(char *dev, int *nump)
 	if (strncmp(d, "/d",2)==0)
 		d += 2, type=1; /* /dev/md/dN{pM} */
 	else if (strncmp(d, "/md_d", 5)==0)
-		d += 5, type=1; /* /dev/md_dNpM */
+		d += 5, type=1; /* /dev/md_dN{pM} */
 	else if (strncmp(d, "/md", 3)==0)
 		d += 3, type=-1; /* /dev/mdN */
 	else if (d-dev > 3 && strncmp(d-2, "md/", 3)==0)
-- 
1.5.6.5


From 7b403fef7e97c16e1eb63773a278eb65c6dfd9a8 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 30 Oct 2008 09:48:18 +1100
Subject: [PATCH] Incremental:  allow assembly of foreign array.

If a foreign (i.e. not known to be local) array is discovered
by --incremental assembly, we now assemble it.  However we ignore
any name information in the array so as not to potentially create
a name that conflict with a 'local' array.
Also, foreign arrays are always assembled 'read-auto' to avoid writing
anything until the array is actually used.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 Incremental.c |   18 ++++++++++++------
 mdopen.c      |    2 +-
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index d61518a..7148a73 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -84,6 +84,7 @@ int Incremental(char *devname, int verbose, int runstop,
 	char *avail;
 	int active_disks;
 	struct createinfo *ci = conf_get_create_info();
+	char *name;
 
 
 	/* 1/ Check if devices is permitted by mdadm.conf */
@@ -199,14 +200,18 @@ int Incremental(char *devname, int verbose, int runstop,
 		match = array_list;
 	}
 
-	/* 3a/ if not, check for homehost match.  If no match, reject. */
+	/* 3a/ if not, check for homehost match.  If no match, continue
+	 * but don't trust the 'name' in the array. Thus a 'random' minor
+	 * number will be assigned, and the device name will be based
+	 * on that. */
+	name = info.name;
 	if (!match) {
 		if (homehost == NULL ||
 		    st->ss->match_home(st, homehost) == 0) {
 			if (verbose >= 0)
 				fprintf(stderr, Name
 	      ": not found in mdadm.conf and not identified by homehost.\n");
-			return 2;
+			name = NULL;
 		}
 	}
 	/* 4/ Determine device number. */
@@ -237,11 +242,11 @@ int Incremental(char *devname, int verbose, int runstop,
 		char *np, *ep;
 		if ((autof&7) == 3 || (autof&7) == 5)
 			use_partitions = 0;
-		np = strchr(info.name, ':');
+		np = name ? strchr(name, ':') : ":NONAME";
 		if (np)
 			np++;
 		else
-			np = info.name;
+			np = name;
 		devnum = strtoul(np, &ep, 10);
 		if (ep > np && *ep == 0) {
 			/* This is a number.  Let check that it is unused. */
@@ -264,7 +269,7 @@ int Incremental(char *devname, int verbose, int runstop,
 	}
 	mdfd = open_mddev_devnum(match ? match->devname : NULL,
 				 devnum,
-				 info.name,
+				 name,
 				 chosen_name, autof >> 3);
 	if (mdfd < 0) {
 		fprintf(stderr, Name ": failed to open %s: %s.\n",
@@ -452,7 +457,8 @@ int Incremental(char *devname, int verbose, int runstop,
 			close(bmfd);
 		}
 		sra = sysfs_read(mdfd, devnum, 0);
-		if (sra == NULL || active_disks >= info.array.working_disks)
+		if ((sra == NULL || active_disks >= info.array.working_disks)
+		    && name != NULL)
 			rv = ioctl(mdfd, RUN_ARRAY, NULL);
 		else
 			rv = sysfs_set_str(sra, NULL,
diff --git a/mdopen.c b/mdopen.c
index 4fbcb48..9250e4b 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -282,7 +282,7 @@ int open_mddev_devnum(char *devname, int devnum, char *name,
 
 	if (devname)
 		strcpy(chosen_name, devname);
-	else if (name && strchr(name,'/') == NULL) {
+	else if (name && *name && strchr(name,'/') == NULL) {
 		char *n = strchr(name, ':');
 		if (n) n++; else n = name;
 		if (isdigit(*n) && devnum < 0)
-- 
1.5.6.5

