From: Cyril Bouthors <cyril@bouthors.org>
Subject: Re: Unable to handle kernel NULL pointer dereference with 2.4.27
Date: Tue, 30 Nov 2004 15:48:06 +0300
Message-ID: <87fz2r4i61.fsf@wide.bouthors.org>
References: <87653oimzy.fsf@wide.bouthors.org>
	<16811.50295.566088.579804@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16811.50295.566088.579804@cse.unsw.edu.au> (Neil Brown's
 message of "Tue, 30 Nov 2004 11:53:11 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=

On 30 Nov 2004, Neil Brown wrote:
> No.  The reference to raid0 is purely accidental - the offset into
> raid0 that is mentioned is -235378 : a negative number !!!!

Sorry about that.

> I suspect that it is a filesystem problem.
> I recommend reporting the problem to linux-kernel@vger.kernel.org
> and mentioning what filesystem you are using.

I will.

Thanks.
-- 
Cyril Bouthors

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBBrGwGZ1SJHeqsYt8RAoIVAKC1LzQ72jtVgcEyBovzb92Z9wcZoQCgoQtB
0qBsS25ihXSxDy6gflE/Q2c=
=dHSZ
-----END PGP SIGNATURE-----
--=-=-=--
