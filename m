From: Johannes Truschnigg <johannes@truschnigg.info>
Subject: Re: Do I have a bad HDD?
Date: Sun, 31 Jul 2011 20:25:42 +0200
Message-ID: <4E359E26.2080500@truschnigg.info>
References: <CADNH=7HDCwtUr-HSN7fH_GSH8jTYb-SAwmKY0ZRn3opWAhKiBQ@mail.gmail.com> <CADNH=7EJ7tvw2DEsAbeuxxRO1k961RSV4axgvfRUBaKG+Q455Q@mail.gmail.com> <CADNH=7EHAyk7Z7Wa72XO=p1od6AQP5aew_W5DffgLfZeCu=d-g@mail.gmail.com> <CADNH=7F3CVZ6r56jFrSHoVyzOZTHCfXPE_j-Rn8powbB6BLBYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig348CB1EF933B20A8866017F9"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7F3CVZ6r56jFrSHoVyzOZTHCfXPE_j-Rn8powbB6BLBYQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig348CB1EF933B20A8866017F9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Mathias,

PLEASE don't always quote everything you've just written a few minutes
ago when replying to yourself. This makes these responses really, really
inconvenient to read.

Concerning your problem at hand: Don't panic, everything should be fine.
Your RAID did what it is supposed to do: protect your from a single
drive failure without inducing downtime. A disk has failed, and now it's
time to replace it, that's nothing out of the ordinary. You don't need
to shut down your system - RAID systems have "no service interruption in
case of an accident" as a design goal, and md is rather good at meeting
just that.

If your SATA controller supports hotplug (and if it's SATA-300, that
much is for certain), just unplug the old drive, replace it with a new
one, clone your partition table setup (if any) from an old driver to the
new one, have md pick up the disk and integrate it into your array, and
see how everything'll be taken care of automatically. md will resync the
array once the new disk is part of the array, and it will be smooth
sailing again afterwards. Just make sure you don't pull out the wrong
drive, but correctly identify the broken one. ;)

While the array's being worked on, you can do whatever you intended to
do with your seemingly healthy array from of a few hours ago - the only
difference it that (some) things will go slower, but that's about it.
The only serious problem you could run into is a second and third
harddrive failing while your array isn't 100% OK again yet - but even in
that case, you'd have a backup ready, now wouldn't you? :)


--=20
with best regards:
- Johannes Truschnigg ( johannes@truschnigg.info )

www: http://johannes.truschnigg.info/
phone: +43 650 2 133337
xmpp: johannes@truschnigg.info

Please do not bother me with HTML-eMail or attachments. Thank you.


--------------enig348CB1EF933B20A8866017F9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk41nioACgkQnnUApj8OcoIUlgCffz/vK2wb3RUxrmQlffRyfGpo
/QkAnAiQ5To3XSHGe8BT7kIvFDSp723u
=Uv9J
-----END PGP SIGNATURE-----

--------------enig348CB1EF933B20A8866017F9--
