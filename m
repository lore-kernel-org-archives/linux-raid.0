From: Blazej Kucman <blazej.kucman@intel.com>
Subject: [PATCH] imsm: Correct minimal device size.
Date: Wed, 11 Mar 2020 15:40:13 +0100
Message-ID: <20200311144013.24424-1-blazej.kucman@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com
List-Id: linux-raid.ids

Check if given size of member drive is not less than 1 MibiByte.

Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
---
 super-intel.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/super-intel.c b/super-intel.c
index c9a1af5b..6680df29 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7425,7 +7425,10 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
 							verbose);
 	}
 
-	if (size && (size < 1024)) {
+	/*
+	 * Size is given in sectors.
+	 */
+	if (size && (size < 2048)) {
 		pr_err("Given size must be greater than 1M.\n");
 		/* Depends on algorithm in Create.c :
 		 * if container was given (dev == NULL) return -1,
-- 
2.16.4
