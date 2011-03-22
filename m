From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 1/2] examine: allows to examine a disk metadata on
 non-metadata compliant systems
Date: Tue, 22 Mar 2011 16:50:45 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D191E0AF50@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

From 0f2d6c1d9d0d09ef99515b3df036878dd2b0f2aa Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Tue, 22 Mar 2011 17:21:22 +0100
Subject: [PATCH 1/2] examine: allows to examine a disk metadata on non-metadata compliant systems

Allow for loading metadata from disk attached to non-metadata compliant
system. Affects mdadm --examine and guess_super.

Added ignore_hw_compat in supertype to pass information to load_super
handler. If ignore_hw_compat is set the handler should load metadata
also from disks that do not comply with metadata requirements (i.e. disk is not
attached to native controller, etc).

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 Examine.c |    2 ++
 mdadm.h   |    6 +++++-
 util.c    |    3 +++
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/Examine.c b/Examine.c
index f949646..5d71e53 100644
--- a/Examine.c
+++ b/Examine.c
@@ -87,6 +87,7 @@ int Examine(struct mddev_dev *devlist, int brief, int export, int scan,
 				st = guess_super(fd);
 			if (st) {
 				err = 1;
+				st->ignore_hw_compat = 1;
 				if (!container)
 					err = st->ss->load_super(st, fd,
 								 (brief||scan) ? NULL
@@ -98,6 +99,7 @@ int Examine(struct mddev_dev *devlist, int brief, int export, int scan,
 					if (!err)
 						have_container = 1;
 				}
+				st->ignore_hw_compat = 0;
 			} else {
 				if (!brief) {
 					fprintf(stderr, Name ": No md superblock detected on %s.\n", devlist->devname);
diff --git a/mdadm.h b/mdadm.h
index fa5af3a..8277594 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -827,7 +827,11 @@ struct supertype {
 	int container_dev;    /* devnum of container */
 	void *sb;
 	void *info;
-
+	int ignore_hw_compat; /* used to inform metadata handlers that it should ignore
+				 HW/firmware related incompatability to load metadata.
+				 Used when examining metadata to display content of disk
+				 when user has no hw/firmare compatible system.
+			      */
 	struct metadata_update *updates;
 	struct metadata_update **update_tail;
 
diff --git a/util.c b/util.c
index 8e1b737..ef4406a 100644
--- a/util.c
+++ b/util.c
@@ -1196,6 +1196,7 @@ struct supertype *guess_super_type(int fd, enum guess_types guess_type)
 		if (guess_type == guess_partitions && ss->add_to_super != NULL)
 			continue;
 		memset(st, 0, sizeof(*st));
+		st->ignore_hw_compat = 1;
 		rv = ss->load_super(st, fd, NULL);
 		if (rv == 0) {
 			struct mdinfo info;
@@ -1211,9 +1212,11 @@ struct supertype *guess_super_type(int fd, enum guess_types guess_type)
 	if (bestsuper != -1) {
 		int rv;
 		memset(st, 0, sizeof(*st));
+		st->ignore_hw_compat = 1;
 		rv = superlist[bestsuper]->load_super(st, fd, NULL);
 		if (rv == 0) {
 			superlist[bestsuper]->free_super(st);
+			st->ignore_hw_compat = 0;
 			return st;
 		}
 	}
-- 
1.6.4.2

