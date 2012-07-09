From: NeilBrown <neilb@suse.de>
Subject: Re: Find mismatch in data blocks during raid6 repair
Date: Mon, 9 Jul 2012 13:43:08 +1000
Message-ID: <20120709134308.0ea5b18d@notabene.brown>
References: <10900468.MPSjVn2C3J@peanut>
	<1436304.MN64neqUEr@peanut>
	<20120630114831.GA3034@lazy.lzy>
	<2116390.poR22k1RqP@peanut>
	<20120703202734.GA10087@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/n6CpmD_l.7aC_TB/kARI2LP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120703202734.GA10087@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Robert Buchholz <robert.buchholz@goodpoint.de>, John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/n6CpmD_l.7aC_TB/kARI2LP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Jul 2012 22:27:34 +0200 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> Hi Robert,
>=20
> On Tue, Jul 03, 2012 at 09:10:41PM +0200, Robert Buchholz wrote:
> [...]
> > > Why always two blocks?
> >=20
> > The reason is simply to have less cases to handle in the code. There's=
=20
> > already three ways to regenerate regenerate two blocks (D&D, D/P&Q and=
=20
> > D&P), and there would be two more cases if only one block was to be=20
> > repaired. With the original patch, if you can repair two blocks, that=20
> > allows you to repair one (and one other in addition) as well.
>=20
> sorry, I express myself not clearly.
>=20
> I mean, a two parities Reed-Solomon system can
> only detect one incorrect slot position, so I would
> expect to have the possibility to fix only one, not
> two slots.
>=20
> So, I did not understand why two. I mean, I understand
> that a RAID-6 can correct exact up two incorrect slots,
> but the "unknown" case might have more and correcting
> will mean no correction or, maybe, even more damage.
>=20
> I would prefer, if you agree, to simply tell "raid6check"
> to fix a single slot, or the (single) wrong slots it finds
> during the check.


I think this is a sensible feature to offer.  Maybe if "autorepair" is given
in place of "repair", then it should choose which block to repair, and do
that one?


>=20
> Does it make sense to you, or, maybe, you're considering
> something I'm missing?
>=20
> > > Of course, this is just a statistical assumption, which
> > > means a second, "aggressive", option will have to be
> > > available, with all the warnings of the case.
> >=20
> > As you point out, it is impossible to determine which of two failed=20
> > slots are in error. I would leave such decision to an admin, but giving=
=20
> > one or more "advices" may be a nice idea.
>=20
> That would be exactly the background.
> For example, considering that "raid6check" processes
> stripes, but the check is done per byte, already
> knowing how many bytes per stripe (or block) need
> to be corrected (per device) will hint a lot about
> the overall status of the storage.
> =20
> > Personally, I am recovering from a simultaneous three-disk failure on a=
=20
> > backup storage. My best hope was to ddrescue "most" from all three disk=
s=20
> > onto fresh ones, and I lost a total of a few KB on each disk. Using the=
=20
> > ddrescue log, I can even say which sectors of each disk were damaged.=20
> > Interestingly, two disks of the same model failed on the very same=20
> > sector (even though they were produced at different times), so I now=20
> > have "unknown" slot errors in some stripes. But with context=20
> > information, I am certain I know which slots need to be repaired.
>=20
> That's good!
> Did you use "raid6check" for a verification?
> =20
> [...]
> > checksums. I may send another patch implementing this, but I wanted to=
=20
> > get general feedback on inclusion of such changes first (Neil?).
>=20
> Yeah, last time Neil mentioned he needs re-triggering :-),
> I guess you'll have to add "[PATCH]" tag to the message too...

:-)

I have applied the patches, though with some fairly minor editing (wrapping
lines, moving variable declarations before any statements, removing
tab-at-the-end-of-the-line).  They probably won't appear in my public .git
for a little while I I have some other patches that I need to sort through
and organise first.


Thanks,
NeilBrown


>=20
> > I am a big supporter of getting it to work, then make it fast. Since a=
=20
> > full raid check takes the magnitude of hours anyway, I do not mind that=
=20
> > repairing blocks from the user space will take five minutes when it=20
> > could be done in 3. That said, I think the faster code in the kernel is=
=20
> > warranted (as it needs this calculation very often when a disk is=20
> > failed), and if it is possible to reuse easily, we sure should.
>=20
> The check is pretty slow, also due to the terminal
> print out, which is a bit too verbose, I think.
>=20
> Anyhow, I'm really happy someone has interest in
> improving "raid6check", I hope you'll be able to
> improve it and, maybe, someone else will join
> the bandwagon... :-)
>=20
> bye,
>=20


--Sig_/n6CpmD_l.7aC_TB/kARI2LP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/pTTDnsnt1WYoG5AQKSixAArIx3ZB5byC8iAIjLk0XdaUAFACETXcsY
56B1v7QTyaRj+T3VrW65nJOpScIourdNzyTUUUV1/0eP8YuXPa6kSMnBX9stPCPC
klPY1mBYCPWnCG0AUFoC9RagkH6rya05Ky+MM9fS8gLTOOuKQNEoL825xLxMeOx0
VE/WT97HzN/kEWro83nDiouir4Ay/Wq4n0FS+JwtVbGE8GR30BO6hVVHgz1qP961
cjd+PZsqUp0KBQd1Ytm26sj2whThL210H8daWiG8rPZHA/4Rp0VfLEqHzSW3HFkl
4zPIGlYRdFalJKqhk3vyMrgEqGFdriC+qVPcCn6M7HlgvR1daWdIEUQ6fPS+P1DV
StkYfsj5dEFwk+kcF6fvcRQ1FMBDCOAdKsnAUOKmIh6HrarWYXALPws+kPbkqW3n
Tz7kckuphXOgQl4l30OBMJJJCahnt7WCnFoXp5R0IuK6tD/aWLFzrF63v3X5oPjj
aFqNRFaQb7is3CjCBa5ifPJURbyKAOMtdKHS83RYZoH99fd0Y15dNXoo0Lh0RvV5
MzV0fCmb2WARrQdfovi/hWKFIgLfO3bbGqrloSxssVurJ3BOqjnDZ3rpAncpNrOQ
rSEPdsOtMvGUuiq+G+Qwqu4VZ7s8P0EovC9FhQ8n1chdHDG2EF4PWsMP2u44qp3N
1r3HHYjAMkk=
=vTwH
-----END PGP SIGNATURE-----

--Sig_/n6CpmD_l.7aC_TB/kARI2LP--
