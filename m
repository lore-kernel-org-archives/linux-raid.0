From: Neil Brown <neilb@suse.de>
Subject: Re: Linux Software RAID Bitmap Question
Date: Mon, 26 Feb 2007 15:22:01 +1100
Message-ID: <17890.24681.249414.635536@notabene.brown>
References: <Pine.LNX.4.64.0702250903120.21821@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Justin Piszcz on Sunday February 25
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday February 25, jpiszcz@lucidpixels.com wrote:
> Anyone have a good explanation for the use of bitmaps?
> 
> Anyone on the list use them?
> 
> http://gentoo-wiki.com/HOWTO_Gentoo_Install_on_Software_RAID#Data_Scrubbing
> 
> Provides an explanation on that page.
> 
> I believe Neil stated that using bitmaps does incur a 10% performance 
> penalty.  If one's box never (or rarely) crashes, is a bitmap needed?

I think I said it "can" incur such a penalty.  The actual cost is very
dependant on work-load.

> 
> The one question I had regarding a bitmap is as follows:
> 
> The mismatch_cnt file.
> 
> If I have bitmaps turned on for my RAID DEVICES, is it possible that the 
> 'mismatch_cnt' will be updated when it finds a bad block?
> 
> That would be VERY nice instead of running a check all the time.

When md find a bad block (read failure) it either fixes it (by
successfully over-writing the correct date) or fails the drive.

The count of the times that this has happened is available via
   /sys/block/mdX/md/errors

If you use version-1 superblocks, then this count is maintained
throughout the life of the array.  If you use v0.90, the count is
zeroed whenever you assemble the array.

This count is completely separate from the 'mismatch_cnt'.
'mismatch_cnt' referred to when md check if redundant information
(copies or parity) is consistent or not.  This does not happen at all
during normal operation.  It only happens when you ask for a 'check'
or 'repair' operation.  It might also happen when the array
automatically performs a 'sync' after an unclean shutdown.

And all this has very little to do with bitmaps.
So I'm afraid I don't understand your question.

NeilBrown
