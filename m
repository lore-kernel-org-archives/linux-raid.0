From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Raid check didn't fix Current_Pending_Sector, but badblocks
 -nsv did
Date: Tue, 7 Jun 2016 10:35:31 +0500
Message-ID: <20160607103531.561755d2@natsu>
References: <20160606174113.GI12382@merlins.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/ZbFHwHsgxnhuqR.5GT6iP_V"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160606174113.GI12382@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/ZbFHwHsgxnhuqR.5GT6iP_V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Jun 2016 10:41:13 -0700
Marc MERLIN <marc@merlins.org> wrote:

> However after the check is over, I still have 29 Current_Pending_Sector on
> that drive.

I had that once, even asked on this list (can't find that now), and it turn=
ed
out the pending sector(s) were in the gap between the start of the partition
and the start of the mdadm actual data (which turned out to be surprisingly
large) -- so naturally neither a check nor repair have ever tried to read or
write there.

> More drive details from before I ran badblocks  (not an SMR drive):
> Device Model:     WDC WD40EFRX-68WT0N0
> Serial Number:    WD-WCC4E0642444

At least if it's out of warranty, consider checking the contact pads unders=
ide
the drive PCB and cleaning them. AFAIK the WD drives in particular are know=
n to
develop rust there, which can lead to all sorts of problems including trans=
ient
"pending" sectors like that.
https://www.youtube.com/watch?v=3DqmT32VC22PU
https://www.youtube.com/watch?v=3DtDTt_yjYYQ8

--=20
With respect,
Roman

--Sig_/ZbFHwHsgxnhuqR.5GT6iP_V
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAldWXScACgkQTLKSvz+PZwiyZQCfdBjZI0uhzv70XY4+Kf5o4FIK
GZIAn3kpmBPKElvI1zjggX91fixXUFxb
=e+Wz
-----END PGP SIGNATURE-----

--Sig_/ZbFHwHsgxnhuqR.5GT6iP_V--
