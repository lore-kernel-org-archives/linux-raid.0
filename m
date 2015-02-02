From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/3] md/bitmap: Delete an unnecessary check before the function
 call "kfree"
Date: Mon, 02 Feb 2015 16:20:42 +0100
Message-ID: <54CF95CA.90102@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.so
 urceforge.net> <54CF93BB.40206@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54CF93BB.40206@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 2 Feb 2015 15:10:57 +0100

The kfree() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

* This issue was detected by using the Coccinelle software.

* Let us also move an assignment for the variable "pages" to the place
  directly before it is really needed for a loop.

* Let us also move another kfree() call into a block which should belong
  to a previous check for the variable "bp".

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/bitmap.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index da3604e..47d72df 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1586,15 +1586,15 @@ static void bitmap_free(struct bitmap *bitmap)
 	bitmap_file_unmap(&bitmap->storage);
 
 	bp = bitmap->counts.bp;
-	pages = bitmap->counts.pages;
 
 	/* free all allocated memory */
-
-	if (bp) /* deallocate the page memory */
+	if (bp) { /* deallocate the page memory */
+		pages = bitmap->counts.pages;
 		for (k = 0; k < pages; k++)
-			if (bp[k].map && !bp[k].hijacked)
+			if (!bp[k].hijacked)
 				kfree(bp[k].map);
-	kfree(bp);
+		kfree(bp);
+	}
 	kfree(bitmap);
 }
 
-- 
2.2.2

