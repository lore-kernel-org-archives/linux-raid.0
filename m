From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: RAID6 and crashes (reporting back re. --bitmap)
Date: Fri, 11 Jun 2010 10:41:34 +0600
Message-ID: <20100611104134.2d3d94eb@natsu>
References: <4C1128C2.4020105@meetinghouse.net>
	<20100611005743.43664e5b@natsu>
	<4C11578B.8010202@meetinghouse.net>
	<20100611034108.6a2cdbc4@natsu>
	<4C1169CB.1030903@meetinghouse.net>
	<20100611085112.5f33b06f@natsu>
	<001501cb091f$07ac4e40$1704eac0$@woodlea.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/eQ9wjZH.5U+Js7e4gif6yHJ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <001501cb091f$07ac4e40$1704eac0$@woodlea.com>
Sender: linux-raid-owner@vger.kernel.org
To: Graham Mitchell <gmitch@woodlea.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/eQ9wjZH.5U+Js7e4gif6yHJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Jun 2010 00:31:57 -0400
"Graham Mitchell" <gmitch@woodlea.com> wrote:

> Can you do this on a live array, or can it only be done (as the docs seem=
 to
> suggest), with the create, build and grow options?

It is a variant of the grow operation, but it can be done on a live array,
even mounted, and completes instantly:

mdadm --grow /dev/md0 --bitmap=3Dinternal --bitmap-chunk=3D131072

In my experience, removing the bitmap (setting it to none) may occasionally
fail (probably when the array has a lot of outstanding write requests), but
just try again when it's a bit quieter, and it'll work.

--=20
With respect,
Roman

--Sig_/eQ9wjZH.5U+Js7e4gif6yHJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwRvn4ACgkQTLKSvz+PZwiL6wCcDW8Q0NPUhjhwlLZoQ/HyvHOS
JbMAnjgR6asMyPhTOlmy3fsAVX7rz1JN
=LUQx
-----END PGP SIGNATURE-----

--Sig_/eQ9wjZH.5U+Js7e4gif6yHJ--
