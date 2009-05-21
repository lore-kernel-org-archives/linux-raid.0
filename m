From: Neil Brown <neilb@suse.de>
Subject: Re: Subject: [PATCH 006/009]: raid1: chunk size check in run
Date: Thu, 21 May 2009 21:33:38 +1000
Message-ID: <18965.15378.406899.856644@notabene.brown>
References: <1242749054.3293.53.camel@raz>
	<18963.24749.218732.45333@notabene.brown>
	<1242827438.3322.81.camel@raz>
	<18964.50795.747389.606277@notabene.brown>
	<1242912733.3598.42.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from raz ben yehuda on Thursday May 21
Sender: linux-raid-owner@vger.kernel.org
To: raz ben yehuda <raziebe@gmail.com>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday May 21, raziebe@gmail.com wrote:
> 
> On Thu, 2009-05-21 at 13:11 +1000, Neil Brown wrote:
> > On Wednesday May 20, raziebe@gmail.com wrote:
> > > Neil
> > > First I thank you for your effort. Now I can work in full steam on the
> > > reshape on top of the new raid0 code. Currently this is what I have in
> > > mind.If you have any design suggestions I would be happy to hear before
> > > the coding.
> > > 
> > >    I added : raid0_add_hot that:
> > > 	1. checks if the new disk size if smaller than the raid chunk size. if
> > > so , reject.
> > > 	2. check if new the disk size max_hw_sectors is smaller than the
> > > raid's. if so generate a warning but do not reject.   
> > >  	3. adds a disk to raid0 disk list. and turns off its in_sync bit.
> > 
> > I don't think the 'in_sync' bit is used in raid0 currently, so that
> > bit seems irrelevant, but shouldn't hurt.
> > > 
> > > I will add raid0_check_reshape 
> > >       This procedure prepares the raid for the reshape process.
> > > 	1. Creates a temporary mddev with the same disks as the raid's and with
> > > the new disks. This raid acts as a mere mappings so i will be able to
> > > map sectors to the new target raid in the reshape process. This means i
> > > have to work in create_strip_zones raid0_run ( separate patch ).
> > >         2. Sets the target raid transfer size.
> > > 	3. Create an allocation scheme for reshape bio allocation. i reshape in
> > > chunk size. 
> > > 	4. create raid0_reshape thread for writes.
> > > 	5. wake up raid0_sync thread. 
> > 
> > Do you really need a temporary mddev, or just a temporary 'conf'??
> I need mddev because i want to use map_sector and create_strip. I
> certainly can fix map_sector and create_strip to work with conf and not
> mddev, though it will make create_strip quite cumbersome. 

I think it would actually be an improvement.
Maybe look at setup_conf in raid5.c.  It does similar things for a
similar reason.
Maybe:
 -  move the setting of mddev->queue->* from create_strip_zones to
    raid0_run.
 -  move the chunk_size check to raid0_run
 -  pass in raid_disks as an argument
 -  get create_strip_zones to return the conf, rather than setting
    ->private (raid0_run sets private if the returned conf was not an
    error).
Then the only part of mddev that create_strip_zones uses is ->disks
which is the same list if both cases (if you ignore those with a
->raid_disk that is too large).


> I will split create_strip to several independent functions. 
> Do you agree ? 

Hard to know without seeing the split.  Maybe if you said what the new
functions would be.

> > Having to create the raid0_reshape thread just for writes is a bit
> > unfortunate, but it probably is the easiest approach.  You might be
> > able to get the raid0_sync thread to do them, but that would be messy
> > I expect.
> I will start with the easy approach, meaning , a different thread for the writes.
> Once i am done , i will see how can merge the reads and writes to work
> in md_sync.

Definitely sensible.

> > > 
> > > I will add raid0_sync: raid0_sync acts as the reshape read size process.
> > > 
> > >     1. Allocates a read bio.	
> > >     2. Map_bio target with find_zone and map_sector, both map_sector and
> > > find_zone are using the old raid mappings.
> > >     3. Deactivate the raid.
> > >     3. Lock and wait for the raid to be emptied from any previous IOs.
> > >     4. Generate a read request.
> > >     5. Release the lock. 
> > 
> > I think that sounds correct.
> > 
> > > 
> > > I will add reshape_read_endio: 
> > > 	if IO is successful then:
> > > 		add the bio to reshape_list
> > > 	else
> > > 		add the bio to a retry list ( how many retries .. ?)
> > 
> > zero retries.  The underlying block device has done all the retries
> > that are appropriate.  If you get a read error, then that block is
> > gone.  Probably the best you can do is write garbage to the
> > destination and report the error.
> > 
> > > 
> > > I will add raid0_reshape: 
> > > 	raid0_reshape is a md_thread that polls on the reshape_list and
> > > commences writes based on the reads.
> > > 	1. Grub a bio from reshape list.
> > > 	2. map sector and find zone on the new raid mappings. 
> > > 	3. set bio direction to write.
> > > 	4. generate a write.
> > > 	
> > > 	if bio is in retry_list retry the bio.
> > > 	if bio is in active_io list do the bio.
> > > 	
> > > I will add a reshape_write_endio that just frees the bio and his pages.
> > 
> > OK (except for the retry).
> > 
> > > 
> > > raid0_make_request
> > > 	I will add a check and see if the raid is in reshape. 
> > > 	if so then
> > > 		if IO is in the new mappings area we generate the IO
> > > 				from the new mappings.
> > > 		if IO is in the old mappings then we generate the IO
> > > 				from the old mappings ( race here .. no ?)
> > > 		if IO is in the current reshape active area, we push the io to a
> > > active_io list that will processed by raid0_reshape.
> > 
> > This doesn't seem to match what you say above.
> > If you don't submit a read for 'reshape' until all IO has drained,  
> > then presumably you would just block any incoming IO until the current
> > reshape requests have all finished.  i.e. you only ever have IO or
> > reshape, but not both.
> Where did i said that ? guess i wasn't clear.
> > Alternately  you could have a sliding window covering there area
> > that is currently being reshaped.
> > If an IO comes in for that area, you need to either
> >   - close the window and perform the IO, or
> >   - wait for the window to slide past.
> > I would favour the latter.  But queueing the IO for raid0_reshape doesn't
> > really gain you anything I think.
> I wasn't clear enough.A "current reshape active area" is my sliding window. 
> I wait for the window to slide past. this is exactly what i had in mind.so yes
> this is what am writing, a reshape_window.

Excellent !!

> > Issues that you haven't mentioned:
> >   - metadata update: you need to record progress in the metadata
> >     as the window slides along, in case of an unclean restart
> I thought md does that for me. So it doesn't. Am i to call
> md_allow_write ( that calls md_update_sbs ) ? how frequent ?

Look at what raid5 does... though that might be a bit hard to follow.
The metadata records the current 'reshape_position'.  That must always
be inside your sliding window.  Once the trailing edge reaches the
reshape_position currently record on disk, you need to update that to
be the leading edge of the window...
Or something like that.  It doesn't feel quite right.  Maybe it is too
late at night to be reasoning this sort of thing clearly :-)

With raid5, I 
  set MD_CHANGE_DEVS in mddev->flags
  md_wakeup_thread(mddev->thread)

and that thread calls md_check_recovery which does:
  if (mddev->flags) {
     if (mddev_trylock(mddev)) {
        if (mddev->flags)
             md_update_sb(mddev, 0);
        mddev_unlock(mddev);
     }



> >   - Unless you only schedule one chunk at a time (which would be slow
> >     things down I expect), you need to ensure that you don't schedule
> >     a write to block for which the read hasn't completed yet.
> ah... yes. i thought of it but forgot. my question is how ? should i
> simply use an interruptable sleep ?  what do you do in raid5 ?

If raid5, I read a whole stripe into the cache before releasing any of
it to be written.  Something like that is probably appropriate for
raid0 too, though you don't have a cache in the same way, so the code
will be very different.

> >     This is particularly an issues if you support changing the 
> >     chunk size.
> >   - I assume you are (currently) only supporting a reshape that
> >     increases the size of the array and the number of devices?
> neither changing the chunk size nor shrink is in my spec. so no. 
> Maybe when i finish my studies ( you can google for "offsched + raz" and follow the link ... )
> then i will have some raid quality time. 
:-)

Thanks,
NeilBrown
