From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: Debugging a strange array corruption
Date: Tue, 14 Dec 2010 14:22:46 +0500
Message-ID: <20101214142246.20c927e1@natsu>
References: <4D07265F.8060109@wasp.net.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+OPcHki7SC84nUnvhJnweI9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D07265F.8060109@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/+OPcHki7SC84nUnvhJnweI9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Dec 2010 16:10:07 +0800
Brad Campbell <brad@wasp.net.au> wrote:

> The drives are all on separate channels. 8 are on a pair of Marvell 88SX7=
042
> controllers and 2 are on a SIL3132. This has occurred since I upgraded the
> mainboard (and kernel at the same time - nothing like throwing more
> variables in the mix) and its effects were subtle enough that I missed th=
em
> until it had successfully rotated out all of my good backups with broken
> data. Lesson learned.

I'd suggest that you try moving two disks away from SiI3132, change your
setup so that at most ONE port on that controller is used, or none at all.

Some time ago there was a report of data corruption with controllers using
that chip when both ports simultaneously read at full speed:
http://forum.ixbt.com/topic.cgi?id=3D11:35147:1200#1200 (in Russian)
Perhaps problem not in the chip itself, but in some variations of
schematics/components/soldering, because only two of five supposedly identi=
cal
boards the reporter bought were corrupting data in that way, one much
more often than the other.

--=20
With respect,
Roman

--Sig_/+OPcHki7SC84nUnvhJnweI9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk0HN2YACgkQTLKSvz+PZwimtACcDc+vL3lzCo/B2aH/9azPFE6O
GfIAn3ucce9ZHvBtjkH7VKgP++ColOje
=GBqx
-----END PGP SIGNATURE-----

--Sig_/+OPcHki7SC84nUnvhJnweI9--
