From: "Peter L. Ashford" <ashford@sdsc.edu>
Subject: Re: RAID 5 performance problems
Date: Thu, 3 Apr 2003 14:13:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.30.0304031405080.20118-100000@multivac.sdsc.edu>
References: <009c01c2fa29$f7b2d290$2e77c23e@pentium4>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <009c01c2fa29$f7b2d290$2e77c23e@pentium4>
To: Jonathan Vardy <jonathanv@explainerdc.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Jonathan,

> > The ONLY reason that I can think of to use round cables would be for
> > looks.  From a performance or reliability standpoint, they are a waste of
> > money.  I routinely build systems with dual 8-channel IDE RAID cards
> > (3Ware 7500-8) and 16 disks, and ONLY use flat cables.
>
> I use rounded cables in my case for a few reasons:
> - The distance between my promise and my drives is small yet the promise
> cables are long, the rounded cables I have are 12" long and fit very neatly
> - The promise cables had two IDE connectors but I only wanted to put one
> drive per channel; the rounded cables are single cables
> - Air flow; because of my small casing the flat promise cables were
> contricting the airflow quite a bit, the rounded less
> - flexibility; I found the flat cables hard to bend in to place whereas the
> round cables you could twist easily
>
> I've added a link which should make it clear that rounded cables in my case
> are a benefit to me. What I was worried about was that they could be
> inferior quality and thus be a factor in my raid performance.
>
> http://www.datzegik.com/DSC00056.JPG

Check out 'http://www.accs.com/p_and_p/TeraByte/cables.html', to see why
round cables are not needed.  Careful cable routing can easilly overcome
the issues you have.  When you have a large number of cables, the flat
cables can stack, but the round cables just make a big bundle.

Also, 3Ware sells 80-conductor/40-pin cables with two connectors in 18",
24" and 36" lengths.

I've built systems in cases that are similar to yours (Antec or Chen-Ming)
with similar numbers of drives, and had no problems with flat cables to
five disks, a CDROM drive and a floppy drive.

Good luck.
				Peter Ashford
