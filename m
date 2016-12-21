From: NeilBrown <neilb@suse.com>
Subject: Re: Fwd: (user) Help needed: mdadm seems to constantly touch my disks
Date: Thu, 22 Dec 2016 09:52:44 +1100
Message-ID: <87mvforj2b.fsf@notabene.neil.brown.name>
References: <CAJ=9zicFM+wOUhpdX1XEVm+y2gYoW3r2aTRj6gAcEkypxJULmA@mail.gmail.com> <871sxbz4yz.fsf@notabene.neil.brown.name> <CAJ=9zieRuTNiEGuB_RouqbdLGoxNkn09yiogR6rND84LtMdbxA@mail.gmail.com> <CAJ=9zifGPd+3YnP1aLwLPXjtpygRc9DsDP37CNz-VHBHn1vDOg@mail.gmail.com> <87inqgvpyj.fsf@notabene.neil.brown.name> <CAJ=9zidNV4sPj7KC7_mJEo8+=-YTKyWD5RiLsGG9p33CV12Qdg@mail.gmail.com> <87twa0tvma.fsf@notabene.neil.brown.name> <CAJ=9zidt_25tCF8QBy0To9oY+QNVD1ufF+CQ-pSjD97zVaLoGg@mail.gmail.com> <87inqftro1.fsf@notabene.neil.brown.name> <CAJ=9zicozhGYUy_iB7EPSRxMVDJBG0ArhKNqyKQYCVwA0zEkew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ=9zicozhGYUy_iB7EPSRxMVDJBG0ArhKNqyKQYCVwA0zEkew@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jure =?utf-8?Q?Erzno=C5=BEnik?= <jure.erznoznik@gmail.com>, linux-raid@vger.kernel.org, tkonto@gmail.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 21 2016, Jure Erzno=C5=BEnik wrote:

> Mr Brown,
>
> Let me begin with: please give me your paypal address or something so
> that I can at least buy you a beer or something

Thanks :-)
My first inclination is to say "no thanks" as I am very adequately
compensated by SUSE, and it is part of my role at SUSE to ensure the
upstream kernel remains healthy.  Encouraging a health community is part
of that (and I often learn something while helping people fix things).

But my second inclination is to recognize that gratitude is an important
part of human interactions, and that a community is strong when
gratitude is appropriately given and received.  It is not my place to
direct others how they should show gratitude.
So I'll tell you my paypal address is neil@brown.name and that I'm more
likely to enjoy hot chocolate than beer, but I'll also emphasize that
there is no expectation attached to this information. :-)

>
>
> Your analysis and discovery that iSCSI is the origin of writes got me
> thinking: how can he see that on md0 device if that device has two
> more layers (bcache + LVM) before iSCSI even comes into play. Maybe
> the system propagates the origin down the block devices or something,
> totally not relevant here. So I embarked on a journey of total data
> destruction by disabling one layer at a time. I started by simply
> detaching bcache as that was the first thing on the list - and was
> non-destructive to boot :)
>
> I have found the culprit:
> It is bcache that does the one second writes. I have yet to find the
> exact parameters that influence this behaviour, but the output of
> writeback_rate_debug is EXTREMELY clear: it's writing a bit of data
> each second, reducing the dirty cache by that tiny amount. This is
> what causes the write "amplification" resulting in clicks long after a
> write has been done - because bcache only writes tiny amounts each
> second instead of flushing the entire cache at once when the time
> comes.

Now that we have an understanding of what is happening, I can recommend
that you increase /sys/block/md0/md/safe_mode_delay.  It is measured in
seconds.  If you make it larger than the period of the bcache writes, it
should stop the 'ticking' you mentioned.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhbB7wACgkQOeye3VZi
gbmnlg/+LxX0HgIsXRhzKvO7yFyb6w2JwaB9Cn0H/32bO3E9D9RlPd5fGU1JLqt4
D7LH9Adv27LbHEDUewK34SvoGuPUcBX7fkvp1duJ6/eHNVBn5hJILFaPEYgZZHbG
7RKC+yA8+i+Ll+WvKtxVZkqJAA6Kb+1JOZzuzs0MefF3Dla3GRdm4Wptrsw9fShd
jZLoQ20rMULliNe5EvesgDL6gOsBvmecakQ6O7A0HhKOl6aiL023z6oCflg6+npp
MmIrEAkb+JjVD3AZbH65EHnA6xO6kKQ9ItIX1wlTiJryirXTcxwESkBhdtqE7mJt
r/zuTq2Vx3yyg/Xdev1iL6vlrv+GQy6A39otYXMKybL79loBWMkr716fvtmayraZ
cTDMCOvUxS+BSpcVcEXKiwbkzQIY66dvFZQLZxv2ejUylurnGvBkNz0INK6vuhAJ
RxahsADOS2MFP9v2ELcv/ljsomTQTJaLBA8EvC6Y5DHjdL7qC8x6d+NXGBVHXGds
o3yyTAz3Hh0c1FmPduDifN0imZhRLsybxaYxe9WWuFb6PIahZdCrzSwiTQOhTMyS
0UbOXxuycaBaamszI9EZd1nc+o77ODXuC5C429fq4PcOAh7752edsYm95tpUiIsR
GTLmgIraFmN11MxlMTyCbT3hreHtpYcDGZIuD0zT0vaYCSQriZQ=
=4239
-----END PGP SIGNATURE-----
--=-=-=--
