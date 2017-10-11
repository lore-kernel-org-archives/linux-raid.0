From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH v2] mdadm/grow: adding a test to ensure resize was required
Date: Wed, 11 Oct 2017 16:53:12 +0800
Message-ID: <1507711992-11548-1-git-send-email-zlliu@suse.com>
References: <1507537274-29350-2-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1507537274-29350-2-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

To fix the commit: 4b74a905a67e
(mdadm/grow: Component size must be larger than chunk size)

array.level > 1 : against the raids which chunk_size is meaningful.
s->size > 0 : ensure that changing component size has required.
array.chunk_size / 1024 > s->size : ensure component size should
be always >= current chunk_size when requires resize, otherwise,
mddev->pers->resize would be set mddev->dev_sectors as '0'.

Reported-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Suggested-by: NeilBrown <neilb@suse.com>
Signed-off-by: Zhilong Liu <zlliu@suse.com>
---

v1: [PATCH 1/3] mdadm/Grow: fix the broken raid level conversion

changes:
  correct the test 's->level == UnSet' as 's->size > 0'

 Grow.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Grow.c b/Grow.c
index 4d79d83..8c2d50c 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1810,6 +1810,7 @@ int Grow_reshape(char *devname, int fd,
 	}
 
 	if (array.level > 1 &&
+	    s->size > 0 &&
 	   (array.chunk_size / 1024) > (int)s->size) {
 		pr_err("component size must be larger than chunk size.\n");
 		return 1;
-- 
2.6.6

