From: NeilBrown <neilb@suse.com>
Subject: Re: Implementing Global Parity Codes
Date: Fri, 02 Feb 2018 16:24:18 +1100
Message-ID: <87d11o2ccd.fsf@notabene.neil.brown.name>
References: <CACm9mdUJLczo8zSB5UfU9Fd_6VK3+sGCYJYdaEaX0qW1cMLtYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACm9mdUJLczo8zSB5UfU9Fd_6VK3+sGCYJYdaEaX0qW1cMLtYA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mostafa kishani <mostafa.kishani@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sat, Jan 27 2018, mostafa kishani wrote:

> Dear All,
>
> I am going to make some modifications to RAID protocol to make it more
> reliable for my case (for a scientific, and maybe later, industrial
> purpose). For example, I'm going to hold a Global Parity (a parity
> taken across the whole data stripe rather than a row) alongside normal
> row-wise parities, to cope with an extra sector/page failure per
> stripe. Do you have any suggestion how can I implement this with a
> moderate effort (I mean what functions should be modified)? have any
> of you had any similar effort?

In raid5.c the is a "struct stripe_head" which represents a stripe that
is one-page (normally 4K) wide across all devices.  All the data for any
parity calculation can all be found in a 'stripe_head'.
You would probably need to modify the stripe_head to represent several
more blocks so that all the Data and Parity for any computation are
always attached to the one stripe_head.

> I also appreciate if you guide me how can I enable DEBUG mode in mdadm.

I assume you mean debug mode on "md".
mdadm is the management tool.
md is the kernel driver.

mdadm doesn't have a debug mode.

md has a number of pr_debug() calls which can each be turned on or off
independently using dynamic debugging

https://www.kernel.org/doc/html/v4.15/admin-guide/dynamic-debug-howto.html

To turn on all pr_debug commands in raid5.c use

   echo file raid5.c +p > /sys/kernel/debug/dynamic_debug/control

to turn them off again:

   echo file raid5.c -p > /sys/kernel/debug/dynamic_debug/control

NeilBrown

>
> Bests,
> Mostafa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlpz9gIACgkQOeye3VZi
gbm1FA//U1ZJcsGFLhGqWZgeciO6qvBEgsDLwb0hJ2J/Dxiu9Wd2X1woWGsttnuK
qWl9IX0EqcUvAwpooTkrJMEqdnA2WvFZN5JIOJ9s4BDTnSW8g9ctTiRb1KOx6lBT
Yuv++WL0u5oaZAS1yY7ykvaBJpjqYDFOeo7bu9L40jJb8LzJ0iGdcJY5QUED0SAe
7Rx8Rbw3EwilXQSPpszMuJkj5791rvU+QuDuyTcIVO7TL/qGm8zkW5naFeC+j7rZ
KWE49DVvsjypz+BR8MrIJBXdlbx8FkgtIzh0MzJTvcJlqD7BD8+7uRucqXSOIw+w
m5lAMVZy20mBAYMfBO+FLKW0lgfrvit9cvu2Jt3agBf0yOe2o56S/vmmvuVIQiVa
Otu4Cn2ivzWQo2UZtR8ddc96nEegmLDrdAjHkv20uUPojOi+ePqp2tQRqZOjrlDF
tcVeqsMWX/1I5ddALP3kErMxfVrfpZHTgI7tY5kdvGW+FvBFSpfzfNkIwMnuThPP
u9dl5L95dl96AwrtFNmxUJZK2wYexywtkimcsA3dMewlH9sj+YVE9xeToiJ6uGBY
mZN3FwNlm+k42TBkneYZ+IIRxZkkQ51m7+/yFLoooKf2N3qIpTg6LAxjlikulLTw
G+EOvpe5014akJRJtY8Z+Rzp2+6Swh+BaWcZOw5G5Zpvogdt20c=
=VINW
-----END PGP SIGNATURE-----
--=-=-=--
