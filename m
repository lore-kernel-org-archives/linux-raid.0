From: Moses Leslie <moses@flyingcroc.net>
Subject: Re: silent corruption with RAID1
Date: Sun, 26 Feb 2006 16:55:20 -0800 (PST)
Message-ID: <20060226164831.G4550@fincher.users.accretive-networks.net>
References: <20060225182714.F4550@fincher.users.accretive-networks.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060225182714.F4550@fincher.users.accretive-networks.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Turns out this is indeed DMA corruption that only happens under high load,
I guessing that raid1 must just do more DMA, so it shows up more often
there.

I can turn the corruption on and off by starting other high-ish bandwidth
processes on the machine (backing up to a remote server, etc).

Thanks for all the suggestions,

Moses

On Sat, 25 Feb 2006, Moses Leslie wrote:

> Hi,
>
> I have a machine that currently has 4 drives in it (currently running
> 2.6.15.4). The first two drives are on the onboard SATA controller (VIA)
> in a RAID-1.  I haven't had any issues with these.
>
> The other two drives were added recently, along with an SiL PCI SATA card
> to put them on.  lspci reports this card as:
>
> 0000:00:0a.0 Unknown mass storage controller: Silicon Image, Inc.
> (formerly CMD Technology Inc) SiI 3112 [SATALink/SATARaid] Serial ATA
> Controller (rev 02)
>
> I initially used mdadm to create a new RAID1 of the two new drives, and
> added them into the LVM group that the other ones were in to expand the
> drive, but pretty quickly noticed (via rsync -c) that all new files were
> corrupted.
>
> I've since pulled the 2nd set of drives out of the LVM to test.  It's only
> when using a RAID-1 that I get occasionaly corruption.  I split the drives
> (each 300GB) into 4 75GB partitions each, and created 3 md devices.   One
> 75GB raid1, one 150GB raid0, and 1 225GB raid5.
>
> I used a script that newfs'd each one, dd'd multiple copies of files (one
> run with a 1GB, one with 3GB, one with 6GB), md5'd those files, then
> umounted.
>
> At least once in each test run, there was a file with the wrong checksum
> when on the RAID-1 part of the test.
>
> After completing all the tests, I redid the md devices such that none
> of them used any of the same partitions that they had used in the first
> test (IE the RAID1 was sda1 and sdb1 in the first one, and was sda4 and
> sdb4 in the second one).
>
> I also did the same test using each of the regular partitions as well
> (sda1-4 and sdb1-4).
>
> I was never able to duplicate any corruption any other time than with the
> RAID1.
>
> There's never any error messages in dmesg or syslog.
>
> Is there anything I can do to help track down where the problem is?
>
> Thanks!
>
> Moses
>
