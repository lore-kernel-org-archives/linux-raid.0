From: Xiao Ni <xni@redhat.com>
Subject: [PATCH] Need update superblock on time when deciding to do reshape
Date: Tue, 17 May 2016 16:54:09 +0800
Message-ID: <1463475249-18658-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

Hi all

If the disks are not enough to have spaces for relocating the data_offset,
it needs to run start_reshape and then run mdadm --grow --continue by 
systemd. But mdadm --grow --continue fails because it checkes that 
info->reshape_active is 0. 

The info->reshape_active is set to 1 when the superblock feature_map
have the flag MD_FEATURE_RESHAPE_ACTIVE. Superblock feature_map is set
MD_FEATURE_RESHAPE_ACTIVE as mddev->reshape_position != MaxSector.

Function start_reshape calls raid5_start_reshape which changes 
mddev->reshape_position to 0. Then in md_check_recovery it updates the
superblock to underlying devices. But there is a chance that the superblock
haven't written to underlying devices, the mdadm reads the superblock data.
So mdadm --grow --continue fails.

The steps to reproduce this:
mdadm -CR /dev/md0 -l5 -n3 /dev/loop[0-2] --bitmap=internal
mdadm --wait /dev/md0
mdadm /dev/md0 -a /dev/loop3
mdadm --grow --raid-devices  4 /dev/md0
The loop device size is 500MB

[root@storageqe-09 ~]# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 loop3[4] loop2[3] loop1[1] loop0[0]
      1021952 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]
      [>....................]  reshape =  0.0% (1/510976) finish=0.0min speed=255488K/sec
      bitmap: 1/1 pages [4KB], 65536KB chunk

unused devices: <none>

So if we update the superblock on time, mdadm can read the right superblock data.

Signed-off-by <xni@redhat.com>

---
 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 14d3b37..7919606 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4350,6 +4350,7 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 			else {
 				clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 				err = mddev->pers->start_reshape(mddev);
+				md_update_sb(mddev, 1);
 			}
 			mddev_unlock(mddev);
 		}
-- 
2.4.3

