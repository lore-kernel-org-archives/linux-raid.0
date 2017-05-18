From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 13/23] md: namespace private helper names
Date: Thu, 18 May 2017 08:26:55 +0200
Message-ID: <20170518062705.25902-14-hch@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170518062705.25902-1-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids

From: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The md private helper uuid_equal() collides with a generic helper
of the same name.

Rename the md private helper to md_uuid_equal() and do the same for
md_sb_equal().

Cc: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/md/md.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 82f798be964f..65795cc4cb7d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -825,7 +825,7 @@ static int read_disk_sb(struct md_rdev *rdev, int size)
 	return -EINVAL;
 }
 
-static int uuid_equal(mdp_super_t *sb1, mdp_super_t *sb2)
+static int md_uuid_equal(mdp_super_t *sb1, mdp_super_t *sb2)
 {
 	return	sb1->set_uuid0 == sb2->set_uuid0 &&
 		sb1->set_uuid1 == sb2->set_uuid1 &&
@@ -833,7 +833,7 @@ static int uuid_equal(mdp_super_t *sb1, mdp_super_t *sb2)
 		sb1->set_uuid3 == sb2->set_uuid3;
 }
 
-static int sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
+static int md_sb_equal(mdp_super_t *sb1, mdp_super_t *sb2)
 {
 	int ret;
 	mdp_super_t *tmp1, *tmp2;
@@ -1025,12 +1025,12 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 	} else {
 		__u64 ev1, ev2;
 		mdp_super_t *refsb = page_address(refdev->sb_page);
-		if (!uuid_equal(refsb, sb)) {
+		if (!md_uuid_equal(refsb, sb)) {
 			pr_warn("md: %s has different UUID to %s\n",
 				b, bdevname(refdev->bdev,b2));
 			goto abort;
 		}
-		if (!sb_equal(refsb, sb)) {
+		if (!md_sb_equal(refsb, sb)) {
 			pr_warn("md: %s has same UUID but different superblock to %s\n",
 				b, bdevname(refdev->bdev, b2));
 			goto abort;
-- 
2.11.0
