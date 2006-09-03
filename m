From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID-5 recovery
Date: Sun, 3 Sep 2006 15:11:11 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0609031504220.21489@uplift.swm.pp.se>
References: <200609031148.56910.clive@vacuumtube.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200609031148.56910.clive@vacuumtube.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Clive Messer <clive@vacuumtube.org.uk>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 3 Sep 2006, Clive Messer wrote:

> This leads me to a question. I understand from reading the linux-raid 
> archives that the current behaviour when rebuilding with a single 
> badblock on another disk is for that disk to also be kicked from the 
> array. For some time I have considered buying a 3ware 9500 card and 
> using that instead of my current ICH6 and md solution. Can anyone tell 
> me what would happen in the same scenario with a 3ware card. ie. would 
> that transparently handle a RAID-5 disk failure and rebuild, with a 
> badblock on another disk? Or would I have even less chance of getting my 
> data back?

I only have experience with the 7500 series card and it does the 
following if you run it in 3ware RAID5 mode:

If there is a read error (bad block) on a disk and the array is not 
degraded, it will recalculate the content of the block from the other 
disks and write the bad block, causing the drive to re-allocate. It 
will log that it did this.

If the array is degraded as per your description, it will default to the 
same behaviour linux kernel does for sw-raid, ie stop rebuilding if it 
encounters a read error.
If on the other hand you do want it to ignore the read error, you can tell 
it to do so.

The command to do so from the 3ware cli program is:

maint rebuild c<c> u<u> p<p:-p...> [ignoreECC]

If you add the option "ignoreECC", it will ignore read errors.

In the web administration part this is called "Force Continue on Source 
Errors".

I think 3ware has the manual of the 9500 online so you can probably find 
if the 9500 does the same thing by downloading the manual, it should cover 
this important aspect of RAID5 operation.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

-- 
VGER BF report: U 0.500325
