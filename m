From: NeilBrown <neilb@suse.de>
Subject: Re: Meaning of "Used Dev Space" in "mdadm --detail" output for a 6
 disk RAID10 array
Date: Wed, 11 Jan 2012 06:48:57 +1100
Message-ID: <20120111064857.491a31b2@notabene.brown>
References: <007601cccf3e$72191470$564b3d50$@wholeworldwindow.net>
	<20120110140851.56f53921@notabene.brown>
	<00b901cccfcb$ab5225a0$01f670e0$@wholeworldwindow.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SRUNmur5L/xPONW9EZx0xC3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00b901cccfcb$ab5225a0$01f670e0$@wholeworldwindow.net>
Sender: linux-raid-owner@vger.kernel.org
To: Bobby Kent <bpkent@wholeworldwindow.net>
Cc: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/SRUNmur5L/xPONW9EZx0xC3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Jan 2012 14:11:34 -0500 Bobby Kent <bpkent@wholeworldwindow.net>
wrote:

> On Monday, January 09, 2012 22:09 -0500 On Behalf Of NeilBrown <
> linux-raid-owner@vger.kernel.org> wrote:
>=20
> > On Mon, 09 Jan 2012 21:20:39 -0500 Bobby Kent
> <bpkent@wholeworldwindow.net>
> > wrote:
> >=20
> >>  Is Used Dev Space a measure of the capacity on each member device used
> by the array?=20
> >=20
> > Yes.
> >=20
> > NeilBrown
>=20
> Hey NeilBrown,
>=20
> Many thanks for clearing that up.=20
>=20
> On the metadata question the mdadm man page at
> http://linux.die.net/man/8/mdadm implies that the driving criteria for
> upgrading from 0.90 is use of HDDs with > 2 TB capacity or > 28 HDDs with=
in
> a raid device, neither of which are in my current plans, though I imagine=
 at
> some point I'll purchase larger HDDs.  Are there any other factors I shou=
ld
> consider (e.g. kernel version compatibility)?

Some newer features - such as bad-block lists - are only supported for 1.x
metadata.

Certainly use 1.x for new arrays, but I wouldn't bother converting old arra=
ys
unless you wanted to convert to large devices (and current kernel/mdadm can
handle 4TB with 0.90 - the 2TB limit was a bug).

>=20
> In my previous mail I might have been a little clearer in describing the
> hangs/lock ups I was experiencing, as there may have been an unintended
> implication that md was somehow at fault.  What I observed was that after
> several hours of uptime the system would hang/lock up, nothing was written
> to syslog, the desktop froze (mouse unresponsive, clock did not advance,
> etc), network unresponsive (could not get a ping response), HDD access LED
> was on.  Hitting the reset button appeared to be my only option to get ba=
ck
> to a working system (on one occasion my machine was left in this state for
> 90+ mins).  I am typically unwilling to hit the reset button, I probably =
did
> it more times last week (3 times after the "downgrading" to 3.0.6 kernel)
> than in the prior 18 months.

I would try alt-sysrq-P or alt-sysrq-T to try to find out what is hanging.


>=20
> It was the LED that lead me to wonder about a resync following a hard sto=
p,
> and after discovering resyncs had not completed I left my machine booted =
to
> the login prompt (rather than logged into in KDE) one night.  To further
> muddy the waters the lock ups occurred while I was making some configurat=
ion
> changes in order to implement real time processing for audio software.  I=
've
> backed these out prior to the "login prompt boot", and, on balance, I
> suspect these may have been the ultimate cause.  Speculation of course,
> though without evidence to the contrary, I typically assume issues are of=
 my
> own creation rather than the fault of otherwise perfectly stable software
> and hardware.  The original question about mdadm output was more a sanity
> check that the arrays were configured consistent with expectations.
>=20
> I'm thinking of setting both LOCKUP_DETECTOR and DETECT_HUNG_TASK in futu=
re
> kernel builds, hopefully these will provide additional information should
> something similar happen in the future.  Are there any other recommended
> kernel settings I should implement?

Nothing springs to mind.

NeilBrown


>=20
> Thanks again,
>=20
> Bobby
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/SRUNmur5L/xPONW9EZx0xC3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwyWKTnsnt1WYoG5AQJZYQ/+MaIsGgsIjRRpYW73Y3hiZaDvc6VJieJx
mnIiAHTMu+yLewINZP/cdMDevwTDcTSGu87LsOHJlEqCmVcJ6/g2NKt9ty38n2Bq
qvOc0eu9dGejFJjZyNMTRfuzgwxVrM8hc9Uaoxa/S4xtkoh9/WpZzQf3tPymkpnZ
udHI8ZCtL3au41KLpMEOqpKRsbK2I5Gf7mRO4fS8wrkoE4/Wk13UTFMHgNGFu7Vi
kNN2JO9HlleAJ6OVtTWpfN83qdk8FeHejajE91MTaxDYiN5xrR8fKlkTaZAaLPhZ
S8KxOWKKw0yzxQDPj86XRu+Xuitwr3HM0DFveyzQdgG/hCV8ec9zX8K+AHhoTfbU
4I395WH03q6A9L7S6pXA4bskjsozykVbhvIMsB3eZNs0MFBzeUIob6yLF7Z0ro4S
2ZCIHLIc2XSptVNHTSYqJOa1qrpM9nPgObEBOX2WpaTFUBRcBQUELeDBgS2/TUCT
klPG25o4HCBV9Z4FjXbPFdCjxfeUGsC624fONDU77bPIXMNbNCzuWXaczGsZXTo/
XZ4FjCWwr0nAwHiBlpvThypdYRE8oRqh/BQulMaWptKXC1tbIwKONorhve1Ers/+
1o3P+bKJgGuNv3GICZtUn3FmsDKUxZII+0IsnMrXjwLGWDsF6yZ/R5eA738fJjVk
mZvpnpxCmyw=
=lciW
-----END PGP SIGNATURE-----

--Sig_/SRUNmur5L/xPONW9EZx0xC3--
