From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 06/16] FIX: suspend_hi and lo set to max and then to 0
Date: Mon, 13 Dec 2010 15:45:40 +0100
Message-ID: <20101213144539.4384.83047.stgit@gklab-170-024.igk.intel.com>
References: <20101213143604.4384.55544.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101213143604.4384.55544.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

After reshape suspend_lo and suspend_hi should be set to start values.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 0896f1d..1f96cbc 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7750,6 +7750,7 @@ int imsm_grow_manage_size(struct supertype *st,
 	unsigned long long size;
 	int container_fd;
 	unsigned long long current_size = 0;
+	unsigned long long suspend_value;
 
 	/* finalize current volume reshape
 	 * for external meta size has to be managed by mdadm
@@ -7793,6 +7794,14 @@ int imsm_grow_manage_size(struct supertype *st,
 		"set size to %llu\n",
 		current_size, size);
 	sysfs_set_num(sra, NULL, "array_size", size);
+	/* manage suspend_* entries
+	 * set suspend_lo to suspend_hi value
+	 * and then push both to 0
+	 */
+	sysfs_get_ll(sra, NULL, "suspend_hi", &suspend_value);
+	sysfs_set_num(sra, NULL, "suspend_lo", suspend_value);
+	sysfs_set_num(sra, NULL, "suspend_hi", 0);
+	sysfs_set_num(sra, NULL, "suspend_lo", 0);
 
 	ret_val = 1;
 

