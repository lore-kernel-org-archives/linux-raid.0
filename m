From: michael@estone.ca
Subject: Re: migrating: degrade or grow
Date: Mon, 21 Apr 2008 08:17:49 -0700
Message-ID: <20080421081749.nuzzot6b5s08ocwg@estone.ca>
References: <200804211621.28526.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200804211621.28526.Dexter.Filmore@gmx.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quoting Dexter Filmore <Dexter.Filmore@gmx.de>:

> current situation:
>
> machine with 8 sata ports, currently 4 disks in raid5.
> new array is gonna be 5 disks.
>
> now the question is: pluck one drive, let the array degrade and move data as
> fast as possible to the new array?
> Or: build new array with 4 drivers, then pull old array and grow new array to
> 5 drives?
>

Sounds like your new 5 disk array will have brand new disks? and larger?

If your filesystem allows, you could also just add your new disks in,  
one at a time. (assuming your running software raid)
Once all your new disks have been inserted one at a time, you then  
grow your raid array to fill up the un used space, and then, you grow  
your filesystem to fill up the un used space.
Takes a long time, and becomes more tricky if your array is mounted on  
/ because then you need to use a rescue disk, or boot CD to modify  
your / system.

Building your new array degraded with 4 disks, copying data, and then  
adding 5th disk sounds like it might be the easiest. Nice that you  
have the 8 controllers to play with.

Cheers,
Mike
