From: Frank Wittig <fw@weisshuhn.de>
Subject: Re: RAID1: What happens when one half of a mirror fails?
Date: Thu, 30 Jun 2005 20:20:28 +0200
Message-ID: <42C437EC.4030508@weisshuhn.de>
References: <200506301024.13126.eric@pretorious.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF0B8B428F78E2BE97A82F6F8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506301024.13126.eric@pretorious.net>
Sender: linux-raid-owner@vger.kernel.org
To: eric@pretorious.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF0B8B428F78E2BE97A82F6F8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The RAID1 should allow the system to opperate as usual until the drive
is replaced. I replaced 2 hot-plugable disks (both part two RAID1 which
were both parts of a RAID0) on a dell poweredge server this tuestay
without even rebooting.
If your disks have EEC there should be a minimum risk for failure of a
degraded RAID1.

Eric Pretorious wrote:
> Hello, All:
> 
> I've been a bit surprised by the complete failure of our system when one half 
> of a mirror failed so I suppose that I should verify that I understand 
> RAID1's failover methodology: Is the purpose of the mirror only to preserve 
> the data or is it to allow the system to continue operating until a 
> replacement can be installed? (i.e., If one half of a mirror fails, shouldn't 
> the system continue operating normally?)
> 


--------------enigF0B8B428F78E2BE97A82F6F8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFCxDfxx6tzaD9P7mkRArbgAKCCYwPvO0WWWn6/5t4837yWo7jrWwCggrgS
nUh1sdNBtEsFI/2rUeV00y4=
=JW2z
-----END PGP SIGNATURE-----

--------------enigF0B8B428F78E2BE97A82F6F8--
