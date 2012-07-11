From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Assembly failure
Date: Wed, 11 Jul 2012 16:44:41 +0600
Message-ID: <20120711164441.2790ac3b@natsu>
References: <20120710163345.GB29855@nsrc.org>
	<4FFC5CC0.8050808@profitbricks.com>
	<20120710170646.GA29962@nsrc.org>
	<4FFC68AB.4010801@profitbricks.com>
	<20120710185927.GA30164@nsrc.org>
	<20120711124316.206ab3d9@notabene.brown>
	<20120711075818.GA30527@nsrc.org>
	<20120711172742.2b8e13e9@batzmaru.gol.ad.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pCbGlDyWa4lyjI5Eixs_jUY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120711172742.2b8e13e9@batzmaru.gol.ad.jp>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Balzer <chibi@gol.com>
Cc: linux-raid@vger.kernel.org, Brian Candler <B.Candler@pobox.com>
List-Id: linux-raid.ids

--Sig_/pCbGlDyWa4lyjI5Eixs_jUY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Jul 2012 17:27:42 +0900
Christian Balzer <chibi@gol.com> wrote:

> RAID until they get a non-braindead firmware that won't park (look at the
> Load_Cycle_Count in SMART) the heads every 30 seconds, come rain or shine.

So I seem to have such firmware, what do I win?

Device Model:     ST1000DM003-9YN162

  9 Power_On_Hours          0x0032   097   097   000    Old_age   Always   =
    -       2796
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always   =
    -       326

or maybe....

# hdparm -B /dev/sda

/dev/sda:
 APM_level	=3D 128

See "man hdparm" about the "-B" switch and check what is the value on your
drives. Mine was at 128 by default btw, I did not have to change this value
manually.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/pCbGlDyWa4lyjI5Eixs_jUY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/9WRkACgkQTLKSvz+PZwgTuACdHqGdqDUYum9qxI/i4vldcF/x
lhcAn3huYLM25gPsS3O9JXXwQScC4APN
=X1o6
-----END PGP SIGNATURE-----

--Sig_/pCbGlDyWa4lyjI5Eixs_jUY--
