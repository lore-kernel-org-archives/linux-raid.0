From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/6] md: Replace seven seq_printf() calls by seq_putc()
Date: Tue, 2 May 2017 16:25:17 +0200
Message-ID: <021be952-41c3-c7af-dfc9-74c398b14883@users.sourceforge.net>
References: <f05bfc4e-7935-7e87-cc85-f0d9c5e3846a@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f05bfc4e-7935-7e87-cc85-f0d9c5e3846a@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 2 May 2017 14:01:17 +0200

A few single characters should be put into a sequence.
Thus use the corresponding function "seq_putc".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/md.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 82f798be964f..7f0a35ee192a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7498,7 +7498,7 @@ static void status_unused(struct seq_file *seq)
 	if (!i)
 		seq_printf(seq, "<none>");
 
-	seq_printf(seq, "\n");
+	seq_putc(seq, '\n');
 }
 
 static int status_resync(struct seq_file *seq, struct mddev *mddev)
@@ -7552,12 +7552,13 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 	per_milli = res;
 	{
 		int i, x = per_milli/50, y = 20-x;
-		seq_printf(seq, "[");
+
+		seq_putc(seq, '[');
 		for (i = 0; i < x; i++)
-			seq_printf(seq, "=");
-		seq_printf(seq, ">");
+			seq_putc(seq, '=');
+		seq_putc(seq, '>');
 		for (i = 0; i < y; i++)
-			seq_printf(seq, ".");
+			seq_putc(seq, '.');
 		seq_printf(seq, "] ");
 	}
 	seq_printf(seq, " %s =%3u.%u%% (%llu/%llu)",
@@ -7678,7 +7679,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 			seq_printf(seq, "[%s] ", pers->name);
 
 		spin_unlock(&pers_lock);
-		seq_printf(seq, "\n");
+		seq_putc(seq, '\n');
 		seq->poll_event = atomic_read(&md_event_count);
 		return 0;
 	}
@@ -7754,8 +7755,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 			seq_printf(seq, "\n       ");
 
 		bitmap_status(seq, mddev->bitmap);
-
-		seq_printf(seq, "\n");
+		seq_putc(seq, '\n');
 	}
 	spin_unlock(&mddev->lock);
 
-- 
2.12.2
