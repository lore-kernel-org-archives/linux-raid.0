From: Andy Smith <andy@lug.org.uk>
Subject: Re: RAID-10 with odd number of disks (was Re: Software RAID 0+1 with mdadm.)
Date: Thu, 27 Jan 2005 17:27:00 +0000
Message-ID: <20050127172700.GN82728@caffreys.strugglers.net>
References: <20050127161927.GK82728@caffreys.strugglers.net> <200501271714.j0RHEa911050@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qjGvC0f9mZqYBGXn"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200501271714.j0RHEa911050@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--qjGvC0f9mZqYBGXn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 27, 2005 at 12:16:31PM -0500, Guy wrote:
> It rotates the pairs!
> Assume 3 disks, A, B and C.
> Each stripe would be on these disks:
> A+B
> C+A
> B+C
> A+B
> C+A
> B+C
> ...

Hmm, difficult to visualise and comprehend if there are any
differences as opposed to "normal" RAID-10.

Is this anything like how RAID-1E works on IBM ServeRAID?

--qjGvC0f9mZqYBGXn
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (FreeBSD)

iD8DBQFB+SRkIJm2TL8VSQsRArDLAKDjc3QAYi1e27yxLrviAkkkr40FSACfVFG0
cXlPY+toFlcBu8zFrJGnEJI=
=Uekp
-----END PGP SIGNATURE-----

--qjGvC0f9mZqYBGXn--
