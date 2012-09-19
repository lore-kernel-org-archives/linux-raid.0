From: NeilBrown <neilb@suse.de>
Subject: Re: Wrong array size detected after reboot
Date: Wed, 19 Sep 2012 11:42:02 +1000
Message-ID: <20120919114202.0ad6355b@notabene.brown>
References: <CAFEwywaeGevnDMu7Do_wK+_Jgtyd0vman0804C2LyqbyzcJ9Sw@mail.gmail.com>
	<504C0462.2000609@turmel.org>
	<20120910091352.38dfdc20@notabene.brown>
	<CAFEwywaGN3cvXVAJxsWuc1-j0mfeLtKs_iqNznFQN8QA7JO8qQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CJLc_Ps0qCvreih=Uy.rFmg"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFEwywaGN3cvXVAJxsWuc1-j0mfeLtKs_iqNznFQN8QA7JO8qQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Irle <tha.bear@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/CJLc_Ps0qCvreih=Uy.rFmg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 16 Sep 2012 01:32:06 +0200 Markus Irle <tha.bear@gmail.com> wrote:

> Hi guys,
>=20
> Thanks for your help.
>=20
> On Mon, Sep 10, 2012 at 1:13 AM, NeilBrown <neilb@suse.de> wrote:
> > On Sat, 08 Sep 2012 22:52:18 -0400 Phil Turmel <philip@turmel.org> wrot=
e:
>=20
> **snip**
>=20
> >> Until recently, due to a long-standing bug, devices larger than 2T were
> >> not usable with v0.90 meta-data.  I don't remember precisely when that
> >> bug was fixed, but I believe it was in the past year.  There are also
> >> potential identification problems with v0.90 when used on the last
> >> partition of a device, but you have a misalignment warning that would
> >> prevent that.
> >
> > The bug was fixed in 3.1-rc6, (commit 27a7b260f71439c40546)
>=20
> I'm running 3.2 (3.2.0-31-generic, latest in current Ubuntu release 12.04=
) now.

Sorry, I got that wrong.
That commit is the one that introduced the bug.

It's fixed by 667a5313ecd7308d which will be in 3.6, and is being
back-ported to most -stable kernels, thought it doesn't seem to have arrived
in any yet.

Maybe you can ask Ubuntu to provide a kernel containing that commit?
Or compile your own?

Or find a kernel older than 3.2...

NeilBrown

>=20
> >> You should see that the used dev size is very close to 2TiB less than
> >> the actual size of your devices.
> >>
> >> First, try the latest stable mainline kernel that you can.  That should
> >> let you back up your data.
>=20
> Unfortunately nothing's changed.
>=20
> The array still thinks it's small:
> [    1.693557]  --- level:5 rd:3 wd:3
> [    1.693559]  disk 0, o:1, dev:sdb1
> [    1.693561]  disk 1, o:1, dev:sdd1
> [    1.693562]  disk 2, o:1, dev:sde1
> [    1.693593] md2: detected capacity change from 0 to 1603139141632
>=20
> and the vg doesn't start:
> [    1.778499] device-mapper: table: 252:0: md2 too small for target:
> start=3D384, len=3D11721064448, dev_size=3D3131131136
>=20
> Cheers,
> Markus


--Sig_/CJLc_Ps0qCvreih=Uy.rFmg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFki6jnsnt1WYoG5AQJEAg//aLyeEv6EtjPFdSdVedDIxN74hY4KDYPJ
+P7XZLRxj0KxDIDdQKMhAC6urkhRMe6BdjRzkG6b20wErHwEBd6KvSuRr/jJbJlL
wxgCVlAZ4Cn8xjSaVodWUoSC84JVY28lJyDDsEPBK3l7eC94ub+w5+AbHpgHOE4C
X/jUxboBOLcUPCEsa6Qkv2UWug97rb+1CEqnabrD/WzDvbiLF5+olsACTBj++MaM
ANESqjYGxgMCk8qQMw0W6tpXz2NpLhdsgNsesteHNHrsECNYO0san9R9TLX0tiUq
B8sIBDUE3jHh1Jtb1eC62H/XUA73o8j4LE4U1SJzjqbCptH5VO6tVOndskMQoVMO
kuBzoAOcQ4UXRQlQN02HXfVEZJIzVogxUn6hkFjFsTUFAniuk6/a7Je2qTM6zhzO
qxVrlXXlwH/9eg+wIGjINAQsHUNDAvBFNItwyX8Kkent2gWmthdjwlbaUSBLQagk
JJfP1BejlAAgJ8oyyBMBes9+waRIYx9wsqBR6UVy5XMkvl64GttQsfq30ysj7hT1
TUKESeF2hu1D+TJGCH7579aSSoQzL4Z9Du5353RHx/uDW6xZmNUxcGVDHhmYEMQu
wGA97gQE3NQzVYQV6XVW21egzBXsQThhVcFw+yQNMKf6MjdPLrq6GcJ4mkM7zfi6
y8tIPY680ZY=
=sFUD
-----END PGP SIGNATURE-----

--Sig_/CJLc_Ps0qCvreih=Uy.rFmg--
