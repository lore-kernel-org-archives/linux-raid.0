From: Roman Mamedov <rm@romanrm.net>
Subject: Re: mdadm RAID6 "active" with spares and failed disks; need help
Date: Sat, 28 Mar 2015 15:11:42 +0500
Message-ID: <20150328151142.11db8c9a@natsu>
References: <54ABEE54.6020707@sympatico.ca>
	<BLU436-SMTP156F9ECC68035EAC3DFB5F181460@phx.gbl>
	<BLU437-SMTP96782B2C74C634FDED13D681420@phx.gbl>
	<54B305B2.6000702@lentijn.sess.ink>
	<54B3F7ED.1000809@youngman.org.uk>
	<BLU436-SMTP1430CA88C11B0E46F15BB3F81480@phx.gbl>
	<54C0C73A.4080409@lentijn.sess.ink>
	<BLU437-SMTP28725520E940DA3707A62F81090@phx.gbl>
	<55160B0A.1090405@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/==FRAZAWW+=gYGdH0cXCU+r"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55160B0A.1090405@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Matt Callaghan <matt_callaghan@sympatico.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/==FRAZAWW+=gYGdH0cXCU+r
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Mar 2015 21:59:38 -0400
Phil Turmel <philip@turmel.org> wrote:

> I read through this.  Given all of the destructive actions you took, I
> am doubtful you will ever get your data.  Like mounting "readonly".
> That gives you a readonly filesystem, but it writes to the device.
> Possibly a great deal if there's a journal to replay.

Are you sure, which FS does that? I remember some discussion on FS lists
(Btrfs?), and IIRC the consensus and the implemented behavior was that the
device shouldn't ever be touched with writes on RO mounts, no matter what.

--=20
With respect,
Roman

--Sig_/==FRAZAWW+=gYGdH0cXCU+r
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlUWfl4ACgkQTLKSvz+PZwgmlgCfVPlCv2mrREqb/lN81EsjCd3U
5hYAninqyEWX2RpP9m2Du6dMZNl0C/JY
=5EVy
-----END PGP SIGNATURE-----

--Sig_/==FRAZAWW+=gYGdH0cXCU+r--
