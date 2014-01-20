From: NeilBrown <neilb@suse.de>
Subject: Re: looking for advice on raid0+raid5 array recovery with mdadm and
 sector offset
Date: Tue, 21 Jan 2014 09:51:29 +1100
Message-ID: <20140121095129.5d5d7f8b@notabene.brown>
References: <CANgodhBjRyNDwJwOxepqxX0zMaLtnniYpwWe_k7hjgfRP0UpvA@mail.gmail.com>
	<20140106124143.287894da@notabene.brown>
	<CANgodhCyo7fgEzkg-=jtYkVkNVda50yiaYCCpzPcxAeFxwNUjw@mail.gmail.com>
	<CANgodhC6wKST5B3zKHD-04xHV8DCUm1Rv71c44RWDMuJp6+WGg@mail.gmail.com>
	<CANgodhDZnogCmXDLz75Hidv=HcYoaoj=1thKTqt8htP8gx3CSw@mail.gmail.com>
	<20140120171645.591b17fc@notabene.brown>
	<CANgodhBzYbr6+V6POFy5e9cYPtGFYNcfmR2Z8hE5Vj0jA8YveA@mail.gmail.com>
	<20140121091144.4873d3ec@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/t30o3ZG2rA+Y8.djHq4sNiY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140121091144.4873d3ec@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: den Hoog <speedyden@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/t30o3ZG2rA+Y8.djHq4sNiY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 21 Jan 2014 09:11:44 +1100 NeilBrown <neilb@suse.de> wrote:

> On Mon, 20 Jan 2014 16:43:38 -0500 den Hoog <speedyden@gmail.com> wrote:
>=20
> > Hello Neil,
> >=20
> > thanks again for spending time on this when you're already swamped, I
> > appreciate it much
> >=20
> > the commands look logical for my setup (just a type on the chunk size,
> > needs tobe capital K)
> > I did not dare to fire off the last command last time, but as missing
> > seems to be available for imsm, I re-processed all of the commands
> > again
> >=20
> > the Raid0 is created without any trouble (only stating it is already
> > part of an array, confirmed with Y), but the raid5 array won't.
> > After it also stated sdc sdd sde are part of an array, and confirming
> > with Y for the create, it gives the following:
> >=20
> > "mdadm: unable to add 'missing' disk to container"
> > I'm using mdadm - v3.2.6 - 25th October 2012.
> > Could it be the 3.2.6 does not support missing for imsm?
>=20
> That's weird.  I'm sure I tested it yesterday and it worked.
> Today it doesn't in exactly the way you describe.
> I'll have a poke and see what is happening.

OK I think I figured it out.

Firstly, to create an IMSM array with a missing device, every array in the
container must have the same device missing.
Now you cannot create the RAID0 with a missing device, so you need to create
a RAID5 in it's place instead.
So:

  mdadm -C /dev/md/imsm -e imsm -n 3 /dev/sd[cde]
  mdadm -C /dev/md0 -l 5 -n 4 -c 128K -z 512G missing /dev/sd[cde]

then create the radi5 you want:

  mdadm -C /dev/md1 -l 5 -n 4 -c 128K missing /dev/sd[cde]

That creates the container with 3 devices, and two 4-device arrays each with
one device missing (every array in a container must have the same number of
devices, and must have the same number that are missing).

However the above will crash.  That is the "secondly".

You need the following patch, or you can just collect the latest from
git://neil.brown.name/mdadm/

NeilBrown

commit 1ca5c8e0c74946f4fcd74e97c5f48fba482d9596
Author: NeilBrown <neilb@suse.de>
Date:   Tue Jan 21 09:40:02 2014 +1100

    IMSM: don't crash when creating an array with missing devices.
   =20
    'missing' devices are in a different list so when collection the
    serial numbers of all devices we need to check both lists.
   =20
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/super-intel.c b/super-intel.c
index c103ffdd2dd8..f0a7ab5ccc7a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5210,6 +5210,8 @@ static int create_array(struct supertype *st, int dev=
_idx)
 		int idx =3D get_imsm_disk_idx(dev, i, MAP_X);
=20
 		disk =3D get_imsm_disk(super, idx);
+		if (!disk)
+			disk =3D get_imsm_missing(super, idx);
 		serialcpy(inf[i].serial, disk->serial);
 	}
 	append_metadata_update(st, u, len);

--Sig_/t30o3ZG2rA+Y8.djHq4sNiY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUt2ocTnsnt1WYoG5AQK7vw/+KsxxJ9P0gPNPYWJM/Fx6ASNhxpo83wU7
L7mt401XCfd6rX68O5+fQW91nASiwtXtqO5MBUSkw7Qz8Mty1WHz8aVtqjM0iA0x
7UzfaFqwUXXP0UKDhGAE5vZpyMjWVlOmC0+i5JZ6DWhrDM2FrM/189ZytGa6hrjD
r5fJVAka/SV7eY3yMTA2y9kX9QqrKPsnuCaSlFfLmk+pEw0OcKPaCosjSXeNIhp1
dsyF5s+utanqs09JLWHy3xW9zTCAcf5/o5LnGe9KcmWeqHEloVBpBPZ82hbTV116
at1cnyzByJ/g8Qj8s95Ut3lTlPxLQSWIISCJBo9D0ighUvP1iUH++XTueJZyiC3b
g1ebVbkKq4D8GhdPUfGzNPdMDqDu+vL/SVC6nf+lJIb2Gz7DovjSALlqgPdc6XV8
W2Uvyqq2MOToYz3VIZ9PG3hVS5OkXkQAmwoaQI6o0Gry1aYI3uQGJdXZGyCzkBSj
Dx6z0+hfFd7ltai6vmMlJeWmiJ0tFvdBDTD/nRrN0tlMvLVyPhIn2PFm4hALpSkS
uOI928LLlY3fcB88hEmMM8OUwko+I/Z0erruT91N/3Cwsm42c1RbeIHO+3zPcpwd
fxYN+V5OcMWn+MvseupzW3nWgUyfGdr8EgY6ehFg92itxr22wgcIQvtO+Z0AU7yW
z6hc4JNJ6Ew=
=aRH5
-----END PGP SIGNATURE-----

--Sig_/t30o3ZG2rA+Y8.djHq4sNiY--
