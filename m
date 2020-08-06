From: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Subject: [PATCH] manual: update --examine-badblocks
Date: Thu,  6 Aug 2020 13:57:50 +0200
Message-ID: <20200806115750.19647-1-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

IMSM also supports it.

Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
---
 mdadm.8.in | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 1474602..ab832e8 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1695,9 +1695,11 @@ does not report the bitmap for that array.
 .TP
 .B \-\-examine\-badblocks
 List the bad-blocks recorded for the device, if a bad-blocks list has
-been configured.  Currently only
+been configured. Currently only
 .B 1.x
-metadata supports bad-blocks lists.
+and
+.B IMSM
+metadata support bad-blocks lists.
 
 .TP
 .BI \-\-dump= directory
-- 
2.25.0
