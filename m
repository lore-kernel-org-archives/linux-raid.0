From: NeilBrown <neilb@suse.de>
Subject: Re: Extending an existing RAID (10) array
Date: Thu, 4 Jul 2013 09:24:02 +1000
Message-ID: <20130704092402.6f3800ec@notabene.brown>
References: <987a86de2c602b7d79c3b926fdfced80@kruemel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/UxgrlMZFNhOJvoBxN/.N+p7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <987a86de2c602b7d79c3b926fdfced80@kruemel.org>
Sender: linux-raid-owner@vger.kernel.org
To: cvb@kruemel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/UxgrlMZFNhOJvoBxN/.N+p7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 03 Jul 2013 21:04:00 +0200 cvb@kruemel.org wrote:

> Hi, I have a short and hopefully simple question: On
>=20
> https://raid.wiki.kernel.org/index.php/Growing
>=20
> there is a section on expanding existing partitions. Does the procedure=20
> described there also apply to RAID 10 arrays?
>=20
> I'm asking, because the section above says explicitly that it only=20
> applies to RAID level 1/4/5/6 arrays. The section on extending=20
> partitions is silent on that point...
>=20
> I have a RAID 10 (software) array here, consisting of 4 disks. As one=20
> of the disks is a bit flaky, I'm thinking of replacing the (all) disks,=20
> maybe with bigger ones - if that should work.
>=20

There are two dimensions for growing an array - it is good to be explicit.
I think you are just talking about making the devices bigger without
increasing the number of devices.
This possible for RAID10 as long as it uses a 'near' or 'offset' layout.  It
is not support for 'far' layout RAID10.

NeilBrown

--Sig_/UxgrlMZFNhOJvoBxN/.N+p7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUdSykjnsnt1WYoG5AQKM8g/+NF/BTRMXqm80Fuh/9L2VMtIEc9Azy3DR
MH2gl5na1AXTjrEJbr5nqfyxLWpdmyXtDVww8q9h+60+jYex3oiQ8uiPM6HXSOHe
9UOPEDGFSBOyZ7VNq9E9QdAROkpfaXgphXP87bVPfsK748d1wRvchb8d16k0cd7/
tLhou/f9zuedFm4zEFa1kWNLw3iv+7EbrWcc1Q8Qbk8mX4iiGAgFL/Rlz04USO8E
m9ASuAQGdq26MsSduMt3WWrG4QCMpua/bUk+XnckU8lGF4b+PX/9r2yTUDGKGEnn
AaprjXWRZEjjzq6wJh9OLoV9fZRQz5UzJTBMNSFVv/VhgOUdfSm8JzNH+EhE5jho
MzIo0JJ1RuejcELVyLMc9qCpIayt9xQJoZ8CsgZzvWbGa2saEAof7PIO7e1ZOIdY
evNIMvtFa99YdUS/gZGtqc+abzfys3X566YqEmgeYuE5dF5gkj7HOt/knYFupFq9
9hZ/CR4xZAHcVfzXzVXBuPMWNhkpEI1apdeEbc1huV4zeoVtY4J6byyDtqWn1D9+
dtmKJYs5wXi8TFEbuJjJNMDyBp841os87FwB2OJPZS5ab4Bkdh1FTR8EsdngOa/5
VtFdoQjPNQ6/6Ri9z4A4u6bXBEVmG8Dy8zppBVP5Ktsziy5wkoXo9a35xZwAD87n
e6xNpGAjIIg=
=6ykY
-----END PGP SIGNATURE-----

--Sig_/UxgrlMZFNhOJvoBxN/.N+p7--
