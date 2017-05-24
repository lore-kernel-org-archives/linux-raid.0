From: NeilBrown <neilb@suse.com>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on md_attr_store / raid5_make_request
Date: Wed, 24 May 2017 11:50:17 +1000
Message-ID: <87mva3hvl2.fsf@notabene.neil.brown.name>
References: <87lgppz221.fsf@esperi.org.uk> <87a865jf9a.fsf@notabene.neil.brown.name> <87o9ukykmk.fsf@esperi.org.uk> <592336E6.8080906@youngman.org.uk> <87y3toic67.fsf@notabene.neil.brown.name> <59244B95.4080600@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59244B95.4080600@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Nix <nix@esperi.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, May 23 2017, Wols Lists wrote:

> Thanks. I've updated the section. I've taken pretty much everything
> you've said, but rewritten it in my own words, so that the page remains
> consistent in style. I hope I haven't missed anything.
>
> It's thrown up two little points I've noted on the page - if a v1.0
> mirror has its offset changed, does this break the linux boot? (that's
> the "without an initramfs" boot that doesn't assemble the mirror until
> after the kernel is running).

Yes, if a v1.0 has a data offset that wasn't zero, you wouldn't be able
to boot of a member device.
But there is no good reason that I can think of to change the data
offset of a device in a RAID1.

>
> And if you shut down cleanly during a backup-file reshape, is this fact
> noted or does mdadm just assume any shutdown is dirty and use the backup
> file anyway?

The backup file contains UUID and version info.
When mdadm determines that part of the backup is no longer needed, it
invalidates the backup before enabling writes to that region of the
array.
So it only uses the file is there is good reason to suspect that it is
both necessary and safe. (It may not always be necessary.  It should
always be safe).

NeilBrown


>
> Cheers,
> Wol

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkk5tkACgkQOeye3VZi
gblogxAAqqJSiGHz/i6jR44Hs7wFcgZrXFppxQ0EuzWi25+WZyyTtE0PlfsElGdv
IMuLKLFvM6z4qao4zd8Bvk0wILBdmZjOf4arS14dIh2nOlM/bQ+8140Z26w55a01
LwCVwu9Jxyzq7XnR75S5KX3WcoauCsCgw7rwrp96eHE/axgKCnYArONpl/Ji0VZB
WpF6ZQ2ej/k3yYvuMYOOef94bBAd+7jPRIMBacE9CrDee+WX63P4sxb0es4vJjok
QVacCY1b4iGiS8fEa3pHCVHaAZjj9CURqXUWnmAFz9lW6hzTsz7lbiTZef4Z74LX
vavwR8xLnwLe3AFx+XP8pOrH/KEkikiyZ719SzbnGuH4t8Kbg54VnZaFI8krIc5L
/4WFbiSuSIu5tErkQjK6jKLn7DvCBsen8Ss4kcH6p6yHu64bomi8elgSB6FmfH9S
q3I1p9MReZdYNZy436O3v8qnjuNQ5TKPO7bPOuNqpK+uL5xXsvWB58g6drc0xLQ5
Qhcnf8m9wXAAvH4qVL/AtBfl4Mb+LP8aBdCvL6gjFL7IREUExQh5rDJtiPQU2UnN
GT1srWWAJUNgBdzWrsIRL8nGebg/08drP/Y96/BhrpJciAP1nOoOChFjYYrGc/NE
T9/C5QuhumaH/bHXqnC02oj6hvs0zG2b914i6fbm1zjWVmmB978=
=SwbX
-----END PGP SIGNATURE-----
--=-=-=--
