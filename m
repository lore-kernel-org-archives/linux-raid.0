From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH 08/12] imsm: don't skip resync when an invalid ppl header is found
Date: Thu, 28 Sep 2017 14:41:14 +0200
Message-ID: <20170928124118.23361-9-pawel.baldysiak@intel.com>
References: <20170928124118.23361-1-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170928124118.23361-1-pawel.baldysiak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

If validate_ppl_imsm() detects an invalid ppl header it will be
overwritten with a valid, empty ppl header. But if we are assembling an
array after unclean shutdown this will cause the kernel to skip resync
after ppl recovery. We don't want that because if there was an invalid
ppl it's best to assume that the ppl recovery is not enough to make the
array consistent and a full resync should be performed. So when
overwriting the invalid ppl add one ppl_header_entry with a wrong
checksum. This will prevent the kernel from skipping resync after ppl
recovery.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 super-intel.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 6c48725d..016a6028 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6080,6 +6080,16 @@ static int write_init_ppl_imsm(struct supertype *st, struct mdinfo *info, int fd
 	ppl_hdr = buf;
 	memset(ppl_hdr->reserved, 0xff, PPL_HDR_RESERVED);
 	ppl_hdr->signature = __cpu_to_le32(super->anchor->orig_family_num);
+
+	if (info->mismatch_cnt) {
+		/*
+		 * We are overwriting an invalid ppl. Make one entry with wrong
+		 * checksum to prevent the kernel from skipping resync.
+		 */
+		ppl_hdr->entries_count = __cpu_to_le32(1);
+		ppl_hdr->entries[0].checksum = ~0;
+	}
+
 	ppl_hdr->checksum = __cpu_to_le32(~crc32c_le(~0, buf, PPL_HEADER_SIZE));
 
 	if (lseek64(fd, info->ppl_sector * 512, SEEK_SET) < 0) {
@@ -6214,8 +6224,12 @@ out:
 		}
 	}
 
-	if (ret == 1 && map->map_state == IMSM_T_STATE_UNINITIALIZED)
-		return st->ss->write_init_ppl(st, info, d->fd);
+	if (ret == 1) {
+		if (map->map_state == IMSM_T_STATE_UNINITIALIZED)
+			ret = st->ss->write_init_ppl(st, info, d->fd);
+		else
+			info->mismatch_cnt++;
+	}
 
 	return ret;
 }
-- 
2.13.5

