From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 4] md: Simplify checking of available size when resizing an array
Date: Mon, 23 Oct 2006 17:07:54 +1000
Message-ID: <1061023070754.29236@suse.de>
References: <20061023170347.29132.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751661AbWJWHIe@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


When "mdadm --grow --size=xxx" is used to resize an array (use more or
less of each device), we check the new siza against the available
space in each device.

The already have that number recorded in rdev->size, so calculating it
is pointless (and wrong in one obscure case).

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-10-23 16:35:05.000000000 +1000
+++ ./drivers/md/md.c	2006-10-23 16:35:21.000000000 +1000
@@ -4047,11 +4047,8 @@ static int update_size(mddev_t *mddev, u
 		return -EBUSY;
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		sector_t avail;
-		if (rdev->sb_offset > rdev->data_offset)
-			avail = (rdev->sb_offset*2) - rdev->data_offset;
-		else
-			avail = get_capacity(rdev->bdev->bd_disk)
-				- rdev->data_offset;
+		avail = rdev->size * 2;
+
 		if (fit && (size == 0 || size > avail/2))
 			size = avail/2;
 		if (avail < ((sector_t)size << 1))
