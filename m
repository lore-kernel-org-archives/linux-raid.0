From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: 3TB drives failure rate
Date: Mon, 29 Oct 2012 02:49:56 +0600
Message-ID: <20121029024956.30edb309@natsu>
References: <11510711257.20121028131527@oudeis.org>
	<DB91871A-731F-44B4-9381-8FBF7D9CC3BF@colorremedies.com>
	<20121029015910.018efb17@natsu>
	<F548750F-8D0E-4D05-813B-58D85D652226@colorremedies.com>
	<20121029021643.1c9e3195@natsu>
	<46B8932A-58A5-4C1A-9C8C-DCCD5D3A1CD9@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.kcNPc86EQtQAhe3i=O2JJl"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46B8932A-58A5-4C1A-9C8C-DCCD5D3A1CD9@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/.kcNPc86EQtQAhe3i=O2JJl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 28 Oct 2012 14:34:49 -0600
Chris Murphy <lists@colorremedies.com> wrote:

> A drive that can sit there like a bump on the log for 2 minutes before it=
 issues an actual read failure on sector(s) means mdadm is likewise waiting=
, and everything above it is waiting. That's a long hang. I'd not be surpri=
sed to see users go for hard reset with such a system hang after 45 seconds=
 let alone 2 minutes.

Which is not different from what you would get (the same hang) in a non-RAID
environment on the same drive, so I don't see how this would be specificall=
y a
RAID-related problem.

> Anyway, the idea mdadm users can't benefit from shorter ERC is untrue. Th=
ey certainly can. But the open question is why would they be getting such l=
ong error recovery times in the first place? 7 seconds is a long time.

One thing is "benefit", i.e. just a comfort issue, to prevent pauses when a
drive starts failing (but really... does that happen very often? and during
those times do you really care so that there are no pauses for error recove=
ry,
or maybe you just want to replace the drive and still have your data safe?),
and another thing is a complete RAID failure that you'd get with a
hardware RAID controller simply because something is not within 7 seconds,
which is the whole source of that vendor-supported myth of "non-RAID drives=
".

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/.kcNPc86EQtQAhe3i=O2JJl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlCNmnQACgkQTLKSvz+PZwgW0ACdELfgWWfJ7KNcjo+9JI6juWdo
qVUAn2eVpcANTF36hL3eyNLueGRgMxl0
=yboB
-----END PGP SIGNATURE-----

--Sig_/.kcNPc86EQtQAhe3i=O2JJl--
