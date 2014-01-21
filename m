From: NeilBrown <neilb@suse.de>
Subject: Re: Disappointing performance: 5-disk RAID6, 3.11.6
Date: Wed, 22 Jan 2014 09:54:04 +1100
Message-ID: <20140122095404.25e63a06@notabene.brown>
References: <CAKuK5J34CvTwZ5S6uyBUdEft2SkwrycXvYfNvQATit8GbdZcuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tokKzDViF3+ymiLWtIKm/m3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKuK5J34CvTwZ5S6uyBUdEft2SkwrycXvYfNvQATit8GbdZcuw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/tokKzDViF3+ymiLWtIKm/m3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 21 Jan 2014 10:42:19 -0600 Jon Nelson
<jnelson-linux-raid@jamponi.net> wrote:

> I have a 5-disk RAID6 using (5) 320GB SATA drives.
> I rarely see even sequential I/O approaching that of a single drive's
> performance.
> Example: (Rarely!) I'll see an aggregate 250MB/s read or write, but
> that translates to 50MB/s read or write per-drive. I was hoping for
> more.

A 5 disk RAID6 has 3 data drives (in each stripe), so 250MB/s translates to
250/3 or 83MB/s per drive (skipping over parity data isn't faster than
reading it unless you have a very large chunk size, which brings other cost=
s).

What exactly where you hoping for?

If you run something like
  for i in a b c d e
  do dd if=3D/dev/sd${i}3 of=3D/dev/null bs=3D1M count=3D100 &
  done
while system is otherwise idle, what throughput does each dd report?

NeilBrown


>=20
> The partition layout looks like this:
>=20
> /dev/sda1 : start=3D     2048, size=3D  1024000, Id=3D83, bootable
> /dev/sda2 : start=3D  1026048, size=3D  1024000, Id=3D82
> /dev/sda3 : start=3D  2050048, size=3D623091712, Id=3Dfd
> /dev/sda4 : start=3D        0, size=3D        0, Id=3D 0
>=20
> on all 5 disks, and sd{whatever}3 is used to assemble the raid,
> specifically, /dev/md2.
>=20
> mdadm -D /dev/md2:
>=20
> /dev/md2:
>         Version : 1.2
>   Creation Time : Fri Nov  1 11:13:07 2013
>      Raid Level : raid6
>      Array Size : 934242816 (890.96 GiB 956.66 GB)
>   Used Dev Size : 311414272 (296.99 GiB 318.89 GB)
>    Raid Devices : 5
>   Total Devices : 5
>     Persistence : Superblock is persistent
>=20
>   Intent Bitmap : Internal
>=20
>     Update Time : Tue Jan 21 10:33:52 2014
>           State : active
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>            Name : turnip:2  (local to host turnip)
>            UUID : bece804d:eaaeb280:38d2d7f3:1e493146
>          Events : 21788
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       51        0      active sync   /dev/sdd3
>        1       8       35        1      active sync   /dev/sdc3
>        2       8        3        2      active sync   /dev/sda3
>        3       8       19        3      active sync   /dev/sdb3
>        4       8       67        4      active sync   /dev/sde3
>=20
> The filesystem is ext4, and debugfs says:
>=20
> RAID stride:              16
> RAID stripe width:        48
>=20
>=20
> The processor is an AMD Phenom 9150e (quad-core, x86_64) and the O/S
> is openSUSE 13.1, kernel 3.11.6. Some of the hardware looks like this:
>=20
> 00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] RS780 Host Bridge
> 00:01.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] RS780/RS880 PCI
> to PCI bridge (int gfx)
> 00:07.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] RS780/RS880 PCI
> to PCI bridge (PCIE port 3)
> 00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI]
> SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode]
>=20
>=20
> Settings:
> The stripe_cache_size is 4096 (see
> http://blog.jamponi.net/2013/12/sw-raid6-performance-influenced-by.html
> )
> readahead is 16384
> scheduler is deadline
> queue depth per-drive is 1.
> nr_requests is 256.
>=20
> Does this seem out of line? Thoughts?
>=20


--Sig_/tokKzDViF3+ymiLWtIKm/m3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUt76jDnsnt1WYoG5AQLQLRAAr0RAwzBwabBhfgtDWmzH6uw6Eqlq771t
RAQCnAtYA3dqNLGp22F+uDebCURBWaTUfKcj9G4c9bsFzXLqP5sn4G5C8xIUYmO+
p2Agc+CCbwgEHZt3d3Gw8u7DDI9gknPjRUIojkmsXT8JWav6j/BeSfjFr+d8QLPY
au+RJclFFll7KSWZptbBTCEo8qvldRO1J+ZvTTG8C6b7oUAbBO8j2/RnHru9pWeE
sUCkopHySJykYuA3DTEpr626W3+ktCVnFSaJHHQONVNpE3LhLiRSbcKu7SUQn4gM
pr12WNwG2npP/1dRIDgKIWXaitSAOt5mGXaanPDHgOQNOVD9rRKFakKkTZqXzBdi
twRaIt+5wY2XVXKNISOU2bRHVXyWGXUNGleQOzlU7sLf4d6eQ9Hr65y/xHGuwKWA
NIVroFFHe88v+m6iAzIPsEd0FuQgxH+sj96dQQJ/TkDl8GN4Zvz+lrYy7a+prJKv
vH/bSIqzyzuijPKPgiJ8xOVeFyvkppC/Io7u4mm2iRitXWLu+BH3tKFTUrStg/br
kyiWkMmEk1Y0jyEGB4ZOpWWKUgB8CKGffNSPwc/W7FXczX9BqilFHI45aQLXZBWB
rSoooGcdaa7+TFOwKXfKj1SvnOZnP80fjndzOFBQ49ZmGSbL0wVAMcUQOsbjJUDK
bYmh+8ASzv4=
=8uzw
-----END PGP SIGNATURE-----

--Sig_/tokKzDViF3+ymiLWtIKm/m3--
