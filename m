From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 00/16] hot-replace support for RAID4/5/6
Date: Fri, 23 Dec 2011 08:14:24 +1100
Message-ID: <20111223081424.682a1597@notabene.brown>
References: <20111026014240.21110.28487.stgit@notabene.brown>
	<CAA9_cmfWEnLnvrShVp3BL+WsEApS+nsWBZfao-qM2_habqFCtg@mail.gmail.com>
	<20111215171850.335da016@notabene.brown>
	<CABE8wwtKvNamQM3VfYFHwGQ0BhV2xBtYgqV1=Rmjc=6J3Bqogw@mail.gmail.com>
	<20111220161820.0830ef18@notabene.brown>
	<20111222215442.Horde.VHSHGZk8pphO85kS1Gs7yvA@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/svj7=jrtIi.j0OBx_iBvwXb"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111222215442.Horde.VHSHGZk8pphO85kS1Gs7yvA@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander =?UTF-8?B?S8O8aG4=?= <alexander.kuehn@nagilum.de>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/svj7=jrtIi.j0OBx_iBvwXb
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Dec 2011 21:54:42 +0100 Alexander K=C3=BChn
<alexander.kuehn@nagilum.de> wrote:

>=20
> Zitat von NeilBrown <neilb@suse.de>:
>=20
> > On Wed, 14 Dec 2011 23:14:04 -0800 "Williams, Dan J"
> > <dan.j.williams@intel.com> wrote:
> >
> >> On Wed, Dec 14, 2011 at 10:18 PM, NeilBrown <neilb@suse.de> wrote:
> >> >> f248f8c md: create externally visible flags for supporting hot-repl=
ace.
> >> >>
> >> >> 'replaceable' just strikes me as a confusing name as all devices are
> >> >> nominally "replaceable", but whether you want it to be actively
> >> >> replaced is a different consideration. =C2=A0What about "incumbent"=
 to mark
> >> >> the disk as currently holding a position we want it to vacate and
> >> >> remove any potential confusion with 'replacement'.
>=20
> 'vacating' strikes me as the obvious choice, no?

Interesting suggestion, but not quite the right meaning.

The bit can be set before a replacement is available.  So it isn't a
statement about what is happening to the device, but about what should
happening to the device.
The meaning we want is "replace this device as soon as possible".

I don't think there is one word that really has a meaning like that.
"replaceable" was the closest I could get but that means "can be replaced"
rather than "should be replaced" and as Dan pointed out that is a significa=
nt
difference.

Maybe "deprecated"?? However I don't think using that would improve clarity.

Thanks,
NeilBrown


--Sig_/svj7=jrtIi.j0OBx_iBvwXb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTvOdsDnsnt1WYoG5AQJOMA//ZKO7phRsBpl2k38UZP6m35xe5VG+EGiw
bpfO+BGvsrQARp4W3AZPZ/g2RYs10GPlLG51eqCuonPJy9+ZJ5ROjOqb6l7eG87S
yYpmRNW85Dcqxcgvi0kn8kx7bkXQOxWblQL0+SuAiSnyUIz90+qs0q4CO4SqIv6v
F25RsyqmePgTYYeCxr2R4uLhTsAXcHVrOjx8/XnGR4RtksIfRyB9XZ2nNOn5IzlA
KzDzFDNypVRU1ryCaFMJqFzSkjFkTAt6dJ3/peJwdgNU0Dc/k767e3VJY58XTfFB
0fTm87TRm30rlfozL+19QeAhqJQMe+uqMJ9WbBBbhBwSS3h+5B6Zahq7eS3sNnsN
jjO9vNIyZEikrPUfZUiiCEghtY5I1gX3R/ogcoUUk1ag7bP2xP+C1dketSnAmajP
3zOY0ePkFIS8U7FZ+EA94cCt1RbMCs3w0Avvs4dURhcRuzHgbLwpNlo1/uFiR5Nd
mE/aX7ncBh1f0ngSvkxpFhY1VM+VSS2d7j/Y+txd0g212Dl8Q534c/17yRm3qF4U
jnKFojDBBSwM7AjjIBA4W4pwO0D2RhLSVtAFetS4NVWCdq3TXwrA3WahhQBQ+iVU
YGYD2h+JlGYgQn69Xhg+JeOH2/ogeK05WPSiRM9MqEn3qoZwidd7FnOi+TQ9INrs
56zacX2sMUs=
=w/7c
-----END PGP SIGNATURE-----

--Sig_/svj7=jrtIi.j0OBx_iBvwXb--
