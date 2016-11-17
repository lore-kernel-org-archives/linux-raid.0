From: NeilBrown <neilb@suse.com>
Subject: Re: Just a thought - linux raid wiki - raid 5 grows getting stuck at 0%
Date: Fri, 18 Nov 2016 09:54:17 +1100
Message-ID: <878tshhg4m.fsf@notabene.neil.brown.name>
References: <582CF0E5.2030605@youngman.org.uk> <87inrmhbnh.fsf@notabene.neil.brown.name> <582D74F0.6080107@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <582D74F0.6080107@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 17 2016, Wols Lists wrote:

> On 17/11/16 06:18, NeilBrown wrote:
>>> > But I'm sure you can see from this that I'm updating this bit of the
>>> > wiki. Is there anything else I ought to know about bitmaps, so I can
>>> > document it? :-)
>
>> If only I could run "diff" between my brain and the wiki....
>
> :-)
>>=20
>> Thanks for doing this!
>>=20
>> NeilBrown
>
> I'll update the wiki in the next day or so.
>
> I'm a bit worried I'll spread myself too thin, but I've been following
> the threads on the recent patch sets, and I've also picked up on the new
> Sphinx kernel documentation stuff.
>
> So my aim now is, on top of generally updating the wiki, to link it in
> to the kernel doc, and update a lot of that doc using re-structured text
> in the md source files. That's not going to be a problem, I hope?
>
> I'm going to dig and find out more, but if anybody can point me to some
> kerneldoc code in the md source, and the corresponding links to the doc
> on the kernel.org website, that'll be wonderful. It'll just give me a
> leg up on the hardest part - actually getting started.

There is no kerneldoc documentation in md - just a few ad-hoc large
comments.
Even Documentation/md.txt isn't in very good shape.

I would be nice to have more documentation, but documentation can so
quickly become stale....

Thanks,
NeilBrown


>
> And if there isn't any at present, it'll just tell me it's needed even
> more :-)
>
> Cheers,
> Wol

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYLjUZAAoJEDnsnt1WYoG5OLEQALmedF+jU4Csod0rKywdurXG
B/pXT/vfPWnu2t01jsZwS7/R+Kq5SWIFQks5KlyErKSoXZ9+ZYmUDlhI+qfkWaFg
6yOZKDrgFydooKS5eLVS2o4DUgVaLlX1vAtUfVWbBaSeRKD2QdJDex8mABhNtdSE
mNEE+3zesZYbuT8oSoTyzx5GMCrvBP98OmvUUL+DC/2Tdg4O9A+msZsqYtAkC2O8
KiPsspNtcC9rzGKjbqpzkNEuskID5YTAr9FDlS9DJEvPcJhKEXRRcrA4Wpp2Taq0
LqH9oBMKhHq4QGzxGQcuqMXyfP7fYr8LMK5tR0wQO1OQJ0hi7Vw7zpwxfNf7A9D4
kFybmdKs5jioWEmUePrN634KukkQ4CyLegwemyTYuT60vH4XlUkAzSGTOLGVeE43
JSe9w4lZphzcyQsToRYXCKzHqnbKiPQfbNDhQeMHYCrG9N9kRGI+jh0VmTlfI+U4
eupep6e8qZwKGCcyUWPX8d7DiEDjrk7sHawBGWlGVeXKaxYuQP35W4YcOihluPsF
rmz7O+o5VJNfFv4XEwjq9iKlTM5HJdaS9wVUhrUU0hkLf9Lm4AQEpECMM17eU60V
eFiMAkzPkGrmvhiAKm40BFrTwSmVenfetdhcUzHzjcFujKPS+GlB/IbRHlZrVN5p
lNkiyjnRS/NLOwh3ZOu0
=T9sO
-----END PGP SIGNATURE-----
--=-=-=--
