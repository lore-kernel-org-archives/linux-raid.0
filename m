From: Krekna Mektek <krekna@gmail.com>
Subject: RAID 5 inaccessible - continued
Date: Mon, 13 Feb 2006 16:08:40 +0100
Message-ID: <8b24c8b10602130708p3e2f9a1dh@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

All right, this weekend I was able to use dd to create an imagefile
out of the disk.
I did the folowing:

dd conv=noerror if=dev/hdd1 of=/mnt/hdb1/Faulty-RAIDDisk.img
losetup /dev/loop0 /mnt/hdb1/Faulty-RAIDDisk.img

I edited the mdadm.conf, by replacing /dev/hdd1 for /dev/loop0.

But it did not work out (yet).

madm -E /dev/loop0
mdadm: No super block found on /dev/loop0 (Expected magic a92b4efc,
got 00000000)


How can I continue best?

- mdadm -A --force /dev/md0

or

- can I restore the superblock from the hdd1 disk (which is still alive)

or

- can I configure mdadm.conf other than this:
 (/dev/hdc1 is spare, probably out of date)

DEVICE /dev/hdb1 /dev/hdc1 /dev/loop0
ARRAY /dev/md0 devices=/dev/hdb1,/dev/hdc1,/dev/loop0

or
- some other solution?

Krekna

2006/2/8, Krekna Mektek <krekna@gmail.com>:
> Hi,
>
> I found out that my storage drive was gone and I went to my server to
> check out what wrong.
> I've got 3 400GB disks wich form the array.
>
> I found out I had one spare and one faulty drive, and the RAID 5 array
> was not able to recover.
> After a reboot because of some stuff with Xen my main rootdisk (hda)
> was also failing, and the whole machine was not able to boot anymore.
> And there I was...
> After I tried to commit suicide and did not succeed, I went back to my
> server to try something out.
> I booted with Knoppix 4.02 and edited the mdadm.conf as follows:
>
> DEVICE /dev/hd[bcd]1
> ARRAY /dev/md0 devices=/dev/hdb1,/dev/hdc1,/dev/hdd1
>
>
> I executed mdrun and the following messages appeared:
>
> Forcing event count in /dev/hdd1(2) from 81190986 upto 88231796
> clearing FAULTY flag for device 2 in /dev/md0 for /dev/hdd1
> /dev/md0 has been started with 2 drives (out of 3) and 1 spare.
>
> So I thought I was lucky enough, to get back my data, maybe a bit lost
> concerning the event count which is missing some. Am I right?
>
> But, when I tried to mount it the next day, this was also not
> happening. I ended up with one faulty, one spare and one active. After
> stopping and starting the array sometimes the array was rebuilding
> again. I found out that the disk that it needs to rebuilt the array
> (hdd1 that is) is
> getting errors and falls back to faulty again.
>
>
>
>     Number   Major   Minor   RaidDevice State
>        0       3       65        0      active sync
>        1       0        0        -      removed
>        2      22       65        2      active sync
>
>        3      22        1        1      spare rebuilding
>
>
> and then this:
>
> Rebuild Status : 1% complete
>
>     Number   Major   Minor   RaidDevice State
>        0       3       65        0      active sync
>        1       0        0        -      removed
>        2       0        0        -      removed
>
>        3      22        1        1      spare rebuilding
>        4      22       65        2      faulty
>
> And my dmesg is full of these errors coming from the faulty hdd:
> end_request: I/O error, dev hdd, sector 13614775
> hdd: dma_intr: status=0x51 { DriveReady SeekComplete Error }
> hdd: dma_intr: error=0x40 { UncorrectableError }, LBAsect=13615063,
> high=0, low=13615063, sector=13614783
> ide: failed opcode was: unknown
> end_request: I/O error, dev hdd, sector 13614783
>
>
> I guess this will never succeed...
>
> Is there away to get this data back from the individual disks perhaps?
>
>
> FYI:
>
>
> root@6[~]# cat /proc/mdstat
> Personalities : [raid5]
> md0 : active raid5 hdb1[0] hdc1[3] hdd1[4](F)
>       781417472 blocks level 5, 64k chunk, algorithm 2 [3/1] [U__]
>       [>....................]  recovery =  1.7% (6807460/390708736)
> finish=3626.9min speed=1764K/sec
> unused devices: <none>
>
> Krekna
>
