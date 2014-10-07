From: NeilBrown <neilb@suse.de>
Subject: Re: auto assemble in read-only mode?
Date: Wed, 8 Oct 2014 10:33:16 +1100
Message-ID: <20141008103316.5ff79105@notabene.brown>
References: <1412600795583058500@businessgrade.com>
	<1412664991898536500@businessgrade.com>
	<20141007181520.359d939b@notabene.brown>
	<1412685094488232500@businessgrade.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/55lUpNH5ib_FmV_kCaOGzNx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1412685094488232500@businessgrade.com>
Sender: linux-raid-owner@vger.kernel.org
To: Errol Neal <eneal@businessgrade.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/55lUpNH5ib_FmV_kCaOGzNx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Oct 2014 08:31:34 -0400 Errol Neal <eneal@businessgrade.com> wrot=
e:

> On Tue, 10/07/2014 03:15 AM, NeilBrown <neilb@suse.de> wrote:
> > On Tue, 7 Oct 2014 02:56:31 -0400 Errol Neal <eneal@businessgrade.com> =
wrote:
> >=20
> > > On Mon, 10/06/2014 09:06 AM, Errol Neal <eneal@businessgrade.com> wro=
te:
> > > > hi folks. is it possible to assemble an md device in read-only mode=
?=20
> > > > after an array has been assembled, I know I can mark it as readonly=
 with --misc -o /dev/md0 for example, but only after its been assembled it =
seems..
> > > >=20
> > >=20
> > > Hi again. No thoughts here?=20
> >=20
> > Not even 18 hours since you last asked - what do you thing this is? The
> > Internet :-)
>=20
> HAHA. I tend to feel ignored on large mailing lists lol. Need to see my t=
herapist again ;)
> =20
> >=20
> > > I'm need to run a RAID1 device on two independent nodes (shared stora=
ge) and I'd like to assemble the device on the "slave" node in read-only mo=
de to prevent any sync actions and etc.=20
> >=20
> > Did you try adding the "--readonly" option to your --assemble command?
> > (Always best to report everything you tried and how it failed - require=
s less
> > guess work).=20
> =20
> I did that previously and mdadm told me that  "option --readonly not vali=
d in assemble mode". E.g. "mdadm --assemble --scan --readonly".=20

That tells me use are using a version of mdadm earlier than 3.3.
"--assemble --readonly" support was added for 3.3.

NeilBrown


> The readonly flag seems like it can only be used after a device has been =
assembled. So for example, after the device has been assembled, I can=20
> run mdadm --misc -o /dev/md0 but that is not always safe for my use case.=
=20
>=20
>=20
> =20
> > I hope you don't expect too much of a filesystem mounted from such an a=
rray
> > while the  other node is writing to the array...
> >=20
>=20
> I don't. It will be read-only until the pacemaker RA promotes the slave.=
=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/55lUpNH5ib_FmV_kCaOGzNx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVDR4PDnsnt1WYoG5AQLx1Q/9EL9SsoEhAv7hBDi30CWEcfFK7hBfiPKa
cu+uByTxuhE2Fy+eDNOncV+rOm7ttLByGvRlXWINuWWPhcQOJpD0IeM5Os2vRf8H
qAg0Azn33AYMQgNJXfJ0WBNy/YzLWhCW1e8RviSWagUq9k6LxRw76VNseo1ONAgk
xfcr/RGWn3yM0kUwYRGriCa3RWpCFAfnV7fcI96dSByPoLgdc8kizJRs1vGbiPXk
eUK4yIHh/y2lpQjRvr1J2WWq5L4+6Z/xJbaOPrHEnpY30HSIr2BRVW4HLV/3NXIL
yIcupkloyT5e7W3TbPuCngtsmEWsDmfxUBMerSCoRa46YUuitE+c1vKv+eSqB5GI
rmY4nAiidHkjSjhA81Sf37AgM1ToGAnd/GjAx6Ekc+PNqZKzxTRFuZMWGUxp4lzp
jb64cJwO8ErjsSbLZ/6WkugXI5DXuypQLC8HAX8ePQwwMIqOXty2+kqWaYqtjl6F
8cbW0Fg4QhpKsXs7bn7THUgJPsDSputvhuDjz0Ow8szcPEoFzXMS+mTSvINj8x88
sYjR69TZ4KEEMhFsxftGKzwPGIyUwBFIElU20bQ64fskZtSTI2ehBoucvr4DHSO5
1Gk7sLxFCGPLtvi9nzAmTWGolK2TYFczEdmH0LH/AO0zijJVP0BSsDY6jriaft9I
oXN6Rs0zni0=
=lf/B
-----END PGP SIGNATURE-----

--Sig_/55lUpNH5ib_FmV_kCaOGzNx--
