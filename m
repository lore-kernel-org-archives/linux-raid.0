From: Durval Menezes <durval.menezes@gmail.com>
Subject: Re: Help, array corrupted after clean shutdown.
Date: Mon, 8 Apr 2013 05:10:07 -0300
Message-ID: <CACj=ugTozdbEKvzeNZ4ZjH67P2mqFAicj_SJM6Ui9pUT64oPeg@mail.gmail.com>
References: <5160060B.8020603@schinagl.nl>
	<CACj=ugTsNd87z4Uq_KdZa_HJYFNTtxwZJ76bv0GNHUj8D66YTA@mail.gmail.com>
	<51603BF2.404@schinagl.nl>
	<CACj=ugSH2YBrePTKy3e36H4fcHpKQ8ywxrJoLJwbqtbvOR+pEQ@mail.gmail.com>
	<5160630D.9000508@schinagl.nl>
	<CACj=ugQR6hjw0qchJiOtgyWd8VRGs_pkZCBXHbQwjrKFz4u=Xg@mail.gmail.com>
	<51619195.9070507@schinagl.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51619195.9070507@schinagl.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Oliver.

On Sun, Apr 7, 2013 at 12:32 PM, Oliver Schinagl
<oliver+list@schinagl.nl> wrote:
>
> On 06-04-13 20:59, Durval Menezes wrote:
>>
>> Hi Oliver,
>>
>>
>> On Sat, Apr 6, 2013 at 3:01 PM, Oliver Schinagl <oliver+list@schinagl.nl
>> <mailto:oliver+list@schinagl.nl>> wrote:
>>
>>     On 04/06/13 19:44, Durval Menezes wrote:
>>
>>         Hi Oliver,
>>
>>         Seems most of your problems are filesystem corruption (the
>>         extN family
>>         is well known for lack of robustness).
>>
>>         I would try to mount the filesystem read-only (without fsck)
>>         and copy
>>         off as much data as possible... Then fsck and try to copy the
>>         rest.
>>
>>         Good luck.
>>
>>     It fails to mount ;)
>>
>>     How can I ensure that the array is not corrupt however (while
>>     degraded)? At least that way, I can try my luck with ext4 tools.
>>
>>
>> If the array was not degraded, I would try an array check:
>>
>> |echo check > /sys/block/md0/md/sync_action|
>>
>> Then, if you had no (or very little) mismatches, I would consider it OK.
>> But as your array is in degraded mode, you have no redundancy to enable you
>> to check... :-/
>
> I guess the 'order' wouldn't have mattered. I would have expected some
> very basic check was available.
>
> Maybe for raid8 :p; Thinking along the lines, every block has an id, and
> each stripe has maching id's. If the id's no longer match, something is
> wrong. Would probably only waste space in the end.

And time ;-)

> Anyhow, I may have panicked a little to early. mount did indeed fail to
> mount, checking dmesg revealed a little more:
> [  117.665385] EXT4-fs (md102): mounted filesystem with writeback data
> mode. Opts: commit=120,data=writeback
> [  126.743000] EXT4-fs (md101): ext4_check_descriptors: Checksum for group
> 0 failed (42475!=15853)
> [  126.743003] EXT4-fs (md101): group descriptors corrupted!
>
> I asked on linux-ext4 what could be going wrong, fsck-ing -n does show
> (all?) group-descriptors not matching.

Ouch :-/

> Mounting ro however works

Glad to hear it. When you said that "it fails to mount", I thought you
had tried mounting read-only as I suggested.

> and all data appears to be correct from a quick
> investigation (my virtual machines start normally, so if that is ok, the
> rest must be too.

So probably only ext4 allocation metadata (which I think is what the
group descriptors are) got corrupted... probably your data survived
OK.

> I am now in the progress of copying, and rsycn -car the
> data to a temporary spot.

After your data is copied, try validating it with whatever tools
available, for example: for compressed files, try checking them (ex:
"tar tvzf" for tar.gz files); if it's your root partition, try
checking your distribution packages (rpm -Va on RPM distros, for
example), etc. If it shows any corrupted data, it might point you
towards things that need restoring, and if it shows nothing wrong, it
will give you confidence that the rest of your (uncheckable) data is
possibly good too.

> Thanks for all the help though, I probably would
> have kept trying to fix the array first.

No prob, and good luck with the rest of your recovery!


> I'm still wondering why my entire (and only the) partition table was gone.

One theory: as your shutdown was clean, then ext4 allocation metadata
has probably been badly mangled in memory before the shutdown, so some
of your data was possibly written over the start of the disk,
clobbering the GPT.

Off (Linux md RAID) topic: If I were in your place, I would start
worrying how the in-memory metadata was SILENTLY mangled in the first
place... do you use ECC memory, for example? Also, I would consider
(now that you will have to mkfs the mangled partition to restore your
data anyway) using a filesystem that has multiple metadata copies and
also the means for not only finding out about silent corruptions but
also for fixing them, to say nothing of a built-in RAID with no
write-hole and that gives your data the same silent-corruption
detection-and-fixing feature: http://zfsonlinux.org/

Cheers,
-- 
   Durval.


Cheers,
-- 
   Durval.

>>
>> Cheers,
>> --
>>    Durval.
>>
>>
>>
>>
>>         --
>>             Durval.
>>
>>         On Apr 6, 2013 12:13 PM, "Oliver Schinagl"
>>         <oliver+list@schinagl.nl <mailto:oliver%2Blist@schinagl.nl>
>>         <mailto:oliver%2Blist@schinagl.nl
>>
>>         <mailto:oliver%252Blist@schinagl.nl>>> wrote:
>>
>>             On 04/06/13 17:06, Durval Menezes wrote:
>>
>>                 Oliver,
>>
>>                 What file system? LVM or direct on the MD device?
>>
>>             Sorry, should have mentioned this.
>>
>>             I have 4 1.5 TB sata drives, connected to the onboard sata
>>         controller.
>>
>>             I have made 1 GPT partition ontop of each drive and then
>>         made a
>>             raid5 array ontop of those devices:
>>
>>             md101 : active (read-only) raid5 sdd1[0] sde1[4] sdf1[1]
>>                    4395413760 blocks super 1.2 level 5, 256k chunk,
>>         algorithm 2
>>             [4/3] [UU_U]
>>
>>             I then formatted /dev/md101 with ext4.
>>
>>             Tune2fs still happily runs on /dev/md101, but of course
>>         that doesn't
>>             mean anything.
>>
>>             riley tmp # tune2fs -l /dev/md101
>>             tune2fs 1.42 (29-Nov-2011)
>>             Filesystem volume name:   data01
>>             Last mounted on:          /tank/01
>>             Filesystem UUID:  9c812d61-96ce-4b71-9763-__b77e8b9618d1
>>
>>             Filesystem magic number:  0xEF53
>>             Filesystem revision #:    1 (dynamic)
>>             Filesystem features:      has_journal ext_attr resize_inode
>>             dir_index filetype extent flex_bg sparse_super large_file
>>         huge_file
>>             uninit_bg dir_nlink extra_isize
>>             Filesystem flags:         signed_directory_hash
>>             Default mount options:    (none)
>>             Filesystem state:         not clean
>>             Errors behavior:          Continue
>>             Filesystem OS type:       Linux
>>             Inode count:              274718720
>>             Block count:              1098853440
>>             Reserved block count:     0
>>             Free blocks:              228693396
>>             Free inodes:              274387775
>>             First block:              0
>>             Block size:               4096
>>             Fragment size:            4096
>>             Reserved GDT blocks:      762
>>             Blocks per group:         32768
>>             Fragments per group:      32768
>>             Inodes per group:         8192
>>             Inode blocks per group:   512
>>             RAID stride:              64
>>             RAID stripe width:        192
>>             Flex block group size:    16
>>             Filesystem created:       Wed Apr 28 16:42:58 2010
>>             Last mount time:          Tue May  4 17:14:48 2010
>>             Last write time:          Sat Apr  6 11:45:57 2013
>>             Mount count:              10
>>             Maximum mount count:      32
>>             Last checked:             Wed Apr 28 16:42:58 2010
>>             Check interval:           15552000 (6 months)
>>             Next check after:         Mon Oct 25 16:42:58 2010
>>             Lifetime writes:          3591 GB
>>             Reserved blocks uid:      0 (user root)
>>             Reserved blocks gid:      0 (group root)
>>             First inode:              11
>>             Inode size:               256
>>             Required extra isize:     28
>>             Desired extra isize:      28
>>             Journal inode:            8
>>             First orphan inode:       17
>>             Default directory hash:   half_md4
>>             Directory Hash Seed:  f1248a94-5a6a-4e4a-af8a-__68b019d13ef6
>>
>>             Journal backup:           inode blocks
>>
>>
>>
>>                 --
>>                      Durval.
>>
>>                 On Apr 6, 2013 8:23 AM, "Oliver Schinagl"
>>                 <oliver+list@schinagl.nl
>>         <mailto:oliver%2Blist@schinagl.nl>
>>         <mailto:oliver%2Blist@schinagl.nl
>>         <mailto:oliver%252Blist@schinagl.nl>>
>>                 <mailto:oliver%2Blist@
>>         <mailto:oliver%252Blist@>__schinagl.nl <http://schinagl.nl>
>>
>>                 <mailto:oliver%252Blist@schinagl.nl
>>
>>         <mailto:oliver%25252Blist@schinagl.nl>>>> wrote:
>>
>>                      Hi,
>>
>>                      I've had a powerfailure today, to which my UPS
>>         responded
>>                 nicely and
>>                      made my server shutdown normally. One would expect
>>                 everything is
>>                      well, right? The array, as far as I know, was
>>         operating without
>>                      problems before the shutdown, all 4 devices where
>>         normally
>>                 online.
>>                      mdadm sends me an e-mail if something is wrong,
>>         so does
>>                 smartctl.
>>
>>                      First thing I noticed that I had 2 (S) drives for
>>                 /dev/md101. I thus
>>                      started examining things. First I thought that it
>>         was some
>>                 mdadm
>>                      weirdness, where it failed to assemble the drive
>>         with all
>>                 components.
>>                      mdadm -A /dev/md101 /dev/sd[cdef]1 failed and
>>         gave the same
>>                 result.
>>                      Something was really wrong.
>>
>>                      I checked and compared the output of mdadm
>>         --examine on all
>>                 drives
>>                      (like -Evvvs below) and found that /dev/sdc1's
>>         events count
>>                 was wrong.
>>                      /dev/sdf1 and /dev/sdd1 matched (and later sde1
>>         too, but
>>                 more on
>>                      that in a sec). So sdc1 may have been dropped
>>         from the
>>                 array without
>>                      me knowing it, unlikely put possible. The odd
>>         thing is the huge
>>                      difference in event counts, but all four are
>>         marked as ACTIVE.
>>
>>                      So then onto sde1; why was it failing on that.
>>         The gpt
>>                 table was
>>                      completly gone. 00000. Gone. I used hexdump to
>>         examine the
>>                 drive
>>                      further, and at 0x00041000 there was the mdraid
>>         table, as
>>                 one would
>>                      expect. Good, so it looks like only the gpt has
>>         been wiped
>>                 for some
>>                      misterious reason. Re-creating the gpt quickly
>>         revealed mdadm's
>>                      information was still correct (as can be seen
>> below).
>>
>>                      So ignore sdc1 and assemble the drive as is
>>         should be fine?
>>                 Right? No.
>>                      mdadm -A /dev/md101 /dev/sd[def]1 worked without
>>         error.
>>
>>                      I always do a fsck before and after a reboot
>>         (unless of
>>                 course I
>>                      can't do the shutdown fsck) and verify
>>         /proc/mdadm after a
>>                 boot. So
>>                      before mounting, as always, I tried to run fsck
>>         /dev/md101
>>                 -C -; but
>>                      that came up with tons of errors. I didn't fix
>>         anything and
>>                 aborted.
>>
>>                      And here we are now. I can't just copy the entire
>>         disk
>>                 (1.5TB per
>>                      disk) and 'experiment', I don't have 4 spare
>>         disks. The
>>                 first thing
>>                      I would want to try is is mdadm -A /dev/sd[cdf]1
>>         --force
>>                 (leave out
>>                      the possibly corrupted sde1) and see what that does.
>>
>>
>>                      All that said when I did the assemble with the
>>         'guessed' 3
>>                 correct
>>                      drives. Did of course increase the events count.
>>         sdc1 of course
>>                      didn't partake in this. Assuming that it is in
>>         sync with
>>                 the rest,
>>                      what is the worst that can happen? And does the
>>         --read-only
>>                 flag
>>                      protect against it?
>>
>>
>>                      Linux riley 3.7.4-gentoo #2 SMP Tue Feb 5
>>         16:20:59 CET 2013
>>                 x86_64
>>                      AMD Phenom(tm) II X4 905e Processor AuthenticAMD
>>         GNU/Linux
>>
>>                      riley tmp # mdadm --version
>>                      mdadm - v3.1.4 - 31st August 2010
>>
>>
>>                      riley tmp # mdadm -Evvvvs
>>                      /dev/sdf1:
>>                                 Magic : a92b4efc
>>                               Version : 1.2
>>                           Feature Map : 0x0
>>                            Array UUID :
>>         2becc012:2d317133:2447784c:____1aab300d
>>
>>                                  Name : riley:data01  (local to host
>>         riley)
>>                         Creation Time : Tue Apr 27 18:03:37 2010
>>                            Raid Level : raid5
>>                          Raid Devices : 4
>>
>>                        Avail Dev Size : 2930276351 (1397.26 GiB
>>         1500.30 GB)
>>                            Array Size : 8790827520 (4191.79 GiB
>>         4500.90 GB)
>>                         Used Dev Size : 2930275840 (1397.26 GiB
>>         1500.30 GB)
>>                           Data Offset : 272 sectors
>>                          Super Offset : 8 sectors
>>                                 State : clean
>>                           Device UUID :
>>         97877935:04c16c5f:0746cb98:____63bffb4c
>>
>>
>>                           Update Time : Sat Apr  6 11:46:03 2013
>>                              Checksum : b585717a - correct
>>                                Events : 512993
>>
>>                                Layout : left-symmetric
>>                            Chunk Size : 256K
>>
>>                          Device Role : Active device 1
>>                          Array State : AA.A ('A' == active, '.' ==
>>         missing)
>>                      mdadm: No md superblock detected on /dev/sdf.
>>                      /dev/sde1:
>>                                 Magic : a92b4efc
>>                               Version : 1.2
>>                           Feature Map : 0x0
>>                            Array UUID :
>>         2becc012:2d317133:2447784c:____1aab300d
>>
>>                                  Name : riley:data01  (local to host
>>         riley)
>>                         Creation Time : Tue Apr 27 18:03:37 2010
>>                            Raid Level : raid5
>>                          Raid Devices : 4
>>
>>                        Avail Dev Size : 2930275847 (1397.26 GiB
>>         1500.30 GB)
>>                            Array Size : 8790827520 (4191.79 GiB
>>         4500.90 GB)
>>                         Used Dev Size : 2930275840 (1397.26 GiB
>>         1500.30 GB)
>>                           Data Offset : 776 sectors
>>                          Super Offset : 8 sectors
>>                                 State : clean
>>                           Device UUID :
>>         3f48d5a8:e3ee47a1:23c8b895:____addd3dd0
>>
>>
>>                           Update Time : Sat Apr  6 11:46:03 2013
>>                              Checksum : eaec006b - correct
>>                                Events : 512993
>>
>>                                Layout : left-symmetric
>>                            Chunk Size : 256K
>>
>>                          Device Role : Active device 3
>>                          Array State : AA.A ('A' == active, '.' ==
>>         missing)
>>                      mdadm: No md superblock detected on /dev/sde.
>>                      /dev/sdd1:
>>                                 Magic : a92b4efc
>>                               Version : 1.2
>>                           Feature Map : 0x0
>>                            Array UUID :
>>         2becc012:2d317133:2447784c:____1aab300d
>>
>>                                  Name : riley:data01  (local to host
>>         riley)
>>                         Creation Time : Tue Apr 27 18:03:37 2010
>>                            Raid Level : raid5
>>                          Raid Devices : 4
>>
>>                        Avail Dev Size : 2930276351 (1397.26 GiB
>>         1500.30 GB)
>>                            Array Size : 8790827520 (4191.79 GiB
>>         4500.90 GB)
>>                         Used Dev Size : 2930275840 (1397.26 GiB
>>         1500.30 GB)
>>                           Data Offset : 272 sectors
>>                          Super Offset : 8 sectors
>>                                 State : clean
>>                           Device UUID :
>>         236f6c48:2a1bcf6b:a7d7d861:____53950637
>>
>>
>>                           Update Time : Sat Apr  6 11:46:03 2013
>>                              Checksum : 87f31abb - correct
>>                                Events : 512993
>>
>>                                Layout : left-symmetric
>>                            Chunk Size : 256K
>>
>>                          Device Role : Active device 0
>>                          Array State : AA.A ('A' == active, '.' ==
>>         missing)
>>                      mdadm: No md superblock detected on /dev/sdd.
>>                      /dev/sdc1:
>>                                 Magic : a92b4efc
>>                               Version : 1.2
>>                           Feature Map : 0x0
>>                            Array UUID :
>>         2becc012:2d317133:2447784c:____1aab300d
>>
>>                                  Name : riley:data01  (local to host
>>         riley)
>>                         Creation Time : Tue Apr 27 18:03:37 2010
>>                            Raid Level : raid5
>>                          Raid Devices : 4
>>
>>                        Avail Dev Size : 2930276351 (1397.26 GiB
>>         1500.30 GB)
>>                            Array Size : 8790827520 (4191.79 GiB
>>         4500.90 GB)
>>                         Used Dev Size : 2930275840 (1397.26 GiB
>>         1500.30 GB)
>>                           Data Offset : 272 sectors
>>                          Super Offset : 8 sectors
>>                                 State : active
>>                           Device UUID :
>>         3ce8e262:ad864aee:9055af9b:____6cbfd47f
>>
>>
>>                           Update Time : Sat Mar 16 20:20:47 2013
>>                              Checksum : a7686a57 - correct
>>                                Events : 180132
>>
>>                                Layout : left-symmetric
>>                            Chunk Size : 256K
>>
>>                          Device Role : Active device 2
>>                          Array State : AAAA ('A' == active, '.' ==
>>         missing)
>>                      mdadm: No md superblock detected on /dev/sdc.
>>
>>
>>                      Before I assembled the array for the first time
>>         (mdadm -A
>>                 /dev/md101
>>                      /dev/sdd1 /dev/sde1 /dev/sdf1), this is how it
>>         looked like:
>>                      So identical to the above, wtih the exception of
>>         the number
>>                 of events.
>>
>>                      riley tmp # mdadm --examine /dev/sde1
>>                      /dev/sde1:
>>                                 Magic : a92b4efc
>>                               Version : 1.2
>>                           Feature Map : 0x0
>>                            Array UUID :
>>         2becc012:2d317133:2447784c:____1aab300d
>>
>>                                  Name : riley:data01  (local to host
>>         riley)
>>                         Creation Time : Tue Apr 27 18:03:37 2010
>>                            Raid Level : raid5
>>                          Raid Devices : 4
>>
>>                        Avail Dev Size : 2930275847 (1397.26 GiB
>>         1500.30 GB)
>>                            Array Size : 8790827520 (4191.79 GiB
>>         4500.90 GB)
>>                         Used Dev Size : 2930275840 (1397.26 GiB
>>         1500.30 GB)
>>                           Data Offset : 776 sectors
>>                          Super Offset : 8 sectors
>>                                 State : clean
>>                           Device UUID :
>>         3f48d5a8:e3ee47a1:23c8b895:____addd3dd0
>>
>>
>>                           Update Time : Sat Apr  6 09:44:30 2013
>>                              Checksum : eaebe3ea - correct
>>                                Events : 512989
>>
>>                                Layout : left-symmetric
>>                            Chunk Size : 256K
>>
>>                          Device Role : Active device 3
>>                          Array State : AA.A ('A' == active, '.' ==
>>         missing)
>>
>>                      --
>>                      To unsubscribe from this list: send the line
>>         "unsubscribe
>>                 linux-raid" in
>>                      the body of a message to
>>         majordomo@vger.kernel.org <mailto:majordomo@vger.kernel.org>
>>                 <mailto:majordomo@vger.kernel.org
>>         <mailto:majordomo@vger.kernel.org>>
>>                      <mailto:majordomo@vger.kernel.
>>         <mailto:majordomo@vger.kernel.>__org
>>
>>                 <mailto:majordomo@vger.kernel.org
>>
>>         <mailto:majordomo@vger.kernel.org>>>
>>                      More majordomo info at
>>         http://vger.kernel.org/____majordomo-info.html
>>                 <http://vger.kernel.org/__majordomo-info.html>
>>                      <http://vger.kernel.org/__majordomo-info.html
>>                 <http://vger.kernel.org/majordomo-info.html>>
>>
>>
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
