From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID5 check does not read disk media
Date: Wed, 4 Apr 2012 14:51:52 +0100
Message-ID: <CADNH=7HbC4M0obMV=nGNVWcH3vJT+nug725om+K7ocvk8=bPxw@mail.gmail.com>
References: <4F7C4B46.2090209@urbanec.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F7C4B46.2090209@urbanec.net>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Urbanec <linux-raid@urbanec.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4 April 2012 14:23, Peter Urbanec <linux-raid@urbanec.net> wrote:
> I'm running Gentoo kernel 3.3.0 with raid5 on four ICH7 AHCI connecte=
d
> Seagate 2TB 7200RPM disks. I also have two WD 1TB Green disks in raid=
1 on a
> Sil3114 with a JBOD (non-RAID) BIOS.
>
> When I attempt to do a scrub/check on the raid5, the check seems to p=
roceed
> without actually reading any data from the disks - the disk activity =
lights
> do not even flicker.
>
> Looking at the speed at which the check completes confirms this:
>
> # cat /proc/sys/dev/raid/speed_limit_min
> 10000
> # cat /proc/sys/dev/raid/speed_limit_max
> 4000000
> # echo check > devices/virtual/block/md0/md/sync_action
> # echo check > devices/virtual/block/md127/md/sync_action
> ...
> # cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [ra=
id4]
> md127 : active raid1 sdf1[1] sde1[0]
> =C2=A0 =C2=A0 =C2=A0976760384 blocks [2/2] [UU]
> =C2=A0 =C2=A0 =C2=A0[>....................] =C2=A0check =3D =C2=A01.7=
% (17387072/976760384)
> finish=3D380.7min speed=3D41994K/sec
>
> md0 : active raid5 sdb[1] sda[0] sdd[4] sdc[2]
> =C2=A0 =C2=A0 =C2=A05860535808 blocks super 1.2 level 5, 512k chunk, =
algorithm 2 [4/4]
> [UUUU]
> =C2=A0 =C2=A0 =C2=A0[=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D>..] =C2=A0check =3D 93.9% (1835359616/1953511936)
> finish=3D0.8min speed=3D2332893K/sec
>
>
> raid1 runs at about 42MB/s as expected with two WD 1TB Green drives.
> raid5 runs at well over 2GB/s - not really possible with four Seagate=
 2TB
> 7200RPM drives.
>
> Any ideas on what may be going on there and how to fix it. Let me kno=
w
> what/if more information may be needed.
>
> Thanks
>
> =C2=A0 =C2=A0Peter Urbanec
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml

=46WIW I'm seeing this as well, kernel 3.3.1, but on RAID6. There's a
message just a few days about this, but no link to a patch.

Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
