From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Failure propagation of concatenated raids ?
Date: Wed, 15 Jun 2016 02:48:51 +0200
Message-ID: <20160615004851.GA16228@metamorpher.de>
References: <CAAkR8+s1=P5+4w0JBLs71DFtqQiD+x4mssjvL4utmb0HGOfLEg@mail.gmail.com>
 <20160614224155.GA15661@metamorpher.de>
 <CAAkR8+seC6guH6zD-GdG+8_VGP+z5zN3soaqsDDqQKxhKm1U0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAkR8+seC6guH6zD-GdG+8_VGP+z5zN3soaqsDDqQKxhKm1U0g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nicolas Noble <nicolas@nobis-crew.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 14, 2016 at 04:35:13PM -0700, Nicolas Noble wrote:
> But I can still read the online stripes, with read errors occuring
> when encountering offline stripes:
> # hexdump -C /dev/md/test-single |& less
> [ works, until it encounters an offline stripe, failing with 'hexdump:
> /dev/md/test-single: Input/output error' ]

Wow.

> No, it really doesn't cascade :-)

I stand corrected on both counts...

> the above lvm layer still continued being online for
> quite some time - about 5 hours with around 10000 files created, and
> about 30GB of fresh data being created

Why didn't the filesystem go into read-only, that's what baffles me the most.

I just tried it with this setup:

| Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] 
| md42 : active raid5 loop0p1[0] loop0p9[10] loop0p8[8] loop0p7[7] loop0p6[6] loop0p5[5] loop0p4[4] loop0p3[3] loop0p2[2] loop0p10[1]
|       82944 blocks super 1.2 level 5, 512k chunk, algorithm 2 [10/10] [UUUUUUUUUU]
|       
| md43 : active raid5 loop1p1[0] loop1p9[10](F) loop1p8[8](F) loop1p7[7] loop1p6[6] loop1p5[5] loop1p4[4] loop1p3[3] loop1p2[2] loop1p10[1]
|       82944 blocks super 1.2 level 5, 512k chunk, algorithm 2 [10/8] [UUUUUUUU__]
|       
| md44 : active raid0 md42[0] md43[1]
|       163840 blocks super 1.2 512k chunks

mkfs works fine:
      
# mkfs.ext4 /dev/md44
Creating filesystem with 163840 1k blocks and 40960 inodes
Filesystem UUID: 9cc7f9db-f8d8-4155-b728-61d4998e03ec
Superblock backups stored on blocks: 
	8193, 24577, 40961, 57345, 73729

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done 

It even mounts fine:

# mount /dev/md44 loop/
# mount
/dev/md44 on /dev/shm/loop type ext4 (rw,relatime,stripe=512,data=ordered)

Creating files?

# yes | split --bytes=1M 
split: xfq: No space left on device

This thing really doesn't go read-only. Wow.

It believes it has written all these, but once you drop caches, 
you get I/O errors when trying to read those files back.

[59381.302517] EXT4-fs (md44): mounted filesystem with ordered data mode. Opts: (null)
[59559.959199] EXT4-fs warning (device md44): ext4_end_bio:315: I/O error -5 writing to inode 12 (offset 0 size 1048576 starting block 6144)

Not what I expected... hope you can find a solution.

Regards
Andreas Klauer
