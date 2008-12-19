From: Neil Brown <neilb@suse.de>
Subject: Re: MD: Feature Request: Estimate of blocks necessary to complete sync
Date: Fri, 19 Dec 2008 15:15:04 +1100
Message-ID: <18763.8136.613030.474356@notabene.brown>
References: <cccedfc60812110727p18abcf49v909cb0860c2d4c02@mail.gmail.com>
	<18759.7048.623851.9550@notabene.brown>
	<20081216105817.GC17966@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Tuesday December 16
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday December 16, maan@systemlinux.org wrote:
> On 14:07, Neil Brown wrote:
> > > What would be nice is the addition of something like this:
> > > Dec 11 08:59:40 turnip kernel: md: bitmap shows 27 128K blocks requiring sync
> > > or
> > > Dec 11 08:59:40 turnip kernel: md: bitmap shows 3456K blocks requiring sync
> > > or some other analogue.
> > > 
> > > Seem reasonable?
> > 
> > Probably.  I wouldn't be too hard to could the number of bits that are
> > set.  I guess it could be useful.
> > 
> > I'll put it on my list :-)
> 
> We already have
> 
> 	printk(KERN_INFO "%s: bitmap initialized from disk: "
> 		"read %lu/%lu pages, set %lu bits\n",
> 		bmname(bitmap), bitmap->file_pages, num_pages, bit_cnt);
> 
> in bitmap.c. Shouldn't that do the trick?

Not entirely.  That is only printed when the array is assembled.

But you might have an active array from which you fail a drive.  Then
subsequent IO causes the bitmap to grow and grow.  Then you
--re-add the drive and start a bitmap-based recovery.  There would be
no info in the logs about how many bits were involved.

I had a look at coding this and decided against it.  At the place
where you would want to print this, you don't have enough information
to know if the resync/recovery will be guided by the bitmap or not.
Only the personality knows that, and it isn't in a good position to
print the message.

If you really want to know, you can use "--examine-bitmap" to see how
many bits are involved I guess....

NeilBrown
