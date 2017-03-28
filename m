From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH v1] mdadm/Build:check the level parameter when build new array
Date: Tue, 28 Mar 2017 21:52:27 +0800
Message-ID: <20170328135227.6081-1-zlliu@suse.com>
References: <wrfjshlyidnx.fsf@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjshlyidnx.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

check if user forgets to specify the --level
when build a new array. such as:
./mdadm -B /dev/md0 -n2 /dev/loop[0-1]

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 Build.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Build.c b/Build.c
index 74a440e..a5fcc06 100644
--- a/Build.c
+++ b/Build.c
@@ -56,6 +56,10 @@ int Build(char *mddev, struct mddev_dev *devlist,
 	int uuid[4] = {0,0,0,0};
 	struct map_ent *map = NULL;
 
+	if (s->level == UnSet) {
+		pr_err("a RAID level is needed to Build an array.\n");
+		return 1;
+	}
 	/* scan all devices, make sure they really are block devices */
 	for (dv = devlist; dv; dv=dv->next) {
 		subdevs++;
-- 
2.10.2

