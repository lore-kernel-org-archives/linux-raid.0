From: Jure Pecar <pegasus@telemach.net>
Subject: Re: What is the logic behind 'Device or resource busy' ?
Date: Tue, 27 May 2003 04:56:39 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030527045639.1e74abcf.pegasus@telemach.net>
References: <20030527015918.047bf247.pegasus@telemach.net>
	<Pine.LNX.4.44.0305261738440.19678-100000@q7.q7.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="pgp-sha1"; boundary="=.q2QC9TbTEfymPu"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0305261738440.19678-100000@q7.q7.com>
To: Joe Pruett <joey@q7.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=.q2QC9TbTEfymPu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 26 May 2003 17:39:45 -0700 (PDT)
Joe Pruett <joey@q7.com> wrote:

> i don't know the mdadm equivalent, but i do raidhotremove followed by 
> raidhotadd to get around that issue.  if you look at /proc/mdstat after 
> the failure, you'll probably see the drive is still part of the array, but
> 
> just marked as down.  raidhotremove tells the system it is gone and then 
> you can add it back.


hm yes... a failed drive is still present and has to be removed. makes sense
now, thanks.


-- 

Jure Pecar

--=.q2QC9TbTEfymPu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+0tPpOHUMrcOSg+8RAltoAKC6PChq3hoj0kyHNrBMx4L+tWauHwCgp4xs
UB4+I6GmlXMhEwbTILyj0Es=
=KvYb
-----END PGP SIGNATURE-----

--=.q2QC9TbTEfymPu--
