From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 5/6] md: Adjust six function calls together with a variable
 assignment in faulty_status()
Date: Tue, 2 May 2017 16:29:39 +0200
Message-ID: <2af19638-e678-3386-f45e-ddaee2c6e9e1@users.sourceforge.net>
References: <f05bfc4e-7935-7e87-cc85-f0d9c5e3846a@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f05bfc4e-7935-7e87-cc85-f0d9c5e3846a@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 2 May 2017 15:35:35 +0200

The script "checkpatch.pl" pointed information out like the following.

ERROR: do not use assignment in if condition

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/faulty.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index f5536c91be5c..2573009b1265 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -231,28 +231,33 @@ static void faulty_status(struct seq_file *seq, struct mddev *mddev)
 	struct faulty_conf *conf = mddev->private;
 	int n;
 
-	if ((n=atomic_read(&conf->counters[WriteTransient])) != 0)
+	n = atomic_read(&conf->counters[WriteTransient]);
+	if (n != 0)
 		seq_printf(seq, " WriteTransient=%d(%d)",
 			   n, conf->period[WriteTransient]);
 
-	if ((n=atomic_read(&conf->counters[ReadTransient])) != 0)
+	n = atomic_read(&conf->counters[ReadTransient]);
+	if (n != 0)
 		seq_printf(seq, " ReadTransient=%d(%d)",
 			   n, conf->period[ReadTransient]);
 
-	if ((n=atomic_read(&conf->counters[WritePersistent])) != 0)
+	n = atomic_read(&conf->counters[WritePersistent]);
+	if (n != 0)
 		seq_printf(seq, " WritePersistent=%d(%d)",
 			   n, conf->period[WritePersistent]);
 
-	if ((n=atomic_read(&conf->counters[ReadPersistent])) != 0)
+	n = atomic_read(&conf->counters[ReadPersistent]);
+	if (n != 0)
 		seq_printf(seq, " ReadPersistent=%d(%d)",
 			   n, conf->period[ReadPersistent]);
 
-
-	if ((n=atomic_read(&conf->counters[ReadFixable])) != 0)
+	n = atomic_read(&conf->counters[ReadFixable]);
+	if (n != 0)
 		seq_printf(seq, " ReadFixable=%d(%d)",
 			   n, conf->period[ReadFixable]);
 
-	if ((n=atomic_read(&conf->counters[WriteAll])) != 0)
+	n = atomic_read(&conf->counters[WriteAll]);
+	if (n != 0)
 		seq_puts(seq, " WriteAll");
 
 	seq_printf(seq, " nfaults=%d", conf->nfaults);
-- 
2.12.2
