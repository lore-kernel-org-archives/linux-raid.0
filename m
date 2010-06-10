From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: RAID6 and crashes
Date: Fri, 11 Jun 2010 00:57:43 +0600
Message-ID: <20100611005743.43664e5b@natsu>
References: <4C1128C2.4020105@meetinghouse.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//CsN40REJv38Xdty5W8aUbc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C1128C2.4020105@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_//CsN40REJv38Xdty5W8aUbc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Jun 2010 14:02:42 -0400
Miles Fidelman <mfidelman@meetinghouse.net> wrote:
=20
> 2.  Are there any settings that can reduce the likelihood of a RAID=20
> volume being dirty after a crash?  (The crash/reboot isn't that much of=20
> a problem - the several hours of degraded performance ARE a problem.)

Do you currently have a write intent bitmap in the array? I think it can
reduce the need for recovery by an order of magnitude in some cases. Check =
man
mdadm for --bitmap if you don't use it yet.

--=20
With respect,
Roman

--Sig_//CsN40REJv38Xdty5W8aUbc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwRNagACgkQTLKSvz+PZwh1/gCcD/SuGnf3heTzMc9AEe/ZxN3A
EAoAoJWEf6FrdIpHYN1rTVeGcP+2Nolh
=P86t
-----END PGP SIGNATURE-----

--Sig_//CsN40REJv38Xdty5W8aUbc--
