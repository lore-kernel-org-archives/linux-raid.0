From: Gordon Henderson <gordon@drogon.net>
Subject: Re: 4 disks: RAID-6 or RAID-10 ..
Date: Fri, 17 Feb 2006 15:56:00 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0602171541110.22063@lion.drogon.net>
References: <Pine.LNX.4.56.0602171100420.22063@lion.drogon.net>
 <43F5B707.3030005@panix.com> <Pine.LNX.4.56.0602171153090.22063@lion.drogon.net>
 <fd8d0180602170407ib160644v@mail.gmail.com> <Pine.LNX.4.56.0602171445280.22063@lion.drogon.net>
 <20060217153132.GA32687@strugglers.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060217153132.GA32687@strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@lug.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 17 Feb 2006, Andy Smith wrote:

> On Fri, Feb 17, 2006 at 03:14:37PM +0000, Gordon Henderson wrote:
> > Still scratching my head, trying to work out if raid-10 can withstand
> > (any) 2 disks of failure though, although after reading md(4) a few times
> > now, I'm begining to think it can't (unless you are lucky!) So maybe I'll
> > just stick with Raid-6 as I know that!
>
> RAID-10 cannot survive the failure of *any* two disks as if two
> disks in one of the mirrors died then the whole mirror would be lost
> which loses you a segment of the upper stripe.  *If* a second disk
> dies, then with 4 didks total you have 50% chance of it being the
> one you're relying on.

I understand the avice in a classic RAID-1+0, but Linux native RAID-10 is
somewhat different from a classic RAID-0 built in top of 2 x 2-disk
RAID-1's (AIUI). I was thinking of 3 replicas in near mode, but that
diminishes my overall disk capacity somewhat... (1.333 times a disk rather
than 2 times a disk for R6, but if performance was significantly better I
could live with it)

I pickup the hardware on Monday evening, so I'll have a few days of
playing.

Cheers,

Gordon
