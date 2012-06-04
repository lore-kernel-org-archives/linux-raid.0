From: NeilBrown <neilb@suse.de>
Subject: Re: How to use replacement?
Date: Mon, 4 Jun 2012 12:11:36 +1000
Message-ID: <20120604121136.0edfd95e@notabene.brown>
References: <201206040953190009422@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pKjujv7eId7_HjXBaSuspir"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201206040953190009422@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/pKjujv7eId7_HjXBaSuspir
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 4 Jun 2012 09:53:21 +0800 majianpeng <majianpeng@gmail.com> wrote:

> Hi:
> 	At present, md is supporting replacement.
> 	In function: state_store()
> >   } else if (cmd_match(buf, "replacement")) {
> >		/* Can only set a device as a replacement when array has not
> >		 * yet been started.  Once running, replacement is automatic
> >		 * from spares, or by assigning 'slot'.
> >		 */
> 		I can using spare disk.But how to use slot?

If you want to ensure that a particular device becomes a replacement for a
particular other device, then
  cd /sys/block/mdX/md
  echo frozen > sync_action
  echo NN:MM > new_dev  # where NN is major and MM is minor of new device
  echo want_replacement > rdSS/state  # where SS is slot number of device to
                          # replace
  echo SS > dev-YYY/slot  # where YYY is the kernel name of the newly added
                          # device
  echo idle > sync_action

should do it, but I haven't tested recently.

NeilBrown


> >		if (rdev->mddev->pers)
> >			err =3D -EBUSY;
> 	=09
>=20
>=20
> --------------
> majianpeng

--Sig_/pKjujv7eId7_HjXBaSuspir
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8wZWTnsnt1WYoG5AQLlvQ/+JTxdi6qooKNIJv62u6VIb8edkxeb0pMQ
U04Aqzrhnj7rHrrg8O5uRLqPTTTp0CiaOMXQbLFGC2XKh+UXkLZbdx6qo7ZenC63
eZ+Pi8HTEkk6tFjaoplrOcG3hOHV1CmEDbU8wDpUGaaRB8OwU87Y0gOJmUfvU/Y9
fMStrSeRFXp9hPm22OsRS8254xeumOEoG4R6vT7ye/wvK5nugz9WhraqjIE9Z1k5
6RifaYswrOgtt2G5i3Thd0xqf7A09nvU7D3NgNUxMGCAqujkTEi20yTj1oJJ+LhR
3iy87m/8HJCFY46Vvxbf6VF0196iF6OeNToTlbytWKNdzfnZMw5oFE7huYQzu583
o86kC0P1VjTud5pqaNFQS20QnWG9vCKBQcl/ouiKr7Ks/IxWlbZjMwhDuLWK8O7Q
43G8xT+IW/ecxPIDj965Sl31PvfQThvXEWopCntyxfvnAQfsebF9AsCxdeUbWBSz
aYGueg7auDU3IfLrs60MQFVS9wNLhHAnLIQsJFRgd8/XumDB+RyQ1W9uE5QjyVcB
KEhf31qxxsDbRmpMOJUuwWydjdvh6It4cNsA79ArvDN/qnltHZjkPtSJKPDV+na0
nfYeJGy6+TOT/7g1jneE3bZ6wcTlHHLxrOrDkZek9wdnbDveKnHutYVyUgfjdjhq
qbSxLN8XpQE=
=YF7Q
-----END PGP SIGNATURE-----

--Sig_/pKjujv7eId7_HjXBaSuspir--
