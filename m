From: NeilBrown <neilb@suse.de>
Subject: Re: RAID-6 with 3 missing disks
Date: Sun, 5 May 2013 12:58:27 +1000
Message-ID: <20130505125827.1cb1e320@notabene.brown>
References: <20130504160804.GA2242@lazy.lzy>
	<14872633-1367684555-cardhu_decombobulator_blackberry.rim.net-102434637-@b3.c7.bise7.blackberry>
	<20130504163006.GA3395@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pbKjOT8ZbbrWsHdjbGoAzqw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130504163006.GA3395@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, linux-raid-owner@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/pbKjOT8ZbbrWsHdjbGoAzqw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 4 May 2013 18:30:06 +0200 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> Hi Rudy,
>=20
> thanks for the answer, but as mentioned at the end,
> "--force" assemby does not work.
> Reason is, 7 disks complains 3 are missing and the
> 3 missing are assembed, since their superblock does
> not report errors.
> Of course, 3 disks are not enough to assembly the
> array, forced or not.

Details please.  "--examine" output of every device would be a good start.
Output for "mdadm --assemble --force --verbose ....."
would help too.

NeilBrown


>=20
> bye,
>=20
> pg
>=20
> On Sat, May 04, 2013 at 04:22:39PM +0000, Rudy Zijlstra wrote:
> > Hi
> >=20
> > I would start with mdadm assemble --force
> >=20
> > Do not use create unless all else has failed
> >=20
> > Cheers
> >=20
> > Rudy
> > ---
> > Verstuurd met mijn BlackBerry van Vodafone
> >=20
> > -----Original Message-----
> > From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
> > Sender: linux-raid-owner@vger.kernel.org
> > Date:	Sat, 4 May 2013 18:08:04=20
> > To: <linux-raid@vger.kernel.org>
> > Subject: RAID-6 with 3 missing disks
> >=20
> > Hi all,
> >=20
> > I know this was probably already discussed, but
> > maybe I need some refresh.
> >=20
> > I've a 10 HDDs RAID-6 which, due to mishap (disks
> > were disconnected accidentaly), has now 3 missing
> > devices and cannot be assembled.
> > The data should be OK, since no writes were occurring
> > during the accident, so putting them together again
> > should work.
> >=20
> > As far as I know, one option is to create, with
> > "mdadm -C" the array again, giving the disks in
> > the proper order.
> >=20
> > Since all HDDs are readable, I guess "mdadm -E"
> > should return the role of each device.
> > Is this correct for the creation order?
> >=20
> > Second question is about the "Data Offset", since
> > this array was created with an older version of
> > "mdadm" and the data offset is very close to the
> > superblock.
> > As far as I know, new mdadm creates the data a
> > bit far aways.
> > Is there any way to specifiy the proper offset?
> >=20
> > Finally, is there an alternative to "mdadm -C"
> > or it is the only option?
> > Forcing assembly does not work, but maybe there
> > is another way to tell mdadm to really assemby
> > the array, taking into account the superblock
> > information, which are all readable.
> >=20
> > Thanks a lot in advance,
> >=20
> > bye,
> >=20
> > --=20
> >=20
> > piergiorgio
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Sig_/pbKjOT8ZbbrWsHdjbGoAzqw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUYXK0znsnt1WYoG5AQLFExAAsidXxdKwVi6lYibydXzL47JTfSyQqjgy
FhpA0ppfpMluFKcTrIaekUSAfkyScLNSSsOoZaZwq8wv6oklsdaibOo2AU1PsGL9
2wsSPixfw22+5PFq04Z91c6OFjkE6dsi1Z7IQvycfAI7i7hcLfs/T9BzG0cgWP22
hppP9iEeAUz+iRNM4dMHO0MFv0gGoegYoq1eq0o7qo5pHNWxrn1iInAZVc6DymVt
vRGpTz2IHKzaOsITpzVjvzzS1FTYUZR08uNC87CnQD+8hg7QuTSbDkYlN/6X92zj
d55b8DcJpCpXhf9U1S53eDqDTj4FsByGtq1LxOp24qxGcBkKQiK7ktjLV6UY8DL+
yfau7oKrGKWCRHbEmPURTl0zDs0qaNoC/G8SgJaCtsg4EsMgi55MWB1+7edFI1K2
feTle9I+EPU335LxJGqocPzSAE5fqbVbiz5yEXfn0DBRXGzn8bsDq2jOcaiLsArU
x33VjZdt/vAk/o2sZVtrbPWRuAsNU0rVCBBqHapIG+/rfDgIPHu33Nm9UtU/mSsH
TE8+0ikkG/crOqSrMf6CP/CzU9kdBuABHspIPfBinouNV5Oxey6gXtfSQ4G6rS5l
/6vtH/z210ALQQp36ANfqKae2Z27Q4CoowhJ9g414s2IOcn/wfS3sSFF8ATmo7Oa
SOIOiR2fLME=
=vbVK
-----END PGP SIGNATURE-----

--Sig_/pbKjOT8ZbbrWsHdjbGoAzqw--
