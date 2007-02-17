From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.20: reproducible hard lockup with RAID-5 resync
Date: Sat, 17 Feb 2007 06:14:15 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0702170613160.8145@p34.internal.lan>
References: <45D55366.4010904@fatooh.org> <17877.25722.404051.470040@notabene.brown>
 <45D620D5.3060805@fatooh.org> <45D6DFB9.3090009@fatooh.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45D6DFB9.3090009@fatooh.org>
Sender: linux-raid-owner@vger.kernel.org
To: Corey Hickey <bugfood-ml@fatooh.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 17 Feb 2007, Corey Hickey wrote:

> Corey Hickey wrote:
>> When I get home (late) tonight I'll try running dd and badblocks on the
>> corresponding drives and partitions.
>
> Well, I haven't been able to reproduce the problem that way. I tried the
> following:
>
> $ dd id=/dev/hda of=/dev/null
> $ badblocks /dev/hda
> $ badblocks -n /dev/hda
>
> ...and the same for sda6, sdb, sdc6, sdd, and md2. In each case I killed
> the test after several seconds, on the assumption that if the problem
> was reproducible within less than a second by triggering a resync, it
> wouldn't take long any other way.
>
> If anyone has any suggestions for further tests I can do, I'll be happy
> to try them out.
>
> Thanks,
> Corey
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I noticed you are running a disk on /dev/hda, if this is an older mobo and 
you use multiple PCI IDE controllers, if they are in certain slots, or you 
put too many in, they can cause these problems, I have had a few mobos 
that do it if the PCI cards are in a 'certain combination'-- I have had 
this happen with an MSI and ABIT board.

Justin.
