From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5 - Disk failed during re-shape
Date: Mon, 13 Aug 2012 09:35:54 +1000
Message-ID: <20120813093554.600d46c2@notabene.brown>
References: <BLU153-ds1688A6A36A974526D12FDB94CC0@phx.gbl>
	<50258CEA.10100@turmel.org>
	<BLU401-EAS3343C9BB7296EA68990FF2294B20@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rJrnSU4G8o4f94POI5WPBbl"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU401-EAS3343C9BB7296EA68990FF2294B20@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Sam Clark <sclark_77@hotmail.com>
Cc: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/rJrnSU4G8o4f94POI5WPBbl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 11 Aug 2012 10:42:01 +0200 Sam Clark <sclark_77@hotmail.com> wrote:

> Thanks for the response Phil.=20
>=20
> I was thinking that 'toast' was the case, and have been looking into my b=
ackups (not so great, though the critical data is fine).=20
>=20

If you've got backups, then that is likely the most reliable solution - sor=
ry.



> I think you are toast, as I saw nothing in the metadata that would give
> you a precise reshape restart position, even if you got Neil to work up
> a custom mdadm that could use it.  The 11.4% could be converted into an
> approximate restart position, perhaps.
>=20
> Neil, is there any way to do some combination of "create
> --assume-clean", start a reshape held at zero, then skip 11.4% ?

The metadata might contain the precise reshape position - but "mdadm
--examine" won't be displaying it.
If you can grab the last 128K of the device (probably using 'dd' with
'skip=3Dxxx' I would be able to check and see.

If you can tell me:
  exactly how big the devices are (sectors)
  what the chunk size of the array was (probably 64K)

and get me that last 128K of a few devices, then I can provide you a shell
script that will poke around in sysfs and activate the array in read-only
mode which might allow you to mount it and copy out any important data.
After that you would need to re-create the array.

I don't think it is really practical to get the array fully working again
with recreating from scratch once you have all the important data.

NeilBrown


--Sig_/rJrnSU4G8o4f94POI5WPBbl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCg92jnsnt1WYoG5AQLz0A/+Kp8YwKb/VmmEuyHoW5wv7GXJZ062sWOC
msfxAvFRb3v8qqWBoaaMUGNVoDtFU8a0DQ8ucLE0whGyIGR6FpMcbnNyS5mqKnl0
CEdVODckPfYbLUtJ2pIwzbKC0dYtvn2/x0tjRbrjc5rrbpnNZaGqTtqbxilVHwVU
4wMaMe1r9z5cr4eg4OU6ZgVvLGFEGidYoFL/iJaqCt7aRyCxuhpzf/sjOVPfkeaI
HlBW2byVeFTufa+stKGxFD3T5akTC6ZszR3mZ371Ilt/sOuGLIjSN5+AQ3fxG5Zr
7UpDAmRh4G+v2iEUESS2hYFgxpgA+DZnK1IZAcebo22THeBLc+YL9tknwIbnMtx/
Mq1aAqL8t+rIR9w3VCOP82z9JDSdPheVLvucY/avw5Dt/JgCeRYZWbgnkhKkb157
4dmUPODxHn0M27ijiQd3Xz80G/NsBSwWQfhkAcrST+BXUESjjTt6PkHbf4r99pmH
djsRTHYHg4dOUDUHrBP3FoUX4HLnJzfUD3V5HaShAq2cnrTVekdggfw9QCbBowTE
KJP56VY2HRrbGsayZKDzp9/TNA0NLY7ocdl3xwMM16bMnkt/H+rUhP4YaIONHrn0
LQdr8ioPDzjXnxTy+fsbEyyRIt4fIp2d7O7YVTI7zWRzydCNfucVpbFoCzxR0gmv
Xe27m/QoKG0=
=7BU8
-----END PGP SIGNATURE-----

--Sig_/rJrnSU4G8o4f94POI5WPBbl--
