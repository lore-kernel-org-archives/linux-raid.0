From: Gordon Henderson <gordon@drogon.net>
Subject: Re: partition sizing and raid1
Date: Thu, 4 Nov 2004 08:10:06 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0411040801200.18144@lion.drogon.net>
References: <4179D9DB.2070709@classforge.com> <4189B3B4.2060203@classforge.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4189B3B4.2060203@classforge.com>
Sender: linux-raid-owner@vger.kernel.org
To: matt brennan <raid@classforge.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 4 Nov 2004, matt brennan wrote:

> I created a new raid1 array on two 300GB disks but it came in
> underweight in size...
>
> Filesystem           1M-blocks      Used Available Use% Mounted on
> /dev/md0                129013     27322     95137  23% /home

Is the disk connected to an ATA-100 or 133 controller? IIRC, you will only
see ~130MB unless it's a 133 controller...

> I guess I stuffed up with the partitioning (from fdisk):
>
> > Disk /dev/hda: 255 heads, 63 sectors, 16709 cylinders
> > Units = cylinders of 16065 * 512 bytes
> >
> >    Device Boot    Start       End    Blocks   Id  System
> > /dev/hda1             1     16709 134215011   fd  Linux raid autodetect

> This was accepting fdisk's default max size.

Check the cylinder/head/sector against the BIOS. If neccessary, you can
use fdisk (or cfdisk) to force a change, but this will likely destroy any
data on the disk.

Also make sure both disks are partitioned identically - RAID1 will only be
as big as the smallest of the partitions.

It does look like fdisk has picked up the wrong CHS numbers - the disk
only appears to be 127GB is size according to those.

  (255*63*16709*512)/(1024*1024*1024) = 127.

Gordon
