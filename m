From: Frank Wittig <fw@weisshuhn.de>
Subject: Re: RAID1: What happens when one half of a mirror fails?
Date: Thu, 30 Jun 2005 21:53:58 +0200
Message-ID: <42C44DD6.5060901@weisshuhn.de>
References: <200506301024.13126.eric@pretorious.net> <42C44210.7010204@gw.unix-scripts.info> <200506301215.39271.eric@pretorious.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDBBF29779CE457627C321775"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506301215.39271.eric@pretorious.net>
Sender: linux-raid-owner@vger.kernel.org
To: eric@pretorious.net
Cc: Laurent CARON <lcaron@gw.unix-scripts.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDBBF29779CE457627C321775
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Eric Pretorious wrote:
> On Thursday 30 June 2005 12:03 pm, Laurent CARON wrote:
> 
>>is the swap partition on raid?
> 
> 
> No. swap both swap partitions are formatted as standard swap partitions and mounted via /etc/fstab.
> 

That's no good idea. If a disk fails which contains a swap partition to
which data has been swapped the system will crash.
Therefor it is important to use mirrored partitions for swap.

--------------enigDBBF29779CE457627C321775
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFCxE3Zx6tzaD9P7mkRAt6zAJ4ka0SKecvf1kHbGTFtpQH0kct4IACdFIA5
sQJpFwEKVmo3PF0y99nSW8I=
=R6/k
-----END PGP SIGNATURE-----

--------------enigDBBF29779CE457627C321775--
