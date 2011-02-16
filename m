From: Phil Turmel <philip@turmel.org>
Subject: Re: old filesystem label remaining after partition --add 'ed?
Date: Wed, 16 Feb 2011 11:52:42 -0500
Message-ID: <4D5C00DA.2060300@turmel.org>
References: <AANLkTikcYz+AYXQBm+BhcjM1SkvDnR=-x58jLbyGB+2d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikcYz+AYXQBm+BhcjM1SkvDnR=-x58jLbyGB+2d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/16/2011 12:44 AM, hansbkk@gmail.com wrote:
> I replaced a RAID6 member drive that hadn't been fully zero'd, had the
> same partitioning layout as the previous one.
> 
> The target partition had previously had an ext3 filesystem on it for
> temporary moving/copying files around, with an e2label on it.
> 
> I added the partition to the array with "mdadm /dev/md_raid6a --add
> /sde4", and let it rebuild, all looks good both via -D and
> /proc/mdstat
> 
> Later on, I noticed that that partition still has the e2label on it? I
> know my RAID1's show the label same as if it's a regular partition,
> but I've always got a "bad magic" message back from checking for a
> label on a RAID5/6 array member partition.
> 
> I'm assuming this is just cosmetic, but it bothers my (probably OCD)
> sense of order, so I thought I'd check in here.
> 
> I don't even know a command to remove an existing filesystem other
> than zeroing out the MBR/partition table - and in this case I didn't
> want to disturb data in the other partitions. I supposed I could have
> formatted it as ntfs or something, but that doesn't seem right.

I'm going to guess that your array has v1.1 metadata.  If so, a fragment of your old filesystem still exists between the end of the MD superblock and the beginning of the data area.  MD's bitmaps are supposed to live in that area, so I'm going to guess that you aren't using an internal bitmap.  An 'mdadm -E' for that partition would help.

Ext2 and friends leave space for a boot block at the beginning, so the first ext2 superblock is 1k (?) into the partition.  The blkid library knows this, so it is looking "past" your md superblock and seeing the ext2 superblock.

A careful dd of the right sectors should knock it out.  (You're going to verify all this first, I hope.)

Phil
