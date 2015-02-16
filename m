From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm failed to remove internal bitmap
Date: Mon, 16 Feb 2015 14:34:19 +1100
Message-ID: <20150216143419.553cf93e@notabene.brown>
References: <54DDC806.5010803@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/qFRw2iB1PQ1u_JU_8eW89as"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54DDC806.5010803@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: gary <gary.mdjiang@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/qFRw2iB1PQ1u_JU_8eW89as
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Feb 2015 17:46:46 +0800 gary <gary.mdjiang@gmail.com> wrote:

> Hi,
>=20
> I used v3.3.1 mdadm to do some test for bitmap, but when switch bitmap fr=
om
> internal to none, the output shows fail info about remove internal=20
> bitmap, is it
> just a warning? Since the bitmap seems to be cleared, and it doesn't=20
> show with
> v3.2.6 mdadm with the same steps.
>=20
> linux:~ # mdadm --create md0 --raid-devices=3D2 --level=3Dmirror=20
> --assume-clean /dev/vdb /dev/vdc
> mdadm: Note: this array has metadata at the start and
>      may not be suitable as a boot device.  If you plan to
>      store '/boot' on this device please ensure that
>      your boot-loader understands md/v1.x metadata, or use
>      --metadata=3D0.90
> Continue creating array? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md/md0 started.
> linux:~ # cat /proc/mdstat
> Personalities : [raid1]
> md127 : active raid1 vdc[1] vdb[0]
>        523712 blocks super 1.2 [2/2] [UU]
>=20
> unused devices: <none>
> linux:~ # mdadm --grow --bitmap=3Dinternal /dev/md127
> linux:~ # cat /proc/mdstat
> Personalities : [raid1]
> md127 : active raid1 vdc[1] vdb[0]
>        523712 blocks super 1.2 [2/2] [UU]
>        bitmap: 1/1 pages [4KB], 65536KB chunk
>=20
> unused devices: <none>
> linux:~ # mdadm --grow --bitmap=3Dnone /dev/md127
> mdadm: failed to remove internal bitmap.
> linux:~ # cat /proc/mdstat
> Personalities : [raid1]
> md127 : active raid1 vdc[1] vdb[0]
>        523712 blocks super 1.2 [2/2] [UU]
>=20
> unused devices: <none>
>=20

I cannot reproduce this.
What kernel are you running?

Please use "strace" on mdadm in a case where it fails, and post the result.

NeilBrown

--Sig_/qFRw2iB1PQ1u_JU_8eW89as
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOFlOznsnt1WYoG5AQJX+Q//YnRZ7MkbOKxsvngnidMzQKzvl38Grr/E
Trv1g2bbc22nQ52cz1jnYedMqwPSidvbFmKTi6o9c0EERTBg+jGrsvmoG0C+ssBK
fpY3Kc1RXVn9HNXVmZ/vENmd1B+ax27mSPZKbJMah5j+O4/8DilLZNFLjoCNYHt4
GLRus2Msxfuh79xg0oalL+SLaItkmXzuFrAmpP7EP+JlDa59aKY+MQTHl7cYAU9U
eCme4fb7c8PJJO/neI//vnqXZ/km5sHP0RHLngfDJHlazj5sqS8l4MN6+ihzekmn
7g4sUvAjf/UV/RkJwzInNxNFmexNyfMr6A0NZSpGn5Ooo9+2PFAHtqt4J4q8bL5n
xQOwmI/8hW0F6ycwaao95b9WkPN6fpi2/HcvDlabTYKD8oxGnjefwptZpluWp30z
/oGiCnAah1l9fu+afBwCTZUQYRCaGZ4Rnk9aJQnqLYfZsSD/ShuexijdJ2G2i00t
TwIATgOXvXZUaOwc8HsWXFwOTmLKyulMw+wGeZ9KIOyJCFr5nspe/S2gpEmpFMqe
LLJ+3+UBGN/ITU6/jTnvrrnTB+V0ntaKuxKQwvSdfQ9I5SOodARMqhWRT8SBdwTs
8dTsY+hRk8l8n5kOo6N3BVcJLvh6xBDwHBFGbVa/goQx4qOfKEBYf618onCfwO+f
xJaI7TxL6aA=
=Cq1g
-----END PGP SIGNATURE-----

--Sig_/qFRw2iB1PQ1u_JU_8eW89as--
