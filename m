From: NeilBrown <neilb@suse.com>
Subject: Re: Reducing the number of devices in a degraded RAID-5
Date: Fri, 26 May 2017 15:13:11 +1000
Message-ID: <87d1awgpzs.fsf@notabene.neil.brown.name>
References: <20170522125332.GA18406@metamorpher.de> <87h90bhujz.fsf@notabene.neil.brown.name> <20170525072436.GA24881@metamorpher.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170525072436.GA24881@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, May 25 2017, Andreas Klauer wrote:

> On Wed, May 24, 2017 at 12:12:32PM +1000, NeilBrown wrote:
>> What does work is:
>>  # start with a degraded array, device 0 missing
>>  mdadm --grow /dev/md42 --array-size=3D.....
>>  echo frozen > /sys/block/md42/md/sync_action
>>  mdadm /dev/md42 --add /dev/loop0
>>  echo 0 > /sys/block/md42/md/dev-loop0/slot
>>  mdadm --grow /dev/md42 --backup-file=3D... --raid-devices=3D4
>
> Wow. Thanks.
>
> This should merge Step 1+2, but not Step 3, right?

Right.  Doing step 3 at the same time is not possible.

NeilBrown


>
> I really need to take a closer look at the things in /sys/.../md/...
>
> Seems like you can do great things with it... terrible, yes, but great.
>
> (
>   Step 3 would be turning slot 4 to-be-spare into slot 0,=20
>   without --add ing another device at all.
>
>   That's what would happen if /dev/loop0 was actually backed=20
>   by and thus identical with the slot4 device.
>
>   But that's playing dirty.
> )
>
> Regards
> Andreas Klauer

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlknuWkACgkQOeye3VZi
gbmXWA/+NPGrG6Z91D03PXGeHLHoOKnHvmXTInI0aHiAroD0nXZKvbnZcuC1RsI9
qA5yYU6saw5hs2B8WY0aEvoj/PYcL/LYayE3pPJLKDVV+MLTVqAJYFVMHrapn1XG
IvGTR9X7pjoj7BMOkpBNuvpZlvrdCdC0ozW6im87bgvFJlUq7bl1ATlRVS7vUsEn
S8XPF8Fl2xaQe7cedWF8TY1FUaF5e7C53KjzgNURCjjFS3io3EUKkNqYL73BIbw0
KTyqEgdg+up1CUhSUWg9ItNux1u5TseqzaUeUtyFOKbtH8jAgu/BSxSNDFlrR/CC
e0yPHIhuPPgLQnCcfOkj+9aYKlv9ReXDm35LWy9JKDfNYJ18tjyfZGBtp5cqfMIq
cmN7GAV88XcN1clE2b5iF/q62r8RBWFMTjd/uP6QUZDtJHrsqWB+ulxB/d5i9fDZ
q5DaVfLt4X//HqgkZcHJg+IbuqUvzi6d/7x6UsjAQcAVdFmktl/oL1KS1BUJy6ix
KflTi1F2UizFySSp+b07HjBACeIocSLzpaeq8OJ0cXLCzcpuhmfZfIqvvmlw8SLc
mRJnO+7jF0yTKjuw/tHojf1qFW4B6gPfg7nHLeeGelhnCf53PzO0BHa/leV7ugBx
rruEXpHZr8XepGU4VTq6fJVncFDCtf0Bq5o3soTvokG3qF5ZJpk=
=TN3c
-----END PGP SIGNATURE-----
--=-=-=--
