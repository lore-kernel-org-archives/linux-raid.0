From: NeilBrown <neilb@suse.de>
Subject: Re: How to identify a failed md array
Date: Mon, 2 Jun 2014 08:54:09 +1000
Message-ID: <20140602085409.3fff453f@notabene.brown>
References: <20140526200711.000030e2@localhost>
	<20140529151851.2508bdb6@notabene.brown>
	<20140601192339.000062d9@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=7bdA//GxjUg3FOIWcYJCuc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140601192339.000062d9@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/=7bdA//GxjUg3FOIWcYJCuc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 1 Jun 2014 19:23:39 +0200 Sebastian Herbszt <herbszt@gmx.de> wrote:

> NeilBrown wrote:
> >=20
> > On Mon, 26 May 2014 20:07:11 +0200 Sebastian Herbszt <herbszt@gmx.de> w=
rote:
> >=20
>=20
> [snip]
>=20
> > > How can I identify a failed array?
> > > array_state reports "clean", the last raid member stays "in_sync" and
> > > the value in degraded doesn't equal raid_disks.
> >=20
> > You know the array is "failed" when you get an IO error.
> >=20
> > When a RAID1 array gets down to just one drive remaining, it starts act=
ing
> > like it is just one drive.
> > How do you tell if is single plain ordinary drive is failed?  You get a=
n IO
> > error.  ditto with RAID1.
> >=20
> > NeilBrown
> >=20
>=20
> Since md knows the current state I hoped it would provide the required
> information for an application to distinguish between degraded and failed
> arrays. Any reason this is not the case?
> This would allow mdadm to not only report "DegradedArray" but also
> "FailedArray". Currently it does not generate any event when the last dri=
ve
> fails.
>=20

But md *doesn't* know the current state.

There is no state for "this device has failed".
There is only 'an IO request has failed' or 'this device has been removed'.

'an IO request has failed' does not necessarily mean that the device has
failed - sometimes that is a very important difference.

NeilBrown

--Sig_/=7bdA//GxjUg3FOIWcYJCuc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU4uvETnsnt1WYoG5AQIUxBAApaWQrCyCuOfybpx9YX2pJeQNelNGHCXs
CUs+cVOTRNYe92muHhfZvxz/C0b1ZfFiwn2xvgozlTC/VoAV/eFzX04jpMK2xe7Z
JZhl5Hu1NmNrEaYDMVRe7go7x1cU/wZdD4eOehjheJt8/F0VrxLY7sd9s9tNVYKS
Y016AV/AORzJY4Hi6egtPdC1Kip14hIV99QCbsZojr7Skgpq+xia8tWs6BYUldi3
DkH8hJnpjVU3YP0TlPRnU3VOgOcYrVDdYaeEkn9aQQl61nQvVCCyE7ouhlSw0Ho/
5V6wiAw64RlLh2qcrzJ097mlc9ZLf+uBgfU8wXQbLcsnguHr4bL0OwOeaVjpj+Sk
BghD3M9H+Y9A+FhO9FUMdvi4GpInUNPUblgkU/BxjFRP7dtwEQLZf7Q67zkVWOhR
tY5kLq2Xkehz7OEjyLGYebADbt+1W/lH0jfK7zZ6/nujrK7umsoqMFx114k/V2h5
6xprmUKDmo0/VK0JkYhdCVYYXXAxYPZjRXU3Q0tQdQtB6JjabdkfE7wHtF0kt39U
hbeZsPXkBFCi4eU+jtCLyYkkY0wlojvQOuGmO2oRhYbWvrQHRlbWCmjLsKdjqvtJ
xEmM8C3w5Dlx0Bc9mKavPJd7y+9FfveqhWQgTH1rDvOtYWwtRRrIp5uTAoNS5tLp
9nFRSa9XKV0=
=7U2s
-----END PGP SIGNATURE-----

--Sig_/=7bdA//GxjUg3FOIWcYJCuc--
