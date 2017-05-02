From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 4/6] md: Use seq_puts() in faulty_status()
Date: Tue, 2 May 2017 16:28:28 +0200
Message-ID: <7bf548c7-2e09-3af1-f301-fe55b4e9f1d8@users.sourceforge.net>
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
Date: Tue, 2 May 2017 15:20:30 +0200

A string which did not contain a data format specification should be put
into a sequence. Thus use the corresponding function "seq_puts".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/faulty.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index b0536cfd8e17..f5536c91be5c 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -253,7 +253,7 @@ static void faulty_status(struct seq_file *seq, struct mddev *mddev)
 			   n, conf->period[ReadFixable]);
 
 	if ((n=atomic_read(&conf->counters[WriteAll])) != 0)
-		seq_printf(seq, " WriteAll");
+		seq_puts(seq, " WriteAll");
 
 	seq_printf(seq, " nfaults=%d", conf->nfaults);
 }
-- 
2.12.2
