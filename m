From: Frank Wittig <fw@weisshuhn.de>
Subject: Re: md Grow for Raid 5
Date: Wed, 09 Mar 2005 10:31:49 +0100
Message-ID: <422EC285.50403@weisshuhn.de>
References: <676e074ffe5f52e6671aac5a2c14e984@case.edu> <422DFE60.5020807@weisshuhn.de> <422E1C6A.2000006@h3c.com> <422E31F3.3070104@panix.com> <422E3352.20002@h3c.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFDD7C8425D6C4AC20BF84439"
In-Reply-To: <422E3352.20002@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFDD7C8425D6C4AC20BF84439
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Mike Hardy wrote:

> You're very correct about needing to grow the FS after growing the 
> device though. Most FS's have tools for that, or there's LVM...
> 
> -Mike

I've tested with LVM2 an found, that resizing is not supported at the 
moment (newest kernel with FC3).
LVM can only grow by adding PVs to the VG. Growing PVs is not supported.
The only way is to export and reimport the VG configuration with 
vgcfgbackup and vgcfgrestore and to alter the number of physical extends 
of the grown PV manually.

Greetings,
Frank

--------------enigFDD7C8425D6C4AC20BF84439
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFCLsKFx6tzaD9P7mkRAgVkAJ9F1FZ7PnO+VZUAuythEY0nv8ErlwCfVRDf
tU7YACVfK7pNPbSOfhgqHqU=
=5Y3+
-----END PGP SIGNATURE-----

--------------enigFDD7C8425D6C4AC20BF84439--
