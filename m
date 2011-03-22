From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/2] man mdadm: add information for MDADM_EXPERIMENTAL flag
Date: Tue, 22 Mar 2011 12:46:35 +0100
Message-ID: <20110322114634.30235.97064.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Update man for MDADM_EXPERIMENTAL flag.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm.8.in |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 4b70e20..96945ae 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -2229,6 +2229,18 @@ in a container can be converted between levels where those levels are
 supported by the container, and the conversion is on of those listed
 above.
 
+Grow functionality (e.g. expand number of raid devices) for Intel's
+IMSM container format has experimental status. It is guarded by
+.B MDADM_EXPERIMENTAL
+environment variable. This is due to the following reasons:
+
+1. Native Intel's IMSM check-pointing is not fully implemented yet.
+This causes IMSM incompatibility during grow process: grew array cannot
+be roamed between Windows(R) and Linux systems.
+
+2. Interrupting grow operation is not recommended, because
+for Intel's IMSM container format it is not fully tested yet.
+
 .SS SIZE CHANGES
 Normally when an array is built the "size" is taken from the smallest
 of the drives.  If all the small drives in an arrays are, one at a

