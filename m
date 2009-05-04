From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 5/7] md: constify VFTs
Date: Mon, 04 May 2009 16:58:50 +1000
Message-ID: <20090504065850.11688.55214.stgit@notabene.brown>
References: <20090504065540.11688.39505.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090504065540.11688.39505.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jan Engelhardt <jengelh@medozas.de>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

From: Jan Engelhardt <jengelh@medozas.de>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5eb01a4..8350bde 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5976,7 +5976,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static struct seq_operations md_seq_ops = {
+static const struct seq_operations md_seq_ops = {
 	.start  = md_seq_start,
 	.next   = md_seq_next,
 	.stop   = md_seq_stop,


