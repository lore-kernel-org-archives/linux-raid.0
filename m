From: Alvin Oga <aoga@ns.Linux-Consulting.com>
Subject: errors Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 06:55:50 -0800 (PST)
Message-ID: <Pine.LNX.3.96.1050105064738.9245B-100000@Maggie.Linux-Consulting.com>
References: <41DBFBAE.1070309@tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41DBFBAE.1070309@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hi ya michael

On Wed, 5 Jan 2005, Michael Tokarev wrote:

> The drive IS reporting read errors in most cases.

and by the time it reports an error ... its too late ...

- one has to play detective and figure out why the error occured
  and prevent it next time

- the worst possible thing to do is .. "disk seems to be dying"
  so 95% of the people say backup the disks ..
	-- its too too late
	-- exercising a dead/dying disks will only aggravate the
	problem even more

- luckily, most "disks errors" are silly errors
	- bad (cheap, not-too-specs) ide cables
	- 80 conductor vs 40 conductor
	- combining 2 different ata speed drives on the same idea cable
	- too long of an ide cable ... 18" is max
	- disk running too hot ... if its warm to the touch,
	its too hot
	( 35C is maybe okay .. use hddtemp to see what its running at )
	- bent disk cables 
	- bad (electrical characteristics) of the ide drivers from the
	motherboard
	- ... on and on ...

	- todays drives are 1000x better quality than 5-10 years ago

> so things are screwed.  Just like if you hot-remove a DIMM while the
> system is running:

those that do hot-swap of memory deserve what they get :-)
( i know you're joking ... and i've seen it done by forgetful admins
	- these atx power supplies are bad for that reason, since
	the motherboard is still live, even if the pc is off, due to
	standby voltages floating around

>  The talks isn't about
> "undetectable" (unreported etc) errors here, but about the fact that
> the error is here.

the trick is to find out what caused the error ... 
	- if you dont figure out what happened ... the problem will 
	continue 

have fun raiding
alvin

