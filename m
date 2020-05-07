From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH] md/raid1: Replace zero-length array with flexible-array
Date: Thu, 7 May 2020 14:22:10 -0500
Message-ID: <20200507192209.GA16290@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

sizeof(flexible-array-member) triggers a warning because flexible array
members have incomplete type[1]. There are some instances of code in
which the sizeof operator is being incorrectly/erroneously applied to
zero-length arrays and the result is zero. Such instances may be hiding
some bugs. So, this work (flexible-array member conversions) will also
help to get completely rid of those sorts of issues.

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/md/md-linear.h |    2 +-
 drivers/md/raid1.h     |    2 +-
 drivers/md/raid10.h    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-linear.h b/drivers/md/md-linear.h
index 8381d651d4ed..24e97db50ebb 100644
--- a/drivers/md/md-linear.h
+++ b/drivers/md/md-linear.h
@@ -12,6 +12,6 @@ struct linear_conf
 	struct rcu_head		rcu;
 	sector_t		array_sectors;
 	int			raid_disks; /* a copy of mddev->raid_disks */
-	struct dev_info		disks[0];
+	struct dev_info		disks[];
 };
 #endif
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index e7ccad898736..b7eb09e8c025 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -180,7 +180,7 @@ struct r1bio {
 	 * if the IO is in WRITE direction, then multiple bios are used.
 	 * We choose the number when they are allocated.
 	 */
-	struct bio		*bios[0];
+	struct bio		*bios[];
 	/* DO NOT PUT ANY NEW FIELDS HERE - bios array is contiguously alloced*/
 };
 
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index d3eaaf3eb1bc..79cd2b7d3128 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -153,7 +153,7 @@ struct r10bio {
 		};
 		sector_t	addr;
 		int		devnum;
-	} devs[0];
+	} devs[];
 };
 
 /* bits for r10bio.state */
