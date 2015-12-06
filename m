From: Phil Turmel <philip@turmel.org>
Subject: Re: Unable to (un)-grow raid6
Date: Sun, 6 Dec 2015 15:35:16 -0500
Message-ID: <56649C04.9000601@turmel.org>
References: <4E26C335-DEDB-489E-B54E-A285273569A1@alkaline-solutions.com>
 <465BF0F5-B5C7-4C02-8EB5-552B959B8D29@alkaline-solutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <465BF0F5-B5C7-4C02-8EB5-552B959B8D29@alkaline-solutions.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Waite <david@alkaline-solutions.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/05/2015 10:04 PM, David Waite wrote:
> I=E2=80=99m having difficulty shrinking down a RAID6 array (md2) on a=
 Sinology NAS. I wish to go from 13 drives to 11, and believe I need to=
 go to 12 first to maintain operation and redundancy through the resizi=
ng process.

No, you can go straight to 11 if you've set array-size properly.  --gro=
w
operations maintain redundancy throughout.

> The -array-size has already been shrunk to account for the two drives=
 I wish to remove, and one of the devices has been removed and the mach=
ine restarted before the command output below was generated.

You might need to set array-size again.  It is a temporary setting that
only becomes permanent when --grow successfully starts.

> # cat /proc/mdstat=20
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [ra=
id4]=20
> md2 : active raid6 sda3[0] sdia3[14] sdib3[9] sdic3[10] sdid3[11] sdi=
e3[12] sdg3[17] sdf3[5] sde3[16] sdd3[3] sdc3[13] sdb3[15]
>       26329895935 blocks super 1.2 level 6, 64k chunk, algorithm 2 [1=
3/12] [UUUUUUU_UUUUU]
>      =20
> md1 : active raid1 sda2[0] sdb2[1] sdc2[2] sdd2[3] sde2[4] sdf2[5] sd=
g2[6]
>       2097088 blocks [8/7] [UUUUUUU_]
>      =20
> md0 : active raid1 sda1[0] sdb1[1] sdc1[2] sdd1[3] sde1[4] sdf1[5] sd=
g1[6]
>       2490176 blocks [8/7] [UUUUUUU_]
>      =20
> unused devices: <none>


> When running=20
> # mdadm --grow -n 12 /dev/md2 --backup-file=3D/mnt/backup-file3
> mdadm: max_devs [384] of [/dev/md2]
> mdadm: Need to backup 7040K of critical section..
> mdadm: Cannot set device shape for /dev/md2: Invalid argument
>=20
> ---
>=20
> dmesg just reports:
> [87908.606245] md: couldn't update array info. -22

Error code 22 is "Invalid Argument", corresponding to the mdadm output.

Try setting array size again, then try again.  Feel free to go straight
to 11 devices -- it'll save you much time.

Also, for completeness, show --detail and --examine for the array and i=
t
members.

Phil

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
