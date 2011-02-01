From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: RAID HDDs spin up sequence
Date: Tue, 1 Feb 2011 17:39:32 +0500
Message-ID: <20110201173932.2455a20f@natsu>
References: <20110131201823.GA15704@lazy.lzy>
	<AANLkTinPTaDfVtjMfz7DHUa95cKFF7MZeg=WhuuTnZM8@mail.gmail.com>
	<20110131222348.GA15912@lazy.lzy>
	<AANLkTi=gL3ATPN1+HHE+mhK7ZsM+aPyyQfVsz9Pq1Ajf@mail.gmail.com>
	<20110131230703.GA16834@lazy.lzy>
	<4D4765B2.7090002@cfl.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/RJJO6N3F8tTbFI7Mbn6=wSp"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D4765B2.7090002@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Roberto Spadim <roberto@spadim.com.br>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/RJJO6N3F8tTbFI7Mbn6=wSp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 31 Jan 2011 20:45:22 -0500
Phillip Susi <psusi@cfl.rr.com> wrote:

> If you want to force serial wakeup, you would need to do some hacking in=
=20
> libata or the scsi layer to only allow one wakeup request at once.  Of=20
> course, with a 6 disk raid where each disk takes 6 seconds to spin up,=20
> you will be waiting 36 seconds to get your data.  Not exactly desirable.

Well, if the other option is to have your system hard-reset because the PSU
overloads from 12-20-24 disks spinning up at once (you know staggered spin-=
up
is supported by disks/controllers for a reason), then the wait does not loo=
k so
bad.

My take on the problem: just don't spin down your RAIDs.

--=20
With respect,
Roman

--Sig_/RJJO6N3F8tTbFI7Mbn6=wSp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1H/wQACgkQTLKSvz+PZwihnwCfUZLy2kWJe6dPp3xPYuxZY1g/
BRIAoIe/xrjKMSThUehGSc6nvzFQbifK
=1vwx
-----END PGP SIGNATURE-----

--Sig_/RJJO6N3F8tTbFI7Mbn6=wSp--
