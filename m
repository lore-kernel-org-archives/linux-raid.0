From: Frank Wittig <fw@weisshuhn.de>
Subject: Re: raid5 - failed disks
Date: Fri, 01 Apr 2005 12:33:46 +0200
Message-ID: <424D238A.8030305@weisshuhn.de>
References: <Pine.LNX.3.96.1050401015858.14428C-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEA90574B936889FABCA40120"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.3.96.1050401015858.14428C-100000@Maggie.Linux-Consulting.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alvin Oga <aoga@mail.Linux-Consulting.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEA90574B936889FABCA40120
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Alvin Oga wrote:
> hi ya raiders ..
> 
> we(they) have 14x 72GB scsi disks config'd as raid5,
> ( no hot spare .. )
> 
> - if 1 disk dies, no problem ... ez to recover

right. if one dies raid does exactly what is's supposed to do...


> - my dumb question is,
> 	- if 2 disks dies at the same time, i

if 2 disks fail at the same time you data is lost.
if you have raid5 with 5 hot spares and a second disk dies, befor a hot
spare is synced into the array (will be listed as spare until sync hast
finished) the same - data gone.


> - i think 4x 300GB ide disks is better ( less likely to fail ?? )

it's a simple calculation.
if one disk fails with a risk of 1 to 100000, then 10 disks fail with 10
to 100000. which means that having 10 disks is two times as dangerous as
having 5 disks.

if i had an array with as much disks as you have i would chose raid
level 6 (not sure if dm supports this by now).
raid level 6 survives two disks failing at once.

btw: what reason is there to switch off air conditioning of your it
equipment. temperature changes are poison to this fragile things.


greetings,
frank

--------------enigEA90574B936889FABCA40120
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFCTSOQx6tzaD9P7mkRAk2wAJ9XeRJGo9xk/t6+VY01naCpnApU2QCfS9ci
FLjap5JM2jdyRhO0FFPfgP8=
=lo75
-----END PGP SIGNATURE-----

--------------enigEA90574B936889FABCA40120--
