From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm + intel matrix
Date: Wed, 10 Apr 2013 14:53:59 +1000
Message-ID: <20130410145359.4a864dcf@notabene.brown>
References: <CAF1jjLtMKmvQrZqO9Uv5vW6VGSJ8OmJZ8G3QxNZ6oGXr-3kS_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rNezElT9RywqkRioR8rAe4c"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF1jjLtMKmvQrZqO9Uv5vW6VGSJ8OmJZ8G3QxNZ6oGXr-3kS_Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NightStrike <nightstrike@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/rNezElT9RywqkRioR8rAe4c
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 9 Apr 2013 03:20:44 -1000 NightStrike <nightstrike@gmail.com> wrote:

> Neil,
>=20
> I have been talking to a lot of irc types, and ultimately, they all
> want me to just contact you directly (even people on
> oftc/#kernelnewbies).

The correct advice is to email linux-raid@vger.kernel.org (you don't need to
be subscribed) and to optionally Cc me.
I've Cc:ed this reply to linux-raid.


>=20
> Basically, using mdadm with the Intel Matrix fakeraid doesn't work
> right anymore.  I can't tell you with what kernel it stopped, but I
> can tell you that it is broken with archlinux 3.8.5, which is a
> vanilla kernel plus a console logging patch.  Here's what happens:
>=20
> 1) Create a new raid in the Option Rom
> 2) Boot up and see md126 and md127, respectively ArchRaid_0 and imsm0.
> 3) Run all sorts of read only things, like mdadm --detail-platform, all g=
ood
> 4) Run cfdisk /dev/md/ArchRaid_0 (which points to md126), set up my parti=
tions
> 5) Hit "Write" to write the partition table
> 6) Everything hangs

I've had this reported on openSUSE too.  I haven't yet had a chance to look
into it properly.
It sounds like "mdmon" is not running - or not working correctly.

On the first attempt to write to the array, md signals mdmon and waits for
the array to be marked "active".
mdmon should notice this, update the metadata on the array to record that t=
he
array is active (so if a crash happens a resync will be force) and then tell
md that the array is active.  md notices and allows the write.

Something in this sequence is not working.
Does everything "unhang" if you run
   mdmon md127 &

??

>=20
> At this point, any program that tries to do anything to the raid, or
> to even mount other volumes, will hang.  Here's a dmesg output of the
> blocked stack traces:
>=20
> http://sprunge.us/BBMM
>=20
> derRichard on #kernelnewbies looked at that and said that everything
> is stuck in __enqueue_entity, and that I have to contact the author of
> mdadm to find out why. :(
>=20
>=20
> Is there any way you can help?  What other info do you need?  And do
> you know how I can reboot gracefully?  Because right now, I'll only be
> able to do a hard reset or an REISUB, because those threads are
> forever blocked.

Hard reset (or "echo b > /proc/sysrq-trigger") is fine.  Nothing has been
written to those devices so on restart it will look just like it did before.


NeilBrown

--Sig_/rNezElT9RywqkRioR8rAe4c
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUWTwZznsnt1WYoG5AQK7xw/+IYhOSeviYJuixPfRl6AbezCxSHKsWMQQ
fnjom5FicNisA/+2EozgC6L6vu5OU9QG8792JwhHMXt5vR0VPXg86PnejsIuhO0W
XjUAvmcF7EtTVQfxOZosuMQyRxQ2y7fyaJnR6jFzPBtr6KLC9iCTWWQ1H/rtHggh
m+oobFddSykuv2bHCJwGy8yLhxGd8neET/IwCb5E/CpL3w6aUEyQ0P2/5uwCCQnZ
nxPaRiq0Z9i3FLyywJRVH8mBhqRipC4v5FIWByVDTkWZKwUxYTMQfqxnc1SqT3oy
YuV59nUyhnLhjL8ls2W18m9KUU8xkb8M2XkmFaK5XL+chYbby8oKJ9sUnnhQU8jY
CB5XUY8N8BgMuiRVVHahxaABChGuaaYAiu8SbeYF5USh9ZE7ZGWW2j+Ckz1R+iuT
QY1u3MWu57XPoqmcP/3TQ8wAL8+vYMXZtDJMjIS8FKhTxos8FO/T6EZlorMkCW6K
lLxAx//qomAxBc5m88tanQqT6uFLv5E7doQKWLz0QrHT0OFX4kfOoMl1Nl6eBOnh
oiFVwOwVCVdGKTP9VQVUBIEvmq5dQi/+SkVU8KrqR3JhpKwrx3PzEEfde01u6YxD
0rc+x0YqcEduF3j10ZuhKYXbFrvXL2Vv+Ehk7Lv3PeDk70H691MBQZWsRTRjiyrq
N+O/t9QLJ/0=
=JzHa
-----END PGP SIGNATURE-----

--Sig_/rNezElT9RywqkRioR8rAe4c--
