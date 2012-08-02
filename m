From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: OT: silent data corruption reading from hard drives
Date: Thu, 2 Aug 2012 23:19:23 +0600
Message-ID: <20120802231923.45b6f1fc@natsu>
References: <50191ADE.10809@fastmail.fm>
	<5019D052.4000409@hardwarefreak.com>
	<20120802091917.32fb0ca5@natsu>
	<501A316C.3020305@hardwarefreak.com>
	<20120802140634.6f729d07@natsu>
	<1343926790.28421.140661109896017.1A222237@webmail.messagingengine.com>
	<CABYL=TpDU0YD4orJqyZzeYPtUJ+vBEeM=CWhFxa4GWGj8SjGMQ@mail.gmail.com>
	<501AB553.2030003@aeoncomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TJwp64Ky.Ywe04n=0GrgnJN"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <501AB553.2030003@aeoncomputing.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/TJwp64Ky.Ywe04n=0GrgnJN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 02 Aug 2012 10:13:55 -0700
Jeff Johnson <jeff.johnson@aeoncomputing.com> wrote:

> The only ways I know of to currently detect/repair silent data=20
> corruption are via the use of T10-DIF on SAS drives with 520-byte=20
> sectors and embedded per block CRCs (bytes 513-520) or via a patented=20
> algorithm used in a commercial Linux software RAID product=20
> (www.streamscale.com).

Well, you can simply use BTRFS RAID1/RAID10 (RAID5/6 to come some time soon=
).
It has per block checksums and auto-healing from other drive(s) if data on
some drive turns out not to match the checksums anymore.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/TJwp64Ky.Ywe04n=0GrgnJN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAatpsACgkQTLKSvz+PZwhcfQCdFdvufIAChs/IsuUQZNyyXE1B
/U8An0JM26ziGn5V7jkINZ29HrbMlpzJ
=Dp7x
-----END PGP SIGNATURE-----

--Sig_/TJwp64Ky.Ywe04n=0GrgnJN--
