From: NeilBrown <neilb@suse.de>
Subject: [PATCH 004 of 4] md: Fix printk format warnings, seen on powerpc64:
Date: Mon, 23 Oct 2006 17:08:06 +1000
Message-ID: <1061023070806.29272@suse.de>
References: <20061023170347.29132.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

From: Randy Dunlap <randy.dunlap@oracle.com>

drivers/md/raid1.c:1479: warning: long long unsigned int format, long unsigned int arg (arg 4)
drivers/md/raid10.c:1475: warning: long long unsigned int format, long unsigned int arg (arg 4)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c  |    4 ++--
 ./drivers/md/raid10.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2006-10-23 16:36:08.000000000 +1000
+++ ./drivers/md/raid1.c	2006-10-23 16:36:08.000000000 +1000
@@ -1474,8 +1474,8 @@ static void fix_read_error(conf_t *conf,
 					       "raid1:%s: read error corrected "
 					       "(%d sectors at %llu on %s)\n",
 					       mdname(mddev), s,
-					       (unsigned long long)sect +
-					           rdev->data_offset,
+					       (unsigned long long)(sect +
+					           rdev->data_offset),
 					       bdevname(rdev->bdev, b));
 				}
 			}

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2006-10-23 16:34:54.000000000 +1000
+++ ./drivers/md/raid10.c	2006-10-23 16:36:08.000000000 +1000
@@ -1470,8 +1470,8 @@ static void fix_read_error(conf_t *conf,
 					       "raid10:%s: read error corrected"
 					       " (%d sectors at %llu on %s)\n",
 					       mdname(mddev), s,
-					       (unsigned long long)sect+
-					            rdev->data_offset,
+					       (unsigned long long)(sect+
+					            rdev->data_offset),
 					       bdevname(rdev->bdev, b));
 
 				rdev_dec_pending(rdev, mddev);
