From: Frank Wittig <fw@weisshuhn.de>
Subject: Re: Questions about software RAID
Date: Mon, 18 Apr 2005 22:50:14 +0200
Message-ID: <42641D86.1030302@weisshuhn.de>
References: <1113853825.1483.34.camel@debian>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBF9085E8C8F32C525538C36B"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1113853825.1483.34.camel@debian>
Sender: linux-raid-owner@vger.kernel.org
To: tmp <skrald@amossen.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBF9085E8C8F32C525538C36B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

tmp wrote:

>2) The new disk has to be manually partitioned before beeing used in the
>array. What happens if the new partitions are larger than other
>partitions used in the array? What happens if they are smaller?
>  
>
there's no problem to create partitions which have exactly the same size
as the old ones.
your disks can be from a different manufacturer, have differnt sizes,
different number of physical heads or anything else.

if you set up your disks to have the same geometry (heads, cylinders,
sectors) you can have partitions exactly the same size. (the extra size
of larger disks won't be lost.)

read "man fdisk" and have a look at the parameters -C -H and -S...

greetings,
frank

--------------enigBF9085E8C8F32C525538C36B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFCZB2Lx6tzaD9P7mkRAsF1AJ9HDFiGxzMFSXBzrUKcZyhR6jIdoQCfWTVX
juGDIxZ1xjkCjrt7LpIXR9c=
=qRRF
-----END PGP SIGNATURE-----

--------------enigBF9085E8C8F32C525538C36B--
