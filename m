From: Blazej Kucman <blazej.kucman@intel.com>
Subject: [PATCH] imsm: Update grow manual.
Date: Thu, 16 Jan 2020 09:34:44 +0100
Message-ID: <20200116083444.4971-1-blazej.kucman@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com
List-Id: linux-raid.ids

Update --grow option description in manual, according to
the supported grow operations by IMSM.

Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
---
 mdadm.8.in | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 6b63bb41..ca02a338 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -481,9 +481,7 @@ still be larger than any replacement.
 This value can be set with
 .B \-\-grow
 for RAID level 1/4/5/6 though
-.B CONTAINER
-based arrays such as those with IMSM metadata may not be able to
-support this.
+DDF arrays may not be able to support this.
 If the array was created with a size smaller than the currently
 active drives, the extra space can be accessed using
 .BR \-\-grow .
@@ -2759,9 +2757,7 @@ container format.  The number of devices in a container can be
 increased - which affects all arrays in the container - or an array
 in a container can be converted between levels where those levels are
 supported by the container, and the conversion is on of those listed
-above.  Resizing arrays in an IMSM container with
-.B "--grow --size"
-is not yet supported.
+above.
 
 .PP
 Notes:
-- 
2.16.4
