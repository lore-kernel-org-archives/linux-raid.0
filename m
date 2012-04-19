From: NeilBrown <neilb@suse.de>
Subject: Re: Should mdraid implement timeouts?
Date: Fri, 20 Apr 2012 07:46:47 +1000
Message-ID: <20120420074647.2846295d@notabene.brown>
References: <4F900F10.1040405@pierre-beck.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dAfFitnm+Wa5tCjd=s4+r7."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F900F10.1040405@pierre-beck.de>
Sender: linux-raid-owner@vger.kernel.org
To: Pierre Beck <mail@pierre-beck.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/dAfFitnm+Wa5tCjd=s4+r7.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Apr 2012 15:11:45 +0200 Pierre Beck <mail@pierre-beck.de> wrote:

> Hello,
>=20
> currently, mdraid will simply block and wait for the underlying layers=20
> to execute commands and does not handle timeouts on its own.
>=20
> In a perfect world, disks will respond within a limited timeframe when=20
> for example a bad sector is encountered. Unfortunately, I see even disks=
=20
> with set TLER that don't. Then, with a configurable timeout, Linux=20
> Kernel will reset the device in question, then the bus, then the=20
> controller. This process takes time (and I think the bus / controller=20
> reset is really adding to that time and should be optional in the first=20
> place) during which data is unavailable, though there is redundancy and=20
> another device is ready to respond.
>=20
> For a read operations, things are simple: mdraid can re-issue the read=20
> on the redundant device(s) and deliver data. For write operations, I see=
=20
> no other option than kicking the disk from the array. With write-intent=20
> bitmaps in place, the disk can be re-added and resync fast once it is=20
> available again.
>=20
> If possible, commands sent to the bad disk should be aborted, so Kernel=20
> doesn't reset the bus.

mdraid should definitely not - no questions, no ifs or buts or maybes -
implement timeouts.  Ever.  Just don't even consider it.
And you have identified here one of the reasons.  The command would have to
aborted and that is not possible.  But even if it were possible it would be
the wrong thing to do.

Timeouts must be handled by the lower levels - the SATA driver or the SCSI
layer or something.
We own the whole stack - we do things at the right layer.  We don't put hac=
ks
in one layer to make up for deficiencies in another.

So if you want more control of timeouts - which I suspect is a good thing to
want - take it to the people who can actually do something about it.  Maybe
the block layer maintainer, maybe the scsi maintainer.

What mdraid *could* possibly do is submit requests with a "FAILFAST" flag
set, though there are 3 of them and there isn't much documentation
explaining how they should be used so it isn't really clear which should be
used or maybe all.
Then errors from a FAILFAST request could be handled differently to normal
errors.
This would allow us to plug-in to different timeout handling in the lower
levels which might be a useful thing.

One of the reasons I haven't explored this in much detail though is - as I
said - there isn't much documentation and there are very few usage examples
to work from and when I tried once the SCSI layer behaved really strangely
and I couldn't tell if it was wrong or if I was wrong as there was no doco =
to
arbitrate between us.

Hope  that helps.

NeilBrown


>=20
> To add response time management, the timeout could work with several=20
> values and sum up like this:
>=20
> max_response_time_ms =3D 20
> timeout_ms =3D 10000
>=20
> Every request would measure response time. If response time -=20
> max_response_time_ms > 0, decrease timeout_ms temporarily by that value.=
=20
> So slow disks would be kicked by the same timeout mechanism.
>=20
> Greetings,
>=20
> Pierre Beck
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/dAfFitnm+Wa5tCjd=s4+r7.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5CHxznsnt1WYoG5AQKd1Q/9GYak1cJPJtdKVebGzRIkZTEQQNFPJDXl
jBrIXInzFw8+K3IwkJFmwBliMZ5I8S+g7tHha2WxHdxIQr80+kgLFgDiYFbkEW9r
V5j75fZ/vs+8f9u5srzaHW1/ZemNHWzsn62fyOHRvikHHHuGksHizhRPwz6TVgog
C/gchmt2Si6TVNwg+NoahnaEmyrftXcF1sXHlAXm7DWNgtHOJ+hM7MC6O3CpnLMG
v3Dwt/mXf/4XsNHPbjBHhGjoZ51T6e6sVbARC79cX036erKn5k1tb0M1H0e9GL1g
zNyh08nMk1jWKYgJbonCrq5oI9dlo17rbwxVynYGv0sIqtH60pvxOdk4HIjzIVO7
LcXEJBN0DRF5HFRmtp5NSOiHPy6QwaXys1+S6aV1wRCI1ysmVfD09es4IrBNXpZ8
lV1HmLODHj9elV2lgkOpeTLXymb2j9E70o+xNjdN8/DHE8B+5QTscHGkTGHC04y5
9XNke1atXb0AhTZV7BCubMCIphHVOHpYc1S0EI60QvQwQnrTHGvTeNMXeyskKp6E
yL7QlcRY7FnnxOqIaOGav8aLuGJXy5iWxBU06yDa+4i2o3KjXMuZiL+AJVjZzDtS
RzEUpCexsMBnvM7fgU4MnAEL84ATC3FEpBDpr5vjpw6jlJkqVOTQrG6lDr6qIxcA
fE36mdwm5iI=
=ivgw
-----END PGP SIGNATURE-----

--Sig_/dAfFitnm+Wa5tCjd=s4+r7.--
