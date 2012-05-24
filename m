From: NeilBrown <neilb@suse.de>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Thu, 24 May 2012 12:08:19 +1000
Message-ID: <20120524120819.08ffa3b0@notabene.brown>
References: <4FAAE8F1.8000600@pocock.com.au>
	<CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com>
	<4FABC7C6.4030107@turmel.org>
	<4FAC2FF2.5060305@hardwarefreak.com>
	<4FAC40BC.1060300@hesbynett.no>
	<CABYL=ToORULrdhBVQk0K8zQqFYkOomY-wgG7PpnJnzP9u7iBnA@mail.gmail.com>
	<4FACBB68.2080304@hesbynett.no>
	<4FACCAC8.4020206@pocock.com.au>
	<4FAD9283.7020809@hardwarefreak.com>
	<CAGqmV7oJg8vwKPJEYJhPANzaN-xxVW6Lw2gLTEKmMfG=pqCHuA@mail.gmail.com>
	<4FBA8EA9.40203@hardwarefreak.com>
	<20120522093404.3ffaae42@notabene.brown>
	<4FBB33D6.4010101@hardwarefreak.com>
	<4FBB406B.7040904@hesbynett.no>
	<4FBCE2C2.6030909@hardwarefreak.com>
	<4FBD3F49.5060005@hesbynett.no>
	<4FBD76F1.80400@hardwarefreak.com>
	<4FBD8C4E.5090507@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/sS2=.BM9CkPQCEx8dKDzyiQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FBD8C4E.5090507@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: David Brown <david.brown@hesbynett.no>, CoolCold <coolthecold@gmail.com>, Daniel Pocock <daniel@pocock.com.au>, Roberto Spadim <roberto@spadim.com.br>, Phil Turmel <philip@turmel.org>, Marcus Sorensen <shadowsor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/sS2=.BM9CkPQCEx8dKDzyiQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 May 2012 20:18:06 -0500 Stan Hoeppner <stan@hardwarefreak.com>
wrote:

> On 5/23/2012 6:46 PM, Stan Hoeppner wrote:
> > On 5/23/2012 2:49 PM, David Brown wrote:
> >=20
> >> It looks like Shaohua Li has done some testing, found that there is a
> >> slow-down even with just 2 or 4 disks, and has written patches to fix =
it
> >> (for raid1 and raid10 so far), which is very nice.
> >=20
> > Ahh, thanks David.  I wasn't aware of Shaohua Li's
> > work on this.  Got a link to his documentation and patches, or article,
> > by chance?
>=20
> My Google searches only turn up Shaohua Li's TRIM patches.  I don't
> believe the issue we're discussing has anything to do with TRIM, though
> I can't be 100% sure as Mark didn't provide much detail of his thread
> ceiling problem, and I don't have a suitable system to do proper testing.
>=20
> Again it would be nice to have a link to Shaohua Li's work to which you
> refer to determine if it's applicable to this issue.
>=20

It's probably in your INBOX.

http://www.spinics.net/lists/raid/msg38899.html

NeilBrown

--Sig_/sS2=.BM9CkPQCEx8dKDzyiQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT72YEznsnt1WYoG5AQI4Gw//ZKrDwIbNbCZxTFSUiZ1Vgwf4GijXQebX
tU29EVz5A7Ssj2ITix01chkNwy3HgSlJIjtWqduFJrRUE++gJix3I0NP2qPHEw3P
TimzwlPGjKs0tWP3bR+P4S/vw34KYTWiqnvqXVaGnePsqqOeDdVU4VvmIwkbwdlO
uFlBXCY5jL37p+W3JEx2QibwHijdHome0ZwWCDXl79IjFzLuH34a/7si+hBMNWVP
Fbp4mcGhQs+C45cYADULcMeqxhORFgYMQijbK2dRFGY065NL0wQ0ptGdVg8tAm3u
buNXEnvKnEK7tNteEX2K+3qwCECT6y+SkEuqoC3h0YaQmbscanmWtvdSXYlN3XWL
yVvrAA/K/VdX53llLQVVeC0/erwne+XDpo6zE7MyEbaI/c5RpjR1CoekH7tfYVKM
e9CrfHcX+sdf3bhMYPLOFLDdIvP3M0B7JoSBwUsg7PoVyuDGjQISC/GcL8lL5fwI
g4HRsSrjqW9JoCrrTOKuf4rRXGNgi22m+KDpI9Xmj4Zkirntzg9zOmAE3iZdub+I
GpTxTnF+SQRSB5st6sJsKt6jd7U8mR/Vw3jKLinovbz6tGarg6TFrHReXupadiHY
ufjZlinvRVxK/PFF6BnWzCgLBrcJuCpNa3bNvJD141XNqqXRlgywWQUOlE2dPkJi
YdNu7HtKABY=
=EEsk
-----END PGP SIGNATURE-----

--Sig_/sS2=.BM9CkPQCEx8dKDzyiQ--
