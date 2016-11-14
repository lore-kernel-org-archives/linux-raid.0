From: NeilBrown <neilb@suse.com>
Subject: Re: Ddf based RAID management software
Date: Mon, 14 Nov 2016 16:48:49 +1100
Message-ID: <877f86k3we.fsf@notabene.neil.brown.name>
References: <CAPO=kN3xzv_MmbTSLT0bfxOpdZ+yvmybSXb6L-goBUasm+1NoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPO=kN3xzv_MmbTSLT0bfxOpdZ+yvmybSXb6L-goBUasm+1NoQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arka Sharma <arka.sw1988@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sun, Nov 13 2016, Arka Sharma wrote:

> Hello All,
>
> Is there any tool apart from mdadm available which can create software
> RAID based on Ddf metadata. We want to dump the metadata content and
> tally with metadata written by mdadm and our application.

Not that I'm aware of.
dmraid can read some ddf metadata, but I don't think it will create new
metadata.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYKVBBAAoJEDnsnt1WYoG5c5gP/0Hx6gjc26rdKXpzEzB6dv/n
2WJ+9g75JDyyAO7M/sGlLYoXyudfkyeUpJS64i8jZiuMsywOAmewbjwF31rZCYgJ
yGX5tfmxF/8ebA896rMqT31tycjPYqg6mpUN+pJrK2wlvLzYVPMlMEkwud1ltNVp
jR1IU/P3+T2rWrEGWhMsHWv1VKPJhouQsGywTQSZ6OH93aEJfp7Jxw/Ep5r+yj9o
AFGkxOk9EuC789EsRNONukRtXrtWdV1bjpf/KUV+B5+/ZzVvts/44T4n4waCLWx8
6UY9Y2xFqfEHV4s/Qr3CLa6fZCbtRHUSFc8ZZSHThqjlkBODdtnBTRlnyBVQLI+A
OE6bypITQl93LnuROfoMt5hxrNOK1yl0N8JDqnsqNnq4o9Wq8+iCbdUImlKdtzjA
YXdzc9WYLE0NtMUwqHOO6PziCIn3aynCeXSYWdvJHUyR3ltG5D3tmUQ8wMkH/mHN
Rv8fm700509ji+eldBWBOXOaQ2SuBISdt3/1ueI2atPp4ERWvpkgpak5l2ckuJJk
prc6yfMh8bkG2c/K74Y/C5JKMxOxSw7UxvSc1+Byl+e9XcME/+U3QfyX3Ijw7WQo
geDwl19RZP+drDNLkhlXt/WoqHAwXoMbo5xtRYbPcHDDiPiPuhL6pB8VEGrfkDTf
XG5A30BU75uOWjRSzp/S
=GeJi
-----END PGP SIGNATURE-----
--=-=-=--
