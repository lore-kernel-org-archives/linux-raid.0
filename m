From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 05/17] imsm: quiet detail platform
Date: Tue, 1 Dec 2015 16:25:21 -0800
Message-ID: <1449015933-255689-6-git-send-email-songliubraving@fb.com>
References: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, dan.j.williams@intel.com, shli@fb.com, Dan Williams <djbw@fb.com>, Lukasz Dorau <lukasz.dorau@intel.com>, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

From: Dan Williams <djbw@fb.com>

Don't squawk when platform capabilities missing, in preparation for
generic SES platform support.  Undo some indentation as well.

Cc: Lukasz Dorau <lukasz.dorau@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 super-intel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index e609e0c..330b24f 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1935,8 +1935,9 @@ static int detail_platform_imsm(int verbose, int enumerate_only, char *controlle
 		if (controller_path && (compare_paths(hba->path, controller_path) != 0))
 			continue;
 		if (!find_imsm_capability(hba)) {
-			pr_err("imsm capabilities not found for controller: %s (type %s)\n",
-				hba->path, get_sys_dev_type(hba->type));
+			if (verbose > 0)
+				pr_err("imsm capabilities not found for controller: %s (type %s)\n",
+				       hba->path, get_sys_dev_type(hba->type));
 			continue;
 		}
 		result = 0;
-- 
2.4.6

