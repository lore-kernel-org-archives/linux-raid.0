From: Sam Hurst <sam@sam-hurst.co.uk>
Subject: [PATCH] [PATCH] Add sector suffix to mdadm --data-offset manpage
Date: Mon, 18 May 2020 23:49:08 +0100
Message-ID: <20200518224908.2457-1-sam@sam-hurst.co.uk>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Sam Hurst <sam@sam-hurst.co.uk>
List-Id: linux-raid.ids

Signed-off-by: Sam Hurst <sam@sam-hurst.co.uk>
---
 mdadm.8.in | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 9e7cb96..c997be4 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -857,8 +857,9 @@ an array which was originally created using a different version of
 which computed a different offset.
 
 Setting the offset explicitly over-rides the default.  The value given
-is in Kilobytes unless a suffix of 'K', 'M', 'G' or 'T' is used to explicitly
-indicate Kilobytes, Megabytes, Gigabytes or Terabytes respectively.
+is in Kilobytes unless a suffix of 'K', 'M', 'G', 'T' or 's' is used to
+explicitly indicate Kilobytes, Megabytes, Gigabytes, Terabytes or sectors
+respectively.
 
 Since Linux 3.4,
 .B \-\-data\-offset
-- 
2.17.1
