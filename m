From: Alvin Oga <aoga@mail.Linux-Consulting.com>
Subject: Re: raid5 - failed disks
Date: Fri, 1 Apr 2005 02:56:39 -0800 (PST)
Message-ID: <Pine.LNX.3.96.1050401025007.30913A-100000@Maggie.Linux-Consulting.com>
References: <424D238A.8030305@weisshuhn.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <424D238A.8030305@weisshuhn.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hi ya frank

On Fri, 1 Apr 2005, Frank Wittig wrote:

> > - my dumb question is,
> >       - if 2 disks dies at the same time, i
>
> if 2 disks fail at the same time you data is lost.
> if you have raid5 with 5 hot spares and a second disk dies, befor a hot
> spare is synced into the array (will be listed as spare until sync hast
> finished) the same - data gone.

yup about failure before the resync completes..

> > - i think 4x 300GB ide disks is better ( less likely to fail ?? )
> 
> it's a simple calculation.
> if one disk fails with a risk of 1 to 100000, then 10 disks fail with 10
> to 100000. which means that having 10 disks is two times as dangerous as
> having 5 disks.

thanx ... that's also a good reaffirmation too ( that i'm not the only
one to use n * MTBF )  or 1/n .. etc depending on point of view

> if i had an array with as much disks as you have i would chose raid
> level 6 (not sure if dm supports this by now).
> raid level 6 survives two disks failing at once.

ah .. but its not my choices yet ...  stuff on inherits including
the finger for somebody elses decisions to buy xx vs yy for nn reasons

> btw: what reason is there to switch off air conditioning of your it
> equipment. temperature changes are poison to this fragile things.

out here.. some building owners are greedy with their nickels, and
its NOT uncommong to have air conditioning turned off on nights and
weekends
	- and for those thinking colo, the colo's too turn aircondition
	off till people complain its to hot ( temp inching upward till
	people complain )
  
	- ambient temp should be 65F or less
	and disk operating temp ( hddtemp ) should be 35 or less

c ya
alvin

