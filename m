From: NeilBrown <neil@brown.name>
Subject: Re: [neilbrown/mdadm] Add udev-md-raid-safe-timeouts.rules (#32)
Date: Fri, 03 Nov 2017 17:37:31 +1100
Message-ID: <87h8ubsw9g.fsf@notabene.neil.brown.name>
References: <neilbrown/mdadm/pull/32@github.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <neilbrown/mdadm/pull/32@github.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


This pull request appeared on my github mdadm ... thing.

I haven't looked in detail.  If someone would like to review it
or something, that would be nice.

Thanks,
NeilBrown

On Fri, Nov 03 2017, jonathanunderwood wrote:

> These udev rules attempt to set a safe kernel controller
> timeout for disks containing RAID level 1 or higher
> partitions for commodity disks which do not have SCTERC
> capability, or do have it but it is disabled.
>
> No attempt is made to change the STCERC settings on devices
> which support it.
>
> This attempts to mitigate the problem described here:
>
>     https://raid.wiki.kernel.org/index.php/Timeout_Mismatch
>     http://strugglers.net/~andy/blog/2015/11/09/linux-software-raid-and-d=
rive-timeouts/
>
> where the kernel controller may timeout on a read from a
> disk after the default timeout of 30 seconds and consequently
> cause mdraid to regard the disk as dead and eject it from the
> RAID array.
>
> The mitigation is to set the timeout to 180 seconds for disks
> which contain a RAID level 1 or higher partition.
> You can view, comment on, or merge this pull request online at:
>
>   https://github.com/neilbrown/mdadm/pull/32
>
> -- Commit Summary --
>
>   * Add udev-md-raid-safe-timeouts.rules
>
> -- File Changes --
>
>     A udev-md-raid-safe-timeouts.rules (61)
>
> -- Patch Links --
>
> https://github.com/neilbrown/mdadm/pull/32.patch
> https://github.com/neilbrown/mdadm/pull/32.diff
>
> --=20
> You are receiving this because you are subscribed to this thread.
> Reply to this email directly or view it on GitHub:
> https://github.com/neilbrown/mdadm/pull/32

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAln8Dq0ACgkQOeye3VZi
gbmSKQ//VdE16Jyc+lfLjzyV3jNQUN2JTU53qCgBVxuro5S/PoqeP583ihyfXf6y
MDkhVNR7UDZ4sPHLijkhdNc2KAMWsbWjsWQQliBMACNb+ss1rG1QOslSCJqOAlo0
eNr7kOKirjwcGJE3kf+4zOSzNQWsasXj0OWbuWMj5fkBM6EeSiLHi3RB94ZaYqGl
GIGgZbuCFWANBgVRa7HLKh8lGo7oNbYHcwLTfGuOR9VRZcjfbAPh4jW7tjX5JYaG
ugiCbxr+6XzIIMSHT9lXUuDS/tQAGDn00rCtyRNa66vS3qNR8IV++2XbFrfSOuKj
wCJsOnVHUmvSjTOtML9DpBLNwjeXW2dMEqcxr7TpzFBjT+yxmVz1eP9ezzGZ5IUf
EWPNjThr4iHgRP17yPeRjN2YgQHx8QRvsh9LF2sbL1GlZv1L27wRytRIPXH7oALp
ReC7IN9s56p5UQADfuDI293t3U1PdJIxvp4lt67G5QEJVaI7nV1sc7eY76ygeU1n
phaosSDnyL0t5MKn+zACHCsIfgNXm7CreEYYDfAigUv2VzwpQ8yUGCvhZLJUx9Mc
ftkhzFeAyhKqsvTUsupKIUu3ORTxxqhCOvSXAEg3MsKoydC4A8LcbU08yqwg9rEq
wxRD9fXoFcX/jLeJ2HI3vgWbyJSc6tivWrcrUJDcdri8qVmAnzU=
=lEl+
-----END PGP SIGNATURE-----
--=-=-=--
