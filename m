From: Alex <mysqlstudent@gmail.com>
Subject: Re: Recovering failed array
Date: Thu, 22 Sep 2011 18:39:10 -0400
Message-ID: <CAB1R3sgywmhCxmcVf8CmRt=KMRz7L=QJnkzXLyaPfrgnXmDXwQ@mail.gmail.com>
References: <CAB1R3sirkfauftgvNN5Sz9_ZGFaHC7_jZUD5cyRrhfARue08TQ@mail.gmail.com>
	<4E7BAE1E.9020704@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7BAE1E.9020704@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

>> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] [li=
near]
>> md1 : inactive sda2[0] sdd2[4](S) sdb2[1]
>> =C2=A0 =C2=A0 =C2=A0 205820928 blocks super 1.1
>>
>> md0 : active raid1 sda1[0] sdd1[3] sdc1[2] sdb1[1]
>> =C2=A0 =C2=A0 =C2=A0 255988 blocks super 1.0 [4/4] [UUUU]
>>
>>
>> # mdadm --add /dev/md1 /dev/sdd2
>> mdadm: Cannot open /dev/sdd2: Device or resource busy
>>
>> # mdadm --run /dev/md1
>> mdadm: failed to run array /dev/md1: Input/output error
>>
>> I've tried "--assemble --scan" and it also provides an IO error.
>>
>> mdadm.conf:
>> # mdadm.conf written out by anaconda
>> MAILADDR root
>> AUTO +imsm +1.x -all
>> ARRAY /dev/md0 level=3Draid1 num-devices=3D4
>> UUID=3D9406b71d:8024a882:f17932f6:98d4df18
>> ARRAY /dev/md1 level=3Draid5 num-devices=3D4
>> UUID=3Df5bb8db9:85f66b43:32a8282a:fb664152
>
> Please show the output of "lsdrv" [1] and then "mdadm -D /dev/md[01]"=
, and also "mdadm -E /dev/sd[abcd][12]"
>
> (From within your rescue environment.) =C2=A0Some errors are likely, =
but get what you can.

Great, thanks for your offer to help. Great program you've written.
I've included the output here:

# mdadm -E /dev/sd[abcd][12]
http://pastebin.com/3JcBjiV6

# When I booted into the rescue CD again, it mounted md0 as md127
http://pastebin.com/yXnzzL6K

# lsdrv output (also included below)
http://pastebin.com/JkpgVNL4

The md1 array appeared as md125 and was inactive, so "mdadm -D" didn't
work. Here is how the arrays now appear. sdb2 should be part of md125,
not its own array, as it is below, obviously.

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md125 : inactive sda2[0](S) sdc2[4](S)
      137213952 blocks super 1.1

md126 : inactive sdb2[1](S)
      68606976 blocks super 1.1

md127 : active raid1 sda1[0] sdd1[3] sdc1[2] sdb1[1]
      255988 blocks super 1.0 [4/4] [UUUU]

unused devices: <none>

lsdrv output:

PCI [pata_amd] 00:07.1 IDE interface: Advanced Micro Devices [AMD]
AMD-8111 IDE (rev 03)
 =E2=94=9C=E2=94=80scsi 0:0:0:0 MATSHITA DVD-ROM SR-8178 {MATSHITADVD-R=
OM_SR-8178_}
 =E2=94=82  =E2=94=94=E2=94=80sr0: [11:0] (iso9660) 352.23m 'sysrcd-2.3=
=2E1'
 =E2=94=82     =E2=94=94=E2=94=80Mounted as /dev/sr0 @ /livemnt/boot
 =E2=94=94=E2=94=80scsi 1:x:x:x [Empty]
PCI [aic79xx] 02:0a.0 SCSI storage controller: Adaptec AIC-7902 U320 (r=
ev 10)
 =E2=94=94=E2=94=80scsi 2:x:x:x [Empty]
PCI [aic79xx] 02:0a.1 SCSI storage controller: Adaptec AIC-7902 U320 (r=
ev 10)
 =E2=94=9C=E2=94=80scsi 3:0:0:0 FUJITSU MAW3073NC {DAM9PA1001LL}
 =E2=94=82  =E2=94=94=E2=94=80sda: [8:0] Partitioned (dos) 68.49g
 =E2=94=82     =E2=94=9C=E2=94=80sda1: [8:1] MD raid1 (0/4) 250.00m md1=
27 clean in_sync
'dbserv.guardiandigital.com:0' {9406b71d-8024-a882-f179-32f698d4df18}
 =E2=94=82     =E2=94=82  =E2=94=94=E2=94=80md127: [9:127] (ext4) 249.9=
9m {a99a461a-ff72-4bc0-9ccc-095b8a26f5e2}
 =E2=94=82     =E2=94=9C=E2=94=80sda2: [8:2] MD raid5 (none/4) 65.43g m=
d125 inactive spare
'dbserv.guardiandigital.com:1' {f5bb8db9-85f6-6b43-32a8-282afb664152}
 =E2=94=82     =E2=94=82  =E2=94=94=E2=94=80md125: [9:125] Empty/Unknow=
n 0.00k
 =E2=94=82     =E2=94=94=E2=94=80sda3: [8:3] (swap) 2.82g {0c2eeeb1-fc3=
5-4e43-9432-21cb005f8e05}
 =E2=94=9C=E2=94=80scsi 3:0:1:0 FUJITSU MAW3073NC {DAM9PA1001L5}
 =E2=94=82  =E2=94=94=E2=94=80sdb: [8:16] Partitioned (dos) 68.49g
 =E2=94=82     =E2=94=9C=E2=94=80sdb1: [8:17] MD raid1 (1/4) 250.00m md=
127 clean in_sync
'dbserv.guardiandigital.com:0' {9406b71d-8024-a882-f179-32f698d4df18}
 =E2=94=82     =E2=94=9C=E2=94=80sdb2: [8:18] MD raid5 (none/4) 65.43g =
md126 inactive spare
'dbserv.guardiandigital.com:1' {f5bb8db9-85f6-6b43-32a8-282afb664152}
 =E2=94=82     =E2=94=82  =E2=94=94=E2=94=80md126: [9:126] Empty/Unknow=
n 0.00k
 =E2=94=82     =E2=94=94=E2=94=80sdb3: [8:19] (swap) 2.82g {e36083c8-59=
a1-437b-8f93-6c624a8b0b90}
 =E2=94=9C=E2=94=80scsi 3:0:2:0 FUJITSU MAW3073NC {DAM9PA1001LD}
 =E2=94=82  =E2=94=94=E2=94=80sdc: [8:32] Partitioned (dos) 68.49g
 =E2=94=82     =E2=94=9C=E2=94=80sdc1: [8:33] MD raid1 (2/4) 250.00m md=
127 clean in_sync
'dbserv.guardiandigital.com:0' {9406b71d-8024-a882-f179-32f698d4df18}
 =E2=94=82     =E2=94=9C=E2=94=80sdc2: [8:34] MD raid5 (none/4) 65.43g =
md125 inactive spare
'dbserv.guardiandigital.com:1' {f5bb8db9-85f6-6b43-32a8-282afb664152}
 =E2=94=82     =E2=94=94=E2=94=80sdc3: [8:35] (swap) 2.82g {fe4c0314-7e=
61-475e-9034-1b90b23e817a}
 =E2=94=94=E2=94=80scsi 3:0:3:0 FUJITSU MAW3073NC {DAM9PA1001LA}
    =E2=94=94=E2=94=80sdd: [8:48] Partitioned (dos) 68.49g
       =E2=94=9C=E2=94=80sdd1: [8:49] MD raid1 (3/4) 250.00m md127 clea=
n in_sync
'dbserv.guardiandigital.com:0' {9406b71d-8024-a882-f179-32f698d4df18}
       =E2=94=9C=E2=94=80sdd2: [8:50] MD raid5 (4) 65.43g inactive
'dbserv.guardiandigital.com:1' {f5bb8db9-85f6-6b43-32a8-282afb664152}
       =E2=94=94=E2=94=80sdd3: [8:51] (swap) 2.82g {deaf299e-e988-4581-=
aba0-d061aa36914a}
Other Block Devices
 =E2=94=9C=E2=94=80loop0: [7:0] (squashfs) 288.07m
 =E2=94=82  =E2=94=94=E2=94=80Mounted as /dev/loop0 @ /livemnt/squashfs
 =E2=94=9C=E2=94=80ram0: [1:0] Empty/Unknown 16.00m
 =E2=94=9C=E2=94=80ram1: [1:1] Empty/Unknown 16.00m
 =E2=94=9C=E2=94=80ram2: [1:2] Empty/Unknown 16.00m
 =E2=94=9C=E2=94=80ram3: [1:3] Empty/Unknown 16.00m
 =E2=94=9C=E2=94=80ram4: [1:4] Empty/Unknown 16.00m
 =E2=94=9C=E2=94=80ram5: [1:5] Empty/Unknown 16.00m
 =E2=94=9C=E2=94=80ram6: [1:6] Empty/Unknown 16.00m
 =E2=94=9C=E2=94=80ram7: [1:7] Empty/Unknown 16.00m
 =E2=94=9C=E2=94=80ram8: [1:8] Empty/Unknown 16.00m
 =E2=94=9C=E2=94=80ram9: [1:9] Empty/Unknown 16.00m
 =E2=94=9C=E2=94=80ram10: [1:10] Empty/Unknown 16.00m
 =E2=94=9C=E2=94=80ram11: [1:11] Empty/Unknown 16.00m
 =E2=94=9C=E2=94=80ram12: [1:12] Empty/Unknown 16.00m
 =E2=94=9C=E2=94=80ram13: [1:13] Empty/Unknown 16.00m
 =E2=94=9C=E2=94=80ram14: [1:14] Empty/Unknown 16.00m
 =E2=94=94=E2=94=80ram15: [1:15] Empty/Unknown 16.00m
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
