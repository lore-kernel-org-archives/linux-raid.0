From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 3/9] imsm:FIX: one spare can be added to raid0 only
Date: Wed, 12 Jan 2011 15:15:54 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176E1AD42@irsmsx503.ger.corp.intel.com>
References: <20110111135227.13862.88465.stgit@gklab-128-013.igk.intel.com>
	<20110111140411.13862.59242.stgit@gklab-128-013.igk.intel.com>
 <20110112164436.04b5e337@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110112164436.04b5e337@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Wednesday, January 12, 2011 6:45 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH 3/9] imsm:FIX: one spare can be added to raid0 only
> 
> On Tue, 11 Jan 2011 15:04:11 +0100 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > This is part of original commit "Add spares to raid0 in mdadm"
> >
> > Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >
> >  super-intel.c |    8 ++++++++
> >  1 files changed, 8 insertions(+), 0 deletions(-)
> >
> > diff --git a/super-intel.c b/super-intel.c
> > index 90bff47..ef51000 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -3442,6 +3442,8 @@ static int add_to_super_imsm_volume(struct
> supertype *st, mdu_disk_info_t *dk,
> >  	return 0;
> >  }
> >
> > +static int write_super_imsm(struct supertype *st, int doclose);
> > +
> >  static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t
> *dk,
> >  			      int fd, char *devname)
> >  {
> > @@ -3506,6 +3508,12 @@ static int add_to_super_imsm(struct supertype
> *st, mdu_disk_info_t *dk,
> >  		super->disks = dd;
> >  	}
> >
> > +	if (!mdmon_running(st->container_dev)) {
> > +		dprintf("imsm: mdmon is not active- write metadata by
> mdadm\n");
> > +		super->updates_pending++;
> > +		write_super_imsm(st, 0);
> > +	}
> > +
> >  	return 0;
> >  }
> >
> 
> 
> No.
> I don't want "mdmon_running" tests in super-intel.c
> 
> What is the problem you are trying to fix (the comment in the patch
> should
> *always* answer that question for me - I shouldn't have to ask).
> 
> NeilBrown

In new code (I've posted today) that new update mechanism for raid0 is used this patch is not necessary.

Thanks
Adam


