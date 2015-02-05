From: NeilBrown <neilb@suse.de>
Subject: Re: Off-Topic Write cache disabling?
Date: Thu, 5 Feb 2015 15:47:25 +1100
Message-ID: <20150205154725.3ea10167@notabene.brown>
References: <CAFE24U1G9+bqTzK4eD-cenyc5CGQQdrcu7S9Ks4CsHPS9wJ4zA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/rwCYxutgE/fD=kAg=Bh=.OW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFE24U1G9+bqTzK4eD-cenyc5CGQQdrcu7S9Ks4CsHPS9wJ4zA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Weedy <weedy2887@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/rwCYxutgE/fD=kAg=Bh=.OW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Feb 2015 12:45:44 -0500 Weedy <weedy2887@gmail.com> wrote:

> Is there a kernel option or sysfs toggle that disables write caching?
> Or forces the kernel to commit everything constantly.
>=20
> ------
> I don't really want to join another ML, especially a higher traffic
> one just to ask this when it only bugs me sometimes. But I'll shut up
> if this is unwanted.
> ------
>=20
> I use a similar kernel config with respect to selected options on all
> my systems but this only effect my laptop.

Maybe it has something to do with "laptop_mode"
 =20
    /proc/sys/vm/laptop_mode
    https://www.kernel.org/doc/Documentation/laptops/laptop-mode.txt

> On any of my personal system or system I have remote access too
> nr_dirty drifts up and down and nr_writeback stays around 0 (assuming
> the system isn't working hard).
> On my laptop both nr_dirty and nr_writeback stay at 0. I can make them
> go up to 10ish if I untar something but then almost immediately go
> back to 0. If I didn't know better I would swear dirty_*_centisecs or
> something was set to a near instant commit interval but I haven't
> found evidence of that. The hard drive light blinks almost constantly
> once a second, even if I'm at a X login screen.

That doesn't quite sound like laptop mode...

laptop mode syncs things more aggressively when the disk is spinning, and
more lazily when it isn't ... or something like that.

So I can imagine nr_dirty staying low - any read will spin the disk, and th=
at
will quickly flush out any dirty pages.
The once-a-second blink is harder to explain.

Still, it would be worth checking if laptop mode is enabled, and if so
disable it and see if anything changes.

NeilBrown



> As I said this doesn't bug me most of the time but if I let my FF
> session get too large or start multiple VMs anything that might make
> me swap a little, the machine pretty much dies from IOWAIT. Which I'm
> guessing is because it's trying to flush (syncfs?) imediately and
> constantly.
>=20
> You guys spend all day in the IO subsystem, any idea where I can keep
> looking? It has persisted across reboots and kernel updates.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/rwCYxutgE/fD=kAg=Bh=.OW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVNL13Tnsnt1WYoG5AQJ8TQ/9FOcmtPyOO2uBHTzvRcnwemfH0caplAC8
tZKwdP9iqAofqo/IN5hV/nv1KWDcgRUeQydgYn1An6aoGvaD0OeFiezk7urZ0uNQ
Zp1B4caK8U23wdCKg2MqTelQ4uX+iWBENB/fskl5N9VWAn8dfawU1CDMBVt4nB+Y
odf2dqfweuw2L4UypUCp38uDi9eka1Q9eeIC3eynHBQXxhVQjy+9/no59Cj41mHu
xYsAiAcqmfmk7aaIjVfiD6DuoO/+F0g8cw6wtZI+h4T+NNW+xej27KigOZOyg+K7
jJnyB80+Xs/kuG4/rujGlf2y++H9zhrOjnbJk8K+0ZE8SkqZE9UJvVZRKP0yk8iW
CWx8IpOqRdrKaY7zsbCtmME7EzCnmhjLm0XVtkLzs5XcFWkd7OQdV0zDqPmfAygK
KvDhbZ9m7IXWKbd1D1YvF2Pbki1yWscEjjTRQ3JTV0rMp6uVj4E6miMQwY0hHj5H
lBkLLO53CrEYq3CZXvbPDZBm5WXqWb4JBfx1JoD/v0ZmW8Nk2J0cBLGP11RsqbXn
fQDscE1fVIt/lEDCzNawhLidS8ij7KGRwZTbzr65PXuLNbDoSvcJ0wo/b1zMLGuU
qtIVQW1nlH73ka4dUOoaN8Y24Gos8y5zprKtz9MK3biKCqWzFHSFhqJnsCOLO9z5
Pr+kQbmljLY=
=Mg7M
-----END PGP SIGNATURE-----

--Sig_/rwCYxutgE/fD=kAg=Bh=.OW--
