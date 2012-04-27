From: NeilBrown <neilb@suse.de>
Subject: Re: raid10 issues after reorder of boot drives.
Date: Sat, 28 Apr 2012 08:05:22 +1000
Message-ID: <20120428080522.637bc564@notabene.brown>
References: <4F9AFBC6.7070803@weboperative.com>
	<4F9B14FA.1090001@weboperative.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/srg5WlqDkAUpgRccGtHixdy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F9B14FA.1090001@weboperative.com>
Sender: linux-raid-owner@vger.kernel.org
To: likewhoa <likewhoa@weboperative.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/srg5WlqDkAUpgRccGtHixdy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Apr 2012 17:51:54 -0400 likewhoa <likewhoa@weboperative.com> wro=
te:


> adding more verbose info gives me:
>=20
> > -> mdadm -A --verbose /dev/md1
> mdadm: looking for devices for /dev/md1
> mdadm: /dev/dm-8 is not one of
> /dev/sdg3,/dev/sdf3,/dev/sde3,/dev/sdd3,/dev/sdb3,/dev/sda3,/dev/sdc3

You seem to have an explicit list of devices in /etc/mdadm.conf
This is not a good idea for 'sd' devices as they can change their names,
which can mean they aren't on the list any more.  You should remove that
once you get this all sorted out.

NeilBrown



--Sig_/srg5WlqDkAUpgRccGtHixdy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5sYIjnsnt1WYoG5AQIFWQ//T2f9DATs1Q7hGtw5DD5nml7JuvQ+d9Sj
rhKJ+E8XcJFYtUmYdhK4gYSvmm1WU4/XGwX3QJwHXpnQPEAJ+m8fxW1N78j+Unwd
pKmkzuIq+lBkhfEG16lziLlzKrjCn1W7laiILUYqEXk7qdR7gzwBKRpifyFrOqUv
C9ZxCNSKx6ZruPONKaL9eaWRBAmqh0yyW93ao2i+WoUjWn79O90quMpgEFj8SpcF
csxtqZBwiD6DSr7hYXjo9Ym5bJHHNDmDl8IJMUnKNNESlRou9QtEqdD1ZHCqcgNY
qMrpOI9wBIdhi/QShbXj+QXsU/J3VUWgbr1YOY1xVkYs3eyd7xUT4Zjh3PFq9H+I
UPXfCFUY9/TX8jvpuY6NsmgDvHADtVYx1t2ShfKPkpbu6kgJ7cz9+DnqUYuxnIyo
SBAEw4OxEDAWp+3tbawqAs8R1+ettVlxKeR9BTDAp+AwaqSAyIfqlqARuUIndqgS
Zv+4c9CYscu4ht3wDq8+NEZkkFBSb2CJtzgoSQMNggAkZ68n//cN8UHoMHzQd0fP
tJiiad89gsCc7VE4YD3R8DK6buxZ0wdATEhMEEeNQWcW3TyfOTGCslQLAGSVTaSI
AvsHVFAX9y8AClw+rEy1IueG7F0Rkcpq8d/wrVyXXOr9sWFp7ynr2yMFlNW7+fpC
nWAwyHyBixg=
=o51r
-----END PGP SIGNATURE-----

--Sig_/srg5WlqDkAUpgRccGtHixdy--
