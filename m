From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 0/7] Grow_continue, use in assembly (cont.)
Date: Wed, 2 Mar 2011 07:49:18 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17A534A21@irsmsx503.ger.corp.intel.com>
References: <20110301144932.10678.20916.stgit@gklab-128-013.igk.intel.com>
 <20110302123032.6d1996ca@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110302123032.6d1996ca@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Wednesday, March 02, 2011 2:31 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH 0/7] Grow_continue, use in assembly (cont.)
> 
> On Tue, 01 Mar 2011 15:56:41 +0100 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > The following series implements next part of resuming reshape from
> checkpoint.
> > In this series call to invoke reshape is included.
> > It is required to have backup file to run reshape, so backup file
> validation is added
> > (without checking in file system)
> > Array seams to be configured for reshape, monitor is blocked and
> doesn't makes changes
> > to process. On the end of reshape monitor unblock is placed also.
> >
> > In patch:
> >    Continue reshape after assembling array
> > some plans for supporting container operations is placed.
> >
> > Reshape restoring is not working yet (a few more pathes are still
> required)
> > I hope some of therm I'll post tomorrow.
> >
> > BR
> > Adam
> >
> > ---
> >
> > Adam Kwolek (7):
> >       FIX: array is frozen after reshape
> >       Continue reshape after assembling array
> >       FIX: Block monitor when starting array with reshape in progress
> >       Add block_subarray()
> >       FIX: configure disks slot for expansion
> >       FIX: reshape in md should wait for monitoring process (external
> metadata)
> >       FIX: Verify Backup file name before reshape
> >
> >
> >  Assemble.c    |   64 +++++++++++++++++++++++++++++++++++++++++++++---
> ---------
> >  Grow.c        |   15 ++++++++++++-
> >  Incremental.c |    1 +
> >  msg.c         |   18 ++++++++++++----
> >  msg.h         |    2 ++
> >  5 files changed, 81 insertions(+), 19 deletions(-)
> >
> 
> 
> I have applied the patches among these which make sense, and replied to
> the
> ones that really don't.
> 
> If you think one of the patches that I rejected really is needed, please
> provide specific detail of what you try to do, how it doesn't work, and
> what
> you think is the reason.
> 
> All applied patches have been pushed to my  devel-3.2 branch.
> 
> Thanks,
> NeilBrown

Thanks, I'll review your comments.

I think that patches:
	FIX: Continue reshape in the background
	FIX: array is frozen after reshape
and reworked:
	FIX: Verify Backup file name before reshape
for fork() in Grow_continue() will be needed for container operation support.

BR
Adam

