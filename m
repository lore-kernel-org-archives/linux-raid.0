From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Creating RAID5 with four devices and end up with 5 (one
	removed and one spare). Why?
Date: Mon, 3 Mar 2008 09:19:52 +0000
Message-ID: <20080303091952.GA1125@cthulhu.home.robinhill.me.uk>
References: <47CBBD11.4020501@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47CBBD11.4020501@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Mar 03, 2008 at 09:55:45AM +0100, Tor Arne Vestb=F8 wrote:

> Hi!
>
> I'm trying to build a Linux RAID5 with four (4) 750GB disks, but not matt=
er=20
> what I do I end up with mdadm listing five (5) devices and telling me tha=
t=20
> one of them is a spare, and another one is failed/removed. I've been=20
> googling and reading HOWTOs for a week now, but can't figure it out. Here=
's=20
> what I do:
>
> monstre:~/buildroot # mdadm --create /dev/md0 --level=3D5 --raid-devices=
=3D4=20
> /dev/sd[cdef]1
>
> mdadm: array /dev/md0 started.
>
> monstre:~/buildroot # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active(auto-read-only) raid5 sdf1[4](S) sde1[2] sdd1[1] sdc1[0]
>       2197715712 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
>
> unused devices: <none>
>
>
> monstre: # mdadm --examine /dev/sdd1
> /dev/sdd1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : a0186556:4ffb5a2a:822f8875:94ae7d2c
>   Creation Time : Sun Mar  2 22:52:53 2008
>      Raid Level : raid5
>   Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
>      Array Size : 2197715712 (2095.91 GiB 2250.46 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 0
>
>     Update Time : Sun Mar  2 22:59:54 2008
>           State : clean
>  Active Devices : 3
> Working Devices : 4
>  Failed Devices : 1
>   Spare Devices : 1
>        Checksum : 6b5e8442 - correct
>          Events : 0.22
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>       Number   Major   Minor   RaidDevice State
> this     1       8       49        1      active sync   /dev/sdd1
>
>    0     0       8       33        0      active sync   /dev/sdc1
>    1     1       8       49        1      active sync   /dev/sdd1
>    2     2       8       65        2      active sync   /dev/sde1
>    3     3       0        0        3      faulty removed
>    4     4       8       81        4      spare   /dev/sdf1
>
> -------------------
>
> So what i don't get is:
>
> 1. Why is mdadm --examine listing "3     3       0        0        3  =20
> faulty removed" and telling me I have a failed device?
> 2. Why is one of the actual disks (sdf) used as a spare, even though I=20
> didn't ask for it?
>
> Thanks for any tips or insights which may put me on the right track :)
>
This is perfectly normal (and explained in the manual page) - the RAID5
array is created in an initially degraded state, then rebuilt.  This
means the array can be available for use immediately, with the rebuild
taking place in the background.  You'll need to run 'mdadm -w /dev/md0'
to force the array into read-write mode (it's currently started in
auto-read-only mode) and the resync will then begin.

HTH,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHy8K4ShxCyD40xBIRAsq5AJ9ktTunl62wSW/7g5mBxM0lLLnEzACfZqOX
16u1ll7/8wH4hPuc9+7D4BA=
=E9gr
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
