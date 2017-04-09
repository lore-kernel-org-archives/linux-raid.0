From: NeilBrown <neilb@suse.com>
Subject: Re: Can we deprecate ioctl(RAID_VERSION)?
Date: Mon, 10 Apr 2017 09:01:09 +1000
Message-ID: <878tn9yymi.fsf@notabene.neil.brown.name>
References: <wrfjvaqid9ih.fsf@gmail.com> <wrfjr316d6f5.fsf@gmail.com> <87h922trit.fsf@notabene.neil.brown.name> <070d7f50-c8f0-d5df-89ed-adb8b7582d8a@gmail.com> <87vaqhyx4i.fsf@notabene.neil.brown.name> <wrfjinmgqkjc.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjinmgqkjc.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid <linux-raid@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, kernel-team@fb.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Apr 07 2017, jes.sorensen@gmail.com wrote:

>
> Next question since I am wearing my 'what is this old stuff doing' hat.
> mdassemble? Does anything still use this? The reason is a lot of the
> newer features are explicitly included, and switching to sysfs is
> effectively going to kill it, unless it gets a major upgrade.
>

I was never a big fan, of mdassemble, but it is smaller than mdadm and
some people apparently have (or had) space-constrained boot
environments.
Maybe post to the linux-raid list with a subject "mdassemble is going
way, do you care?". ??

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljqvTUACgkQOeye3VZi
gbk46xAAwX9d6NO4ielb7rEcs8uZErO+v0aaQM5wGz56U9XJvRPgje9sO+pZZKBw
sX0sL5Eptvm1Oye0uNVKXOhQSf3LHQyfELCK+4fcsI+DzuQ+tTyaJ+SIWrQXRbaB
q9psBOyadmg10rYeYG65Vo3OZsBWoRJCdnp9mKqHJnYCNs3Zk2hUgDCO83L/FPRy
So1hO89dMBwUc0Zd39ym673ZOGohHw0SNexR1maRkhBbOx2LS2DwkHXR4IkI45wr
W2s/zMP57QLB3ZWOrQiXhWd77MCgqgXihIAAJqhmoyFDTmvQaoN20zoMpSvvj3Cq
OYshHCUz6+Vib+XUgsZJDrfjAcKHQHCcz84yDkR3ogrknyB4vwVQ28rt0fyItFw1
dF08i8z8Nx9A+utADdPmSvmn0wxjG5LUgyg0sNVhRW5R/SdTc3Xo3efF3ZAOMrCP
uyRo/Wm/FJ+CN3CXpDRzvPM2retbreXQkuRrBjJ/ZRaPsCsExowzcw3mykvytX0B
5Job13jpzvI+gFt+SD2ex2TiMWPp0yT2d+o4s6UJAgkVIgcMvhxbipOjLMRO2UVU
OKgca+Fbc0W1jtgJ0HvRYjdoAuPlL+TT/otKIqLFZBbG/7zIAj1zl/G2K4P60ik0
3+Md2svqaSN3B53ViEoOTYL2ic81cNxRWzd9LJ5MK82B9OJMKJw=
=+kTz
-----END PGP SIGNATURE-----
--=-=-=--
