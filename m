From: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Subject: RE: [PATCH 00/22] IMSM checkpointing implementation
Date: Wed, 8 Jun 2011 08:34:35 +0100
Message-ID: <28DBC0EA64324E4F9C21D1148E3310B92F48A005@irsmsx503.ger.corp.intel.com>
References: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
 <20110608172349.5ee242c9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608172349.5ee242c9@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Thanks Neil!

We will send set of bug fixes today.

Regards
Krzysztof

> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Wednesday, June 08, 2011 9:24 AM
> To: Wojcik, Krzysztof
> Cc: linux-raid@vger.kernel.org; Neubauer, Wojciech; Kwolek, Adam;
> Williams, Dan J; Ciechanowski, Ed
> Subject: Re: [PATCH 00/22] IMSM checkpointing implementation
> 
> On Thu, 02 Jun 2011 16:48:08 +0200 Krzysztof Wojcik
> <krzysztof.wojcik@intel.com> wrote:
> 
> > IMSM for securing reshape process uses special disk area outside
> metadata
> > for reshaped area backup purposes. If just reshaped array area
> requires
> > backup, bunch of array stripes prepared for reshape is stored in to
> > Migration Copy Area. In case of reshape interruption, Option ROM
> during
> > restart or mdadm during reshape restart (when no reboot occurs) will
> > restore Migration Copy Area to designation array.
> > Reshape can be continued form stable array stable state.
> >
> > The following series implements IMSM checkpointing procedure.
> 
> I have applied most of these patches - some with some minor fixes.  The
> major
> changes I have already mentioned.
> 
> I will wait for you responses to those changes, and the other bug fixes
> you
> mentioned before considering a release of 3.2.2, but I would like to
> make
> that release in the next week or two.
> 
> Thanks,
> NeilBrown
> 
> >
> > ---
> >
> > Adam Kwolek, Krzysztof Wojcik (22):
> >       imsm: Add migration record to intel_super
> >       Support restore_stripes() from the given buffer
> >       Define dummy functions to mdmon.c
> >       imsm: Add support for copy area and backup operations
> >       imsm: check migration compatibility
> >       FIX: Initialize reshape structure
> >       imsm: Add wait_for_reshape_imsm() implementation
> >       imsm: Implement imsm_manage_reshape(), reshape workhorse
> >       imsm: Check if array degradation has been changed
> >       imsm: Clear migration record when no migration in progress
> >       imsm: Add information about migration record to mdadm '-E'
> option
> >       imsm: update blocks_per_migr_unit() to support migration record
> >       Add reshape restart support for external metadata
> >       imsm: Implement recover_backup_imsm() for imsm metadata
> >       imsm: Disable checkpoint updating by mdmon for general
> migration
> >       imsm: Add metadata update type for general migration check-
> pointing
> >       imsm: Prepare checkpoint update for general migration
> >       imsm: Apply checkpoint metadata update for general migration
> >       FIX: Enable metadata updates for raid0
> >       Do not use backup file for external metadata
> >       imsm: Remove user warning before reshape start
> >       imsm: Unit Tests - remove backup-file during grow command
> >
> >
> >  Assemble.c               |   10
> >  Grow.c                   |   50 +-
> >  mdadm.h                  |    7
> >  mdmon.c                  |   23 +
> >  restripe.c               |  101 +++-
> >  super-intel.c            | 1241
> ++++++++++++++++++++++++++++++++++++++++++++--
> >  tests/imsm-grow-template |    5
> >  7 files changed, 1322 insertions(+), 115 deletions(-)
> >

