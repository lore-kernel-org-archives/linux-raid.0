From: NeilBrown <neilb@suse.de>
Subject: Re: raid5 missing disks during chunk size grow
Date: Tue, 23 Sep 2014 10:32:46 +1000
Message-ID: <20140923103246.7bd0acf6@notabene.brown>
References: <374D34B3-E7F5-48AD-9A22-23C76AA0A60F@senebald.de>
	<alpine.DEB.2.02.1409221342090.14735@uplift.swm.pp.se>
	<719BBDB5-4E57-49D9-AFA2-0552141D7C41@senebald.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/CDcnIWKiMj6MJuWC_yNidpy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <719BBDB5-4E57-49D9-AFA2-0552141D7C41@senebald.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Senebald <martin@senebald.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/CDcnIWKiMj6MJuWC_yNidpy
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Sep 2014 13:55:24 +0200 Martin Senebald <martin@senebald.de> wro=
te:

> Am 22.09.2014 um 13:44 schrieb Mikael Abrahamsson <swmike@swm.pp.se>:
>=20
> > On Mon, 22 Sep 2014, Martin Senebald wrote:
> >=20
> >> My idea was, first bringing back the disks in the array then continue =
the grow (using the backup file)
> >> add / re-add disk was not working, so i assumed recreate the array wit=
h =E2=80=94assume-clean would bring me closer.
> >=20
> > Was this an idea you had that you didn't do, or did you actually execut=
e on it?
>=20
> I did ..=20

oops. Though maybe I should say OOOPS.

Part of your array had one chunk size, part of the array had another.  By
using "create" you had to choose one chunk size or the other.  Obviously
neither is correct of the whole device.

You are now in a situation where you have made a mess and you need to someh=
ow
recover your data.  It is all there, but how patient and careful can you be?

By far the safest approach would be to find some other storage solution into
which you can restore all the data.  Then you can try to restore the data
there and see if it look OK.

There are three sections  to the data:

 1/ the early part of the array which has been reshaped to the new chunk si=
ze.
 2/ the part of the array which is stored in the backup file.
 3/ the late part of the array which has not been reshaped yet.


Depending on which chunksize you used when you created the array (and
assuming the the newly created array has the same data-offset as the old
array), then either '1' or '3' should be available directly in the newly
created array.  Calculating the exact start and size requires care.  I
suggest you try to work it out and I can check your calculations.

If you copy that out, then 'create' the array with the other chunk size you
should be able to copy the other large section.

Getting the data out of the backup file might require careful reading of a
hex dump of that file to read the 'superblock' to find out exactly what is
store there and  where.  It shouldn't be difficult but does need care.

If  you do go down this path, please feel free to ask for more specifics and
ask me to check your calculations.

For future reference "--assemble --force" is your friend.

NeilBrown

>=20
> >=20
> >> What would be the best way to tackle this problem?
> >=20
> > Send mdadm --examine from all 6 component drives to the list and let's =
take it from there.
>=20
> the current state of the disks:
>=20
> https://gist.github.com/daquan/94239614fc3b67789c9a#file-current-state
>=20
> the state before the =E2=80=94create=20
>=20
> https://gist.github.com/daquan/94239614fc3b67789c9a#file-before-create-as=
sume-clean
>=20
>=20
> > Under no circumstances do --create on the components.
>=20
> that sounds not so promising anymore :-/
>=20
> >=20
> > What kernel version and mdadm version do you have?
> >=20
> > --=20
> > Mikael Abrahamsson    email: swmike@swm.pp.se
> >=20
>=20
>=20
> BR Martin
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/CDcnIWKiMj6MJuWC_yNidpy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCC/rjnsnt1WYoG5AQKBYA//fOauZlhq1EOwgWci4W3Jxse3vlYYxyGF
orh41Vib3Id4nzESE80lTVcR/sB+31iqubRjZEgz5SWAnYUBEr6/7QY29vsb+UJx
Q1CYQ1wI5cZMrvqqjP9DSzqEzZrwBImGPCWDoxNvoC90cs0bFrNPhYwArqcN68QS
ylsp07ytSkWXJmFnleGWFpKNYBdyzYDo61nAqk1MKNVZPtq1QmCvZuu+968bTINB
NuFt9WjBuRQo52sUtlgCAi05nStcne/KP89YCb0sLkrT5rg+vk1grjgPs2PT3FK5
x6PT/I8mYJvnFua+fGEQN+V2na6eAvvuh5pv7AyWHd+asQ1/oxJ1S4rwDg2AFjHy
BiYJzHiDnDiD7RJBMX2hEjS0IeeC4tMBjV0+Fw8RHGms76QxZlNJCN5wX1qy8cCL
VRwPKczkL/aKMWv58PabipBr5HwHqG0hZUrq2GSw1VhgrieygzUp6dzUwT5k7vw+
PsF7mkmqF2NATO5RId8VWVHfJReJrjPNApFQSdRaispTYFbSByPm3zqS9tbR4W1Q
7SfhKX8RYbqZEnSpSNZgcp86yFBRnaHS/SNL1ygxJiUe+awg5SGDT+elsw1p4mn1
sk8mYoyZVb+xcf3ADfpxy4N60jgfeksEQwLSfqXmlvMCHLaEN1XQVpAk/+KSHzMP
FFV9gtk3wx0=
=rRy1
-----END PGP SIGNATURE-----

--Sig_/CDcnIWKiMj6MJuWC_yNidpy--
