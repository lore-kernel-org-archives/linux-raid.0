From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 2/2] imsm: FIX: Be more patient during loading matadata
Date: Thu, 14 Apr 2011 08:57:01 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D1923BF6D4@irsmsx503.ger.corp.intel.com>
References: <20110412125116.7062.36275.stgit@gklab-128-013.igk.intel.com>
	<20110412125128.7062.38008.stgit@gklab-128-013.igk.intel.com>
	<BANLkTinryn7FTdXMHx9HsMSQqpgykWW+Gg@mail.gmail.com>
	<905EDD02F158D948B186911EB64DB3D192368340@irsmsx503.ger.corp.intel.com>
 <BANLkTi=nontnQ_WKCaUWmosBDBihoDC7JA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

> -----Original Message-----
> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On 
> Behalf Of Dan Williams
> Sent: Wednesday, April 13, 2011 8:56 PM
> To: Kwolek, Adam
> Cc: neilb@suse.de; linux-raid@vger.kernel.org; Ciechanowski, Ed; 
> Neubauer, Wojciech
> Subject: Re: [PATCH 2/2] imsm: FIX: Be more patient during loading 
> matadata
> 
> 2011/4/12 Kwolek, Adam <adam.kwolek@intel.com>:
> >> -----Original Message-----
> >> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On 
> >> Behalf Of Dan Williams
> >> Sent: Wednesday, April 13, 2011 2:45 AM
> >> To: Kwolek, Adam
> >> Cc: neilb@suse.de; linux-raid@vger.kernel.org; Ciechanowski, Ed; 
> >> Neubauer, Wojciech
> >> Subject: Re: [PATCH 2/2] imsm: FIX: Be more patient during loading 
> >> matadata
> >>
> >> On Tue, Apr 12, 2011 at 5:51 AM, Adam Kwolek 
> >> <adam.kwolek@intel.com>
> >> wrote:
> >> > Sometimes occurs that metadata cannot be loaded e.g. wrong check
> sum
> >> > It can happen due to metadata update racing with mdmon condition.
> >> > If mpb loading is tried again, it is loaded successfully.
> >> > Try to load metadata again before really giving up.
> >> >
> >> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> >> > ---
> >> >
> >> >  super-intel.c |   10 ++++++++--
> >> >  1 files changed, 8 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/super-intel.c b/super-intel.c index dc5e34e..d23267a 
> >> > 100644
> >> > --- a/super-intel.c
> >> > +++ b/super-intel.c
> >> > @@ -2773,8 +2773,14 @@ load_and_parse_mpb(int fd, struct
> intel_super
> >> *super, char *devname, int keep_fd
> >> >        int err;
> >> >
> >> >        err = load_imsm_mpb(fd, super, devname);
> >> > -       if (err)
> >> > -               return err;
> >> > +       if (err) {
> >> > +               /* try to load mpb again,
> >> > +                * in case of mdmon race we could have more luck...
> >> > +                */
> >> > +               err = load_imsm_mpb(fd, super, devname);
> >> > +               if (err)
> >> > +                       return err;
> >> > +       }
> >> >        err = load_imsm_disk(fd, super, devname, keep_fd);
> >> >        if (err)
> >> >                return err;
> >>
> >> This is semi-duplicates the check we already do after returning 
> >> from load_and_parse_mpb in load_super_imsm_all.  I'm curious, are 
> >> you hitting this path from load_super_imsm?  If the container is
> assembled
> >> we should be loading from the container, if the container is not 
> >> available then mdmon can't be running and checksum errors are real.
> >>
> >
> > My test scenario is that after boot I'm disassembling read only 
> > array
> and immediately new array is assembled for grow continuation.
> > Sometimes occurs that mdadm throws exception and core file is
> generated. It shows that anchor pointer has NULL value due to CRC error.
> > Second reading try helps, and anchor is always read correctly.
> > This behavior and fact that if I put more time between array
> disassembling and assembling it again helps also suggest, that we have 
> some race condition here.
> 
> Right, so we need to fix that disassemble-to-assemble race, this patch 
> only "helps" :-).
> 
> > Problem is not in currently monitored in mdmon container but rather 
> > in
> interaction with previous mdmon session that is about to close.
> >
> > This patch makes that error condition never occurs in this scenario.
> 
> That "never" needs to be qualified.  This patch makes the race harder 
> to lose, but as far as I can see not "impossible" to lose.


Grow.c looks all devices for metadata,
so I think for both patches word never is ok (without qualified)


> 
> > Grow.c is fixed for correct error condition behavior also.
> > I can agree that both patches in this series can help for this 
> > problem
> separately, but I think both should be placed in code.
> 
> Why does this existing check:
> 
>                /* retry the load if we might have raced against mdmon */
>                 if (err == 3 && mdmon_running(devnum))
>                         for (retry = 0; retry < 3; retry++) {
>                                 usleep(3000);
>                                 err = load_and_parse_mpb(dfd, s, NULL, 
> 1);
>                                 if (err != 3)
>                                         break;
>                         }
> 
> ...not help in this case.  I suspect due to that mdmon_running()




Probably because it is not in execution patch for my case ;) This is in load_super_imsm_all(), my case applies to load_super() /load_super_imsm()/ for particular device that is used in Grow.c:2934.
As You point yourself, similar fix /workaround/ is applied for different usage scenario, so problem is not new and can be fixed in this way. 


> qualification and the fact that the test is only seeing this in a
> disassemble-to-assemble window.  So that seems to be further evidence
> that a higher level fix is needed.
> 
> --
> Dan


I think that mdmon-mdadm synchronization/communication/ has to be discussed again. Such problems can push it to happen.
Probably metadata loading via mdmon should be implemented (single metadata access point).
Anchor passed to mdadm should be build by mdmon /not loaded from disks/. During mdmon life it needs one metadata load 
on start and then metadata snapshots should be flushed to disks only. 
It will take a while /if we decide to use this idea/, but at this moment we have to have code without execution exceptions.


BR
Adam
