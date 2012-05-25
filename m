From: Lukasz Dorau <lukasz.dorau@intel.com>
Subject: [PATCH] imsm: fix: correct checking volume's degradation
Date: Fri, 25 May 2012 15:06:41 +0200
Message-ID: <20120525130641.31750.43414.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

We do not check the return value of sysfs_get_ll() now. It is wrong.
If reading of the sysfs "degraded" key does not succeed,
the "new_degraded" variable will not be initiated
and accidentally it can have the value of "degraded" variable.
In that case the change of degradation will not be checked.

It happens if mdadm is compiled with gcc's "-fstack-protector" option
when one tries to stop a volume under reshape (e.g. OLCE).
Reshape seems to be finished then (metadata is in normal/clean state)
but it is not finished, it is broken and data are corrupted.

Now we always check the return value of sysfs_get_ll().
Even if reading of the sysfs "degraded" key does not succeed
(rv == -1) the change of degradation will be checked.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
---
 super-intel.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 6c87e20..07ab9ae 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -10370,8 +10370,10 @@ int check_degradation_change(struct mdinfo *info,
 			     int degraded)
 {
 	unsigned long long new_degraded;
-	sysfs_get_ll(info, NULL, "degraded", &new_degraded);
-	if (new_degraded != (unsigned long long)degraded) {
+	int rv;
+
+	rv = sysfs_get_ll(info, NULL, "degraded", &new_degraded);
+	if ((rv == -1) || (new_degraded != (unsigned long long)degraded)) {
 		/* check each device to ensure it is still working */
 		struct mdinfo *sd;
 		new_degraded = 0;

