From: David Brown <david@westcontrol.com>
Subject: Re: wish for Linux MD mirrored raid types
Date: Fri, 06 May 2011 12:54:28 +0200
Message-ID: <iq0jv1$psl$1@dough.gmane.org>
References: <20110506071752.GA22063@www2.open-std.org>	<20110506133159.30c66519@natsu>	<20110506090345.GA22245@www2.open-std.org>	<4DC3BDD9.1060300@abpni.co.uk>	<20110506094102.GC22245@www2.open-std.org> <20110506155059.6f82cbeb@natsu> <4DC3C804.6080200@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DC3C804.6080200@abpni.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/05/2011 12:05, Jonathan Tripathy wrote:
>
>>>> RAID1 is traditionally a mirror only setup (ok, some RAID
>>>> implementations may do some load-balancing of some sort). So a RAID1
>>>> with 4 disks is one data set copied onto 4 disks. Bandwidth is roughly
>>>> the same as a single disk (ignoring any load balancing).
>>>> RAID10 is mirror and stripe. A RAID10 with 4 disks is similar to a 2
>>>> disk RAID0 (double bandwidth with data split in half across both
>>>> disks),
>>>> but with each disk having a mirror (which brings the total up to 4
>>>> drives).
>>>>
>>>> Additionally, a RAID1 disk (at least using MD) can be accessed just
>>>> like
>>>> a normal disk (good for recovery etc.) however a single disk out of a
>>>> RAID10 array is next to useless.
> Just so I can sleep at night, is my understanding of RAID10 and RAID1
> above correct?
>

It's mostly right (assuming, of course, that /I/ am correct here...).

RAID1 is traditionally a two-way mirror on two disks (or possibly on two 
other raid sets, as in raid0+1).  So if you talk about RAID1 with 4 
disks, you should probably qualify it more precisely - otherwise people 
will wonder what you mean, or think it is impossible (many other RAID1 
solutions, hardware or software, don't support more than two-way 
mirrors).  /I/ would certainly say that a 4-disk RAID1 is a four-way 
mirror as you described - but some people might think of a standard 
layout RAID1+0.

As you say, RAID10,near on four disks is pretty much identical to 
RAID1+0 - i.e., a stripe of two normal RAID1 pairs.

A single md RAID1 disk can be accessed like a normal disk, /if/ it uses 
metadata format 0.90 which is put at the end of the drive.  If you have 
later metadata formats that are at the beginning, then that will cause 
trouble if you try to view the disk without using md.  A single disk 
from a RAID10 is, as you say, useless without md.

However, assuming your recovery PC supports md raid, then you can 
assembly your single RAID10 disk as a degraded RAID10 array.  After all, 
it wouldn't be very redundant if you only had access to your data when 
all the disks were working!


