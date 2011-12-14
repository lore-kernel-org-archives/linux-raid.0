From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/3] imsm: FIX: 'UT 09imsm-assemble' fails
Date: Wed, 14 Dec 2011 16:07:12 +0100
Message-ID: <20111214150712.21483.48715.stgit@gklab-128-013.igk.intel.com>
References: <20111214150448.21483.16231.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111214150448.21483.16231.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Problem was introduced by patch (2011-06-08):
   getinfo_super now clears the 'info' structure before filling it in.

Field update private is not managed here and pointer associated outside
is cleaned up.
Add code for field update_private cleaning preservation.
In places where in patch
  'getinfo_super now clears the 'info' structure before filling it in.'
cleaning structure was removed, cleaning update_private field was added
as getinfo_super() cannot be responsible for this pointer management.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c    |    2 ++
 Incremental.c |    3 +++
 super-intel.c |    9 +++++++++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index fac2bad..c8b538f 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -422,6 +422,7 @@ int Assemble(struct supertype *st, char *mddev,
 					int uuid[4];
 
 					content = &info;
+					info.update_private = NULL
 					tst->ss->getinfo_super(tst, content, NULL);
 
 					if (!parse_uuid(ident->container, uuid) ||
@@ -485,6 +486,7 @@ int Assemble(struct supertype *st, char *mddev,
 		} else {
 
 			content = &info;
+			info.update_private = NULL
 			tst->ss->getinfo_super(tst, content, NULL);
 
 			if (!ident_matches(ident, content, tst,
diff --git a/Incremental.c b/Incremental.c
index d3724a4..112a1ec 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -205,6 +205,7 @@ int Incremental(char *devname, int verbose, int runstop,
 	}
 	close (dfd); dfd = -1;
 
+	info.update_private = NULL
 	st->ss->getinfo_super(st, &info, NULL);
 
 	/* 3/ Check if there is a match in mdadm.conf */
@@ -404,6 +405,7 @@ int Incremental(char *devname, int verbose, int runstop,
 				goto out_unlock;
 			}
 			close(dfd2);
+			info.update_private = NULL
 			st2->ss->getinfo_super(st2, &info2, NULL);
 			st2->ss->free_super(st2);
 			if (info.array.level != info2.array.level ||
@@ -1382,6 +1384,7 @@ static int Incremental_container(struct supertype *st, char *devname,
 	int ra_blocked = 0;
 	int ra_all = 0;
 
+	info.update_private = NULL
 	st->ss->getinfo_super(st, &info, NULL);
 
 	if ((runstop > 0 && info.container_enough >= 0) ||
diff --git a/super-intel.c b/super-intel.c
index e1073ef..5e1d278 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2365,8 +2365,13 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	char *devname;
 	unsigned int component_size_alligment;
 	int map_disks = info->array.raid_disks;
+	void *update_private_saver = info->update_private;
 
 	memset(info, 0, sizeof(*info));
+	/* preserve pointer cleanup, as someone elese is pointer owner
+	 */
+	info->update_private = update_private_saver;
+
 	if (prev_map)
 		map_to_analyse = prev_map;
 
@@ -2601,12 +2606,16 @@ static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *
 	int max_enough = -1;
 	int i;
 	struct imsm_super *mpb;
+	void *update_private_saver = info->update_private;
 
 	if (super->current_vol >= 0) {
 		getinfo_super_imsm_volume(st, info, map);
 		return;
 	}
 	memset(info, 0, sizeof(*info));
+	/* preserve pointer cleanup, as someone elese is pointer owner
+	 */
+	info->update_private = update_private_saver;
 
 	/* Set raid_disks to zero so that Assemble will always pull in valid
 	 * spares

