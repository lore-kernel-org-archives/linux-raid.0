From: Cihangir Akturk <cakturk@gmail.com>
Subject: [PATCH] md: replace seq_release_private with seq_release
Date: Sat, 29 Jul 2017 19:52:45 +0300
Message-ID: <1501347165-32241-1-git-send-email-cakturk@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Cihangir Akturk <cakturk@gmail.com>
List-Id: linux-raid.ids

Since commit f15146380d28 ("fs: seq_file - add event counter to simplify
poll() support"), md.c code has been no longer used the private field of
the struct seq_file, but seq_release_private() has been continued to be
used to release the allocated seq_file. This seems to have been
forgotten. So convert it to use seq_release() instead of
seq_release_private().

Signed-off-by: Cihangir Akturk <cakturk@gmail.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8cdca029..6174360 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7836,7 +7836,7 @@ static const struct file_operations md_seq_fops = {
 	.open           = md_seq_open,
 	.read           = seq_read,
 	.llseek         = seq_lseek,
-	.release	= seq_release_private,
+	.release	= seq_release,
 	.poll		= mdstat_poll,
 };
 
-- 
2.7.4
