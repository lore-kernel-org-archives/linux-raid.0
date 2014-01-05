From: NeilBrown <neilb@suse.de>
Subject: Re: More 'D' state processes [was: Re: Weird problem: mdadm blocks]
Date: Mon, 6 Jan 2014 09:00:54 +1100
Message-ID: <20140106090054.594f6853@notabene.brown>
References: <52B6AA66.5050502@hanswkraus.com>
	<20131222221914.78630829@notabene.brown>
	<52B70F38.5040807@hanswkraus.com>
	<52B716BF.70000@hanswkraus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FgQlfGICMoQDEE/S=yifaHR"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52B716BF.70000@hanswkraus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hans Kraus <hans@hanswkraus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/FgQlfGICMoQDEE/S=yifaHR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Dec 2013 17:43:43 +0100 Hans Kraus <hans@hanswkraus.com> wrote:

> Hi Neil,

Hi Hans,
 sorry for the delay - Christmas/New Year vacation...

> > [40800.777037] xfsaild/dm-0    D ffff88003754c300     0 20798      2
> > 0x00000000
> > [40800.777042]  ffff88003754c300 0000000000000046 0000000000000000
> > ffff88005d7c51a0
> > [40800.777047]  0000000000013780 ffff88001b01ffd8 ffff88001b01ffd8
> > ffff88003754c300
> > [40800.777052]  ffff880071fede00 ffffffff81070fc1 0000000000000046
> > ffff88003734a400
> > [40800.777057] Call Trace:
> > [40800.777061]  [<ffffffff81070fc1>] ? arch_local_irq_save+0x11/0x17
> > [40800.777071]  [<ffffffffa0170466>] ? md_flush_request+0x96/0x111 [md_=
mod]
> > [40800.777076]  [<ffffffff8103f6c4>] ? try_to_wake_up+0x197/0x197
> > [40800.777082]  [<ffffffffa0f11711>] ? make_request+0x25/0x37a [raid456]
> > [40800.777091]  [<ffffffffa0185873>] ?

This looks like the most likely root of the problem - something wrong in
md_flush_request.

There was a bug here fixed in 2.6.37

commit a035fc3e2531703b539f23bec4ca7943cfc69349
Author: NeilBrown <neilb@suse.de>
Date:   Thu Dec 9 16:17:51 2010 +1100

    md: fix possible deadlock in handling flush requests.

You didn't say which kernel you were running.  Could it be earlier than
2.6.37???

NeilBrown

--Sig_/FgQlfGICMoQDEE/S=yifaHR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUsnWFjnsnt1WYoG5AQI7/g/+P3zcZYEb/FVde/gCxc9VcFbxnoUkmx4u
bR8GYyWalLraQp58DSisyhAqv3CiNMcTeoZQKX5Dtr/neUNy7rK0oC8lwk2uMepx
jYRvjlhSkCXbctq9pKvmDbugCJIIvLuD5eMmlFmIQnDuXu0yr8KrI7faIoJkt/kk
+ze1ailIyevJ2TgOws10Iyc+9+7wJPcnAo4/mlShcjDnDY9ReW9yW9JVyhc0/npx
2jJayEuYZlIIM5LO5fNkBGu8a9Tj0RSFLQ7rPT8VRDsZq15QJuZx6g7C4WdgiFK7
x3ADN2c2ic3y1npc3J/pGpsUN59MPBWvELHhdjhM1treZBqN26AOMiKulafpUY3u
hfFDiYrU41x08y5VyswQS+ajWRcL2sKDdoQ+29wku2Ce8BJMLYQrOgp3l7ys9LFg
kKrmlTmOBB3Lt5noc0LZ5Vd4OjpQwrnDwIVhJB/yuA1BMMJoVWw2k7uNuA4xz/cy
Cl2B70ada9mtAko1RyKUnrJsBku4R50CqcY5/+sDrhosF8qSp8AM9dhSEMoIjSi7
wuA8JzGMzUF3L4LnS3o7TUr1gMmpYkpuSIJM6FpPdVRkQGDn291Wyoj9clXO6u8o
obshiglatYrxA2CMjx+eEp8jzrofcRHf2OZYkAl9mi9lE08GkaFzwaHgGm3jKumJ
DVBbX4v2kOg=
=3/g9
-----END PGP SIGNATURE-----

--Sig_/FgQlfGICMoQDEE/S=yifaHR--
