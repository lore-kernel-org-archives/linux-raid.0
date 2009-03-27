From: Neil Brown <neilb@suse.de>
Subject: Re: raid0 zones
Date: Fri, 27 Mar 2009 15:41:22 +1100
Message-ID: <18892.22770.668365.114417@notabene.brown>
References: <5d96567b0903261017u515b8e00qc12368e7f82b73f5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Raz on Thursday March 26
Sender: linux-raid-owner@vger.kernel.org
To: Raz <raziebe@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday March 26, raziebe@gmail.com wrote:
> Neil Hello
> I sincerely hope you will answer this email.As i understand , raid0
> zones are aimed for cases where the disks are not symmetric ( or
> partitions ) in their sizes.

correct.

> But this means imbalanced IO. An inbalanced IO, from my application
> perspective is a disaster.
> I am wondering whether zone number greater than 1 may be an option in mdadm.
> I will most thankful for your opinion on this matter.

If you want to avoid zones, simply create partitions that are all the
same size and do raid0 across those.

With v1.x metadata, it might be possible that specifying "--size
whatever" will achieve the same effect, but I'm not certain.

> 
> PS
> I managed to expand raid0 ( very very experimental , and only with zone
> nr == 1).

Cool.

> I still have to learn how to write the superblocks though because I
> cannot re-assemble the raid, and behave according to md rules.

I've been wondering whether it might be easiest to use the raid5 code
base to reshape a raid0.  Handling zones would be very messy, but the
rest should be quite easy.
Just convert the raid0 into a raid4 with a missing party disk.  Then
add a device and reshape to a larger raid4 which is still missing the
parity disk.  Then convert back to raid0.

NeilBrown
