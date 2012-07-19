From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Need to remove failed disk from RAID5 array
Date: Thu, 19 Jul 2012 09:16:11 +0600
Message-ID: <20120719091611.22e16100@natsu>
References: <CAB1R3shxBWebm13ie5gR0h++-GBTyfZrranHr8tjGkbPipV32w@mail.gmail.com>
	<50071C0A.8080307@tmr.com>
	<CAB1R3sjhES1+0XB43oXLomgH7Q6LPiTm11tPSoDJ91RRrfNy=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TzmTT1fcpR0RgQlYO70Rv4s"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3sjhES1+0XB43oXLomgH7Q6LPiTm11tPSoDJ91RRrfNy=A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Linux RAID <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

--Sig_/TzmTT1fcpR0RgQlYO70Rv4s
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Jul 2012 22:44:06 -0400
Alex <mysqlstudent@gmail.com> wrote:

> I'm not sure what stats I could provide to troubleshoot this further.
> At this rate, the 2.7T array will take a full day to resync. Is that
> to be expected?

1) did you try increasing stripe_cache_size?

2) maybe it's an "Advanced Format" drive, the RAID partition is not properly
aligned?

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/TzmTT1fcpR0RgQlYO70Rv4s
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAHe/sACgkQTLKSvz+PZwhbDACdEEW60z8DWBMGLPQ0MXTxLZRk
W7wAoJQdMUMQCRoY1jGrKLBRMwVhnb3u
=z0vQ
-----END PGP SIGNATURE-----

--Sig_/TzmTT1fcpR0RgQlYO70Rv4s--
