From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Re-arranged Drives in MDADM?
Date: Thu, 28 Jan 2010 21:39:24 +0000
Message-ID: <20100128213924.GA1664@cthulhu.home.robinhill.me.uk>
References: <d80f793f1001281058g60228b6bo7fc001fcfedd4487@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d80f793f1001281058g60228b6bo7fc001fcfedd4487@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Jan 28, 2010 at 01:58:20PM -0500, Carlos Williams wrote:

> I new system was built today and I don't understand why the drives are
> out of order. I don't think it matters but I wanted to ask here. I am
> 100% sure I specified /dev/sdd2 to be my spare device but when I now
> check mdadm, it does not appear this way...
>=20
> [root@tuna ~]# mdadm --detail /dev/md0
> /dev/md0:
>         Version : 0.90
>   Creation Time : Thu Jan 28 06:59:49 2010
>      Raid Level : raid5
>      Array Size : 480391552 (458.14 GiB 491.92 GB)
>   Used Dev Size : 240195776 (229.07 GiB 245.96 GB)
>    Raid Devices : 3
>   Total Devices : 4
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>=20
>     Update Time : Thu Jan 28 13:50:40 2010
>           State : clean
>  Active Devices : 3
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 1
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>            UUID : c935f1cc:af72fc84:c89aa428:f91eeb1b
>          Events : 0.471
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8        2        0      active sync   /dev/sda2
>        1       8       18        1      active sync   /dev/sdb2
>        2       8       50        2      active sync   /dev/sdd2
>=20
>        3       8       34        -      spare   /dev/sdc2
>=20
>=20
> As you can see it has my /dev/sdc2 instead of /dev/sdd2 as my spare.
> The problem is the drives are physically labeled on the chasis and I
> was wondering why it did this and also can it be fixed. Can I move
> /dev/sdd2 from number '2' position to my spare and then move /dev/sdc2
> as an active member of the raid? The /dev/md0 is my entire / partition
> so anything that requires me stopping the RAID becomes a little
> difficult.
>=20
When you created the array, it would have started as a degraded array
(using sda2 and sdb2), with the other two as spares.  The array is then
recovered using one of the spare drives - I don't know whether there's
any way to specify which though (other than creating with just three,
and adding the fourth after the rebuild has finished).

If you really want the two swapped (not sure why - any failure will
cause this to change anyway), you can fail & remove sdd2, then re-add it
after the recovery to sdc2 has completed.  This won't stop the array
=66rom running, but does leave you at risk of total failure until the
rebuild completes.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAktiBAsACgkQShxCyD40xBKYwQCguRRXwn9Njh7CPoDV3eAct3oM
5GgAnjXxeaKUlO9a4yaiztOzwBmcU4nL
=Cnj7
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
