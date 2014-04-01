From: "nixbugz" <nixbugz@outlook.com>
Subject: Re: Can't grow IMSM RAID5
Date: Tue, 1 Apr 2014 18:34:07 +0100
Message-ID: <DUB113-DS32C3A824A4ED3C133290E0A9620@phx.gbl>
References: <DUB113-DS14AD0971A94EC90C73E3A6A9620@phx.gbl> <1396368503.172158.6.camel@djiang5-desk1.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed	reply-type=original
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1396368503.172158.6.camel@djiang5-desk1.amr.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Jiang, Dave" <dave.jiang@intel.com>
Cc: linux-raid@vger.kernel.org, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

-----Original Message-----=20
=46rom: Jiang, Dave
Sent: Tuesday, April 1, 2014 5:08 PM
To: nixbugz@outlook.com
Cc: linux-raid@vger.kernel.org ; Paszkiewicz, Artur
Subject: Re: Can't grow IMSM RAID5

On Tue, 2014-04-01 at 16:42 +0100, nixbugz wrote:
> Hello
>
> I=E2=80=99m stuck trying to add a 4th disc to an IMSM RAID5 container=
:
>
> # mdadm -a /dev/md127 /dev/sdb
> mdadm: added /dev/sdb
>
> # mdadm --grow --raid-devices=3D4
> /dev/md127 --backup-file=3D/mnt/spare/raid-backup-file
> mdadm: Cannot read superblock for /dev/md127

I think you need to grow the RAID volume and not the container? So it
would be /dev/md0 or /dev/md1 instead of /dev/md127? Here's URL to the
Linux IMSM user's manual that hopefully may be of use:
http://www.intel.com/support/chipsets/rste/sb/CS-033622.htm

>
> # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdd[2] sda[1] sdc[0]
>       1887436800 blocks super external:/md127/0 level 5, 128k chunk,
> algorithm 0 [3/3] [UUU]
>
> md1 : active (auto-read-only) raid5 sdc[2] sdd[1] sda[0]
>       66077696 blocks super external:/md127/1 level 5, 128k chunk,=20
> algorithm
> 0 [3/3] [UUU]
>
> md127 : inactive sdb[3](S) sda[2](S) sdc[1](S) sdd[0](S)
>       12612 blocks super external:imsm
>
> unused devices: <none>
>
> # mdadm =E2=80=93V
> mdadm - v3.3 - 3rd September 2013
>
>
> I don=E2=80=99t know if this is related but mdmon has trouble finding=
 the ports:
>
> # mdadm --detail-platform -v
> mdadm: checking metadata 0.90
> mdadm: 0.90 metadata is platform independent
> mdadm: checking metadata 1.x
> mdadm: 1.x metadata is platform independent
> mdadm: checking metadata ddf
> mdadm: ddf metadata is platform independent
> mdadm: checking metadata imsm
> mdmon: found Intel(R) SATA RAID controller at 0000:00:1f.2.
>        Platform : Intel(R) Matrix Storage Manager
>         Version : 11.6.0.1702
>     RAID Levels : raid0 raid1 raid10 raid5
>     Chunk Sizes : 4k 8k 16k 32k 64k 128k
>     2TB volumes : supported
>       2TB disks : supported
>       Max Disks : 6
>     Max Volumes : 2 per array, 4 per controller
> I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2 (SATA)
> mdmon: failed to determine port number for
> /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0
> mdmon: failed to enumerate ports on SATA controller at 0000:00:1f.2.
> mdadm: checking metadata mbr
> mdadm: mbr metadata is platform independent
> mdadm: checking metadata gpt
> mdadm: gpt metadata is platform independent
> #

Artur, any ideas why mdmon isn't happy in this instance?

> Thanks
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
N=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BDy=EF=BF=BD=EF=BF=BD=D8=B2X=EF=BF=BD=
=EF=BF=BDv=D8=96)=EF=BF=BD{n=C7=89=EF=BF=BD=EF=BF=BD{=EF=BF=BD=EF=BF=BD=
=EF=BF=BD{y=EF=BF=BD=CA=87=EF=BF=BD=EF=BF=BDj=07=EF=BF=BDf=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BDz=EF=BF=BD=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BDj:v=EF=BF=BD=EF=BF=BDwj=D8=B6=EF=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=
=BDzZ=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDj=EF=BF=BD=EF=BF=BD



Thanks for your quick response.  I wasn't sure whether to grow containe=
r or=20
volume but this from man mdadm decided it:

      Using  GROW  on containers is currently supported only for Intel'=
s=20
IMSM
      container format.   The  number  of  devices  in  a  container  c=
an=20
be
      increased  - which affects all arrays in the container ...

It gives the same message anyway when applied to the volume md0.

This extract from the Intel doc you linked to says the same (note that =
md0=20
is the container here :-)

    The example below adds a single disk to the RAID container and then=
=20
grows the
    volume(s). Because IMSM volumes inside a container must span the sa=
me
    number of disks, all volumes are expanded.
=2E..
        mdadm =E2=80=93a /dev/md0 /dev/sde
        mdadm =E2=80=93G /dev/md0 =E2=80=93n 4 --backup-file=3D/tmp/bac=
kup

Might it be something to do with what's already on the new drive?
This is an Intel DQ77MK motherboard.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
