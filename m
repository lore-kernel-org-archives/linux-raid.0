From: Sebastian Kuzminsky <seb@highlab.com>
Subject: Re: Raid sync observations
Date: Wed, 21 Dec 2005 10:02:31 -0700
Message-ID: <E1Ep7MF-0000uF-Fj@highlab.com>
References: <E1Eol86-0008Ju-3J@highlab.com> <43A8B623.5060704@nighthawkrad.net> <20051221114912.GY10278@strugglers.net>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20051221114912.GY10278@strugglers.net> 
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andy Smith <andy@lug.org.uk> wrote:
> On Wed, Dec 21, 2005 at 12:55:47PM +1100, Christopher Smith wrote:
> > Why would you use RAID6 and not RAID10 with four disks ?
> 
> I was wondering the same thing.  It's true that RAID6 is guaranteed
> to still run degraded after losing 2 devices, whereas a RAID10 on 4
> devices could only lose 1 device from each RAID1.  So there is some
> small extra redundancy there.

That's the reason - better reliability.  With 4-disk RAID-10, a 2-disk
failure has a 1/3 chance of causing array failure.  With RAID-6, there
is no chance.


> But how does the performance for read and write compare?

Good question!  I'll post some performance numbers of the RAID-6
configuration when I have it up and running.


-- 
Sebastian Kuzminsky
