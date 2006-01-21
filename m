From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Save to use spindown?
Date: Sat, 21 Jan 2006 20:21:23 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0601212009570.20336@lion.drogon.net>
References: <12D89F37-5B36-46A6-860F-53DD9F457E6F@bitart.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12D89F37-5B36-46A6-860F-53DD9F457E6F@bitart.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gerd Knops <gerti-lraid@bitart.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 21 Jan 2006, Gerd Knops wrote:

> Hi,
>
> I have a RAID5 setup with 3 250GB SATA disks. Often the RAID is not
> accessed for days, so I wonder if I can extend the life of the disks
> by spinning them down, eg by setting the spindown timeout for the
> drives with hdparm -S nn.
>
> The hdparm man page says "[after spindown] the drive may take as long
> as 30 seconds to respond to a subsequent disk access". Could that
> cause a timeout when accessing the disks, resulting in one or more
> disks being marked bad?

Hi,

AIUI, It's generally safe to use spin-down. I used it for several years on
a RAID-1 set with good results.

However...

You have N disks in a RAID-X set, and you do a sequential read, it could
then takes N times the spin-up time before you can start to stream data
)-:

Or maybe, you get a little bit of data then a pause as the next disk spins
up, then more data, then a pause, and so on.

This may or may not be an issue for you though, but at between 10-20
seconds per disk could be come annoying quite quickly!

The other major issue is making sure they stay spun-down once you turn
them off. Using hdparm, while sounding like a good thing isn't actually
that good. Too many things running on your server will keep them going -
eg. ext3 likes to peek at the drives every 5 seconds (and it's probable
that other journaling FS's to some extent or other). Then there's
log-files - you'll need to go through syslog.conf and "-" every file to
suppress the fflush. And then the kernel just wants to flush its buffers
from time to time because it's in a good mood.

What I used was something called noflushd. It takes care of the kernel
buffer flush, by keeping it all in memory until theres no more memory.
This it worked well for me with ext2 and kernel 2.4.X. The down-side of
keeping all writes in memory is that if you have a power failure then
things can go quite wrong quite quickly... (I UPSd that particular box)

Get noflushd from: http://noflushd.sourceforge.net/

I retired that particular server after 3 years of use in a home office
environment and the new one has ext3 and doesn't spin down the disks
(yet!)

Gordon
