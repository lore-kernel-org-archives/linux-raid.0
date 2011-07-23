From: Matthew Tice <mjtice@gmail.com>
Subject: Re: Problems with raid after reboot.
Date: Fri, 22 Jul 2011 21:12:25 -0600
Message-ID: <CA+taBv-3OxS52vLgOJiruqAnnOh8nsKtTFsPa20X1DEODdVSYA@mail.gmail.com>
References: <CA+taBv-V7HasgHFFaLV+Ppbgv=b-6CvLLkGHh3oN+GAO0wFHxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+taBv-V7HasgHFFaLV+Ppbgv=b-6CvLLkGHh3oN+GAO0wFHxA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 20, 2011 at 3:24 PM, Matthew Tice <mjtice@gmail.com> wrote:
> Hello,
>
> I had to shutdown my machine for moving - when I powered it back up m=
y
> raid-5 array is in a bad state:
>
> # mdadm -A -s
> mdadm: no devices found for /dev/md0
> mdadm: /dev/md/0 assembled from 2 drives - not enough to start the ar=
ray.
>
> I ended up forcing the assembly:
>
> # mdadm -A -s -f
> mdadm: no devices found for /dev/md0
> mdadm: forcing event count in /dev/sde(1) from 177 upto 181
> mdadm: clearing FAULTY flag for device 1 in /dev/md/0 for /dev/sde
> mdadm: /dev/md/0 has been started with 3 drives (out of 4).
>
> Looking at the detailed output the missing disk (/dev/sdc) is "remove=
d":
>
>
> # mdadm --detail /dev/md0
> /dev/md0:
> =A0 =A0 =A0 =A0Version : 00.90
> =A0Creation Time : Sat Mar 12 21:22:34 2011
> =A0 =A0 Raid Level : raid5
> =A0 =A0 Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
> =A0Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
> =A0 Raid Devices : 4
> =A0Total Devices : 3
> Preferred Minor : 0
> =A0 =A0Persistence : Superblock is persistent
>
> =A0 =A0Update Time : Tue Jul 19 20:44:45 2011
> =A0 =A0 =A0 =A0 =A0State : clean, degraded
> =A0Active Devices : 3
> Working Devices : 3
> =A0Failed Devices : 0
> =A0Spare Devices : 0
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 64K
>
> =A0 =A0 =A0 =A0 =A0 UUID : daf06d5a:b80528b1:2e29483d:f114274d (local=
 to host storage)
> =A0 =A0 =A0 =A0 Events : 0.181
>
> =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> =A0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 80 =A0 =A0 =A0 =A00 =A0 =A0 =A0=
active sync =A0 /dev/sdf
> =A0 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 64 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sde
> =A0 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 48 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdd
> =A0 =A0 =A0 3 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0removed
>
>
> I can examine the disk but I'm unable to add it (I don't recall if it
> needs to be removed first or not):
>
> # mdadm --examine /dev/sdc
> /dev/sdc:
> =A0 =A0 =A0 =A0 =A0Magic : a92b4efc
> =A0 =A0 =A0 =A0Version : 00.90.00
> =A0 =A0 =A0 =A0 =A0 UUID : daf06d5a:b80528b1:2e29483d:f114274d (local=
 to host storage)
> =A0Creation Time : Sat Mar 12 21:22:34 2011
> =A0 =A0 Raid Level : raid5
> =A0Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
> =A0 =A0 Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
> =A0 Raid Devices : 4
> =A0Total Devices : 3
> Preferred Minor : 0
>
> =A0 =A0Update Time : Tue Jul 19 20:44:45 2011
> =A0 =A0 =A0 =A0 =A0State : clean
> =A0Active Devices : 3
> Working Devices : 3
> =A0Failed Devices : 1
> =A0Spare Devices : 0
> =A0 =A0 =A0 Checksum : 22ac1229 - correct
> =A0 =A0 =A0 =A0 Events : 181
>
> =A0 =A0 =A0 =A0 Layout : left-symmetric
> =A0 =A0 Chunk Size : 64K
>
> =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
> this =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 32 =A0 =A0 =A0 =A03 =A0 =A0 =
=A0active sync =A0 /dev/sdc
>
> =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 80 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sdf
> =A0 1 =A0 =A0 1 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0faulty removed
> =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 48 =A0 =A0 =A0 =A02 =A0 =A0=
 =A0active sync =A0 /dev/sdd
> =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 32 =A0 =A0 =A0 =A03 =A0 =A0=
 =A0active sync =A0 /dev/sdc
>
> # mdadm --add /dev/md0 /dev/sdc
> mdadm: Cannot open /dev/sdc: Device or resource busy
>
> So a couple questions.
>
> 1. Any thoughts on what would cause this? =A0I seem to have bad luck
> with my raid arrays whenever I reboot.
> 2. How do I fix? =A0Everything *seems* to be as it should be . . .
>
> Here is the mdadm.conf:
>
> # cat /etc/mdadm/mdadm.conf =A0| grep -v ^#
>
> DEVICE partitions
> CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
> HOMEHOST <system>
> MAILADDR root
> ARRAY /dev/md0 level=3Draid5 num-devices=3D4
> UUID=3D11c1cdd8:60ec9a90:2e29483d:f114274d
>
> Any help is greatly appreciated.
>
> Matt
>

One thing I just noticed that seems kind of strange is that when I do
the --examine /dev/sdc it shows the drive in the list and another is
listed as faulty?  Am I reading that right?


# mdadm --examine /dev/sdc
/dev/sdc:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : daf06d5a:b80528b1:2e29483d:f114274d (local to host st=
orage)
  Creation Time : Sat Mar 12 21:22:34 2011
     Raid Level : raid5
  Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
     Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Tue Jul 19 20:44:45 2011
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 22ac1229 - correct
         Events : 181

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       32        3      active sync   /dev/sdc

   0     0       8       80        0      active sync   /dev/sdf
   1     1       0        0        1      faulty removed
   2     2       8       48        2      active sync   /dev/sdd
   3     3       8       32        3      active sync   /dev/sdc
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
