From: Nominal Animal <kernel@nominal-animal.net>
Subject: [PATCH 1/1] md/bitmap.c:bitmap_status(): Fix filename escaping
Date: Mon, 30 May 2016 21:00:19 +0300
Message-ID: <574C7FB3.50304@nominal-animal.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

The call to seq_file_path() does not include backslash itself
in the set of file names escaped. This results in files named
"foo\t-\nbar" and "foo\\011-\\012bar" being both shown
as "foo\\011-\\012bar". Fix this by including backslash
in the escaped set.

diff -Nabpur linux-4.6/drivers/md/bitmap.c linux-new/drivers/md/bitmap.c
--- linux-4.6/drivers/md/bitmap.c	2016-05-16 01:43:13.000000000 +0300
+++ linux-new/drivers/md/bitmap.c	2016-05-30 19:56:43.791298226 +0300
@@ -1928,7 +1928,7 @@ void bitmap_status(struct seq_file *seq,
 		   chunk_kb ? "KB" : "B");
 	if (bitmap->storage.file) {
 		seq_printf(seq, ", file: ");
-		seq_file_path(seq, bitmap->storage.file, " \t\n");
+		seq_file_path(seq, bitmap->storage.file, " \t\n\\");
 	}

 	seq_printf(seq, "\n");

Regards,
  Nominal Animal
