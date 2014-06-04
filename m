From: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Subject: RE: [PATCH] Forbid merging with partially assembled IMSM array
Date: Wed, 4 Jun 2014 09:25:47 +0000
Message-ID: <84A53BEA6EAC69439B7E311E9B17A76F0791D2DE@IRSMSX105.ger.corp.intel.com>
References: <84A53BEA6EAC69439B7E311E9B17A76F07918BDA@IRSMSX105.ger.corp.intel.com>
	<20140602121955.10a72b32@notabene.brown>
	<84A53BEA6EAC69439B7E311E9B17A76F0791C0DD@IRSMSX105.ger.corp.intel.com>
 <20140604123046.02e224d6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140604123046.02e224d6@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

> On Wednesday, June 04, 2014 4:31 AM NeilBrown [neilb@suse.de] wrote:
> Subject: Re: [PATCH] Forbid merging with partially assembled IMSM array
> 
> On Tue, 3 Jun 2014 09:03:16 +0000 "Baldysiak, Pawel"
> <pawel.baldysiak@intel.com> wrote:
> 
> > >On Monday, June 02, 2014 4:20 AM NeilBrown [neilb@suse.de] wrote:
> > > On Fri, 30 May 2014 13:11:43 +0000 "Baldysiak, Pawel"
> > > <pawel.baldysiak@intel.com> wrote:
> > >
> > > > Changes introduced in commit:
> > > > 0431869cec4c673309d9aa30a2df4b778bc0bd24
> > > > enabled adding devices to partially assembled array.
> > > > It causes assemble process to override checking controller of device.
> > > >
> > > > For example:
> > > > If ones created IMSM array will be stopped, and some disks will be
> > > > attached to different controller, mdadm will allow to fully
> > > > assemble this array as one md device (due to marge one part to
> another).
> > > >
> > > > This patch resolve this problem by forbidding merge operation on
> > > > arrays with IMSM metadata.
> > >
> > > Why do you think this is a good thing?
> > > You seem to be saying "You cannot access that data  because I don't
> > > like which controllers you have attached it to".
> > >
> > > My thought is that you should provide access to data whenever possible.
> > >
> > > Is there some important situation where the current behaviour will
> > > cause real problems?
> > >
> > > Maybe a warning might be appropriate, but failure doesn't seem
> sensible...
> > >
> > > NeilBrown
> > >
> > Hi Neil,
> >
> > Sorry for all this mess with white-space corruption.
> >
> > Intel platforms have separate OpROMs for each controller.
> > OpROMs manage SW RAIDs at startup and don't support arrays spanned
> across different controllers.
> > In this case array will become degraded or failed after reboot anyway,
> because each OpROM will overwrite metadata on disks based on disks
> attached to specific controller.
> 
> If this is true, then surely we will never get into the situation where the same
> metadata is seen on different controller: the OpROM will have 'fixed' it
> already.
> 
> > User should never be able to assemble IMSM array with disks under
> different controllers by default.
> 
> I ask again:
>    "Is there some important situation where the current behaviour will cause
>     real problems?"
> 
> If not, I don't feel that the change is justified.
> 
> NeilBrown

Hi Neil
 
There are several cases where not forbidding this operation can cause problems.
For example, if user will create IMSM array at one platform, then stop it, detach devices,
and hotplug them to another platform (mixed between two different controllers) - 
everything will be looking good (array will be incrementally assembled without any errors) until reboot.
After that, user will be confused why array is degraded/failed and will be at risk of losing data.
Also, creation of IMSM array under different controllers is forbidden, so there is no point in allowing that it in assemble process.

If you really think this is no justification - I will prepare a patch that will print warning,
but in my opinion this operation should be allowed only with "--force"... 

Thanks
Pawel Baldysiak

> 
> > You can always use "--force" to override this check.
> >
> > Pawel Baldysiak
> >
> > > >
> > > > Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> > > > Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> > > >
> > > > ---
> > > > Assemble.c | 23 +++++++++++++++++++++++
> > > > 1 file changed, 23 insertions(+)
> > > >
> > > > diff --git a/Assemble.c b/Assemble.c index a57d384..9fb65e5 100644
> > > > --- a/Assemble.c
> > > > +++ b/Assemble.c
> > > > @@ -1329,6 +1329,29 @@ try_again:
> > > >                                                return 1;
> > > >                                }
> > > >                                for (dv = pre_exist->devs; dv; dv =
> > > > dv->next) {
> > > > +                                             if
> > > > + (strncmp(mp->metadata, "imsm", 4) == 0 && !c-
> > > >force) {
> > > > +                                                             int dfd;
> > > > +                                                             char dn[20];
> > > > +                                                             struct supertype *st2;
> > > > +                                                             sprintf(dn, "%d:%d", dv->disk.major,
> > > > +                                                                                             dv->disk.minor);
> > > > +                                                             st2 = dup_super(st);
> > > > +                                                             dfd = dev_open(dn, O_RDONLY);
> > > > +                                                             if
> > > > + ((dfd > 0) && (st2->ss->load_super(st2,
> > > dfd, NULL) ||
> > > > +                                                                  (st->ss->compare_super(st, st2) !=
> 0))) {
> > > > +
> > > > + pr_err("IMSM metadata
> > > mismatch!\n");
> > > > +                                                                             pr_err("Aborting...\n");
> > > > +                                                                             close(dfd);
> > > > +                                                             } else {
> > > > +
> > > > + pr_err("IMSM Array already
> > > partially assembled!\n");
> > > > +                                                                             pr_err("Aborting...\n");
> > > > +                                                             }
> > > > +                                                             if (st2) {
> > > > +                                                                             st2->ss->free_super(st2);
> > > > +                                                                             free(st2);
> > > > +                                                             }
> > > > +                                                             return 1;
> > > > +                                             }
> > > >                                                /* We want to add this device to our list,
> > > >                                                 * but it could already be there if "mdadm -I"
> > > >                                                 * started *after* we checked for O_EXCL.
> > > > --
> > > > 1.9.0
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > in the body of a message to majordomo@vger.kernel.org More
> majordomo
> > info at  http://vger.kernel.org/majordomo-info.html

