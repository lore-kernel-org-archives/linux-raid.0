From: Tim Bostrom <tbostrom@gmail.com>
Subject: Re: blkid and partition problem
Date: Fri, 21 May 2010 19:31:50 -0700
Message-ID: <AANLkTilu5tG3GwgyZY8Cqo7VpNRlFOT3YZUIMx77lZX8@mail.gmail.com>
References: <AANLkTilFZtEDC9au165SQSsj7U1B2f_XOA4kY_4hbE0j@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTilFZtEDC9au165SQSsj7U1B2f_XOA4kY_4hbE0j@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Some more RAID specific info:

/dev/md2:
        Version : 0.90
  Creation Time : Thu Apr 22 09:46:10 2010
     Raid Level : raid5
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
   Raid Devices : 4
  Total Devices : 2
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Mon May 17 03:03:01 2010
          State : active, degraded, Not Started
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : f911d5fb:8cf20015:ab2fedca:3ef56cfb (local to host
teraserver.teambostrom.com)
         Events : 0.7473

    Number   Major   Minor   RaidDevice State
       0       8      161        0      active sync   /dev/sdk1
       1       0        0        1      removed
       2       0        0        2      removed
       3       8      145        3      active sync   /dev/sdj1



[Fri May 21-19:31:10] [root@teraserver tbostrom]# mdadm -E /dev/sdm
/dev/sdm:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : db34c204:6c5a7156:28d0d689:13f396a5
           Name : 0
  Creation Time : Mon Feb 16 17:06:30 2009
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953525032 (931.51 GiB 1000.20 GB)
     Array Size : 5860574592 (2794.54 GiB 3000.61 GB)
  Used Dev Size : 1953524864 (931.51 GiB 1000.20 GB)
    Data Offset : 136 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : f7446973:f8b8f899:45e53330:004e0ca7

    Update Time : Sat Feb 28 14:42:38 2009
       Checksum : e23f94ed - correct
         Events : 7

         Layout : left-symmetric
     Chunk Size : 32K

   Device Role : Active device 1
   Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)

[Fri May 21-19:31:37] [root@teraserver tbostrom]# mdadm -E /dev/sdj1
/dev/sdj1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : f911d5fb:8cf20015:ab2fedca:3ef56cfb (local to host
teraserver.teambostrom.com)
  Creation Time : Thu Apr 22 09:46:10 2010
     Raid Level : raid5
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 2930279808 (2794.53 GiB 3000.61 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 2

    Update Time : Mon May 17 03:03:01 2010
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 1
       Checksum : eb4f7c77 - correct
         Events : 7473

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8      145        3      active sync   /dev/sdj1

   0     0       8      161        0      active sync   /dev/sdk1
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       8      145        3      active sync   /dev/sdj1
   4     4       8      193        4      spare


-tim



On Fri, May 21, 2010 at 5:28 PM, Tim Bostrom <tbostrom@gmail.com> wrote=
:
> Looking for some help. =A0I'm trying to start my array but just notic=
ed
> that somehow my the UUID got assigned to my physical drive and not th=
e
> partition. =A0The partition doesn't show up in /dev/. =A0Drive sdm ha=
s a
> valid partition, but blkid is set on the physical disk.
>
> /dev/sdm is the drive causing issue. =A0The partition is there (see
> fdisk output below). =A0It contains data so I'd like to not have to
> completely wipe the drive. =A0Is there any option to fix this?
>
> blkid output (see /dev/sdm):
> ----------------------
> /dev/sda1: UUID=3D"dd8018e3-2939-4236-9a63-c36d6df9cf80" TYPE=3D"ext3=
"
> /dev/sda2: UUID=3D"287f5ab6-d463-43a2-a3b2-7bf789dd8744" TYPE=3D"ext3=
"
> /dev/sda3: UUID=3D"336a1681-af86-401d-946e-201ae37780fe" TYPE=3D"swap=
"
> /dev/sdb1: UUID=3D"cdaba8bd-8094-3c6a-ab2f-edca3ef56cfb" TYPE=3D"linu=
x_raid_member"
> /dev/sdc1: UUID=3D"cdaba8bd-8094-3c6a-ab2f-edca3ef56cfb" TYPE=3D"linu=
x_raid_member"
> /dev/sdd1: UUID=3D"cdaba8bd-8094-3c6a-ab2f-edca3ef56cfb" TYPE=3D"linu=
x_raid_member"
> /dev/sde1: UUID=3D"cdaba8bd-8094-3c6a-ab2f-edca3ef56cfb" TYPE=3D"linu=
x_raid_member"
> /dev/sdf1: UUID=3D"649526d8-828a-57b4-ab2f-edca3ef56cfb" TYPE=3D"linu=
x_raid_member"
> /dev/sdg1: UUID=3D"649526d8-828a-57b4-ab2f-edca3ef56cfb" TYPE=3D"linu=
x_raid_member"
> /dev/sdh: UUID=3D"7ea182f5-0c31-3e24-adba-30185bcf511e" LABEL=3D"1"
> TYPE=3D"linux_raid_member"
> /dev/sdi: UUID=3D"7ea182f5-0c31-3e24-adba-30185bcf511e" LABEL=3D"1"
> TYPE=3D"linux_raid_member"
> /dev/sdj1: UUID=3D"f911d5fb-8cf2-0015-ab2f-edca3ef56cfb" TYPE=3D"linu=
x_raid_member"
> /dev/sdk1: UUID=3D"f911d5fb-8cf2-0015-ab2f-edca3ef56cfb" TYPE=3D"linu=
x_raid_member"
> /dev/md0: LABEL=3D"teradata" UUID=3D"2e7624ad-f059-4e35-a18a-eb8ffa64=
5d54"
> TYPE=3D"ext3"
> /dev/sdm: UUID=3D"db34c204-6c5a-7156-28d0-d68913f396a5" LABEL=3D"0"
> TYPE=3D"linux_raid_member"
> /dev/md1: UUID=3D"eea5390f-8f24-4a82-b899-7924fb126a5b" TYPE=3D"ext3"
>
>
> fdisk -l /dev/sdm output:
> ------------------
> Disk /dev/sdm: 1000.2 GB, 1000204886016 bytes
> 255 heads, 63 sectors/track, 121601 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Disk identifier: 0x000f2387
>
> =A0 Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0Block=
s =A0 Id =A0System
> /dev/sdm1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0121601 =A0 9767600=
01 =A0 fd =A0Linux raid autodetect
>
>
> =A0ls -l /dev/sd*
> brw-rw---- 1 root disk 8, =A0 0 2010-05-21 16:32 /dev/sda
> brw-rw---- 1 root disk 8, =A0 1 2010-05-21 16:32 /dev/sda1
> brw-rw---- 1 root disk 8, =A0 2 2010-05-21 16:32 /dev/sda2
> brw-rw---- 1 root disk 8, =A0 3 2010-05-21 16:32 /dev/sda3
> brw-rw---- 1 root disk 8, =A016 2010-05-21 16:32 /dev/sdb
> brw-rw---- 1 root disk 8, =A017 2010-05-21 16:32 /dev/sdb1
> brw-rw---- 1 root disk 8, =A032 2010-05-21 16:32 /dev/sdc
> brw-rw---- 1 root disk 8, =A033 2010-05-21 16:32 /dev/sdc1
> brw-rw---- 1 root disk 8, =A048 2010-05-21 16:32 /dev/sdd
> brw-rw---- 1 root disk 8, =A049 2010-05-21 16:32 /dev/sdd1
> brw-rw---- 1 root disk 8, =A064 2010-05-21 16:32 /dev/sde
> brw-rw---- 1 root disk 8, =A065 2010-05-21 16:32 /dev/sde1
> brw-rw---- 1 root disk 8, =A080 2010-05-21 16:32 /dev/sdf
> brw-rw---- 1 root disk 8, =A081 2010-05-21 16:32 /dev/sdf1
> brw-rw---- 1 root disk 8, =A096 2010-05-21 16:32 /dev/sdg
> brw-rw---- 1 root disk 8, =A097 2010-05-21 16:32 /dev/sdg1
> brw-rw---- 1 root disk 8, 112 2010-05-21 16:32 /dev/sdh
> brw-rw---- 1 root disk 8, 128 2010-05-21 16:32 /dev/sdi
> brw-rw---- 1 root disk 8, 144 2010-05-21 16:32 /dev/sdj
> brw-rw---- 1 root disk 8, 145 2010-05-21 16:32 /dev/sdj1
> brw-rw---- 1 root disk 8, 160 2010-05-21 16:32 /dev/sdk
> brw-rw---- 1 root disk 8, 161 2010-05-21 16:32 /dev/sdk1
> brw-rw---- 1 root disk 8, 176 2010-05-21 16:32 /dev/sdl
> brw-rw---- 1 root disk 8, 192 2010-05-21 16:32 /dev/sdm
>
>
>
> Any help is greatly appreciated.
>
> -Tim
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
