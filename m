From: Simon Becks <beckssimon5@gmail.com>
Subject: Re: restore 3disk raid5 after raidpartitions have been setup with xfs
 filesystem by accident
Date: Wed, 21 Sep 2016 20:31:23 +0200
Message-ID: <CAKA=zHoJu2vTXQa4yvbJDA2nmQwXLHyw2DfUJ+cVgTDr_gu2XQ@mail.gmail.com>
References: <CAKA=zHqbFv_RQvyR4o4HPS2UrP4xrRWLiy2nR+gudDguk+JLog@mail.gmail.com>
 <CAJCQCtR4NoCebcDLD-ovT+hZY=NKRtj1cP693wHQTbmiERDAXw@mail.gmail.com>
 <CAKA=zHpgVoNA5Y6MBmB4fnG85F-z=hj4FXEiUOggsWUn3tfWXg@mail.gmail.com>
 <20160921171511.GA6381@metamorpher.de> <CAKA=zHq7OgZ+oVAqn7zVmBM0gSQedNk2kZ3dkuBG7V89G-G3Rg@mail.gmail.com>
 <20160921180318.GA6633@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160921180318.GA6633@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Yes.

root@grml ~ # mdadm --create /dev/md42 --metadata=1.2 --data-offset=1M
--chunk=512 --level=5 --assume-clean --raid-devices 3 /dev/mapper/sda6
/dev/mapper/sdb6 /dev/mapper/sdc6      :(
mdadm: array /dev/md42 started.

root@grml ~ # cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md42 : active raid5 dm-2[2] dm-1[1] dm-0[0]
      1923496960 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
      bitmap: 8/8 pages [32KB], 65536KB chunk

[ 1686.015891] md: bind<dm-0>
[ 1686.015937] md: bind<dm-1>
[ 1686.015977] md: bind<dm-2>
[ 1686.099569] raid6: sse2x1    6749 MB/s
[ 1686.167598] raid6: sse2x2    3460 MB/s
[ 1686.235644] raid6: sse2x4    3827 MB/s
[ 1686.235647] raid6: using algorithm sse2x1 (6749 MB/s)
[ 1686.235649] raid6: using ssse3x2 recovery algorithm
[ 1686.240790] async_tx: api initialized (async)
[ 1686.245577] xor: measuring software checksum speed
[ 1686.283657]    prefetch64-sse: 13934.000 MB/sec
[ 1686.323682]    generic_sse: 12289.000 MB/sec
[ 1686.323683] xor: using function: prefetch64-sse (13934.000 MB/sec)
[ 1686.331416] md: raid6 personality registered for level 6
[ 1686.331419] md: raid5 personality registered for level 5
[ 1686.331420] md: raid4 personality registered for level 4
[ 1686.331676] md/raid:md42: device dm-2 operational as raid disk 2
[ 1686.331678] md/raid:md42: device dm-1 operational as raid disk 1
[ 1686.331679] md/raid:md42: device dm-0 operational as raid disk 0
[ 1686.331903] md/raid:md42: allocated 0kB
[ 1686.331926] md/raid:md42: raid level 5 active with 3 out of 3
devices, algorithm 2
[ 1686.331927] RAID conf printout:
[ 1686.331927]  --- level:5 rd:3 wd:3
[ 1686.331928]  disk 0, o:1, dev:dm-0
[ 1686.331929]  disk 1, o:1, dev:dm-1
[ 1686.331929]  disk 2, o:1, dev:dm-2
[ 1686.331966] created bitmap (8 pages) for device md42
[ 1686.332394] md42: bitmap initialized from disk: read 1 pages, set
14676 of 14676 bits
[ 1686.332435] md42: detected capacity change from 0 to 1969660887040
[ 1686.332457] md: md42 switched to read-write mode.
[ 1686.334058]  md42: unknown partition table



root@grml ~ # mount /dev/md42 /te

                                       :(
mount: /dev/md42 is write-protected, mounting read-only
mount: wrong fs type, bad option, bad superblock on /dev/md42,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

root@grml ~ # fsck -n /dev/md42
fsck from util-linux 2.25.2
e2fsck 1.42.12 (29-Aug-2014)
ext2fs_open2: Bad magic number in super-block
fsck.ext2: Superblock invalid, trying backup blocks...
fsck.ext2: Bad magic number in super-block while trying to open /dev/md42

The superblock could not be read or does not describe a valid ext2/ext3/ext4
filesystem.  If the device is valid and it really contains an ext2/ext3/ext4
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>
 or
    e2fsck -b 32768 <device>


Maybe i just assembled it in the wrong order?

2016-09-21 20:03 GMT+02:00 Andreas Klauer <Andreas.Klauer@metamorpher.de>:
> On Wed, Sep 21, 2016 at 07:23:42PM +0200, Simon Becks wrote:
>> But this disk was not in the raid for almost 2 month.
>
> ?
>
> I'm not suggesting to use this disk. Well, not yet anyway.
> It might be an option if everything else fails...
>
> You posted this output assuming that the other disks were set up the same way, yes?
> In that case overlay + mdadm --create (with the settings you showed) is what you do.
>
> Regards
> Andreas Klauer
