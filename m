From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC mdadm PATCH 01/11] sysfs: fix sysfs_set_array() to accept
 valid negative array levels
Date: Thu, 24 Apr 2014 00:22:22 -0700
Message-ID: <20140424072222.4515.47283.stgit@viggo.jf.intel.com>
References: <20140424071902.4515.19684.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140424071902.4515.19684.stgit@viggo.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, jes.sorensen@redhat.com, artur.paszkiewicz@intel.com, dave.jiang@intel.com
List-Id: linux-raid.ids

From: Dan Williams <dan.j.william@intel.com>

Assume this FIXME was to prevent loading a personality for containers.
Fix it up to accept the values that correlate with the actual md kernel
personalities.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 sysfs.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/sysfs.c b/sysfs.c
index 9a1d856960e8..4cbd4e5d051b 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -628,8 +628,9 @@ int sysfs_set_array(struct mdinfo *info, int vers)
 			return 1;
 		}
 	}
-	if (info->array.level < 0)
-		return 0; /* FIXME */
+	/* containers have no personality, they're rather bland */
+	if (info->array.level <= LEVEL_CONTAINER)
+		return 0;
 	rv |= sysfs_set_str(info, NULL, "level",
 			    map_num(pers, info->array.level));
 	if (info->reshape_active && info->delta_disks != UnSet)

