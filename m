From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 14/53] FIX: Cannot exit monitor after takeover
Date: Tue, 30 Nov 2010 16:03:16 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174C8AB57@irsmsx503.ger.corp.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
	<20101126080537.5221.28837.stgit@gklab-170-024.igk.intel.com>
 <20101129103829.0964debb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101129103829.0964debb@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

The problem is that, when raid0 array is about unfreezing and this is single/last array in container,
Ping to this container causes to mdmon not to exit.
In such condition managemon receives message and in handle_message() for ping case, calls wakeup_monitor()
and then goes in to loop for monitor_loop_cnt update 
1. this occurs after timeout 
2. when this happens managemon stops on pselect() and as there is nothing to monitor in never wakeups.
3. monitor waits to be allowed to exit on open handlers.

How can this be resolved:
1. do not ping for last raid0 array during unfreezing (I've reworked patch to meet this condition)
2. guard waiting for monitor_loop_cnt change in handle_message() with:
	if (container->arrays)

3. change in manage member condition:
	if (sigterm)
		Wakeup_monitor();

To
	if (sigterm || (container->arrays == NULL))
		Wakeup_monitor();

This causes additional monitor wakeup.

Any of method causes mdmon to exit as expected. 
In cases 2 and 3 it takes a while (we are waiting on communication timeouts).
Method 1 is fast and we are not blocking mdmon exit by communication.

BR
Adam

> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Monday, November 29, 2010 12:38 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed
> Subject: Re: [PATCH 14/53] FIX: Cannot exit monitor after takeover
> 
> On Fri, 26 Nov 2010 09:05:37 +0100 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > When performing backward takeover to raid0 monitor cannot exit
> > for single raid0 array configuration.
> > Monitor is locked by communication (ping_manager()) after unfreeze()
> 
> I think you are saying that when we convert a RAID5 to a RAID0, the
> mdmon
> notices that there is nothing more for it to do, so it exits.  Then
> mdadm has
> problems contacting it.  Is that right?
> It doesn't seem quite right as the 'ping_monitor' should simply fail if
> the
> mdmon has disappeared.
> 
> Could you say a bit more about what you observe happening.
> 
> >
> > Do not ping manager for raid0 array as they shouldn't be monitored.
> 
> Only this isn't quite what the patch does.  What it does is:
>    if the 'last' subarray found is raid0, then don't ping the monitor.
> In general, (though possibly not in imsm) there could be multiple
> arrays,
> some RAID0, some not.  So we would need to track if there are an with
>    level > 0
> and ping_monitor if any such were found.
> 
> I would be reasonably happy with such a patch, except that I cannot yet
> see
> exactly why it is needed.  So could you explain exactly what you are
> seeing
> please?
> 
> Thanks,
> NeilBrown
> 
> 
> 
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >
> >  msg.c |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/msg.c b/msg.c
> > index 8e7ebfd..95c6f0b 100644
> > --- a/msg.c
> > +++ b/msg.c
> > @@ -385,11 +385,12 @@ void unblock_monitor(char *container, const int
> unfreeze)
> >  		if (!is_container_member(e, container))
> >  			continue;
> >  		sysfs_free(sra);
> > -		sra = sysfs_read(-1, e->devnum, GET_VERSION);
> > +		sra = sysfs_read(-1, e->devnum, GET_VERSION|GET_LEVEL);
> >  		if (unblock_subarray(sra, unfreeze))
> >  			fprintf(stderr, Name ": Failed to unfreeze %s\n", e-
> >dev);
> >  	}
> > -	ping_monitor(container);
> > +	if (sra && sra->array.level > 0)
> > +		ping_monitor(container);
> >
> >  	sysfs_free(sra);
> >  	free_mdstat(ent);

