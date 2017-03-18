From: Xiao Ni <xni@redhat.com>
Subject: [PATCH 2/2] mdadm: Forced type conversion to avoid truncation
Date: Sat, 18 Mar 2017 10:33:45 +0800
Message-ID: <1489804425-4949-2-git-send-email-xni@redhat.com>
References: <1489804425-4949-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1489804425-4949-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: ncroxon@redhat.com, artur.paszkiewicz@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gcc reports it needs 19 bytes to right to disk->serial. Because the type of argument i
is int. But the meaning of i is failed disk number. So it doesn't need to use 19 bytes.
Just add a type conversion to avoid this building error

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 super-intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/super-intel.c b/super-intel.c
index 343f20d..e1618f1 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5228,7 +5228,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 			disk->status = CONFIGURED_DISK | FAILED_DISK;
 			disk->scsi_id = __cpu_to_le32(~(__u32)0);
 			snprintf((char *) disk->serial, MAX_RAID_SERIAL_LEN,
-				 "missing:%d", i);
+				 "missing:%d", (__u8)i);
 		}
 		find_missing(super);
 	} else {
-- 
2.7.4

