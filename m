From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: RE: [PATCH 2/9] FIX: Cannot add spare to monitored container
Date: Thu, 13 Jan 2011 15:15:21 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E8FE023@irsmsx504.ger.corp.intel.com>
References: <20110111135227.13862.88465.stgit@gklab-128-013.igk.intel.com>
	<20110111140403.13862.8338.stgit@gklab-128-013.igk.intel.com>
	<20110112164317.5ccfd59e@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D176E1ADE0@irsmsx503.ger.corp.intel.com>
 <20110113140729.141ff645@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110113140729.141ff645@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

With this problem we are not able to move any spare to imsm container 
and so most of Monitor tests fail at the moment.
Regards 
Anna

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: Thursday, January 13, 2011 4:07 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH 2/9] FIX: Cannot add spare to monitored container
> 
> On Wed, 12 Jan 2011 15:57:45 +0000 "Kwolek, Adam"
> <adam.kwolek@intel.com>
> wrote:
> 
> > > -----Original Message-----
> > > From: NeilBrown [mailto:neilb@suse.de]
> > > Sent: Wednesday, January 12, 2011 6:43 AM
> > > To: Kwolek, Adam
> > > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > > Neubauer, Wojciech
> > > Subject: Re: [PATCH 2/9] FIX: Cannot add spare to monitored
> container
> > >
> > > On Tue, 11 Jan 2011 15:04:03 +0100 Adam Kwolek
> <adam.kwolek@intel.com>
> > > wrote:
> > >
> > > > This fix rolls backs some changes introduced by patch:
> > > > 	"Add spares to raid0 in mdadm"
> > > >
> > > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > >
> > > It would help a lot if you explained *why* you were rolling back
> these
> > > changes.
> > >
> > > Not applied.
> > >
> > > NeilBrown
> >
> >
> > I cannot add spare to i.e. raid5 array. In my unit tests, I'm
> creating raid5 array and then I'm adding spares for expansion (mdadm --
> add).
> > If I've create container with more disks than create array that is
> using fewer disks, I can test expansion.
> > Spares can be added to raid0 with no monitor usage without problems.
> > I've started to observe this problem when patch for adding spares to
> raid0 was applied.
> > I've identify code change that makes problem. This causes this code
> rollback.
> >
> > Problem that is visible is  that. Monitor cannot write major:minor to
> new_dev in sysfs /without code roll back/.
> > I didn't dig this problem deeply. This patch is rather reminder to
> signalize problem /and not forget about it/.
> >
> 
> Fair enough.
> Having a patch which works around a problem and reminds you to fix it
> later
> is a good idea.  However you should make sure that the notes at the top
> of
> the patch make it clear that is the purpose of the patch  - especially
> when
> you post it to me.
> It is just SO important to include completed details in the notes at
> the top
> of the patch!!!!
> 
> NeilBrown
> 
> 
> > BR
> > Adam
> >
> > >
> > > > ---
> > > >
> > > >  Manage.c |    8 ++++----
> > > >  1 files changed, 4 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/Manage.c b/Manage.c
> > > > index 4e6afb5..fa1b13f 100644
> > > > --- a/Manage.c
> > > > +++ b/Manage.c
> > > > @@ -800,16 +800,16 @@ int Manage_subdevs(char *devname, int fd,
> > > >  				if (dv->writemostly == 1)
> > > >  					disc.state |= 1 <<
> MD_DISK_WRITEMOSTLY;
> > > >  				dfd = dev_open(dv->devname, O_RDWR |
> > > O_EXCL|O_DIRECT);
> > > > -				if (tst->ss->external &&
> > > > -				    mdmon_running(tst->container_dev))
> > > > -					tst->update_tail = &tst->updates;
> > > >  				if (tst->ss->add_to_super(tst, &disc,
> dfd,
> > > >  							  dv->devname)) {
> > > >  					close(dfd);
> > > >  					return 1;
> > > >  				}
> > > >  				/* write_init_super will close 'dfd' */
> > > > -				if (tst->ss->write_init_super(tst))
> > > > +				if (tst->ss->external)
> > > > +					/* mdmon will write the metadata */
> > > > +					close(dfd);
> > > > +				else if (tst->ss->write_init_super(tst))
> > > >  					return 1;
> > > >  			} else if (dv->re_add) {
> > > >  				/*  this had better be raid1.
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
