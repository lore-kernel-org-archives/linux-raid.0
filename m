From: Mike Hardy <mhardy@h3c.com>
Subject: Re: More tales of horror from the linux (HW) raid crypt
Date: Wed, 22 Jun 2005 12:33:10 -0700
Message-ID: <42B9BCF6.1010206@h3c.com>
References: <5d96567b05061804477325d743@mail.gmail.com> <200506201853.11768.hjm@tacgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506201853.11768.hjm@tacgi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Harry Mangalam <hjm@tacgi.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Not that I wish bad luck on anyone, but I always enjoy reading about
problems others have had and how they solved them, so I don't have to
learn the hard way. Hopefully your situation gets sorted out.

I can only second (and third, etc) the motion to do SMART tests on all
drives before putting them in service, and add that you should really do
a short test daily and a long test at least weekly if possibly.
Basically you just can't trust consumer drives at all these days.
smartmontools and rsync are probably my most-loved open source packages
these days. I usually get 1 out of 10 bad out of the box now (some
remappable at least) and a handful then fail quickly too. Most of them
haven't gone three years so I can't say if they fail completely, but
they seem to be lasting ok with occasional bad blocks.

I'm very interested in the relative SW raid / HW raid performance. I
have both in service (two raid 5 sets are actually the same size with
the same number of components) and see roughly the same as you mention.
One difference that I see is that HW raid should generate fewer
interrupts and lower bus traffic.

In the one area I used HW raid (a 3ware 8 port PATA, 8x250GB Maxtor,
2xOpteron), it was specifically because the motherboard chipset (or its
interaction with Linux at least) was crap, and couldn't handle the
interrupt load under bonnie++. So this could be a factor.

It also goes to show that burning the machine in (with bonnie++ or
similar) is a very good step. At least you catch these things before
they're in service...

Anyway, good luck with the new drives.

-Mike

Harry Mangalam wrote:
> Hi All,
> 
>>From the traffic, this list seems to be heavily slanted towards the SW aspect 
> of Linux RAID, but there have been a few postings (other than mine) about the 
> HW aspects of it.  So, apologies for the verbarea on the HW aspects, but at 
> least a few people have told me that this running monologue of raid troubles 
> has been useful, so herein, some more.  If I'm reiterating what is part of a 
> FAQ, please let me know, but I read a lot of them and didn't stumble across 
> much of this.
> 
> 
> short version:  test ALL your disks before you use them, especially in a RAID 
> set, especially the 'recertified' ones.
