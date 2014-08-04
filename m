From: NeilBrown <neilb@suse.de>
Subject: Re: Are we forced to use bad blocks list?
Date: Mon, 4 Aug 2014 11:38:59 +1000
Message-ID: <20140804113859.63b5ac90@notabene.brown>
References: <53DA5340.7080507@shiftmail.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/qYMhZ5s/3WLuYNpXZXk4QOi"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53DA5340.7080507@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ethan Wilson <ethan.wilson@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/qYMhZ5s/3WLuYNpXZXk4QOi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Jul 2014 16:31:28 +0200 Ethan Wilson <ethan.wilson@shiftmail.org>
wrote:

> Dear MD developers,
> it seems that with mdadm 3.3.1 , if an array has bad blocks disabled=20
> (e.g. "--update=3Dno-bbl"  was invoked) and we want to add a disk to that=
=20
> array, e.g. a spare, that one will be created by mdadm with BBL enabled=20
> during the --add operation.
>=20
> There is apparently no "--add --no-bbl" option in mdadm, so the BBL will=
=20
> result in being forcibly active for that disk, it seems to me.
>=20
> It is indeed possible to "--stop" the array and then "--assemble=20
> --update=3Dno-bbl" so to clear the BBL flag in all disks, but this=20
> requires stopping the array, which for a production system often is not=20
> possible, and not justified for just adding a spare.
>=20
> Can I add a "feature request" to have BBL optional, and/or to default=20
> BBL presence/absence so that it conforms to the presence/absence of BBLs=
=20
> in the other disks of the array which is already running?
>=20
> The same problem probably happens when mdadm monitor daemon moves spares=
=20
> among the spare-group: it should probably understand if the receiving=20
> array is configured for BBL or not, and add a spare of the same type.
>=20

Why don't you want bad-block-lists?

I'm not necessarily against having some why to avoid getting them
automatically ... possibly a 'policy' option in mdadm.conf.
But I'd like to make sure I understand all of your thinking first.

Thanks,
NeilBrown

--Sig_/qYMhZ5s/3WLuYNpXZXk4QOi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU97kMznsnt1WYoG5AQK0XxAAsH9bCLh8akvzTKcsknZDleEkc9uT+zU6
hojdHYBpqVH/FiCVfdHwzot1dOqoDRiMaSfoZoXMqwJRhxz8DnED1EqUL/J8/xkO
HMuf3BA0gYWWerbfAsAnZMOBC5MZY15qBrKfuGEZUYO/MTZWtGw+6JFOaeb8eRWF
N2oTtiHGup7TKfF84ylDS8aqdDPQHtbOrdArfKfm/B7ZVloh7iAGSfcISZ/5n0Er
aJy3zR76DjwxvwTDvH4nYde4/NDnmIeH2e0oUfkcBcm1UnMuEq1sYOGxBxSRan5f
rUR4XOkhCMNoT5RzGdUp6bQAuwz4GoyCl6J/MXcaRBNVgdYzVNtVMpkF2nj8Y0iM
PNxYEHoNAes03rVVrpAoaM/p2QcB9oRws7RpYbFu++t+S07rGsVqgrEZaLaxPBV2
sTjdUJzkDw/PS0N7+UvkIVlXDLlvKGI/j9WFEgasnWvZWjeQYoi4KXrfKAMBtk29
pUTOy0Snmoh4BXyNw7aOBiJS4yqtBM1oFoPTnCA2bJqfhAnU1+xs1TVmls8Epeee
NxhEJMZtxRl/WOhyChiity8WyZUB4hKycAM3KyvkRtUnD11TraYyotXMt8xBCOIO
70+s12sV/FycS5aWReKmG3p8Mpo3WutpiEg69e59bJuygldvfX702vDsCu8P/TLT
A5QG1LQG05g=
=25Kw
-----END PGP SIGNATURE-----

--Sig_/qYMhZ5s/3WLuYNpXZXk4QOi--
