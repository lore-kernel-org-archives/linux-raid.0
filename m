From: Neil Brown <neilb@suse.de>
Subject: Re: 2.6.15-rc5-mm3 sata_mv raid5 array failure to start
Date: Tue, 10 Jan 2006 12:29:48 +1100
Message-ID: <17347.3596.845986.167120@cse.unsw.edu.au>
References: <43B82D22.7080705@projecthugo.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: message from Matt Darcy on Sunday January 1
Sender: linux-ide-owner@vger.kernel.org
To: Matt Darcy <kernel-lists@projecthugo.co.uk>
Cc: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday January 1, kernel-lists@projecthugo.co.uk wrote:
> Hello all,
> 
> I am still persisting with my quest for a usable sata_mv driver.
> 
> The 2.5.15-rc5-m3 kernel appear to have been good to me.
> 
> Before I attempt moving to later releases of the 2.6.15 tree I thought 
> I'd get feedback from the people in the know
> 
> This is an intentional cross-post as I'm not %100 sure if the problems 
> sits in the raid error or the actual libata/driver area (more probable)
> 
> I have 7 SATA disks hanging of an 8 port controller which uses the 
> sata_mv driver.
> 
> I create a raid 5 array consisting of 6 disks (using 1 full disk 
> partition) and 1 spare

"1 full disk partition"... So I would expect the array consist of
   sdc1 sdd1 sde1 ...

but..
> 
> The array builds fine - although it takes 300 minutes so its not a quick 
> process to run through tests.
> 
> 
> md6 : active raid5 sdh[5] sdi[6](S) sdg[4] sdf[3] sde[2] sdd[1] sdc[0]
>       1225586560 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
> 

It doesn't.  It is created using the full disks (sdc, sdd, ... No partitioning).

> Jan  1 16:59:51 berger kernel: md: Autodetecting RAID arrays.
> Jan  1 16:59:51 berger kernel: md: invalid superblock checksum on sdh1
> Jan  1 16:59:51 berger kernel: md: sdh1 has invalid sb, not importing!
> Jan  1 16:59:51 berger kernel: md: autorun ...
> Jan  1 16:59:51 berger kernel: md: considering sdi1 ...
> Jan  1 16:59:51 berger kernel: md:  adding sdi1 ...
> Jan  1 16:59:51 berger kernel: md:  adding sdg1 ...
> Jan  1 16:59:51 berger kernel: md:  adding sdf1 ...
> Jan  1 16:59:51 berger kernel: md:  adding sde1 ...
> Jan  1 16:59:51 berger kernel: md:  adding sdd1 ...
> Jan  1 16:59:51 berger kernel: md:  adding sdc1 ...

and them on reboot, md tried to assemble an array from the partitions,
presumably because you set the partition type to raid-auto-detect.
This doesn't work because the array wasn't made from partitions.

I suggest you recreate the array using partitions and see how that
goes:

  mdadm -C /dev/md6 -l5 -n6 -x1 /dev/sd[cdefghi]1

NeilBrown
