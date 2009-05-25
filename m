From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 1/3] md: improve errno return when setting array_size
Date: Mon, 25 May 2009 14:33:52 +1000
Message-ID: <20090525043351.3758.38621.stgit@notabene.brown>
References: <20090525042538.3758.7928.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090525042538.3758.7928.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Instead of always returns EINVAL if anything goes wrong
when setting the array size, add the option of
  E2BIG
if the size requested is too large.  This makes it easier
for user-space to be sure what went wrong.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index fccc834..cc46c11 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3680,7 +3680,7 @@ array_size_store(mddev_t *mddev, const char *buf, size_t len)
 		if (strict_blocks_to_sectors(buf, &sectors) < 0)
 			return -EINVAL;
 		if (mddev->pers && mddev->pers->size(mddev, 0, 0) < sectors)
-			return -EINVAL;
+			return -E2BIG;
 
 		mddev->external_size = 1;
 	}


