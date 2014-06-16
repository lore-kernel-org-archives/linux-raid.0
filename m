From: NeilBrown <neilb@suse.de>
Subject: Re: How to fix this superblock?
Date: Mon, 16 Jun 2014 11:48:29 +1000
Message-ID: <20140616114829.6e6b7fa6@notabene.brown>
References: <20140616105927.828a6765.psid@riverland.net.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6NHI1g=BNLZIggrnuH9a.Ym"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140616105927.828a6765.psid@riverland.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Pete <psid@riverland.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/6NHI1g=BNLZIggrnuH9a.Ym
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Jun 2014 10:59:27 +0930 Pete <psid@riverland.net.au> wrote:

> Hi all. Please excuse, newbie here, finding out how much I don't know
> about md.
>=20
> I have a RAID1 array which is running in degraded mode. When I try to
> re-add the device that used to be part of the array, I'm told that it's
> too small, though it used to be fine.
>=20
> /proc/mdstat:
>=20
> md1 : active raid1 sdc3[2]
>       2920305508 blocks super 1.0 [2/1] [_U]
>=20
> When I try to re-add the device that used to be part of the array, mdadm
> says it's not large enough:
>=20
> # mdadm --add /dev/md1 /dev/sdb3
> mdadm: /dev/sdb3 not large enough to join array
>=20
> The partition tables hadn't changed when this started. Since then I've
> re-partitioned sdb to make sdb3 a few GB bigger, but it's still not
> large enough.
>=20
> Looking at the working device's superblock, there's a heap of "failed"
> so I'm guessing that superblock has been damaged:
>=20
> # mdadm -E /dev/sdc3
>=20
> /dev/sdc3:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x0
>      Array UUID : 129ec25f:f07e292a:5bf0829d:19793e6c
>            Name : pioneer:1  (local to host pioneer)
>   Creation Time : Thu Nov 21 21:19:12 2013
>      Raid Level : raid1
>    Raid Devices : 2
>=20
>   Used Dev Size : 5841405976 (2785.40 GiB 2990.80 GB)
>      Array Size : 5840611016 (2785.02 GiB 2990.39 GB)
>       Used Size : 5840611016 (2785.02 GiB 2990.39 GB)
>    Super Offset : 5841406232 sectors
>           State : clean
>     Device UUID : 6bbc382c:244cf1ad:4fd61c87:4e40e592
>=20
>     Update Time : Fri Jun 13 17:05:57 2014
>        Checksum : 93cf5353 - correct
>          Events : 444384
>=20
>     Array Slot : 2 (failed, failed, 1, failed, failed, failed, failed,
> failed, failed, failed, failed, failed, failed, failed, failed, failed,
> failed, failed, failed, failed, failed, failed, failed, failed, failed,
> failed, failed, failed, failed, failed, failed, failed, failed, failed,
>  [snip]
> failed) Array State : _U 383 failed
>=20
>=20
> Could it be that whatever happened to the superblock on sdc3 is giving
> it an incorrect idea of the array size? Is that something I can fix?
>=20
> Would I be better off creating a new array on sdb3+missing and copying
> data to that? Then I would zero the superblock on sdc3 and hopefully
> add it to the new array.
>=20
> Would appreciate any help.

I suspect that upgrading to a newer mdadm would solve most of these problem=
s.
What are you running? (mdadm -V)
Try:

  cd /tmp
  git clone git://neil.brown.name/mdadm
  cd mdadm
  make
  ./mdadm ......

NeilBrown

--Sig_/6NHI1g=BNLZIggrnuH9a.Ym
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU55M7Tnsnt1WYoG5AQKg8g/8DVPViuLJPs78V6+Ra2O5Ywg9z5/HnVEr
/0WG2C7SS8/uLKrA8aBdhlyBGzMUTLRcZ2F933pUEWtvVBFzv7lJvJR2TPh1CDsg
+ORfexVILpagbyX59n4rlFeQfxsX+XycqN4Ji6I5mqVu2ldsxV1RWw4Q/eOFtRlv
5Uhmd5fupT/OqYKlhAwlxHIed3FdskH+BdqU9g+0bUv+cVPrOZ78R6XK+0UpcXPi
iPz65nvlatuFQM8neMAvYYh45icN2zVJ6FN0o2xE4n/TRQD/scnKs12JDgpUOPuQ
DcEeDiCrTuDu56enzqOCYdSmVmQz/3YcCH2FgW+atV5rWFudLFWSGbMBCcgp6vqd
qD0lc6vJ3uGlSmnNju6HvM/9zHSdHzUWRWEEIYg3gupdCIVKOXK/VACjTPksWkhe
ek6uDAaaDDqwU1q4pA2MUYJLsbR2pCiRhn/yLq2kQQqNSqBmXjxNUWZ4oHbBKRh7
QpBMdDPDlO//w9D6cBwspFa9sOrf00UXSgJzBPnDGrRdJhV7WvJASbVb+dZEPGRt
b+U0UU86mdpJy93A1axbIfjv1yaXoyBVOPiXnoCr3l81qgXpcKj/1mvBjEdb1G3i
5rIu7J1ooq1De/HruA0SMZij9+V8zeVzHxMFAZZdtag/QatsPi2FM45bvqSbWXf2
gpFUzXoo+L8=
=FiD9
-----END PGP SIGNATURE-----

--Sig_/6NHI1g=BNLZIggrnuH9a.Ym--
