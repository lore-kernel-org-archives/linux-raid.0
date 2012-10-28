From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: 3TB drives failure rate
Date: Mon, 29 Oct 2012 03:18:51 +0600
Message-ID: <20121029031851.42a5e1e9@natsu>
References: <11510711257.20121028131527@oudeis.org>
	<DB91871A-731F-44B4-9381-8FBF7D9CC3BF@colorremedies.com>
	<20121029015910.018efb17@natsu>
	<F548750F-8D0E-4D05-813B-58D85D652226@colorremedies.com>
	<20121029021643.1c9e3195@natsu>
	<46B8932A-58A5-4C1A-9C8C-DCCD5D3A1CD9@colorremedies.com>
	<A9ED9351-3430-43B8-AEA8-031B3DE29522@colorremedies.com>
	<6FAB7F92-66E2-4276-9774-B80DAC92E450@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5MCf.lTJVEcXq82HaO7Pci7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6FAB7F92-66E2-4276-9774-B80DAC92E450@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/5MCf.lTJVEcXq82HaO7Pci7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 28 Oct 2012 15:07:53 -0600
Chris Murphy <lists@colorremedies.com> wrote:

>=20
> On Oct 28, 2012, at 2:50 PM, Chris Murphy <lists@colorremedies.com> wrote:
>=20
> > For any serious use I just wouldn't use the Greens, without very non-co=
nsumer like scrubs, extended smart tests, and cycling out drives so they co=
uld be ATA Enhance Secure Erase nuked say once a year or maybe more often. =
And a rigorous backup. With that kind of expertise and dedication should co=
me a better budget for a better drive.
>=20
> On 2nd thought, I'd consider the greens something like a "hostile witness=
" in legal jargon. Relegate them to only ZFS or btrfs (or ReFS maybe, uncle=
ar) for "raid" like pooling or redundancy. The drives themselves are inhere=
ntly suspect so a suspicious grand inquisitor of a file system seems like a=
n appropriate match, to constantly 2nd guess them.

Now you are moving into unfounded superstitions territory.

You seem to imply that a Green drive would return just plain bad data in so=
me
failure condition (else why all the checksumming FSes?), and not an IO Erro=
r.
I don't think anything of this sort has been demonstrated so far, and while
this could happen due to bad RAM/chipset/controller/bus/cache/etc, this wou=
ld
have nothing to do specifically with "Greenness" of a drive, nor any
particular model would be inherently more prone to that.

> But still, once a drive is asked to retrieve an LBA, so long as the drive=
 eventually reports it back correctly, the file system won't correct that s=
ector merely for a delay, even if it is up to 2 minutes or whatever it is. =
So, filesystem choice doesn't really solve the delay problem. You just have=
 to obliterate the disk periodically with zeros or secure erase.

I do not think there is a state in modern HDDs that there would be a sector
which consistently takes 30-120 seconds to read. Those are either unreadabl=
e at
all, or readable after a delay -- and then already remapped by the HDD into=
 the
reserved zone, so the delay is not there the next time.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/5MCf.lTJVEcXq82HaO7Pci7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlCNoTsACgkQTLKSvz+PZwgQfwCfXUYfdN2EBwLYicZx8y196KDK
J94An36dWbZovrmz9c027RSAeTlYUlkT
=rHEC
-----END PGP SIGNATURE-----

--Sig_/5MCf.lTJVEcXq82HaO7Pci7--
