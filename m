From: Alvin Oga <aoga@ns.Linux-Consulting.com>
Subject: Re: parts -- Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 18 Jan 2005 21:05:04 -0800 (PST)
Message-ID: <Pine.LNX.3.96.1050118205122.1423A-100000@Maggie.Linux-Consulting.com>
References: <41EDE62B.7030303@tequila.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41EDE62B.7030303@tequila.co.jp>
Sender: linux-raid-owner@vger.kernel.org
To: Clemens Schwaighofer <cs@tequila.co.jp>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hi ya clemen

On Wed, 19 Jan 2005, Clemens Schwaighofer wrote:

> On 01/05/2005 11:44 PM, Alvin Oga wrote:
> 
> > you're buying bad hardware from bad vendors
> 
> seriously, thats just wrong. Ever heard of IBM "death"start HDs? Or
> other stuff? As long as you use IDE hardware you are always close to
> fail, IDE hardware is done to put much data on cheap disks.

the "deathstar" ( from thailand to be specific ) disks are the exception
and the worst of the bunch

majority of all my dead disks are scsi disks ..
	- the so called better scsi is in fact worst probably
	because it runs hotter ( spinning faster )
	where cooling the case will not help the ball bearings
	or cooling the disk controller's chips

	( scsi: seagate, ibm, fujitsu, ..
	( ide:  seagate, ibm, fujitsu, wd, maxtor, quantum ... 

ide disks are warranteed for 1,3 or 5 years  and some have
a 1,000,000 MTBF ... what you do to it to destroy the mtbf
is what makes the difference of how long it will in fact last
in your environment

and most of my ide disks are approaching 8-10 years and no problems
though most of the cpu's or mb have long since been offline for
too slow of a cpu  -- most all are in offices or 65F server rooms

how you build systems does make a difference..
	- lots of fans ( at least 2 per ide disk, just in case one dies )
	( that is the same as with scsi .. now you can compare )

> A expensive vendor doesn't help you from crappy HW insealf.

lots ... 90% f crappy vendors ... 
	- bad disk or wrong disks
	- bad mb or wrong mb
	- bad nic or wrong nic
	- or no rma number to return bad parts
	- .. on and on ..

- i buy thru tier1 distributors and don't have any "noticeable" bad parts
  ( maybe .1% failure ( doa )) over 1,000s of ide disks in the past year
  or two  and lasts way past its warranty period

==
== everybody has their good and bad ideas of what are good disks and not
== and does not mean that otehrs should expect the same problem
== when everybody buys disks from different vendors and definitely
== installed differently  ( no redundant fans to cool 7200rpm ide disks )
==	operating temp on ide disks should be 25-30C or less per "hddtemp"
==

c ya
alvin 

