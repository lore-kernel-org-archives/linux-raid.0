From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: migrating: degrade or grow
Date: Mon, 21 Apr 2008 20:14:20 +0200
Message-ID: <200804212014.21014.Dexter.Filmore@gmx.de>
References: <200804211621.28526.Dexter.Filmore@gmx.de> <20080421081749.nuzzot6b5s08ocwg@estone.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080421081749.nuzzot6b5s08ocwg@estone.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: michael@estone.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Montag, 21. April 2008 17:17:49 schrieb michael@estone.ca:
> Quoting Dexter Filmore <Dexter.Filmore@gmx.de>:
> > current situation:
> >
> > machine with 8 sata ports, currently 4 disks in raid5.
> > new array is gonna be 5 disks.
> >
> > now the question is: pluck one drive, let the array degrade and move data
> > as fast as possible to the new array?
> > Or: build new array with 4 drivers, then pull old array and grow new
> > array to 5 drives?
>
> Sounds like your new 5 disk array will have brand new disks? and larger?
>
> If your filesystem allows, you could also just add your new disks in,
> one at a time. (assuming your running software raid)
> Once all your new disks have been inserted one at a time, you then
> grow your raid array to fill up the un used space, and then, you grow
> your filesystem to fill up the un used space.
> Takes a long time, and becomes more tricky if your array is mounted on
> / because then you need to use a rescue disk, or boot CD to modify
> your / system.
>
> Building your new array degraded with 4 disks, copying data, and then
> adding 5th disk sounds like it might be the easiest. Nice that you
> have the 8 controllers to play with.

Andrew Farley already pointed me at that option, whcih I wasn't aware of in 
the first place. I think I'll go for that, leaves the old array intact.

Now about the man page on how to create a degraded array...

That 8 ports come from 4 onboard ports and another 4 from a sil3114 card. I 
wonder why there's not more of those.



-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.vorratsdatenspeicherung.de
