From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/2] imsm: FIX: Be more patient during loading matadata
Date: Wed, 13 Apr 2011 11:56:29 -0700
Message-ID: <BANLkTi=nontnQ_WKCaUWmosBDBihoDC7JA@mail.gmail.com>
References: <20110412125116.7062.36275.stgit@gklab-128-013.igk.intel.com>
	<20110412125128.7062.38008.stgit@gklab-128-013.igk.intel.com>
	<BANLkTinryn7FTdXMHx9HsMSQqpgykWW+Gg@mail.gmail.com>
	<905EDD02F158D948B186911EB64DB3D192368340@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D192368340@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

2011/4/12 Kwolek, Adam <adam.kwolek@intel.com>:
>> -----Original Message-----
>> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On
>> Behalf Of Dan Williams
>> Sent: Wednesday, April 13, 2011 2:45 AM
>> To: Kwolek, Adam
>> Cc: neilb@suse.de; linux-raid@vger.kernel.org; Ciechanowski, Ed;
>> Neubauer, Wojciech
>> Subject: Re: [PATCH 2/2] imsm: FIX: Be more patient during loading
>> matadata
>>
>> On Tue, Apr 12, 2011 at 5:51 AM, Adam Kwolek <adam.kwolek@intel.com>
>> wrote:
>> > Sometimes occurs that metadata cannot be loaded e.g. wrong check s=
um
>> > It can happen due to metadata update racing with mdmon condition.
>> > If mpb loading is tried again, it is loaded successfully.
>> > Try to load metadata again before really giving up.
>> >
>> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
>> > ---
>> >
>> > =A0super-intel.c | =A0 10 ++++++++--
>> > =A01 files changed, 8 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/super-intel.c b/super-intel.c
>> > index dc5e34e..d23267a 100644
>> > --- a/super-intel.c
>> > +++ b/super-intel.c
>> > @@ -2773,8 +2773,14 @@ load_and_parse_mpb(int fd, struct intel_sup=
er
>> *super, char *devname, int keep_fd
>> > =A0 =A0 =A0 =A0int err;
>> >
>> > =A0 =A0 =A0 =A0err =3D load_imsm_mpb(fd, super, devname);
>> > - =A0 =A0 =A0 if (err)
>> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
>> > + =A0 =A0 =A0 if (err) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* try to load mpb again,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* in case of mdmon race we could =
have more luck...
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D load_imsm_mpb(fd, super, dev=
name);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
>> > + =A0 =A0 =A0 }
>> > =A0 =A0 =A0 =A0err =3D load_imsm_disk(fd, super, devname, keep_fd)=
;
>> > =A0 =A0 =A0 =A0if (err)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return err;
>>
>> This is semi-duplicates the check we already do after returning from
>> load_and_parse_mpb in load_super_imsm_all. =A0I'm curious, are you
>> hitting this path from load_super_imsm? =A0If the container is assem=
bled
>> we should be loading from the container, if the container is not
>> available then mdmon can't be running and checksum errors are real.
>>
>
> My test scenario is that after boot I'm disassembling read only array=
 and immediately new array is assembled for grow continuation.
> Sometimes occurs that mdadm throws exception and core file is generat=
ed. It shows that anchor pointer has NULL value due to CRC error.
> Second reading try helps, and anchor is always read correctly.
> This behavior and fact that if I put more time between array disassem=
bling and assembling it again helps also suggest, that we have some rac=
e condition here.

Right, so we need to fix that disassemble-to-assemble race, this patch
only "helps" :-).

> Problem is not in currently monitored in mdmon container but rather i=
n interaction with previous mdmon session that is about to close.
>
> This patch makes that error condition never occurs in this scenario.

That "never" needs to be qualified.  This patch makes the race harder
to lose, but as far as I can see not "impossible" to lose.

> Grow.c is fixed for correct error condition behavior also.
> I can agree that both patches in this series can help for this proble=
m separately, but I think both should be placed in code.

Why does this existing check:

               /* retry the load if we might have raced against mdmon *=
/
                if (err =3D=3D 3 && mdmon_running(devnum))
                        for (retry =3D 0; retry < 3; retry++) {
                                usleep(3000);
                                err =3D load_and_parse_mpb(dfd, s, NULL=
, 1);
                                if (err !=3D 3)
                                        break;
                        }

=2E..not help in this case.  I suspect due to that mdmon_running()
qualification and the fact that the test is only seeing this in a
disassemble-to-assemble window.  So that seems to be further evidence
that a higher level fix is needed.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
