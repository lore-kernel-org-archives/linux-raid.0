From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 0/3] Continue expansion after reboot
Date: Wed, 23 Feb 2011 09:02:25 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D178FAB82A@irsmsx503.ger.corp.intel.com>
References: <20110222135440.7582.87319.stgit@gklab-128-013.igk.intel.com>
 <20110223143756.41139e11@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110223143756.41139e11@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Wednesday, February 23, 2011 4:38 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH 0/3] Continue expansion after reboot
> 
> On Tue, 22 Feb 2011 15:13:15 +0100 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > Currently reshaped/expanded array is assembled but it stays in
> inactive state.
> > This patches allows for array assembly when array is under expansion.
> > Array with reshape/expansion information in metadata is assembled
> > and reshape process continues automatically.
> >
> > Next step:
> > Problem is how to address container operation during assembly.
> > 1. After first array being reshaped, assebly process looks if mdmon
> >    sets migration for other array in container. If yes it continues
> work
> >    for next array.
> >
> > 2. Assembly process performs reshape of currently reshaped array only.
> >    Mdmon sets next array for reshape and user triggers manually mdadm
> >    to finish container operation with just the same parameters set.
> >
> > Reshape finish can be executed for container operation by container
> re-assembly
> > also (this works in current code).
> >
> 
> Yes, this is an awkward problem.
> 
> Just to be sure we are thinking about the same thing:
>   When restarting an array in which migration is already underway mdadm
> simply
>   forks and continues monitoring that migration.
>   However if it is an array-wide migration, then when the migration of
> the
>   first array completes, mdmon will update the metadata on the second
> array,
>   but it isn't clear how mdadm can be told to start monitoring that
> array.
> 
> How about this:
>   the imsm metadata handler should report that an array is 'undergoing
>   migration if it is, or if an earlier array in the container is
> undergoing a
>   migration which will cause 'this' array to subsequently be migrated
> too.
> 
>   So if the first array is in the middle of a 4drive->5drive conversion
> and
>   the second array is simply at '4 drives', then imsm reported (to
>   container_content) that the second drive is actually undergoing a
> migration
>   from 4 to 5 drives, and is at the very beginning.
> 
>   When mdadm assembles that second array it will fork a child to monitor
> it.
>   It will need to somehow wait for mdmon to really update the metadata
> before
>   it starts.  This can probably be handled in the ->manage_reshape
> function.
> 
> Something along those line would be the right way to go I think.  It
> avoid
> any races between arrays being assembled at different times.


This looks fine for me.

> 
> 
> > Adam Kwolek (3):
> >       FIX: Assemble device in reshape state with new disks number
> 
> I don't think this patch is correct.  We need to configure the array
> with the
> 'old' number of devices first, then 'reshape_array' will also set the
> 'new'
> number of devices.
> What exactly what the problem you were  trying to fix?

When array is being assembled with old raid disk number assembly cannot set readOnly array state
(error on sysfs state writing). Array stays in inactive state, so nothing (reshape) happened later.

I think that array cannot be assembled with old disks number (added new disks are present as spares)
because begin of array uses new disks already. This means we are assembling array with not complete disk set.
Stripes on begin can be corrupted (not all disks present in array). At this point inactive array state is ok to keep safe user data.


I'll test is setting old disk number and later configuration change in disks number and array state resolves problem.
I'll let you know results.

BR
Adam

> 
> 
> >       imsm: FIX: Report correct array size during reshape
> >       imsm: FIX: initalize reshape progress as it is stored in
> metatdata
> >
> These both look good - I have applied them.  Thanks.
> 
> NeilBrown
> 

