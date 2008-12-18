From: Neil Brown <neilb@suse.de>
Subject: Re: weird issues with raid1
Date: Thu, 18 Dec 2008 16:43:05 +1100
Message-ID: <18761.58089.682224.315110@notabene.brown>
References: <cccedfc60812051810q3c44ae28x514072cb870ac390@mail.gmail.com>
	<18757.62097.166706.244330@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Neil Brown on Monday December 15
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday December 15, neilb@suse.de wrote:
> > 
> > No matter how long I wait, until it is rebuilt, the bitmap on /dev/sda
> > is always 100% dirty.
> > If I --fail, --remove (twice) /dev/sda, and I re-add /dev/sdd1, it
> > clearly uses the bitmap and re-syncs in under 1 second.
> 
> Yes, there is a bug here.
> When an array recovers on to a hot space it doesn't copy the bitmap
> across.  That will only happen lazily as bits are updated.
> I'm surprised I hadn't noticed that before, so they might be more to
> this than I'm seeing at the moment.   But I definitely cannot find
> code to copy the bitmap across.  I'll have to have a think about
> that. 

There isn't a bug here, I was wrong.

We don't update the bitmap on recovery until the recovery is
complete.  Once it is complete we do (as you notice) update it all at
once.
This is correct behaviour because until the recovery is complete, the
new device isn't really part of the array so the bitmap on it doesn't
mean anything.  As soon as the array is flagged as 'InSync' we update
the bitmap on it.

NeilBrown
