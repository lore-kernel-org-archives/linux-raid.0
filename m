From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: RAID 5,6 sequential writing seems slower in newer kernels
Date: Thu, 3 Dec 2015 08:39:02 -0600
Message-ID: <CAE9DZUSd3nmYv2HXPQnsS67YpaqQidBQYgBLk9H3u85BuMOVLw@mail.gmail.com>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F7761B9B1D11B64BBB666019E9378117FDDF77@CFWEX01.americas.cray.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Kierski <rkierski@cray.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Dec 3, 2015 at 8:19 AM, Robert Kierski <rkierski@cray.com> wrote:
> Phil,
>
> I have a variety of testing tools that I use to corroborate the results of the others.  So... IOR, XDD, fio, iozone, (and dd when I need something simple).  Each of those can be run with a variety of options that simulate what an FS will submit to the block layer without adding the complexity, overhead, and uncertainty that an FS brings to the table.  I've run the same tools through an FS, and found that at the bottom end of things, I can configure those tools to do exactly what the FS does... only when I'm looking at the traces, I don't have to scan past 100K lines while the FS is dealing with inodes, privileges, and other meta data.
>
> But to more precisely answer your question... as an example, if I'm using dd, I give this command:
>
> dd if=/dev/zero of=/dev/md0 bs=1M oflag=direct
>
> Where /dev/md0 is the raid device I've configured.
>
> I don't use bitmaps, I've configured my raid using "--bitmap=none" and confirmed that mdadmin sees that there is no bitmap.  I don't have alignment issues as my ramdisk has 512byte sectors.  If something is somehow aligning things off 512byte boundaries when doing 1m writes.... I would be surprised.  Also... I verified that the data written to disk falls at the boundaries I'm expecting.
>
> I tried RAID0 and got performance that is similar to what I was expecting -- 38G/s doing the writes.
>
> I tried the 4.1 kernel, and was able to get better performance.  It was actually 2x the 3.18 performance... but the 3.18 performance is so bad that twice horrible is still horrible.
>
> Bob Kierski
> Senior Storage Performance Engineer
> Cray Inc.
> 380 Jackson Street
> Suite 210
> St. Paul, MN 55101
> Tele: 651-967-9590
> Fax:  651-605-9001
> Cell: 651-890-7461
>

> I have a variety of testing tools that I use to corroborate the results of the others.

Robert, can you summarize your results for RAID 0, 1, 5, 6?  I'm
interested to see what you are actually getting compared to what you
expected particularly for RAID 5 & 6.
