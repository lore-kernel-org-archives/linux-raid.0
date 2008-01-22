From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH] md: constify function pointer tables
Date: Tue, 22 Jan 2008 20:50:39 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801222049570.5722@fbirervta.pbzchgretzou.qr>
References: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 drivers/md/md.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index cef9ebd..6295b90 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5033,7 +5033,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static struct seq_operations md_seq_ops = {
+static const struct seq_operations md_seq_ops = {
 	.start  = md_seq_start,
 	.next   = md_seq_next,
 	.stop   = md_seq_stop,
-- 
1.5.3.4

