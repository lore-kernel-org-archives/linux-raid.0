From: Neil Brown <neilb@suse.de>
Subject: Re: weird issues with raid1
Date: Tue, 16 Dec 2008 08:33:44 +1100
Message-ID: <18758.52536.345145.238926@notabene.brown>
References: <cccedfc60812051810q3c44ae28x514072cb870ac390@mail.gmail.com>
	<18757.62097.166706.244330@notabene.brown>
	<cccedfc60812150542y5607d168q94c09d8dc3438226@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Monday December 15
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday December 15, jnelson-linux-raid@jamponi.net wrote:
> 
> However, it raises a question: bitmaps are about 'resync' not
> 'recovery'?  How do they differ?

With resync, the expectation is that most of the device is correct.
The bitmap tells us which sectors aren't, and we just resync those.

With recover, the expectation is that the entire drive contains
garbage and it has to be recovered from beginning to end.

Each device has a flag to say where the device is in sync write the
array.  The bit map records which sectors of "in-sync" devices may not
actually in in-sync at the moment.
'resync' synchronises the 'in-sync' devices.
'recovery' synchronises a 'not-in-sync' device.b


> 
> >> Question 1:
> >> I'm using a bitmap. Why does the rebuild start completely over?
> >
> > Because the bitmap isn't used to guide a rebuild, only a resync.
> >
> > The effect of --re-add is to make md do a resync rather than a rebuild
> > if the device was previously a fully active member of the array.
> 
> Aha!  This explains a question I raised in another email. What
> happened there is a previously fully active member of the raid got
> added, somehow, as a spare, via --incremental. That's when the entire
> raid thought it needed to be rebuilt. How did that (the device being
> treated as a spare instead of as a previously fully active member)
> happen?

It is hard to guess without details, and they might be hard to collect
after the fact.
Maybe if you have the kernel logs of when the server rebooted and the
recovery started, that might contain some hints.

Thanks,
NeilBrown
