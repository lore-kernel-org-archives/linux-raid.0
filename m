From: NeilBrown <neilb@suse.com>
Subject: Re: GET_ARRAY_INFO assumptions?
Date: Fri, 21 Apr 2017 07:49:31 +1000
Message-ID: <87k26esqac.fsf@notabene.neil.brown.name>
References: <ab07d303-85fb-e912-e4fa-9ee66a1277cc@gmail.com> <20170413203742.wg6mrnzedw7ew5ky@kernel.org> <0c3633e4-df8c-c59a-17d4-917495931ba1@gmail.com> <c0a29266-fdf4-2f07-aabd-6aa1f55d7d46@gmail.com> <87k26itx2v.fsf@notabene.neil.brown.name> <59ca76c6-1f1f-4d9c-4eb9-d468131e0d55@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59ca76c6-1f1f-4d9c-4eb9-d468131e0d55@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 20 2017, Jes Sorensen wrote:

>
> I think I got it right this time and pushed it into git. It made things=20
> a lot prettier too IMHO :)
>
> In the process I also changed the behavior of=20
> sysfs_read(GET_ARRAY_STATE) as I really didn't like how it was copying=20
> in the string rather than parsing it.
>
> I am traveling at the moment and don't yet have my new raid test box=20
> setup back at the office, so my testing is limited. If I broke something=
=20
> badly, feel free to throw rotten tomatoes at me.
>
> Cheers,
> Jes

Looks good to me, except...

	/*
	 * Beware map_name() uses strcmp() so active-idle must come before
	 * active, to be detected correctly.
	 */

???
If map_name() used strncmp() you might need to be careful, but not with
strcmp.
Also:

int map_name(mapping_t *map, char *name)
{
	while (map->name) {
		if (strcmp(map->name, name)=3D=3D0)
			return map->num;
		map++;
	}

	return map->num;
}

Both returns do the same thing... so there should (could) just be one.
is:

 while (map->name && strcmp(map->name, name) !=3D 0)
 	map++;
 return map->num;

too terse??

I do like that you could use map_name to parse the array_state file.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlj5LOsACgkQOeye3VZi
gbkAUw//QfLxYvA2UP19IJVLSp8iWHWJxmCybe0MsG6EXLTwf25lZR3b1r7RXMv6
GsSJf6NJtaAiE9yIzjpIXBC1eWO+fCfgYMbCujZ9pXYHNmK+nwGmToa/adX3j5I3
JyHwW05CMZ2nFGbjsXLmKKrVmXjqqNAinP/o4If70zfLlfnHuH/JMqsgn79FeHTe
cdYCSTKXJcTFjC3VKeqAo5baGbE98JCxE7lHdrT0IdTEslfkNAh0yYhWeuDRyiHn
R8dzbAURaWR3XcVCbTtNSEAK6mSSRWPXYx16l2/r5xOG/ezheNvCgOMuFj/Pbwd9
r6BC1LJE9HU2ZTlqg+esdZVwPn6uDdOobN9CHYlV2+5o82FgCL9/vjaJUs6QqQag
JIdxRH6iumFnVqH2ODnywAA8IIU+BxAPqzUDYQL4L0rRcWgOEQ0QL4ACC3/LnPt/
4BU4rvLTZowJr03d7i3J4YCorH9LIDgyyZAcH52sugqLGwEeNchgXpLmRiXw7vdD
OCN0WLWups4O10z7Dl3qtg2oTgXykmDIwe0Dsa3nc4UqRQOUscfZL2lgZ59TJrrx
98mrzs3JqDvDna/7Kb6R61mUwzY4irEEnQocHyH1GQhJKrXW4mXKSR9tdQr+EWl7
kX2DWIqj3pXB5ArqRgFgDyob4vgUqgPuuWXH636k91SaQVBxQZQ=
=TvE/
-----END PGP SIGNATURE-----
--=-=-=--
