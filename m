From: Neil Brown <neilb@suse.de>
Subject: Re: checking md device parity (forced resync) - is it necessary?
Date: Tue, 5 Sep 2006 20:13:23 +1000
Message-ID: <17661.19907.140798.943518@cse.unsw.edu.au>
References: <44FD3C65.8040000@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tomasz Chmielewski on Tuesday September 5
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday September 5, mangoo@wpkg.org wrote:
> Lately I installed Debian on a Thecus n4100 machine.
> It's a 600 MHz ARM storage device, and has 4 x 400 GB drives.
> 
> I made Linux software RAID on these drives:
> - RAID-1  - ~1 GB for system (/)
> - RAID-1  - ~1 GB for swap
> - RAID-10 - ~798 GB for iSCSI storage
> 
> 
> I noticed that each day the device slows down; a quick investigation 
> discovered that Debian runs a "checkarray" script each night at 1 am 
> (via cron). The essence of "checkarray" script is basically this:
> 
> echo check > /sys/block/$dev/md/sync_action
> 
> Which starts a resync of drives. As one can imagine, resync of 800 GB on 
> a rather slow device (600 MHz ARM) can take 12 hours or so...
> 

I believe that was intended to be once a month, not once a day.
Slight error in crontab.

> 
> So my question is: is this "daily forced resync" necessary?

Daily is probably excessive, certainly on an array that size.

Monthly is good.  Weekly might be justified on cheap (i.e. unreliable)
drives and very critical data.

With RAID, sleeping bad blocks can be bad.  If you hit one while
recovering a failed drive, you have to put the piece back together by
hand.
A regular check can wake up those sleeping bad blocks.

> 
> Perhaps in some cases, yes, because someone wrote that tool which does 
> it daily.
> 
> On the other hand, if we consider Linux software RAID stable, such a 
> resync would be only needed in some rare situations.

It has little to do with the stability of Linux software RAID and a
lot to do with stability of modern disk drives.

> 
> When can one need to run a "daily forced resync", and in which 
> circumstances?

As I said, I think the 'daily' is an error.  What exactly do you have
in crontab??

NeilBrown
