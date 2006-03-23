From: NeilBrown <neilb@suse.de>
Subject: [PATCH] Fix bug: BIO_RW_BARRIER requests to md/raid1 hang.
Date: Thu, 23 Mar 2006 14:41:16 +1100
Message-ID: <1060323034116.13086@suse.de>
References: <20060323143936.13067.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The following fixes a rather embarassing bug in 2.6.16, and so should
go into 2.6.16.1, and 2.6.16-rc1.
Thanks,
NeilBrown


### Comments for Changeset

Both R1BIO_Barrier and R1BIO_Returned are 4 !!!!

This means that barrier requests don't get returned (i.e. b_endio
called) because it looks like they already have been.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./include/linux/raid/raid1.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff ./include/linux/raid/raid1.h~current~ ./include/linux/raid/raid1.h
--- ./include/linux/raid/raid1.h~current~	2006-03-23 13:46:27.000000000 +1100
+++ ./include/linux/raid/raid1.h	2006-03-23 14:36:53.000000000 +1100
@@ -130,6 +130,6 @@ struct r1bio_s {
  * with failure when last write completes (and all failed).
  * Record that bi_end_io was called with this flag...
  */
-#define	R1BIO_Returned 4
+#define	R1BIO_Returned 6
 
 #endif
