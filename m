From: NeilBrown <neilb@suse.com>
Subject: Re: Interesting mdadm quirk ...
Date: Wed, 11 Jan 2017 09:07:01 +1100
Message-ID: <87wpe2in7e.fsf@notabene.neil.brown.name>
References: <5870EB3F.2060206@youngman.org.uk> <87mvf1jhnu.fsf@notabene.neil.brown.name> <587334E6.406@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <587334E6.406@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>
Cc: jes.sorensen@redhat.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 09 2017, Wols Lists wrote:

> On 08/01/17 22:44, NeilBrown wrote:
>> On Sun, Jan 08 2017, Wols Lists wrote:
>>=20
>>> Just been doing some raid testing, and this happened ...
>>>
>>> linux-lfqf:/dev # mdadm md/parity
>>> md/parity: 31.97GiB raid5 3 devices, 0 spares. Use mdadm --detail for
>>> more detail.
>>> linux-lfqf:/dev # mdadm --stop md/parity
>>> mdadm: Cannot open md/parity
>>> linux-lfqf:/dev # mdadm --stop /dev/md/parity
>>> mdadm: stopped /dev/md/parity
>>>
>>> Weird - why can it successfully stop it when passed an absolute path,
>>> but not when passed a relative path? When I did the first variant, I
>>> used tab completion, and then when I edited it I really did edit it, not
>>> retype it, so I can't see any way the two arguments could refer to
>>> different objects.
>>=20
>> If you give mdadm a name of an array that start with "/", it is assumed
>> to be a path name (usually in /dev).
>> If it doesn't start with "/", then it is an array name.  The might mean
>> different things in different contexts, I'm not 100% sure.
>> However, for --stop, it a name like you would find is /sys/block or
>> /proc/mdstat.
>> So "mdadm --stop md0" or "mdadm --stop md_parity" might do what you
>> want.
>> Probably the error message could be more useful here.
>>=20
> Does that mean an array name can contain a "/"?

No, it cannot.

>
> Assuming it can't, surely it's better to alter the logic slightly...
>
> if char[0] ne '/' then
>   open array_name
> end
> if not successful then
>   open path_name
>   if error then go error_handler
> end
> carry on ...
>
> That way naive users like me won't get a surprise. And it is rather
> inconsistent for it to work with one sort of path but not another ...
> and actually that logic will work fine even if the name does contain a
> "/" :-)

If you can convert the above into a patch.....

I agree with your logic.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlh1WwUACgkQOeye3VZi
gbl+tg/+I526MLCqgetVymHF8jbuurLfKIGGNOxGpDA6cK/bqX9eaYeadt/C3sUb
Y9JohhJz1puuoGuwY2Y9cYKAfmazyvmCITK45v/FRPLf4e89n1fWcggDAaYBeM8K
gJ02Y+lvWc5/PRzMzMFZT7xhK2LhIFHWvB9VZgz66T4RAzxlE5Kd79wwtsPCh4E1
xApF1NwhRy1dEiRoTNh16akUsoRgPSgROSES8zGc64GaqP8Y8qMn/z2rsTNIkfzA
ZLa2DETuy6XirjwFKyOh4pQiTLkspvb9N9/PJsZV+jcq1nKo08hjAzwLRj43Fybz
B1bu6gFEDJjXsVBdYSTt3bRbuC54zhMkTUgNN9X0Iy2geUQcdwrbB8QdjPM0AHC1
oV0xrFiIjZr+aohEi3eBj1Jjx8ZsGD9AP7m6hpGegJ3oZacmZS4WLTcrw0p6qgu0
cR/dMMbixBTOQsh49JaE1roQiGabiscHnpo8VzwU/0ZJCmwh7tq8sdNYD96VMLrp
bdBBnxl5xt8E5xUnQqmNfUx99w1u5MtJUlQSSh578yPVCAOf3nDFOn8wxFzJdBYH
EHibbHwfqEYoOlEThlM7ZLQXnN6/gCMrn/l9uEbZcUXdn6uaY8rHhG4LhI5fqJoc
X6xqSv8U7Ra4WUe8VEbaAXfFZzHUlCYiLdi0FdspqajCepakiiY=
=JJSZ
-----END PGP SIGNATURE-----
--=-=-=--
