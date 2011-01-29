From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: partitions
Date: Fri, 28 Jan 2011 22:46:07 -0500
Message-ID: <4D438D7F.50007@cfl.rr.com>
References: <AANLkTimGHtECH2oFdcWWmjXjzrFeRmDsXhfwg4FMR2a8@mail.gmail.com>	<AANLkTim_16xzRaQJLd1QGd5Dx2LScNX-VUjxrN5uXZng@mail.gmail.com>	<AANLkTinjmGobHBtZxsz3Tv9US1-VKr32ODy4h=-9V1cO@mail.gmail.com>	<AANLkTi=z7PxSrsPoh4gozv8sx2H416pqn=dEGBcciR2m@mail.gmail.com> <AANLkTikNPmc2AK93k5KTUg4fTM5GoOcr+mtYyv5GN08z@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikNPmc2AK93k5KTUg4fTM5GoOcr+mtYyv5GN08z@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hank Barta <hbarta@gmail.com>
Cc: doug@easyco.com, Roberto Spadim <roberto@spadim.com.br>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/28/2011 08:22 PM, Hank Barta wrote:
> One exception: Grub (and perhaps LILO) can boot from a RAID1 partition
> because the individual partition looks like a plain file system. It
> requires v 0.9 metadata which stores the superblock at the end of the
> partition. (Don't ask me how I know! ;) )

Grub2 can boot from raid1, raid0, raid5, it doesn't care ( without a 
plain /boot partition ).

> I have used LVM to partition a RAID5. I have no idea if it adds
> significant overhead vs. partitioning the RAID itself if that were
> possible. It was arcane enough for me to not care to do it again. It
> appears to have some powerful capabilities that were not needed by me.

With LVM you can do online resize and moves, and don't run into issues 
trying to expand a partition and having to take forever to move an 
adjacent one over to make room, or other issues with the 4 primary 
partition limit.  I find these to be pretty handy.

