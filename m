From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] imsm: FIX: Be more patient during loading matadata
Date: Thu, 14 Apr 2011 18:08:46 +1000
Message-ID: <20110414180846.6a71eeb9@notabene.brown>
References: <20110412125116.7062.36275.stgit@gklab-128-013.igk.intel.com>
	<20110412125128.7062.38008.stgit@gklab-128-013.igk.intel.com>
	<BANLkTinryn7FTdXMHx9HsMSQqpgykWW+Gg@mail.gmail.com>
	<905EDD02F158D948B186911EB64DB3D192368340@irsmsx503.ger.corp.intel.com>
	<BANLkTi=nontnQ_WKCaUWmosBDBihoDC7JA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=nontnQ_WKCaUWmosBDBihoDC7JA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Kwolek, Adam" <adam.kwolek@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Wed, 13 Apr 2011 11:56:29 -0700 Dan Williams <dan.j.williams@intel.c=
om>
wrote:

> 2011/4/12 Kwolek, Adam <adam.kwolek@intel.com>:
> >> -----Original Message-----
> >> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] O=
n
> >> Behalf Of Dan Williams
> >> Sent: Wednesday, April 13, 2011 2:45 AM
> >> To: Kwolek, Adam
> >> Cc: neilb@suse.de; linux-raid@vger.kernel.org; Ciechanowski, Ed;
> >> Neubauer, Wojciech
> >> Subject: Re: [PATCH 2/2] imsm: FIX: Be more patient during loading
> >> matadata
> >>
> >> On Tue, Apr 12, 2011 at 5:51 AM, Adam Kwolek <adam.kwolek@intel.co=
m>
> >> wrote:
> >> > Sometimes occurs that metadata cannot be loaded e.g. wrong check=
 sum
> >> > It can happen due to metadata update racing with mdmon condition=
=2E
> >> > If mpb loading is tried again, it is loaded successfully.
> >> > Try to load metadata again before really giving up.
> >> >
> >> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> >> > ---
> >> >
> >> > =A0super-intel.c | =A0 10 ++++++++--
> >> > =A01 files changed, 8 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/super-intel.c b/super-intel.c
> >> > index dc5e34e..d23267a 100644
> >> > --- a/super-intel.c
> >> > +++ b/super-intel.c
> >> > @@ -2773,8 +2773,14 @@ load_and_parse_mpb(int fd, struct intel_s=
uper
> >> *super, char *devname, int keep_fd
> >> > =A0 =A0 =A0 =A0int err;
> >> >
> >> > =A0 =A0 =A0 =A0err =3D load_imsm_mpb(fd, super, devname);
> >> > - =A0 =A0 =A0 if (err)
> >> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
> >> > + =A0 =A0 =A0 if (err) {
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* try to load mpb again,
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* in case of mdmon race we coul=
d have more luck...
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D load_imsm_mpb(fd, super, d=
evname);
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
> >> > + =A0 =A0 =A0 }
> >> > =A0 =A0 =A0 =A0err =3D load_imsm_disk(fd, super, devname, keep_f=
d);
> >> > =A0 =A0 =A0 =A0if (err)
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return err;
> >>
> >> This is semi-duplicates the check we already do after returning fr=
om
> >> load_and_parse_mpb in load_super_imsm_all. =A0I'm curious, are you
> >> hitting this path from load_super_imsm? =A0If the container is ass=
embled
> >> we should be loading from the container, if the container is not
> >> available then mdmon can't be running and checksum errors are real=
=2E
> >>
> >
> > My test scenario is that after boot I'm disassembling read only arr=
ay and immediately new array is assembled for grow continuation.
> > Sometimes occurs that mdadm throws exception and core file is gener=
ated. It shows that anchor pointer has NULL value due to CRC error.
> > Second reading try helps, and anchor is always read correctly.
> > This behavior and fact that if I put more time between array disass=
embling and assembling it again helps also suggest, that we have some r=
ace condition here.
>=20
> Right, so we need to fix that disassemble-to-assemble race, this patc=
h
> only "helps" :-).
>=20

Yes.  We need to fix it properly.
The race should be avoided by proper use of O_EXCL.
i.e.
 1/ mdmon should only write metadata to devices while they are actually=
 part
    of the container and so the container has exclusive access (which i=
t
    shares with member arrays).
 2/ mdadm should only try to use a device in an array if it has O_EXCL =
access.

Which of these rules is broken - and where?


> > Problem is not in currently monitored in mdmon container but rather=
 in interaction with previous mdmon session that is about to close.
> >
> > This patch makes that error condition never occurs in this scenario=
=2E
>=20
> That "never" needs to be qualified.  This patch makes the race harder
> to lose, but as far as I can see not "impossible" to lose.
>=20
> > Grow.c is fixed for correct error condition behavior also.
> > I can agree that both patches in this series can help for this prob=
lem separately, but I think both should be placed in code.
>=20
> Why does this existing check:
>=20
>                /* retry the load if we might have raced against mdmon=
 */
>                 if (err =3D=3D 3 && mdmon_running(devnum))
>                         for (retry =3D 0; retry < 3; retry++) {
>                                 usleep(3000);
>                                 err =3D load_and_parse_mpb(dfd, s, NU=
LL, 1);
>                                 if (err !=3D 3)
>                                         break;
>                         }

It's pretty horrible that we need to do this, isn't it?
Maybe we need some way to synchronise with mdmon so we *know* if we hav=
e
raced or not.
i.e. mdmon keeps a count of the number of times it has updated the meta=
data.
We send a message to get the count, read, then get the count again.
The request blocks while mdmon is actually writing.
If the counts are different, we read again.
??

NeilBrown


>=20
> ...not help in this case.  I suspect due to that mdmon_running()
> qualification and the fact that the test is only seeing this in a
> disassemble-to-assemble window.  So that seems to be further evidence
> that a higher level fix is needed.
>=20
> --
> Dan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
