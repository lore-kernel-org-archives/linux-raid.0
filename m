From: NeilBrown <neilb@suse.com>
Subject: Re: mdadm --misc --readonly -> ENODEV indefinitely
Date: Mon, 29 May 2017 06:20:35 +1000
Message-ID: <877f10hgx8.fsf@notabene.neil.brown.name>
References: <87y3th2rdu.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87y3th2rdu.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sun, May 28 2017, Nix wrote:

> So I was trying to flip on the RAID journal now I'd fully populated my
> array and cut over to it. So, from early userspace, I did
>
>    # first line done by initramfs scripting
>    /sbin/mdadm --assemble --scan --auto=md --freeze-reshape
>    mdadm --misc --readonly /dev/md/fast
>    mdadm --manage /dev/md/fast --add-journal /dev/ssd1
>    mdadm --misc --readwrite /dev/md/fast
>
> This did not work as planned, or indeed at all. After the first
> --readonly, all requests for /dev/md/fast report "No such device or
> address" until a reboot, though /proc/mdstat says the thing is still
> there and /sys/block/md125/dev reports no change in major/minor numbers.
> (I don't have udev in my early-userspace environment, but mdev reports
> no change, either.)
>
> It's a bit hard to do anything else after that, like, say, turn the
> journal on.
>
> ... maybe an mdadm --assemble --scan --auto=md --readonly in one go
> would work better, rather than starting with the default (?read-mostly?)
> and flipping it? I'll give that a try later.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Commit: 065e519e71b2 ("md: MD_CLOSING needs to be cleared after called md_set_readonly or do_md_stop")

Broken in v4.9-rc1
Fixed in v4.12-rc1

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkrMRUACgkQOeye3VZi
gbkj2BAAr4uKN2yufTUAM3KS2JZs7q9eWopayegxDiGrkjO5lLh99UlJGD5L2d44
NOT90PMKcttv/pxK5QPNEHzP3qXWXjP9p9f+8lF+AZwSEsLuEFcEoBs/vJMUE0Mq
UV8zBk4SYtCKuAy1uWf7tqoKOZ9+oP/y9yYqBS1uYtQ4a+t7ugL1Y4ZX/YCfgVTw
XRlnFTrMFfcbEfko5jWmxTg42cMjf525O5/ZoBoGAtt20RFk/TqwiusG7fMIJNMF
lZdSndNuxkaUp92dQlU/rx7ASnqGBlRIPKUDp86sRwuqeDaQYmyUG8kcZtkB9xRy
VKhvA8Xnx4iumSWdZut4lT29D4ZqTbebPrV0KEacLgH1ruWUzk+38Z7ZfSykD213
nybZIGntHfaVDbi/VxdAaCKrMzQtgkM0j/gbA+MaP/U/qo1BQTwOEm2ldJghZx+I
comqfRTTHwRw0d/Y1wL7Apg+ATDn7Oys23NMATu6oqNEMh/u/+oL2pY/tQINsJ9h
5fstGgXvM5EW2IqeIrQAqHnNQkAkNbB85qu3yyyo2C8vGRpjQWIyJx16PrQKJ44c
pE5X93cLLC2HAtuDR/pOhWPL8K3rnwYyMrIyJ24WJ+oKHnsobI8E0qDXw7LOj9dd
vxK02uzrKaBKjnAfuifR2eUs4s0AFjTvhwEUd8EBC8KFSg4xU/s=
=5c1K
-----END PGP SIGNATURE-----
--=-=-=--
