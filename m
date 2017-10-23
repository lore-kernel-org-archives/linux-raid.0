From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH v3] mdadm/grow: adding a test to ensure resize was required
Date: Mon, 23 Oct 2017 17:13:41 +0800
Message-ID: <1508750021-4919-1-git-send-email-zlliu@suse.com>
References: <1507711992-11548-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1507711992-11548-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

To fix the commit: 4b74a905a67e
(mdadm/grow: Component size must be larger than chunk size)

array.level > 1 : against the raids which chunk_size is meaningful.
s->size > 1 : ensure changing component size has required, s->size
is '1' when '--grow --size max' parameter is specified.
array.chunk_size / 1024 > s->size : ensure component size should
be always >= current chunk_size when requires resize, otherwise,
mddev->pers->resize would be set mddev->dev_sectors as '0'.

Reported-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Suggested-by: NeilBrown <neilb@suse.com>
Signed-off-by: Zhilong Liu <zlliu@suse.com>
---

v1: [PATCH 1/3] mdadm/Grow: fix the broken raid level conversion
v2: [PATCH v2] mdadm/grow: adding a test to ensure resize was required

changes:
  v2: correct the test 's->level == UnSet' as 's->size > 0' against v1
  v3: correct 's->size > 0' as 's->size > 1' against v2, s->size is '1'
      when '--grow --size max' parameter is specified.

 Grow.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index 4d79d83..e14c921 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1810,7 +1810,8 @@ int Grow_reshape(char *devname, int fd,
 	}
 
 	if (array.level > 1 &&
-	   (array.chunk_size / 1024) > (int)s->size) {
+	    s->size > 1 &&
+	    (array.chunk_size / 1024) > (int)s->size) {
 		pr_err("component size must be larger than chunk size.\n");
 		return 1;
 	}
-- 
2.6.6

