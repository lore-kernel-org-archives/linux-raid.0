From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH] mdadm: Fix Segmentation fault.
Date: Fri, 25 May 2012 19:49:40 +0800
Message-ID: <201205251949358900592@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

In function write_init_super1():
If "rv = store_super1(st, di->fd)" return error and the di is the last.
Then the di = NULL && rv > 0, so exec:
if (rv)
    fprintf(stderr, Name ": Failed to write metadata to%s\n",
     	 di->devname);
will be segmentation fault.

Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 super1.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/super1.c b/super1.c
index 4f20cc3..37b7a90 100644
--- a/super1.c
+++ b/super1.c
@@ -1242,6 +1242,8 @@ static int write_init_super1(struct supertype *st)
 			rv = st->ss->write_bitmap(st, di->fd);
 		close(di->fd);
 		di->fd = -1;
+		if (rv)
+			goto error_out;
 	}
 error_out:
 	if (rv)
-- 
1.7.5.4

 				
--------------
majianpeng
2012-05-25

