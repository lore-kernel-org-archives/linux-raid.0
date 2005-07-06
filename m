From: "Bailey, Scott" <scott.bailey@eds.com>
Subject: RE: mdadm memory leak?
Date: Wed, 6 Jul 2005 12:09:49 -0400
Message-ID: <E26C409DCE780347BD93D08771FF08E92F74D8@usahm236.amer.corp.eds.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>, Eric Sandall <eric@sandall.us>
Cc: David Kowis <dkowis@shlrm.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>diff -Nru a/drivers/md/md.c b/drivers/md/md.c
>--- a/drivers/md/md.c	2005-01-22 00:16:02 -08:00
>+++ b/drivers/md/md.c	2005-01-22 00:16:02 -08:00
>@@ -332,29 +332,26 @@
> static int sync_page_io(struct block_device *bdev, sector_t sector,
int size,
> 		   struct page *page, int rw)
> {
>-	struct bio bio;
>-	struct bio_vec vec;
>+	struct bio *bio = bio_alloc(GFP_KERNEL, 1);
> 	struct completion event;
>+	int ret;
>+
>+	bio_get(bio);
>....
>+	bio_put(bio);
>+	return ret;
> }
>
>bio_alloc sets the refcount to 1.
>bio_get increments it to 2.
>bio_put sets it back to 1.  But it never reaches zero.
>
>You want to get rid of that bio_get near the top of sync_page_io.

I had been wondering why my Alphaserver running Debian kernel 2.6.10-5
had been OOMing every week or so. :-) When I started reading this
thread, nearly a week since the last reboot, I found I had more than 3GB
of memory tied up in bio and biovec-1 slab. (!)

With the offending "bio_get(bio);" removed as described above, the
system is looking much better. With unpatched kernel, I rebooted system
and started synchronization of 9GB RAID-1 drive - at completion, the bio
slab had grown to something like 15,000+ entries. With patched kernel, I
rebooted and am doing another RAID-1 rebuild now - with that about 50%
complete, there are only 992 bio entries. (And only half of those are in
use - this never went below 99% before.)

Many thanks,

	Scott Bailey
	scott.bailey@eds.com
