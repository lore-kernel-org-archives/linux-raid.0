From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 04/23] md: Use existed macros instead of numbers
Date: Wed, 14 Mar 2012 15:40:39 +1100
Message-ID: <20120314044039.7978.71742.stgit@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120314043555.7978.75486.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: majianpeng <majianpeng@gmail.com>

Signed-off-by: majianpeng <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 include/linux/raid/md_p.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/raid/md_p.h b/include/linux/raid/md_p.h
index 6f6df86..8c0a3ad 100644
--- a/include/linux/raid/md_p.h
+++ b/include/linux/raid/md_p.h
@@ -281,6 +281,10 @@ struct mdp_superblock_1 {
 					    * active device with same 'role'.
 					    * 'recovery_offset' is also set.
 					    */
-#define	MD_FEATURE_ALL			(1|2|4|8|16)
+#define	MD_FEATURE_ALL			(MD_FEATURE_BITMAP_OFFSET	\
+					|MD_FEATURE_RECOVERY_OFFSET	\
+					|MD_FEATURE_RESHAPE_ACTIVE	\
+					|MD_FEATURE_BAD_BLOCKS		\
+					|MD_FEATURE_REPLACEMENT)
 
 #endif 


