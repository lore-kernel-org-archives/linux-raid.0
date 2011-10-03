From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/4] FIX: restore_backup() throws core dump
Date: Mon, 03 Oct 2011 18:13:38 +0200
Message-ID: <20111003161338.18410.79083.stgit@gklab-128-013.igk.intel.com>
References: <20111003160839.18410.33275.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111003160839.18410.33275.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

1. restore_backup() throws core dump during releasing fdlist.
Loop for closing handlers checks next_spare variable,
but iterates disk_count.

2. fdlist initialization/close is corrected to initialize/close
   whole allocated array

3. next_spare variable name is replaced by spares

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Grow.c b/Grow.c
index de177d8..ae0d112 100644
--- a/Grow.c
+++ b/Grow.c
@@ -38,7 +38,7 @@
 int restore_backup(struct supertype *st,
 		   struct mdinfo *content,
 		   int working_disks,
-		   int next_spare,
+		   int spares,
 		   char *backup_file,
 		   int verbose)
 {
@@ -46,7 +46,7 @@ int restore_backup(struct supertype *st,
 	int *fdlist;
 	struct mdinfo *dev;
 	int err;
-	int disk_count = next_spare + working_disks;
+	int disk_count = working_disks + spares;
 
 	dprintf("Called restore_backup()\n");
 	fdlist = malloc(sizeof(int) * disk_count);
@@ -55,7 +55,7 @@ int restore_backup(struct supertype *st,
 			Name ": cannot allocate memory for disk list\n");
 		return 1;
 	}
-	for (i = 0; i < next_spare; i++)
+	for (i = 0; i < disk_count; i++)
 		fdlist[i] = -1;
 	for (dev = content->devs; dev; dev = dev->next) {
 		char buf[22];
@@ -68,16 +68,16 @@ int restore_backup(struct supertype *st,
 		if (dev->disk.raid_disk >= 0)
 			fdlist[dev->disk.raid_disk] = fd;
 		else
-			fdlist[next_spare++] = fd;
+			fdlist[working_disks++] = fd;
 	}
 
 	if (st->ss->external && st->ss->recover_backup)
 		err = st->ss->recover_backup(st, content);
 	else
-		err = Grow_restart(st, content, fdlist, next_spare,
+		err = Grow_restart(st, content, fdlist, working_disks,
 				   backup_file, verbose > 0);
 
-	while (next_spare > 0) {
+	while (disk_count > 0) {
 		disk_count--;
 		if (fdlist[disk_count] >= 0)
 			close(fdlist[disk_count]);

