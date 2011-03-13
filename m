From: Rory Jaffe <rsjaffe@gmail.com>
Subject: Re: RAID5 Shrinking array-size nearly killed the system
Date: Sun, 13 Mar 2011 06:56:08 +0000
Message-ID: <AANLkTi=ZtxFJDtYCP62BZDg5=QyM3873eNDXZqC2c_wu@mail.gmail.com>
References: <AANLkTimrq904HRZfx6RpPrVNd0EJ5AkUZtytY7TqcFYv@mail.gmail.com>
	<AANLkTikQ5_xm3+JKP8pR=oYO5xi6Qk1=VrSsiBkgtB6q@mail.gmail.com>
	<alpine.DEB.1.10.1103120655370.7942@uplift.swm.pp.se>
	<4D7B85EB.60505@turmel.org>
	<AANLkTik2qk2ep7fsQPjAesnjur-0AB-Xx7EeZ5YfeCSA@mail.gmail.com>
	<AANLkTikRdqZ4nAdLcUuYz17KeWb54ES_sNYzzW-u1R0x@mail.gmail.com>
	<4D7BB462.5030706@turmel.org>
	<AANLkTim+OwO5-w5Hhjdchp+Nj8k0zTLqqvRKfAzFgkWz@mail.gmail.com>
	<4D7BD323.3040205@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D7BD323.3040205@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> OK, so your new array size will be 5857612608 (1952537536 * 3) =3D=3D=
 5586GB
>
> You can use an initial resize2fs to 5.4T to speed things up, as you d=
on't really need to move items that are currently located between the 3=
=2E8T and 5.4T mark. =C2=A0Then use the exact "mdadm --grow /dev/md0 --=
array-size=3D5857612608" afterwards before you fsck it.
>
> If that passes, do the rest. =C2=A0The final resize2fs should be very=
 quick.
>
> Phil
>

One more glitch? I ran the following command, trying several different
locations for the backup file, all of which have plenty of space and
are not on the array.

sudo mdadm -G /dev/md/0_0 -n 4 --backup-file=3D/tmp/backmd

mdadm gives the message "mdadm: Need to backup 960K of critical
section.." and it immediately returns to the command prompt without
shrinking the array.

=46ollowing is the current array info

ubuntu@ubuntu:~/mdadm-3.2$ sudo mdadm -D /dev/md/0_0
/dev/md/0_0:
        Version : 0.90
  Creation Time : Thu Jan  6 06:13:08 2011
     Raid Level : raid5
     Array Size : 5857612608 (5586.25 GiB 5998.20 GB)
  Used Dev Size : 1952537536 (1862.08 GiB 1999.40 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 127
    Persistence : Superblock is persistent

    Update Time : Sun Mar 13 06:46:37 2011
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 7e946e9d:b6a3395c:b57e8a13:68af0467
         Events : 0.73

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       50        1      active sync   /dev/sdd2
       2       8       66        2      active sync   /dev/sde2
       3       8       82        3      active sync   /dev/sdf2
       4       8       98        4      active sync   /dev/sdg2
       5       8      114        5      active sync   /dev/sdh2
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
