From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: Software Raid Cache
Date: Sun, 23 Feb 2003 23:12:45 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.1.6.2.20030223231035.0686d400@mail.harddata.com>
References: <message from SoulBlazer on Friday February 21>
 <3E56910F.6050509@lamp-post.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15961.46603.166633.265132@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

With regards to your message at 11:04 PM 2/23/03, Neil Brown. Where you stated:
> > If this is even something doable (tweakable) Im wondering what the perf
> > gain from allocating say 2 or 4gb just to raid cache would be.
> >
> > Comments ?
>
>How do you imagine this extra 'cache' would be used.
>
>Cache on raid cards tends to be battery backed (I believe) and to
>operate as a write-behind cache thereby increasing performance.  As
>main system memory is not battery backed, you cannot use it as a
>write-behind cache.
>
>NeilBrown


True, and the cache on a RAID controller is not clobbered when the OS or 
computer crashes.
Mind you the same problem exists to some degree with PCI based RAID 
controllers, so the most robust are host independent SCSI/SCSI RAID 
controllers.

Too bad these cost about as much as a typical server!



With our best regards,

Maurice W. Hilarius       Telephone: 01-780-456-9771
Hard Data Ltd.               FAX:       01-780-456-9772
11060 - 166 Avenue        mailto:maurice@harddata.com
Edmonton, AB, Canada      http://www.harddata.com/
    T5X 1Y3

