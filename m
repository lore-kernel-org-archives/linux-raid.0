From: "Stephen C. Tweedie" <sct@redhat.com>
Subject: Re: Assertion failure, BUG at journal.c:1732
Date: Mon, 25 Nov 2002 15:08:25 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021125150825.A11869@redhat.com>
References: <Pine.NEB.4.44.0211231926020.11197-100000@iceland.freeshell.org> <Pine.NEB.4.44.0211232017520.8377-200000@iceland.freeshell.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="sm4nu43k4a2Rpi4c"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.NEB.4.44.0211232017520.8377-200000@iceland.freeshell.org>; from schaller@freeshell.org on Sat, Nov 23, 2002 at 08:18:26PM +0000
To: Jeff Schaller <schaller@freeshell.org>
Cc: sct@redhat.com, akpm@zip.com.au, adilger@clusterfs.com, mingo@redhat.com, neilb@cse.unsw.edu.au, ext3-users@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Sat, Nov 23, 2002 at 08:18:26PM +0000, Jeff Schaller wrote:
> Boy, it'd help if I actually attached the log, eh?

Yes. :)

Content-Description: kern.log
> Nov 19 06:58:47 debian kernel: attempt to access beyond end of device
> Nov 19 06:58:47 debian kernel: 09:00: rw=1, want=39121480, limit=39121408

Corruption on disk.  Undiagnosable without more info --- it could be
hardware or software.

> Nov 19 06:58:47 debian kernel: Assertion failure in __journal_remove_journal_head() at journal.c:1732: "buffer_jbd(bh)"
> Nov 19 06:58:47 debian kernel: kernel BUG at journal.c:1732!

That's a core driver layer bug which we found recently, but it's
too close to 2.4.20 to include the fix.  Basically, on an
out-of-bounds IO the ll_rw_block code was clearing most of the bits in
the buffer_head state, leading to the above assert failure when ext3
found its critical metadata had been corrupted.

Patch is below, I'll send it to Marcelo for 2.4.21-pre.

--Stephen

--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="000-buffer_clearbits.patch"

--- linux-2.4-ext3merge/drivers/block/ll_rw_blk.c.=K0026=.orig	Mon Nov 25 15:03:18 2002
+++ linux-2.4-ext3merge/drivers/block/ll_rw_blk.c	Mon Nov 25 15:04:00 2002
@@ -1129,7 +1129,7 @@
 
 		if (maxsector < count || maxsector - count < sector) {
 			/* Yecch */
-			bh->b_state &= (1 << BH_Lock) | (1 << BH_Mapped);
+			bh->b_state &= ~(1 << BH_Dirty);
 
 			/* This may well happen - the kernel calls bread()
 			   without checking the size of the device, e.g.,
@@ -1140,7 +1140,6 @@
 			       kdevname(bh->b_rdev), rw,
 			       (sector + count)>>1, minorsize);
 
-			/* Yecch again */
 			bh->b_end_io(bh, 0);
 			return;
 		}

--sm4nu43k4a2Rpi4c--
