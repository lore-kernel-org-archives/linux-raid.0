From: Krzysztof Adamski <k-list@adamski.org>
Subject: Re: Looking for help how to migrate 2disk RAID1 to 3 disk RAID6
Date: Wed, 01 Jan 2014 10:10:51 -0500
Message-ID: <1388589051.5058.43.camel@oxygen.netxsys.com>
References: <1388537511.5058.22.camel@oxygen.netxsys.com>
	 <52C36908.2010701@insync.za.net>
	 <1388552041.5058.25.camel@oxygen.netxsys.com>
	 <52C3EEE2.10402@insync.za.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C3EEE2.10402@insync.za.net>
Sender: linux-raid-owner@vger.kernel.org
To: Pieter De Wit <pieter@insync.za.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2014-01-01 at 23:33 +1300, Pieter De Wit wrote:
> On 1/01/2014 17:54, Krzysztof Adamski wrote:
> > On Wed, 2014-01-01 at 14:02 +1300, Pieter De Wit wrote:
> >> On 1/01/2014 13:51, Krzysztof Adamski wrote:
> >>> <snip>
> >> Hi,
> >>
> >> RAID Level 6 requires a minimum of 4 drives to implement
> >>
> >> Cheers,
> >>
> >> Pieter
> > I have seen messages by Neil from 2011 that he was planning to remove
> > this silly minimum requirement of 4 drive for RAID6.
> >
> >
> IMHO, that "silly minimum requirement" *is* RAID6, 2xDATA, 2xPARITY. If 
> you make it 1 DATA, then you might as well have RAID1 with a hot spare 
> (not even sure how the calc's will work - for RAID6 like that, RAID1 is 
> easy :) )

Based of what you are saying you probably would not believe that RAID5
can be made with 2 drives, DATA + 1 PARITY. But Linux RAID supports that
just fine (thanks Neil).

Hot spares are a joke, you have to wait for a drive to fail before you
use them, that can be to late. A 3 drive RAID1 make more sense. On one
system I have a 8 drive RAID1 (the /boot partition) the / (root)
partition is a 8 drive RAID6.

> I would use RAID5 for now, then migrate to RAID6 when you get a forth 
> drive. IIRC, you can always upgrade "up", not down (RAID numbers that is)

Using RAID5 defeats the purpose of having 2 parity drives.

If you want to know why I'm so paranoid, if that I had 5 enterprise
series drives fail within a month period of each other. I didn't lose
any data, but from now I don't trust any drive and I expect triple
redundancy. 

> Cheers,
> 
> Pieter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


