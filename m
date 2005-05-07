From: Sam Varshavchik <mrsam@courier-mta.com>
Subject: mdadm oddity.
Date: Sat, 07 May 2005 19:33:36 -0400
Message-ID: <cone.1115508816.149032.5308.500@commodore.email-scan.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
    boundary="=_mimegpg-commodore.email-scan.com-5308-1115508816-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.

--=_mimegpg-commodore.email-scan.com-5308-1115508816-0001
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

I noticed a slight oddity on one of my servers: when I start "mdadm 
--monitor --scan" I get only the "NewArray" message.  On the other server I 
get a "NewArray" then a "SparesMissing" message, for each RAID partition.  
Neither server has spares.  Both servers have a pair of SCSI drives in a 
RAID-1 configuration for all of the partitions.

Well, the real oddity is actually that the other server only reports a 
NewArray -- because I see in the ChangeLog mdadm is _supposed_ to report 
both NewArray and SparesMissing.  But until I turned up the second server I 
only ever got NewArray from mdadm, so that was something new.

Investigating this I discovered that I get a SparesMissing message if I 
explicitly enumerate all my RAID partitions in mdadm.conf (mdadm 1.5.0).  If 
I don't list my partitions in mdadm.conf, mdadm still finds them, but then 
reports only a NewArray message.  Does that sound right?



--=_mimegpg-commodore.email-scan.com-5308-1115508816-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBCfVBQx9p3GYHlUOIRAsh5AJ9QknBTIVK6YCyHyrLv/ujdWlkpSACfQUWu
R3AZTAsIIMRLtSXUT10Y29k=
=QiG2
-----END PGP SIGNATURE-----

--=_mimegpg-commodore.email-scan.com-5308-1115508816-0001--
