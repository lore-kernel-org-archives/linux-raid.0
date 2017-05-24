From: NeilBrown <neilb@suse.com>
Subject: Re: Reducing the number of devices in a degraded RAID-5
Date: Wed, 24 May 2017 12:12:32 +1000
Message-ID: <87h90bhujz.fsf@notabene.neil.brown.name>
References: <20170522125332.GA18406@metamorpher.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170522125332.GA18406@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, May 22 2017, Andreas Klauer wrote:

> Hi,
>
> this is not a recovery question, no real data involved. Thanks for helpin=
g!
>
> Suppose you have a failing drive in RAID-5 but you wanted to move to=20
> fewer drives anyway, so one way or another you're going to reduce=20
> the number of drives in your RAID.
>
> Given a RAID 5 with 5 drives            [UUUUU]
> Reducing it by one drive results in     [UUUU] + Spare
> Okay.
>
> Given a degraded RAID 5 with 5 drives   [_UUUU]
> Reducing it by one drive results in     [_UUU] + Spare
> Still okay? Rebuild must be started manually.
>
> It seems reducing a degraded RAID is a bad idea,=20
> since there is no redundancy for a very long time.
>
> So what you might end up doing is a three step process:
>
> -> [_UUUU] (Degraded)
>
> Step 1: Add another drive (redundancy first)
>
> -> [UUUUU]
>     ^ added drive
>
> Step 2: Reduce by one drive
>
> -> [UUUU] + Spare
>
> Step 3: --replace the previously added drive
>         (if the spare happened to be one of the drives you wanted to keep)
>
> -> [UUUU]
>     ^ former spare
>
> This way the process is redundant but it takes a very long time,=20
> three separate reshape/rebuilds instead of just one.
>
> Steps to reproduce the [_UUUU] -> [_UUU] + Spare case:
> (using linux 4.10, mdadm 4.0)
>
> # truncate -s 100M 1.img 2.img 3.img 4.img
> # devices=3D$(for f in ?.img; do losetup --find --show "$f"; done)
> # mdadm --create /dev/md42 --level=3D5 --raid-devices=3D5 missing $devices
> md42 : active raid5 loop4[4] loop3[3] loop2[2] loop1[1]
>       405504 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/4] [_UU=
UU]
> # mdadm --grow /dev/md42 --array-size 304128
> # mdadm --grow /dev/md42 --backup-file=3Dmd42.backup --raid-devices=3D4
> md42 : active raid5 loop4[4](S) loop3[3] loop2[2] loop1[1]
>       304128 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [_UU=
U]
> # not rebuilding until you re-add the spare
>
> Is it possible to do [_UUUU] -> [UUUU] in a single step?
> I haven't found a way. Any ideas?

I hoped that
  mdadm --grow /dev/md42 --backup-file=3D... --raid-device=3D4 --add /dev/l=
oop4

would have worked, but it doesn't.
What does work is:
 # start with a degraded array, device 0 missing
 mdadm --grow /dev/md42 --array-size=3D.....
 echo frozen > /sys/block/md42/md/sync_action
 mdadm /dev/md42 --add /dev/loop0
 echo 0 > /sys/block/md42/md/dev-loop0/slot
 mdadm --grow /dev/md42 --backup-file=3D... --raid-devices=3D4


NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkk7BAACgkQOeye3VZi
gbn7jg//XyH5gpFWN4/FoydDsldlNBWGzKuU4XMKDP4BBNfsCXW87GUABeOXwbWW
NPYKvGPF9zh4iYeysvikSFghjsDqylglGGqCDGt74n56AghL7FwrtIE7+Dxao8iZ
KcZMNjm43G7DMMRqLl59nGqHphkwKk1Djio6hql8CpxBFD/5sLG2UJzmqneCy1tK
/n7pK9gOq1Yiv3Teodctr1PQNn0mW+5PtmfSFkjyOVRMPfzJuAwp96cXk7sWX1sR
Nw2PR4EJPiGiphMz2Ebtg7XY5+ng9aXVCfQ1OQhw0A96Nxnj/myGj/r3pIlJmdSr
dOjftv0PZvWOt+9F2Ofgpo7PIcsn8sirkjSTSTr53/6pMxx9OV5pfrhUBItInu5T
8hA6OTuLXWa8N2GkfGkHQk+ziHiLIu4rNiIzYgCUDXpuXw+FWEeVH62+hG2o3bru
tCAjbUJnprtchZlySUnM5w5ZkgwkMZH1tIj3d155408sMtCvbUtXTSvycSTNu/iu
R0pqMmgh1s1gGbHJGnrRzqwLfLBygOsiTvw9+khsMZLgHfgwmcpoLiK1QydCxqb+
A39BhanRA7iEoYaDbV2QqVPF7mbQan25yJzYjTFwOtGq36eQyBnFanAvSus3v/Ac
wef4ImcSUj3Plji87AaSrLWYOSnEf+XBRtMnZrGhFU/GA0mfMMI=
=+smh
-----END PGP SIGNATURE-----
--=-=-=--
