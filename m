From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 10/22] imsm: Clear migration record when no migration in
	progress
Date: Thu, 02 Jun 2011 16:49:34 +0200
Message-ID: <20110602144934.27355.23565.stgit@gklab-128-111.igk.intel.com>
References: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Adam Kwolek <adam.kwolek@intel.com>

When metadata is saved and there is no general migration in progress
/in container/ clear migration record in container.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 super-intel.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index d2393c2..db2f2b9 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4254,6 +4254,8 @@ static int write_super_imsm_spares(struct intel_super *super, int doclose)
 	return 0;
 }
 
+static int is_gen_migration(struct imsm_dev *dev);
+
 static int write_super_imsm(struct supertype *st, int doclose)
 {
 	struct intel_super *super = st->sb;
@@ -4265,6 +4267,7 @@ static int write_super_imsm(struct supertype *st, int doclose)
 	int i;
 	__u32 mpb_size = sizeof(struct imsm_super) - sizeof(struct imsm_disk);
 	int num_disks = 0;
+	int clear_migration_record = 1;
 
 	/* 'generation' is incremented everytime the metadata is written */
 	generation = __le32_to_cpu(mpb->generation_num);
@@ -4299,6 +4302,8 @@ static int write_super_imsm(struct supertype *st, int doclose)
 			imsm_copy_dev(dev, dev2);
 			mpb_size += sizeof_imsm_dev(dev, 0);
 		}
+		if (is_gen_migration(dev2))
+			clear_migration_record = 0;
 	}
 	mpb_size += __le32_to_cpu(mpb->bbm_log_size);
 	mpb->mpb_size = __cpu_to_le32(mpb_size);
@@ -4307,6 +4312,9 @@ static int write_super_imsm(struct supertype *st, int doclose)
 	sum = __gen_imsm_checksum(mpb);
 	mpb->check_sum = __cpu_to_le32(sum);
 
+	if (clear_migration_record)
+		memset(super->migr_rec_buf, 0, 512);
+
 	/* write the mpb for disks that compose raid devices */
 	for (d = super->disks; d ; d = d->next) {
 		if (d->index < 0)
@@ -4314,6 +4322,14 @@ static int write_super_imsm(struct supertype *st, int doclose)
 		if (store_imsm_mpb(d->fd, mpb))
 			fprintf(stderr, "%s: failed for device %d:%d %s\n",
 				__func__, d->major, d->minor, strerror(errno));
+		if (clear_migration_record) {
+			unsigned long long dsize;
+
+			get_dev_size(d->fd, NULL, &dsize);
+			if (lseek64(d->fd, dsize - 512, SEEK_SET) >= 0) {
+				write(d->fd, super->migr_rec_buf, 512);
+			}
+		}
 		if (doclose) {
 			close(d->fd);
 			d->fd = -1;

