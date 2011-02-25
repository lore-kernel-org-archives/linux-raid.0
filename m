From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 0/3] Continue expansion after reboot
Date: Fri, 25 Feb 2011 15:55:01 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17904F0CA@irsmsx503.ger.corp.intel.com>
References: <20110222135440.7582.87319.stgit@gklab-128-013.igk.intel.com>
 <20110223143756.41139e11@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>, NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: Kwolek, Adam
> Sent: Wednesday, February 23, 2011 10:02 AM
> To: 'NeilBrown'
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: RE: [PATCH 0/3] Continue expansion after reboot
> 
> 
> 
> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Wednesday, February 23, 2011 4:38 AM
> > To: Kwolek, Adam
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > Neubauer, Wojciech
> > Subject: Re: [PATCH 0/3] Continue expansion after reboot
> >
> > On Tue, 22 Feb 2011 15:13:15 +0100 Adam Kwolek <adam.kwolek@intel.com>
> > wrote:
> >
> > > Currently reshaped/expanded array is assembled but it stays in
> > inactive state.
> > > This patches allows for array assembly when array is under
> expansion.
> > > Array with reshape/expansion information in metadata is assembled
> > > and reshape process continues automatically.
> > >
> > > Next step:
> > > Problem is how to address container operation during assembly.
> > > 1. After first array being reshaped, assebly process looks if mdmon
> > >    sets migration for other array in container. If yes it continues
> > work
> > >    for next array.
> > >
> > > 2. Assembly process performs reshape of currently reshaped array
> only.
> > >    Mdmon sets next array for reshape and user triggers manually
> mdadm
> > >    to finish container operation with just the same parameters set.
> > >
> > > Reshape finish can be executed for container operation by container
> > re-assembly
> > > also (this works in current code).
> > >
> >
> > Yes, this is an awkward problem.
> >
> > Just to be sure we are thinking about the same thing:
> >   When restarting an array in which migration is already underway
> mdadm
> > simply
> >   forks and continues monitoring that migration.
> >   However if it is an array-wide migration, then when the migration of
> > the
> >   first array completes, mdmon will update the metadata on the second
> > array,
> >   but it isn't clear how mdadm can be told to start monitoring that
> > array.
> >
> > How about this:
> >   the imsm metadata handler should report that an array is 'undergoing
> >   migration if it is, or if an earlier array in the container is
> > undergoing a
> >   migration which will cause 'this' array to subsequently be migrated
> > too.
> >
> >   So if the first array is in the middle of a 4drive->5drive
> conversion
> > and
> >   the second array is simply at '4 drives', then imsm reported (to
> >   container_content) that the second drive is actually undergoing a
> > migration
> >   from 4 to 5 drives, and is at the very beginning.
> >
> >   When mdadm assembles that second array it will fork a child to
> monitor
> > it.
> >   It will need to somehow wait for mdmon to really update the metadata
> > before
> >   it starts.  This can probably be handled in the ->manage_reshape
> > function.
> >
> > Something along those line would be the right way to go I think.  It
> > avoid
> > any races between arrays being assembled at different times.
> 
> 
> This looks fine for me.
> 
> >
> >
> > > Adam Kwolek (3):
> > >       FIX: Assemble device in reshape state with new disks number
> >
> > I don't think this patch is correct.  We need to configure the array
> > with the
> > 'old' number of devices first, then 'reshape_array' will also set the
> > 'new'
> > number of devices.
> > What exactly what the problem you were  trying to fix?
> 
> When array is being assembled with old raid disk number assembly cannot
> set readOnly array state
> (error on sysfs state writing). Array stays in inactive state, so
> nothing (reshape) happened later.
> 
> I think that array cannot be assembled with old disks number (added new
> disks are present as spares)
> because begin of array uses new disks already. This means we are
> assembling array with not complete disk set.
> Stripes on begin can be corrupted (not all disks present in array). At
> this point inactive array state is ok to keep safe user data.
> 
> 
> I'll test is setting old disk number and later configuration change in
> disks number and array state resolves problem.
> I'll let you know results.

I've made some investigations. I've tried assemble algorithm (as you suggested):
Conditions:
 reshape 3 disk raid5 array to 4 disks raid5 array
   is interrupted. Restart is invoked by command 'mdadm -As'

1. Assemble() builds container with new disks number
2. Assemble() builds container content (array with /old/ 3 disks)
3. array is set to frozen to block monitor
4. sync_max in sysfs is set to 0, to block md until reshape monitoring takes carry about reshape process
5. Continue_reshape() starts reshape process
6. Continue_reshape() continues reshape process

Problems I've met:
1. not all disks in Assembly() are added to array (old disks number limitation)
2. setting reshape_position invokes automatically reshape start in md on array run
3. setting of reshape position clears delta_disks in md (and other parameters, for now not important)
4. Assembly() closes handle to array (it has to be not closed and used in reshape continuation)
5. reshape continuation can require backup file. It depends where it was interrupted during expansion,
   Other reshapes can always require backup file 
6. to run reshape, 'reshape' has to be written to sync_action.
    Raid5_start_reshape() is not prepared for reshape restart (i.e reshape position can be 0 or max array value
    - it depends on operation grow/shrink)
7. After array start flag MD_RECOVERY_NEEDED is set, so reshape cannot be started from mdadm
    As array is started with not all disks (old raid disks), we cannot allow for such check (???)
    I've made workaround (setting reshape position clears this flag for external meta)

I've started reshape again on /all/ new disks number, but it still starts from array begin. This is a matter of search where checkpoint is lost.

I've tested my first idea also.
To do as much as we can, as for native meta (reshape is started by array run).
Some problems are similar as before (p.4, p.5)
The only serious problem, that I've got with this is how to let to know md about delta_disks.
I've resolved it by adding special case in raid_disks_store(), 
similar to native metadata when old_disks number is guessed.
For external metadata, I am storing old and then new disks numbers, md calculates delta disks from this raid disks numbers sequence. 
(as I remember you do not want to expose delta disks in sysfs). 

Other issue that I'm observing in both methods is sync_action sysfs entry behavior. It reports reshape->idle->reshape...
This 'idle' for a very short time causes migration cancelation. I've made workaround in mdmon for a now.

Both methods are not fully workable yet, but I think this will change on Monday.

Considering above, I still like more method when we construct array with new disks number.
Begin of array /already reshaped/ has all disks present. In the same way md works for native arrays.

I'm waiting for your comments/questions/ideas.

BR
Adam

> 
> BR
> Adam
> 
> >
> >
> > >       imsm: FIX: Report correct array size during reshape
> > >       imsm: FIX: initalize reshape progress as it is stored in
> > metatdata
> > >
> > These both look good - I have applied them.  Thanks.
> >
> > NeilBrown
> >

