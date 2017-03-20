From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: strange mirror write perf
Date: Mon, 20 Mar 2017 00:53:50 +0000
Message-ID: <22735.10270.726966.698144@tree.ty.sabi.co.uk>
References: <eda41097b3c3a385f83041f0df372912@grim-is-a-geek.fr>
        <6ec5f2dbefa2b7489d9f39d4833d5113@grim-is-a-geek.fr>
        <c0981a7c8b13facace1228ed0f99efdc@grim-is-a-geek.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c0981a7c8b13facace1228ed0f99efdc@grim-is-a-geek.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]
> abyss ~ # dd bs=1M count=2024 if=/dev/zero of=/dev/sdd conv=fdatasync
> 2024+0 records in
> 2024+0 records out
> 2122317824 bytes (2,1 GB, 2,0 GiB) copied, 14,1238 s, 150 MB/s
> abyss ~ # dd bs=1M count=2024 if=/dev/zero of=/dev/sdc conv=fdatasync
> 2024+0 records in
> 2024+0 records out
> 2122317824 bytes (2,1 GB, 2,0 GiB) copied, 14,7046 s, 144 MB/s
[ ... ]
> mdadm: automatically enabling write-intent bitmap on large array
[ ... ]
> abyss ~ # dd bs=1M count=2024 if=/dev/zero of=/dev/md/md6to conv=fdatasync
> 2024+0 records in
> 2024+0 records out
> 2122317824 bytes (2,1 GB, 2,0 GiB) copied, 21,1528 s, 100 MB/s
[ ... ]

This is not about "performance" but raw speed in a very
particular situation. The difference is not large and could be
meaningless for a variety of reasons:

* Had the initial 6TB sync finished (would take 15-17 hours)?
* Internal bitmaps can steal a fair bit of speed.
* For whatever weirdness is related to the appalling
  implementation of the Linux page cache, IO reading (but less
  so writing) an MD block device is often slower than to a file
  on a filetree on that block device, plus writing via the page
  cache costs a lot of CPU time.

Replication of the experiment on similar smaller disks:

soft#  mdadm --create --verbose /dev/md/md6to --level=1 --raid-devices=2 /dev/sde3 /dev/sdf3
mdadm: size set to 243269440K
mdadm: array /dev/md/md6to started.

soft#  grep -A2 'sd[ef]3' /proc/mdstat 
md127 : active raid1 sdf3[1] sde3[0]
      243269440 blocks super 1.0 [2/2] [UU]
      [====>................]  resync = 20.5% (49954880/243269440) finish=19.5min speed=164445K/sec

soft#  grep -A2 'sd[ef]3' /proc/mdstat; dd bs=1M count=2024 if=/dev/zero of=/dev
/md/md6to conv=fdatasync                                                        
md127 : active raid1 sdf3[1] sde3[0]
      243269440 blocks super 1.0 [2/2] [UU]
      
2024+0 records in
2024+0 records out
2122317824 bytes (2.1 GB) copied, 13.8561 s, 153 MB/s
