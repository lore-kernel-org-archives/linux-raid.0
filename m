From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 09/23] md/bitmap: ensure to load bitmap when creating via
 sysfs.
Date: Wed, 14 Mar 2012 15:40:40 +1100
Message-ID: <20120314044040.7978.5283.stgit@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120314043555.7978.75486.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When commit 69e51b449d383e (md/bitmap:  separate out loading a bitmap...)
created bitmap_load, it missed calling it after bitmap_create when a
bitmap is created through the sysfs interface.
So if a bitmap is added this way, we don't allocate memory properly
and can crash.

This is suitable for any -stable release since 2.6.35.
Cc: stable@vger.kernel.org
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/bitmap.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index cdf36b1..239af9a 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1904,6 +1904,8 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			if (mddev->pers) {
 				mddev->pers->quiesce(mddev, 1);
 				rv = bitmap_create(mddev);
+				if (!rv)
+					rv = bitmap_load(mddev);
 				if (rv) {
 					bitmap_destroy(mddev);
 					mddev->bitmap_info.offset = 0;


