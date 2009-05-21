From: Neil Brown <neilb@suse.de>
Subject: Re: Subject: [PATCH 006/009]: raid1: chunk size check in run
Date: Thu, 21 May 2009 13:11:39 +1000
Message-ID: <18964.50795.747389.606277@notabene.brown>
References: <1242749054.3293.53.camel@raz>
	<18963.24749.218732.45333@notabene.brown>
	<1242827438.3322.81.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from raz ben yehuda on Wednesday May 20
Sender: linux-raid-owner@vger.kernel.org
To: raz ben yehuda <raziebe@gmail.com>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday May 20, raziebe@gmail.com wrote:
> Neil
> First I thank you for your effort. Now I can work in full steam on the
> reshape on top of the new raid0 code. Currently this is what I have in
> mind.If you have any design suggestions I would be happy to hear before
> the coding.
> 
>    I added : raid0_add_hot that:
> 	1. checks if the new disk size if smaller than the raid chunk size. if
> so , reject.
> 	2. check if new the disk size max_hw_sectors is smaller than the
> raid's. if so generate a warning but do not reject.   
>  	3. adds a disk to raid0 disk list. and turns off its in_sync bit.

I don't think the 'in_sync' bit is used in raid0 currently, so that
bit seems irrelevant, but shouldn't hurt.

> 
> I will add raid0_check_reshape 
>       This procedure prepares the raid for the reshape process.
> 	1. Creates a temporary mddev with the same disks as the raid's and with
> the new disks. This raid acts as a mere mappings so i will be able to
> map sectors to the new target raid in the reshape process. This means i
> have to work in create_strip_zones raid0_run ( separate patch ).
>         2. Sets the target raid transfer size.
> 	3. Create an allocation scheme for reshape bio allocation. i reshape in
> chunk size. 
> 	4. create raid0_reshape thread for writes.
> 	5. wake up raid0_sync thread. 

Do you really need a temporary mddev, or just a temporary 'conf'??
Having to create the raid0_reshape thread just for writes is a bit
unfortunate, but it probably is the easiest approach.  You might be
able to get the raid0_sync thread to do them, but that would be messy
I expect.

> 
> I will add raid0_sync: raid0_sync acts as the reshape read size process.
> 
>     1. Allocates a read bio.	
>     2. Map_bio target with find_zone and map_sector, both map_sector and
> find_zone are using the old raid mappings.
>     3. Deactivate the raid.
>     3. Lock and wait for the raid to be emptied from any previous IOs.
>     4. Generate a read request.
>     5. Release the lock. 

I think that sounds correct.

> 
> I will add reshape_read_endio: 
> 	if IO is successful then:
> 		add the bio to reshape_list
> 	else
> 		add the bio to a retry list ( how many retries .. ?)

zero retries.  The underlying block device has done all the retries
that are appropriate.  If you get a read error, then that block is
gone.  Probably the best you can do is write garbage to the
destination and report the error.

> 
> I will add raid0_reshape: 
> 	raid0_reshape is a md_thread that polls on the reshape_list and
> commences writes based on the reads.
> 	1. Grub a bio from reshape list.
> 	2. map sector and find zone on the new raid mappings. 
> 	3. set bio direction to write.
> 	4. generate a write.
> 	
> 	if bio is in retry_list retry the bio.
> 	if bio is in active_io list do the bio.
> 	
> I will add a reshape_write_endio that just frees the bio and his pages.

OK (except for the retry).

> 
> raid0_make_request
> 	I will add a check and see if the raid is in reshape. 
> 	if so then
> 		if IO is in the new mappings area we generate the IO
> 				from the new mappings.
> 		if IO is in the old mappings then we generate the IO
> 				from the old mappings ( race here .. no ?)
> 		if IO is in the current reshape active area, we push the io to a
> active_io list that will processed by raid0_reshape.

This doesn't seem to match what you say above.
If you don't submit a read for 'reshape' until all IO has drained,
then presumably you would just block any incoming IO until the current
reshape requests have all finished.  i.e. you only ever have IO or
reshape, but not both.

Alternately  you could have a sliding window covering there area
that is currently being reshaped.
If an IO comes in for that area, you need to either
  - close the window and perform the IO, or
  - wait for the window to slide past.

I would favour the latter.  But queueing the IO for raid0_reshape doesn't
really gain you anything I think.

Issues that you haven't mentioned:
  - metadata update: you need to record progress in the metadata
    as the window slides along, in case of an unclean restart
  - Unless you only schedule one chunk at a time (which would be slow
    things down I expect), you need to ensure that you don't schedule
    a write to block for which the read hasn't completed yet.
    This is particularly an issues if you support changing the 
    chunk size.
  - I assume you are (currently) only supporting a reshape that
    increases the size of the array and the number of devices?

NeilBrown
