From: Neil Brown <neilb@suse.de>
Subject: Re: Devel 3.2 branch issues
Date: Tue, 23 Nov 2010 11:52:13 +1100
Message-ID: <20101123115213.3664ec27@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BF03CC6@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BF03CC6@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On Mon, 22 Nov 2010 22:39:00 +0000
"Czarnowska, Anna" <anna.czarnowska@intel.com> wrote:

> 
> > by the way, some of the changes in you of the patches you sent have not
> > been
> > included in any form.  They include:
> > 
> > - the getinfo_super_disks method.  I couldn't see why you need this.
> > All the
> >   info about the state of the arrays should already be available.
> >   If there is something that you need that we don't have, please
> > explain and
> >   we can see how best to add it back in.
> 
> Marcin has already answered this but here is my explanation.
> Current test devstate[i]==0 is always true for container so any device seems a good candidate to move.
> To be able to identify members, failed devices and real spares we updated devstate for containers.
> To find members we can just check which disks are used in subarrays, but a failed disk is removed from subarray after a short while and as soon as it happens we are not able to see a difference between the failed disk and a spare unless we look at metadata. 

Thanks.  That makes sense.  I'll look at the code and see about applying it.

> 
> > - min_active_disk_size_in_array.  I don't think the minimum current
> > size is
> >   really a good guide.  I've kept the code for letting the metadata
> > handler
> >   check the size, but anything beyond that should be done with domains
> > I
> >   think.
> >   E.g have a domain '2G-or-greater' which is assigned to all 2G or
> > greater
> >   devices.  Then anything smaller will automatically be excluded from
> > arrays
> >   with those devices.
>  
> So if someone doesn't base domains on size they may have a small spare added to an array where it cannot be used. 
> Min_active_disk_size was more than required for an array that didn't occupy the whole disk but at least it ensured that we are not throwing in something that wouldn't help. If we do this the array will remain degraded but will have spare - so Monitor may think it does not need more.
> For this reason we also checked the case when there was a spare in "to" container. If the spare was not suitable (size check here too) we would still look for a good one. 

I don't think it is possible to come up with an automatic way to determine if
a given spare suits a given array that is always correct.  There are too many
subtleties.
So I would like to allow the sysadmin to exercise complete control, and have
defaults that make reasonable sense in common cases.

The 'complete control' can be exercised through domain - though I will
probably add some size based rule mechanism to the policy code so devices can
be categorised by size if wanted.
The 'safe default' is probably best left to the metadata handler.  So
ultimately all metadata types *should* specify min_acceptable_spare_size,
and we will just make do with that.

Does that sound OK?


> 
> And now back to assembly. There is still a segmentation fault when we try to assemble a subarray. Occurs when there is any config file and we run "mdadm -As" or "mdadm -Asc /etc/mdadm.conf". content is NULL when we try to compare uuid in line 413 in Assemble.c.

Yes - patch below should fix this.

> We are going to prepare some tests to add to current suite so it will be easier to verify new patches. 

That would be greatly appreciated!!

Thanks,
NeilBrown

commit 87477e6d5e4201bf2bd812f34f8321983310bd99
Author: NeilBrown <neilb@suse.de>
Date:   Tue Nov 23 11:34:36 2010 +1100

    Assemble: get content before testing it.
    
    When checking that a container matches the required uuid,
    we need to call 'getinfo_super' before we have a 'content'
    to test.
    
    Reported-by: "Czarnowska, Anna" <anna.czarnowska@intel.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Assemble.c b/Assemble.c
index 1a1e128..607f2af 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -409,6 +409,11 @@ int Assemble(struct supertype *st, char *mddev,
                                if (ident->container[0] != '/') {
                                        /* we have a uuid */
                                        int uuid[4];
+
+                                       content = &info;
+                                       memset(content, 0, sizeof(*content));
+                                       tst->ss->getinfo_super(tst, content, NULL);
+
                                        if (!parse_uuid(ident->container, uuid) ||
                                            !same_uuid(content->uuid, uuid, tst->ss->swapuuid)) {
                                                if (report_missmatch)
