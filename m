From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Unable to grow raid10 (error -22)
Date: Wed, 25 Apr 2012 10:04:19 +0200
Message-ID: <4F97B003.1060201@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am facing a problem which I believe is new (I distinctly remember
doing the same on 2.6.somethingold couple years ago). When I try to
grow an array where all memembers have been replaced with large ones
I get an inexplicable.

   kernel: md: couldn't update array info. -22

Nothing else. I am using kernel 3.2.0 and mdadm 3.2.3, both from
debian:
http://packages.debian.org/sid/linux-image-3.2.0-2-amd64 (3.2.15-1)
http://packages.debian.org/sid/mdadm (3.2.3-2)

Here is my full test setup replicating the problem (was replicated
on a different machine). Let me know if I can assist further in
figuring this out:

root@Thesaurus:~/raidfail# for n in $(seq 4) ; do dd if=/dev/zero of=member_$n.img bs=1M count=256 ; done

root@Thesaurus:~/raidfail# for n in $(seq 4) ; do losetup /dev/loop$n member_$n.img ; done

root@Thesaurus:~/raidfail# losetup -a
/dev/loop1: [fd01]:1081442 (/root/raidfail/member_1.img)
/dev/loop2: [fd01]:1081481 (/root/raidfail/member_2.img)
/dev/loop3: [fd01]:1081483 (/root/raidfail/member_3.img)
/dev/loop4: [fd01]:1081515 (/root/raidfail/member_4.img)

root@Thesaurus:~/raidfail# mdadm -C /dev/md1010 -l 10 -p f3 -n 4 -c 256 -e 1.2 -z 128M /dev/loop[1234]
mdadm: largest drive (/dev/loop1) exceeds size (131072K) by more than 1%
Continue creating array? y
mdadm: array /dev/md1010 started.

root@Thesaurus:~/raidfail# mdadm -w /dev/md1010

root@Thesaurus:~/raidfail# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4] [raid10]
md1010 : active raid10 loop4[3] loop3[2] loop2[1] loop1[0]
       174080 blocks super 1.2 256K chunks 3 far-copies [4/4] [UUUU]

(Note - no bitmaps, no anything)

root@Thesaurus:~/raidfail# mdadm --grow --size=max /dev/md1010
mdadm: Cannot set device size for /dev/md1010: Invalid argument


root@Thesaurus:~/raidfail# tail /var/log/kern.log
Apr 25 09:52:36 localhost kernel: md: using maximum available idle IO bandwidth (but not more than 30000 KB/sec) for resync.
Apr 25 09:52:36 localhost kernel: md: using 128k window, over a total of 174080k.
Apr 25 09:52:42 localhost kernel: md: md1010: resync done.
Apr 25 09:52:43 localhost kernel: RAID10 conf printout:
Apr 25 09:52:43 localhost kernel: --- wd:4 rd:4
Apr 25 09:52:43 localhost kernel: disk 0, wo:0, o:1, dev:loop1
Apr 25 09:52:43 localhost kernel: disk 1, wo:0, o:1, dev:loop2
Apr 25 09:52:43 localhost kernel: disk 2, wo:0, o:1, dev:loop3
Apr 25 09:52:43 localhost kernel: disk 3, wo:0, o:1, dev:loop4
Apr 25 09:53:39 localhost kernel: md: couldn't update array info. -22


root@Thesaurus:~/raidfail# mdadm -D /dev/md1010
/dev/md1010:
         Version : 1.2
   Creation Time : Wed Apr 25 09:52:24 2012
      Raid Level : raid10
      Array Size : 174080 (170.03 MiB 178.26 MB)
   Used Dev Size : 130560 (127.52 MiB 133.69 MB)
    Raid Devices : 4
   Total Devices : 4
     Persistence : Superblock is persistent

     Update Time : Wed Apr 25 09:52:43 2012
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : far=3
      Chunk Size : 256K

            Name : Thesaurus:1010  (local to host Thesaurus)
            UUID : 19aeca84:142ee179:b344a19d:08a730fc
          Events : 17

     Number   Major   Minor   RaidDevice State
        0       7        1        0      active sync   /dev/loop1
        1       7        2        1      active sync   /dev/loop2
        2       7        3        2      active sync   /dev/loop3
        3       7        4        3      active sync   /dev/loop4

root@Thesaurus:~/raidfail# mdadm -E /dev/loop1
/dev/loop1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 19aeca84:142ee179:b344a19d:08a730fc
            Name : Thesaurus:1010  (local to host Thesaurus)
   Creation Time : Wed Apr 25 09:52:24 2012
      Raid Level : raid10
    Raid Devices : 4

  Avail Dev Size : 522240 (255.04 MiB 267.39 MB)
      Array Size : 261120 (127.52 MiB 133.69 MB)
   Used Dev Size : 261120 (127.52 MiB 133.69 MB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : d7734a6c:5df0c7cc:b5f7dc04:6595a5eb

     Update Time : Wed Apr 25 09:53:05 2012
        Checksum : 22c8ad18 - correct
          Events : 17

          Layout : far=3
      Chunk Size : 256K

    Device Role : Active device 0
    Array State : AAAA ('A' == active, '.' == missing)
