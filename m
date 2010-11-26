From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 04/53] Grow: mark some functions static
Date: Fri, 26 Nov 2010 09:04:22 +0100
Message-ID: <20101126080422.5221.96021.stgit@gklab-170-024.igk.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Dan Williams <dan.j.williams@intel.com>

Going through the Grow api found some local routines that could be
marked static.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 Grow.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Grow.c b/Grow.c
index 0571f5b..f16228d 100644
--- a/Grow.c
+++ b/Grow.c
@@ -409,7 +409,7 @@ static struct mdp_backup_super {
 	__u8 pad[512-68-32];
 } __attribute__((aligned(512))) bsb, bsb2;
 
-__u32 bsb_csum(char *buf, int len)
+static __u32 bsb_csum(char *buf, int len)
 {
 	int i;
 	int csum = 0;
@@ -432,7 +432,7 @@ static int child_same_size(int afd, struct mdinfo *sra, unsigned long blocks,
 			   int disks, int chunk, int level, int layout, int data,
 			   int dests, int *destfd, unsigned long long *destoffsets);
 
-int freeze_array(struct mdinfo *sra)
+static int freeze_array(struct mdinfo *sra)
 {
 	/* Try to freeze resync on this array.
 	 * Return -1 if the array is busy,
@@ -450,14 +450,14 @@ int freeze_array(struct mdinfo *sra)
 	return 1;
 }
 
-void unfreeze_array(struct mdinfo *sra, int frozen)
+static void unfreeze_array(struct mdinfo *sra, int frozen)
 {
 	/* If 'frozen' is 1, unfreeze the array */
 	if (frozen > 0)
 		sysfs_set_str(sra, NULL, "sync_action", "idle");
 }
 
-void wait_reshape(struct mdinfo *sra)
+static void wait_reshape(struct mdinfo *sra)
 {
 	int fd = sysfs_get_fd(sra, NULL, "sync_action");
 	char action[20];
@@ -1266,7 +1266,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
  */
 
 /* FIXME return status is never checked */
-int grow_backup(struct mdinfo *sra,
+static int grow_backup(struct mdinfo *sra,
 		unsigned long long offset, /* per device */
 		unsigned long stripes, /* per device */
 		int *sources, unsigned long long *offsets,
@@ -1381,7 +1381,7 @@ int grow_backup(struct mdinfo *sra,
  * every works.
  */
 /* FIXME return value is often ignored */
-int wait_backup(struct mdinfo *sra,
+static int wait_backup(struct mdinfo *sra,
 		unsigned long long offset, /* per device */
 		unsigned long long blocks, /* per device */
 		unsigned long long blocks2, /* per device - hack */

