From: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Subject: Re: mdadm: /dev/md0 has been started with 1 drive (out of 2).
Date: Fri, 8 Nov 2013 08:32:01 +0200
Message-ID: <985D2F3C-9E55-405E-AC95-FF7733599870@gmail.com>
References: <C8EFEBC6-4B43-4B71-AA3F-7DC69480220D@gmail.com> <5278C2A6.7060005@websitemanagers.com.au> <E9509E1D-C8FB-4496-ADD5-C6ACBEFC4007@gmail.com> <5278D84C.4040600@websitemanagers.com.au> <5E756798-9940-4EA9-821A-2A49F92E0B03@gmail.com> <5278E50E.90808@websitemanagers.com.au> <6BD059D7-DF6F-4185-B1F9-A564ECB3EFBE@gmail.com> <5279F64F.5000104@websitemanagers.com.au> <F53E1ABB-E13A-45EC-A27E-5917F54546A5@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F53E1ABB-E13A-45EC-A27E-5917F54546A5@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

so I've successfully rebuilt the array, added internal bitmap, haven't =
run any extensive i/o tests but I continued with copying of my data off=
 the old disks and I haven't really noticed a serious impact. This is a=
 first impression only, but so far so good.

Now that I have bitmap I deliberately repeated sleep/resume cycle exact=
ly as it was done the last time that led to array degradation and sure =
enough the system started up with a degraded array. in fact, it is way =
more messy this time because both devices were dynamically assigned new=
 /dev/sdx devices: before sleep they were /dev/sdc1 and /dev/sdd1, afte=
r resume they became /dev/sdd1 and /dev/sdb1.

So, I unmounted filesystem on the array, and stopped the array. Then re=
assembled it, and it looks to be in a good shape. However, I am wonderi=
ng if this is exactly due to the internal bitmap. Basically what surpri=
sed me was that the array was assembled and shown as in sync instantly.=
 Worth noting, I should say that before the laptop went to sleep there =
were no processes writing to the array disks -- I made sure -- so the d=
ata should be consistent on both drives, but as we know from my very fi=
rst message event count may be still different when upon resume from sl=
eep.

Anyway, here's how it looked in more specific terms

> % mount
> proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
> sys on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
> dev on /dev type devtmpfs (rw,nosuid,relatime,size=3D1551228k,nr_inod=
es=3D216877,mode=3D755)
> run on /run type tmpfs (rw,nosuid,nodev,relatime,mode=3D755)
> /dev/sda3 on / type ext3 (rw,relatime,data=3Dordered)
> devpts on /dev/pts type devpts (rw,relatime,mode=3D600,ptmxmode=3D000=
)
> shm on /dev/shm type tmpfs (rw,nosuid,nodev,relatime)
> binfmt on /proc/sys/fs/binfmt_misc type binfmt_misc (rw,relatime)
> tmpfs on /tmp type tmpfs (rw,nosuid,nodev,relatime)
> gvfs-fuse-daemon on /home/ilj/.gvfs type fuse.gvfs-fuse-daemon (rw,no=
suid,nodev,relatime,user_id=3D1000,group_id=3D1000)
> /dev/md0 on /mnt/RAIDVault type ext4 (rw,relatime,stripe=3D32,data=3D=
ordered)
> % cat /proc/mdstat=20
> Personalities : [raid1]=20
> md0 : active raid1 sdc1[2]
>      1953276736 blocks super 1.2 [2/1] [U_]
>      bitmap: 0/15 pages [0KB], 65536KB chunk
>=20
> unused devices: <none>
> % ls -lah /mnt/RAIDVault/
> ls: reading directory /mnt/RAIDVault/: Input/output error
> total 0
> % su
> Password:=20
> % umount /mnt/RAIDVault/
> % mdadm --stop --scan
> mdadm: stopped /dev/md0
> =85
> here I checked the logs, learned that the drives are now represented =
by different block device files
> =85
> % ls /dev/sd
> sda   sda1  sda2  sda3  sdb   sdb1  sdd   sdd1  sde  =20
> % mdadm --assemble --scan
> mdadm: /dev/md0 has been started with 2 drives.
> % cat /proc/mdstat=20
> Personalities : [raid1]=20
> md0 : active raid1 sdd1[2] sdb1[1]
>      1953276736 blocks super 1.2 [2/2] [UU]
>      bitmap: 0/15 pages [0KB], 65536KB chunk
>=20
> unused devices: <none>
> % mdadm --examine /dev/sdd1
> /dev/sdd1:
>          Magic : a92b4efc
>        Version : 1.2
>    Feature Map : 0x1
>     Array UUID : c4cf4a52:6daa94c8:6d88a2fa:8f604199
>           Name : sega:0  (local to host sega)
>  Creation Time : Fri Nov  1 16:24:18 2013
>     Raid Level : raid1
>   Raid Devices : 2
>=20
> Avail Dev Size : 3906553856 (1862.79 GiB 2000.16 GB)
>     Array Size : 1953276736 (1862.79 GiB 2000.16 GB)
>  Used Dev Size : 3906553472 (1862.79 GiB 2000.16 GB)
>    Data Offset : 262144 sectors
>   Super Offset : 8 sectors
>          State : clean
>    Device UUID : 827ed4c3:baf1ba90:d8f21e10:e524d383
>=20
> Internal Bitmap : 8 sectors from superblock
>    Update Time : Fri Nov  8 00:10:07 2013
>       Checksum : 18402838 - correct
>         Events : 56
>=20
>=20
>   Device Role : Active device 0
>   Array State : AA ('A' =3D=3D active, '.' =3D=3D missing)
> % mdadm --examine /dev/sdb1
> /dev/sdb1:
>          Magic : a92b4efc
>        Version : 1.2
>    Feature Map : 0x1
>     Array UUID : c4cf4a52:6daa94c8:6d88a2fa:8f604199
>           Name : sega:0  (local to host sega)
>  Creation Time : Fri Nov  1 16:24:18 2013
>     Raid Level : raid1
>   Raid Devices : 2
>=20
> Avail Dev Size : 3906553856 (1862.79 GiB 2000.16 GB)
>     Array Size : 1953276736 (1862.79 GiB 2000.16 GB)
>  Used Dev Size : 3906553472 (1862.79 GiB 2000.16 GB)
>    Data Offset : 262144 sectors
>   Super Offset : 8 sectors
>          State : clean
>    Device UUID : cea7f341:435cdefd:5f883265:a75c5080
>=20
> Internal Bitmap : 8 sectors from superblock
>    Update Time : Fri Nov  8 00:10:07 2013
>       Checksum : 55138955 - correct
>         Events : 56
>=20
>=20
>   Device Role : Active device 1
>   Array State : AA ('A' =3D=3D active, '.' =3D=3D missing)

My question is basically if I'm enjoying the benefits of having interna=
l bitmap or maybe I got lucky and this time event count was the same fo=
r both drives?

Ivan--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
