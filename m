From: Andy Smith <andy@strugglers.net>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 10:04:11 +0000
Message-ID: <20050105100411.GY99565@caffreys.strugglers.net>
References: <20050104024108.GK99565@caffreys.strugglers.net> <895qa2-0qa.ln1@news.it.uc3m.es> <200501042002.32292.maarten@ultratux.net> <j6dra2-9vs.ln1@news.it.uc3m.es> <41DB127F.3090303@wasp.net.au> <qukra2-s1j.ln1@news.it.uc3m.es> <41DB7EB7.4090404@wasp.net.au> <4umsa2-c9q.ln1@news.it.uc3m.es> <41DBB012.5040308@wasp.net.au> <ljosa2-lg.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nrCuQK91QKw8CgBg"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ljosa2-lg.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--nrCuQK91QKw8CgBg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 05, 2005 at 10:28:53AM +0100, Peter T. Breuer wrote:
> If you do an md5sum on file contents and compare with a previous md5sum
> run, then it will be detected provided that the error occurs in a file,
> but assuming that your disk is 50% full, that is only 50% likely.

"If a bit flips in the unused area of the disk and there is no one
there to md5sum it, did it really flip at all?"

:)

Out of interest Peter could you go into some details about how you
automate the md5sum of your filesystems?  Obviously I can think of
ways I would do it but I'm interested to hear how you have it set up
first.

--nrCuQK91QKw8CgBg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (FreeBSD)

iD8DBQFB27ubIJm2TL8VSQsRAoeOAKCc0e5vuGWEannnL2xSgEY8nGWjbQCfaL36
PeTye+AJF3JXo4R9IWWdACI=
=M4qt
-----END PGP SIGNATURE-----

--nrCuQK91QKw8CgBg--
