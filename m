From: NeilBrown <neilb@suse.de>
Subject: Re: Can't reshape RAID1 to RAID5 due to chunk size
Date: Wed, 19 Sep 2012 16:20:58 +1000
Message-ID: <20120919162058.3101366d@notabene.brown>
References: <20120912105956.155f5d5e@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=ovNhNIRPAAoZ/oD8Djenky"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120912105956.155f5d5e@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/=ovNhNIRPAAoZ/oD8Djenky
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Sep 2012 10:59:56 +0600 Roman Mamedov <rm@romanrm.ru> wrote:

> Hello,
>=20
> # mdadm --detail /dev/md1=20
> /dev/md1:
>         Version : 1.2
>   Creation Time : Fri May 27 09:50:54 2011
>      Raid Level : raid1
>      Array Size : 488372863 (465.75 GiB 500.09 GB)
>   Used Dev Size : 488372863 (465.75 GiB 500.09 GB)
>    Raid Devices : 2
>   Total Devices : 3
>     Persistence : Superblock is persistent
>=20
>   Intent Bitmap : Internal
>=20
>     Update Time : Wed Sep 12 10:54:33 2012
>           State : active=20
>  Active Devices : 2
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 1
>=20
>            Name : avdeb:1  (local to host avdeb)
>            UUID : e29a222d:e6245302:5ff3f834:ad471a01
>          Events : 26
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       82        0      active sync   /dev/sdf2
>        1       8       34        1      active sync   /dev/sdc2
>=20
>        2       8       50        -      spare   /dev/sdd2
>=20
> # mdadm --grow /dev/md1 --chunk=3D64K --level=3D5 --raid-devices=3D3
> mdadm: New chunk size does not divide component size
>=20
> -----
> Shouldn't mdadm be able to figure out a way to somehow proceed in this ca=
se? :)
> So what if it does not divide, I am increasing the array size by 33%, it
> has plenty of new space, why not leave a bit of it in the end of all devi=
ces so
> the chunk size does divide...
> Also I heard of cases (on #linux-raid IRC, I think) when people reshaped =
like
> this without specifying the chunk size explicitly, and ended up with some=
thing
> like a 4K chunk, which is certainly less than optimal.
>=20

Yes, there is room for improvement here.

The difficulty is that the RAID1 must be converted to a 2-device RAID5 befo=
re
devices can be added, and the RAID5 must have a chunk size that is a multip=
le
of 4K.
Your array cannot even manage 1K.

Newer versions of mdadm will create raid1 arrays to be a multiple of 64K (I
think) so this will be less of a problem.

What you need to do is:
  - make sure the filesystem in /dev/md1 doesn't use the last 3k (it probab=
ly=20
    uses a 4K block size, so cannot use that last bit
  - resize the array down to 488372860K  (mdadm -G /dev/md0 --size 48837286=
0)
  - convert to a 2-device RAID5 with a 4K chunk size:
      mdadm -G /dev/md1 -c 4K -l5 -n2
  - convert to a 3-device RAID5 with a 64K chunk size:
      mdadm -G /dev/md1 -c 64k -n3

NeilBrown

--Sig_/=ovNhNIRPAAoZ/oD8Djenky
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFlkSjnsnt1WYoG5AQIXahAAk+HI77E6x9m3e2Vjt7Qscy130MmiOQDE
SoRH1ltsrzU3ydu9Zv2gCLzJ6Ee6CdPb/QFb9NlxpthYvaXwYnYjKdoeXnrjaKEF
7vpJYFahz0BM0XV0bH4jyuBt70k+ut4yj4gCBnSK3d+u8kJZOo2lpVkdMy0CFADr
CSKT4jbwkoYvzMgJigTxWtGDtofzQFx+oaWizdz7nbxZxlUpyMSxdQRsz06g7bSH
WUUVNUo23Zaf+W+jw0ciwZ1cKJgEBwEn5Ia65fitHjvwO91sI6WvJGM0f7DG5aPH
tkDsD24R7diPCaixnLRTl0u3Zj74mo800nHJ58a0yTyQCOlH9EtUdwWcM2eoqRne
ZvP5FSW1daKXYcj2JwbdjV/RiVzxYk18yMlVLA94ohZlYYq6uqRyTl58sNYWG8YW
W0UPl3veSyrPj/91b0Vvd2cMf8naszscFkuJC5uaLA1XyeNJbvD/PcOhqtRIOcJd
LoK/P97Nw85fOzYmDw1+z1eN47k1A+uRHsXW9z5uyl1jmjR8RmfDO2jyZJJblUot
8e1icvSQ5oJpnrNoUwBubJdAYkHMEIUzn9lZK3QRzlc5S4PIgdtb3cXifWQHeyg+
sIEDavOvJ2zT3hsZ8DMjv9+qnHv6u6zu+FK6LBSOn3RpLAZ9Bb/3OPhS5EKSN9MC
VHP6/ZsRhg0=
=F6DW
-----END PGP SIGNATURE-----

--Sig_/=ovNhNIRPAAoZ/oD8Djenky--
