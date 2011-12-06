From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 00/11] Degradation during reshape
Date: Tue, 6 Dec 2011 08:03:55 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A055871@IRSMSX101.ger.corp.intel.com>
References: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
 <20111206115338.2032996c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111206115338.2032996c@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: Tuesday, December 06, 2011 1:54 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin; Williams,
> Dan J
> Subject: Re: [PATCH 00/11] Degradation during reshape
> 
> On Thu, 24 Nov 2011 13:17:10 +0100 Adam Kwolek
> <adam.kwolek@intel.com> wrote:
> 
> > The following series implements support for array degradation during
> reshape.
> >
> > Series mostly fixes problems in handling degradation during reshape in
> > imsm metadata .
> >
> > Main common problem that last patch resolves is is lack of BBM support.
> > md on disk failure reports BBM event to user space and waits for an
> answer.
> > The side effect of this action is stopping reshape process. The last
> > patch /together with md patch sent separately/ allows for disabling BBM
> mechanism.
> > This is similar as native metadata v0.9 works.
> >
> > BR
> > Adam
> >
> >
> 
> Sorry for the long delay in getting to these - I've been busy :-(
> 
> >
> > Adam Kwolek (11):
> >       Disable BBM when it is not supported
> 
> Not applied as discussed separately.  I'll follow up on this issue separately.
> 
> >       imsm: FIX: Check maximum allowed degradation level in
> recover_backup_imsm()
> >       imsm: FIX: Check maximum allowed degradation level in
> open_backup_targets()
> >       imsm: FIX: Function rework - imsm_count_failed()
> 
> These 3 applied.
> 
> >       imsm: FIX: Manage second map state on array degradation
> 
> I've applied this, but I don't like the fact that you have used '2' and '4'
> for MAP_0 and MAP_1.
> I see that you use '&' to test a bit and you wanted separate bits, but I don't
> see any place where "look_in_map" could have multiple bits set.
> So why not MAP_0==0 and MAP_1==1 and use e.g. "look_in_map ==
> MAP_0".
> 
> I'm quite happy with defining the symbolic named (MAP_0 and MAP_1), just
> confused by the values chosen.
> 
> Could you please explain the logic, or fix it up with a new patch?  Thanks.

Using 'bits' gives ability to test in both maps at a time. 
Now I've got this series a 'little' reworked so I try to remove it.

> 
> >       imsm: FIX: Restore critical section on degraded array
> >       imsm: FIX: Remove single map state limitation in getinfo
> >       imsm: FIX: Finalize degraded migration
> >       imsm: FIX: Do not end migration when missing drive is handled
> 
> These 4 applied.
> 
> >       imsm: FIX: Mark both maps on degradation while migrating
> 
> applied, but I think mark_failure might still be wrong.
> What if the device that fails is in MAP_1 but not in MAP_0?  I don't think it
> gets marked as failed in that case.

Currently there is not disk replace functionality, so this case is not possible.
If something is failed in MAP_1 this means that it is marked as failed in MAP_0 already
Or it is rebuild of this failed disk, but I'll think about preparing it for the future.



> 
> >       imsm: FIX: Return longer map for failure setting
> 
> I changed the type of 'map2' from 'void *' to 'struct imsm_map *', and
> applied the result.
> 
> Thanks.
> 
> BTW if you want these in SLES11-SP2 I'll need a request through bugzilla.
> Just one is enough, not one for every patch.

It will be nice:) I'll do this when whole solution will be in place.

BR
Adam

> 
> NeilBrown

