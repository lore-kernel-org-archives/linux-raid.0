From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 5,6 sequential writing seems slower in newer kernels
Date: Thu, 3 Dec 2015 10:04:08 -0500
Message-ID: <566059E8.60804@turmel.org>
References: <CAE9DZURyZKmnUmnn5ELAhLUq8nhXD1eBx4g8hDmCzS-MYLrT+Q@mail.gmail.com>
 <20151202010745.GC9812@www5.open-std.org>
 <F7761B9B1D11B64BBB666019E9378117FDDB18@CFWEX01.americas.cray.com>
 <565F03F2.3070803@turmel.org>
 <F7761B9B1D11B64BBB666019E9378117FDDBB9@CFWEX01.americas.cray.com>
 <565F1035.10800@turmel.org>
 <F7761B9B1D11B64BBB666019E9378117FDDC2A@CFWEX01.americas.cray.com>
 <565F136F.2090709@turmel.org>
 <CAE9DZUQGeGFxWigXJr4+HoWCn7+TYj4QBECLce75_zugV14wZQ@mail.gmail.com>
 <F7761B9B1D11B64BBB666019E9378117FDDF77@CFWEX01.americas.cray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F7761B9B1D11B64BBB666019E9378117FDDF77@CFWEX01.americas.cray.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Kierski <rkierski@cray.com>, Dallas Clement <dallas.a.clement@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/03/2015 09:19 AM, Robert Kierski wrote:
> Phil,
> 
> I have a variety of testing tools that I use to corroborate the results of the others.  So... IOR, XDD, fio, iozone, (and dd when I need something simple).  Each of those can be run with a variety of options that simulate what an FS will submit to the block layer without adding the complexity, overhead, and uncertainty that an FS brings to the table.  I've run the same tools through an FS, and found that at the bottom end of things, I can configure those tools to do exactly what the FS does... only when I'm looking at the traces, I don't have to scan past 100K lines while the FS is dealing with inodes, privileges, and other meta data.

Ok.  Please cite the tool when you give a performance number, please.

> But to more precisely answer your question... as an example, if I'm using dd, I give this command:
> 
> dd if=/dev/zero of=/dev/md0 bs=1M oflag=direct

Why oflag=direct ?  And what do you get without it?

> Where /dev/md0 is the raid device I've configured.
> 
> I don't use bitmaps, I've configured my raid using "--bitmap=none" and confirmed that mdadmin sees that there is no bitmap.  I don't have alignment issues as my ramdisk has 512byte sectors.  If something is somehow aligning things off 512byte boundaries when doing 1m writes.... I would be surprised.  Also... I verified that the data written to disk falls at the boundaries I'm expecting.

Ok.  I wasn't concerned about sector size.  I was concerned about writes
not filling complete stripes in a single IO.  Writes to parity raid are
broken up into 4k blocks in the stripe cache for parity calculation.
Each block in that stripe is separated from its mates by the chunk size.
 If you don't write to all of them before the state machine decides to
compute, the parity devices will be read to perform RMW cycles (or the
other data members will be read to recompute from scratch).  Either way,
when the 4k blocks are then written from the stripe, they have to have a
chance to get merged again.

> I tried RAID0 and got performance that is similar to what I was expecting -- 38G/s doing the writes.

Yep, those 1M writes are broken into chunk-sized writes for each member
and submitted as is.  Raid456 breaks those down further for parity
calculation.

So, you probably have found a bug in post-stripe merging.  Possibly due
to the extreme low latency of a ramdisk.  Possibly an O_DIRECT side
effect.  There's been a lot of work on parity raid in the past couple
years, both fixing bugs and adding features.

Sounds like time to bisect to locate the patches that make step changes
in performance on your specific hardware.

Phil
