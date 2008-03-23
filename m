From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 6/8] Fix a typo in the comment to cmd_match().
Date: Sun, 23 Mar 2008 19:34:54 +0100
Message-ID: <S1750934AbYGGIdv/20080707083351Z+1939@vger.kernel.org>
References: <20080707075532.GA32617@skl-net.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080707075532.GA32617@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids


Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index cdc381f..fe4d9af 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1787,7 +1787,7 @@ repeat:
 
 }
 
-/* words written to sysfs files may, or my not, be \n terminated.
+/* words written to sysfs files may, or may not, be \n terminated.
  * We want to accept with case. For this we use cmd_match.
  */
 static int cmd_match(const char *cmd, const char *str)
-- 
1.5.3.8

