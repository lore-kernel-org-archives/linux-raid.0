From: NeilBrown <neilb@suse.de>
Subject: Re: md: raid5 resync corrects read errors on data block - is this
 correct?
Date: Wed, 12 Sep 2012 08:29:09 +1000
Message-ID: <20120912082909.33c8eec0@notabene.brown>
References: <CAGRgLy6Cqxyf2im+tG2JiaQFooLBBzT76hGpfTb47Cr_sFLr6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/18CA4lYxin4PQz.IFIqQn0E"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6Cqxyf2im+tG2JiaQFooLBBzT76hGpfTb47Cr_sFLr6g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/18CA4lYxin4PQz.IFIqQn0E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Sep 2012 22:10:01 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> I have been doing some investigation about resync on raid5, and I
> induced a repairable read error on a drive that contains a data block
> for a particular stripe_head. I saw that resync corrects the read
> error by recomputing the missing data block, rewriting it (twice) and
> then re-reading back.
>=20
> Then I dug into code and eventually saw that fetch_block():
>=20
> if ((s->uptodate =3D=3D disks - 1) &&
>     (s->failed && (disk_idx =3D=3D s->failed_num[0] ||
> 		   disk_idx =3D=3D s->failed_num[1]))) {
> 	/* have disk failed, and we're requested to fetch it;
> 	 * do compute it
> 	 */
>=20
> doesn't care whether disk_idx holds data or parity for this
> stripe_head. It only checks that stripe_head has enough redundancy to
> recompute the block.
>=20
> My question: is this behavior correct? I mean that if we are doing
> resync, it means that we are not sure that parity is correct (e.g.,
> after an unclean shutdown). But we still use this possibly-incorrect
> parity to recompute the missing data block. So is this a potential
> bug?
>

Maybe.
I guess that if bad-block recording is enabled, then recording a bad block
there would be the "right" thing to do.
However if bad-block recording is not enabled then there are two options:
 1/ kick the device from the array
 2/ re-write the failing block based on the parity block which might be
    incorrect, but very probably is correct.

I suspect that the second option (which is currently implemented) will cause
less data loss than the first.

So I think the current code is the best option (unless we want to add some
bad-block-recording support).

NeilBrown

--Sig_/18CA4lYxin4PQz.IFIqQn0E
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE+7NTnsnt1WYoG5AQLV0xAAk9pha6LnlcKoRb1rlnxHhIkTpRjANNb/
SDG9jwb+C21L03jjB06eoTjGCLnQSlFGxWPO09r2kXhPY8+/q5n30fU1P7MOyx6A
fojNAjrXxf/7+WqoFfWonqrrdpgWTdJquGSi4NArbhtv1HqIiBN6izMOaohO1C1J
q8RQdBrA+6YERDYQrJ/JP/1+GztmvS4OoJfGaVRA5MyXo4eFUqF0Ce9LeiO2lyUc
flSQZd4eBDPrhLn22ebfIG0zRT/+Q5I6nLbtLmU3A0eEETYz8Shp2esFosHvY7kf
pVRlhFgb7IWCY4ZUbZS9IEmRY3WqYoVKiOhVPIboraL+Pbgx72uOjJzFBmh5wd/0
QgTb70c1ieUGJ3VvOFfKrWf0V2Tyz8oljSFKIcMsb57JvtSSz+OyeWAlNAo01gPh
REz5ISoeHLdkTicgdKr7HIfrHyp5oxW7ulfVtX8+/MroH0PrU2UchxAcyVTIEtDI
wbjoW3mY5DDcasdOrumAVkCLZb93GBE26yPiGtu9KZNPg2nPohFbSpjnAzQjeJ9o
vNdirJtAXgRNuxLs0onTVWP9f8Dd/cJZ+JYY7UZEBtFygOSMSfM9SuesJhynHWpD
w2w/AXVjLlrWZF+mnjOoUrzZ1LJgnCEkTe8MC7Kz2uVsJJUqNH+x7Yzf2L8oZMHP
2Hxw7Ojra/s=
=a1Pw
-----END PGP SIGNATURE-----

--Sig_/18CA4lYxin4PQz.IFIqQn0E--
