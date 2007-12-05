From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: raid6 check/repair
Date: Wed, 5 Dec 2007 07:53:45 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712050749410.11889@uplift.swm.pp.se>
References: <474431BF.30103@ph.tum.de> <18244.64972.172685.796502@notabene.brown>
 <4745B375.4030500@ph.tum.de> <18254.21949.441607.134763@notabene.brown>
 <474F4880.8080300@eyal.emu.id.au> <47502140.1080601@ph.tum.de>
 <1196650421.14411.10.camel@elara.tcw.local> <47546019.5030300@ph.tum.de>
 <18261.49547.588360.436369@base.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18261.49547.588360.436369@base.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 4 Dec 2007, Peter Grandi wrote:

> ms> and linux-raid / mdadm did not complain or do anything.
>
> The mystic version of Linux-RAID is in psi-test right now :-).
>
> To me RAID does not seem the right abstraction level to deal with
> this problem; and perhaps the file system level is not either,
> even if ZFS tries to address some of the problem.

Hm. If I run a "check" on a raid1, I would expect it to read data from 
both disks and compare them, and complain if it's not identical. Are you 
sure you really mean what you're saying here?

I do realise that if the corruption happens above the raid layer then 
there is nothing we can do, but if md asks to write a block to two raid1 
disks and the system corrupts the write and writes different data to the 
two different drives in the raid1, then when md does check at a later time 
and discovers this, it should scream bloody murder, choose one of the data 
and replicate it to the other one...? I know this might as well be the 
wrong data, but md can't figure that out, but it should correct the 
*raid1* inconsistancy, which I think is what the person you replied to 
meant?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
