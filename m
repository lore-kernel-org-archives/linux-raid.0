From: ycbzzjlby@gmail.com
Subject: [PATCH] raid5: Retry R5_ReadNoMerge flag when hit a read error.
Date: Sun,  1 Sep 2013 20:13:02 -0400
Message-ID: <1378080782-9971-1-git-send-email-ycbzzjlby@gmail.com>
Content-Type: text/plain; charset="utf-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Bian Yu <bianyu@kedacom.com>
List-Id: linux-raid.ids

From: Bian Yu <bianyu@kedacom.com>

Because of block layer merge, one bio fails will cause other bios
which belongs to the same request fails, so raid5_end_read_request
will record all these bios as badblocks.
If retry request with R5_ReadNoMerge flag to avoid bios merge,
badblocks can only record sector which is bad exactly.

test:
hdparm --yes-i-know-what-i-am-doing --make-bad-sector 300000 /dev/sdb
mdadm -C /dev/md0 -l5 -n3 /dev/sd[bcd] --assume-clean
mdadm /dev/md0 -f /dev/sdd
mdadm /dev/md0 -r /dev/sdd
mdadm --zero-superblock /dev/sdd
mdadm /dev/md0 -a /dev/sdd

1. Without this patch:
cat /sys/block/md0/md/rd*/bad_blocks
299776 256
299776 256

2. With this patch:
cat /sys/block/md0/md/rd*/bad_blocks
300000 8
300000 8

Signed-off-by: Bian Yu <bianyu@kedacom.com>
---
 drivers/md/raid5.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ff1aecf..ee8c280 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1924,6 +1924,9 @@ static void raid5_end_read_request(struct bio * bi, int error)
 			       mdname(conf->mddev), bdn);
 		else
 			retry = 1;
+		if (set_bad && test_bit(In_sync, &rdev->flags)
+		    && !test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
+			retry = 1;
 		if (retry)
 			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags)) {
 				set_bit(R5_ReadError, &sh->dev[i].flags);
-- 
1.7.1
