From: Jan Engelhardt <jengelh@medozas.de>
Subject: md: constify VFTs
Date: Sun, 11 Jan 2009 23:47:18 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901112345400.20350@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This was already sent on January 22 2008 for 2.6.25, but on a recent
rebase of my constify branch still was not in for 2.6.29.
http://www.mail-archive.com/linux-raid@vger.kernel.org/msg10397.html


---8<---
parent 5b692aa02e68392e41a5b341e5c965b382fda948 (v2.6.29-rc1-6-g5b692aa)
commit e6422a7a52d38365b8697463bebaefcdcb179e3a
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun Jan 11 23:45:53 2009 +0100

md: constify VFTs

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 drivers/md/md.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 41e2509..20c1634 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5644,7 +5644,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static struct seq_operations md_seq_ops = {
+static const struct seq_operations md_seq_ops = {
 	.start  = md_seq_start,
 	.next   = md_seq_next,
 	.stop   = md_seq_stop,
-- 
# Created with git-export-patch

