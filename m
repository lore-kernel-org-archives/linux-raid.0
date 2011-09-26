From: NeilBrown <neilb@suse.de>
Subject: Re: examining the layout of an existing raid device?
Date: Mon, 26 Sep 2011 20:32:48 +1000
Message-ID: <20110926203248.7ff8303f@notabene.brown>
References: <20110926101824.GA30509@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8rQUbjefB0mwvxJHG2lVHV2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110926101824.GA30509@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/8rQUbjefB0mwvxJHG2lVHV2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Sep 2011 06:18:24 -0400 Christoph Hellwig <hch@infradead.org>
wrote:

> Maybe I'm just stupid, but is there a way to figure out the exact
> geometry (e.g. pretty print of the superblock) for an existing array
> somehow?  I couldn't find anything in the mdadm man page for it.

mdadm -E /dev/sda

will print the metadata on device /dev/sda which describes the array that it
is a member of.

mdadm -D /dev/md0

will print the geometry of the array /dev/md0

Is that what you wanted?

NeilBeown


--Sig_/8rQUbjefB0mwvxJHG2lVHV2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOgFTQG5fc6gV+Wb0RAu20AJ9RYNW64HF7i2NidaosE+sadllmsgCgzQAY
qcnlDAJzmHg1GRykAkQETKM=
=3fZD
-----END PGP SIGNATURE-----

--Sig_/8rQUbjefB0mwvxJHG2lVHV2--
