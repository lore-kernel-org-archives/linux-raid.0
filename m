From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: very degraded RAID5, or increasing capacity by adding discs
Date: Tue, 9 Oct 2007 00:46:36 +0200
Message-ID: <20071009004636.112c886e@absurd>
References: <20071008211313.6cd8bbb5@absurd>
	<470A846B.9090805@sauce.co.nz>
	<20071009002550.12b9b26d@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071009002550.12b9b26d@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janek Kozicki said:     (by the date of Tue, 9 Oct 2007 00:25:50 +0200)

> Richard Scobie said:     (by the date of Tue, 09 Oct 2007 08:26:35 +1300)
> 
> > No, but you can make a degraded 3 drive array, containing 2 drives and 
> > then add the next drive to complete it.
> > 
> > The array can then be grown (man mdadm, GROW section), to add the fourth.
> 
> Oh, good. Thanks, I must've been blind that I missed this.
> This completely solves my problem.

Uh, actually not :)

My 1st 500 GB drive is full now. When I buy a 2nd one I want to
create a 3-disc degraded array using just 2 discs, one of which
contains unbackupable data.

steps:
1. create degraded two-disc RAID5 on 1 new disc
2. copy data from old disc to new one
3. rebuild the array with old and new discs (now I have 500 GB on 2 discs)
4. GROW this array to a degraded 3 discs RAID5 (so I have 1000 GB on 2 discs)
...
5. when I buy 3rd drive I either grow the array, or just rebuild and
wait with growing until I buy a 4th drive.

Problems at step 4.: 'man mdadm' doesn't tell if it's possible to
grow an array to a degraded array (non existant disc). Is it possible?


PS: the fact, that degraded array will be unsafe for the data is an
intented motivating factor for buying next drive ;)

-- 
Janek Kozicki                                                         |
