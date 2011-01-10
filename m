From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 10/13] FIX: Cannot unmount array after reshape
Date: Mon, 10 Jan 2011 12:28:48 +0100
Message-ID: <20110110112848.10776.61232.stgit@gklab-128-013.igk.intel.com>
References: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

After reshape array remains blocked (i.e. cannot be umounted) due to suspend_lo
sysfs entry setting.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 6b2889e..f083ba5 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2026,6 +2026,7 @@ static int reshape_array(char *container, int fd, char *devname,
 				unsigned long long current_size = 0;
 				unsigned long long new_size =
 					info2->custom_array_size/2;
+				unsigned long long suspend_value;
 
 				if (sysfs_get_ll(sra,
 						 NULL,
@@ -2043,6 +2044,13 @@ static int reshape_array(char *container, int fd, char *devname,
 					dprintf(" from %llu to %llu.\n",
 						current_size, new_size);
 				}
+				/* manage suspend_* entries
+				 * set suspend_lo to suspend_hi value
+				 * to unblock array
+				 */
+				sysfs_get_ll(sra, NULL, "suspend_hi", &suspend_value);
+				sysfs_set_num(sra, NULL, "suspend_lo", suspend_value);
+
 				sysfs_free(info2);
 			}
 		}

