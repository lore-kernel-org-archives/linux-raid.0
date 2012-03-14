From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 23/23] md: Add judgement bb->unacked_exist in function
 md_ack_all_badblocks().
Date: Wed, 14 Mar 2012 15:40:42 +1100
Message-ID: <20120314044041.7978.83573.stgit@notabene.brown>
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

If there are no unacked bad blocks, then there is no point searching
for them to acknowledge them.


Signed-off-by: majianpeng <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e9913bf..3b6f4d0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8021,7 +8021,7 @@ void md_ack_all_badblocks(struct badblocks *bb)
 		return;
 	write_seqlock_irq(&bb->lock);
 
-	if (bb->changed == 0) {
+	if (bb->changed == 0 && bb->unacked_exist) {
 		u64 *p = bb->page;
 		int i;
 		for (i = 0; i < bb->count ; i++) {


