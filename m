From: raz ben yehuda <raziebe@gmail.com>
Subject: Re: Subject: [PATCH 006/009]: raid1: chunk size check in run
Date: Wed, 20 May 2009 16:50:38 +0300
Message-ID: <1242827438.3322.81.camel@raz>
References: <1242749054.3293.53.camel@raz>
	 <18963.24749.218732.45333@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18963.24749.218732.45333@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil
First I thank you for your effort. Now I can work in full steam on the
reshape on top of the new raid0 code. Currently this is what I have in
mind.If you have any design suggestions I would be happy to hear before
the coding.

   I added : raid0_add_hot that:
	1. checks if the new disk size if smaller than the raid chunk size. if
so , reject.
	2. check if new the disk size max_hw_sectors is smaller than the
raid's. if so generate a warning but do not reject.   
 	3. adds a disk to raid0 disk list. and turns off its in_sync bit.

I will add raid0_check_reshape 
      This procedure prepares the raid for the reshape process.
	1. Creates a temporary mddev with the same disks as the raid's and with
the new disks. This raid acts as a mere mappings so i will be able to
map sectors to the new target raid in the reshape process. This means i
have to work in create_strip_zones raid0_run ( separate patch ).
        2. Sets the target raid transfer size.
	3. Create an allocation scheme for reshape bio allocation. i reshape in
chunk size. 
	4. create raid0_reshape thread for writes.
	5. wake up raid0_sync thread. 

I will add raid0_sync: raid0_sync acts as the reshape read size process.

    1. Allocates a read bio.	
    2. Map_bio target with find_zone and map_sector, both map_sector and
find_zone are using the old raid mappings.
    3. Deactivate the raid.
    3. Lock and wait for the raid to be emptied from any previous IOs.
    4. Generate a read request.
    5. Release the lock. 

I will add reshape_read_endio: 
	if IO is successful then:
		add the bio to reshape_list
	else
		add the bio to a retry list ( how many retries .. ?)

I will add raid0_reshape: 
	raid0_reshape is a md_thread that polls on the reshape_list and
commences writes based on the reads.
	1. Grub a bio from reshape list.
	2. map sector and find zone on the new raid mappings. 
	3. set bio direction to write.
	4. generate a write.
	
	if bio is in retry_list retry the bio.
	if bio is in active_io list do the bio.
	
I will add a reshape_write_endio that just frees the bio and his pages.

raid0_make_request
	I will add a check and see if the raid is in reshape. 
	if so then
		if IO is in the new mappings area we generate the IO
				from the new mappings.
		if IO is in the old mappings then we generate the IO
				from the old mappings ( race here .. no ?)
		if IO is in the current reshape active area, we push the io to a
active_io list that will processed by raid0_reshape.

		





	 
On Wed, 2009-05-20 at 11:45 +1000, Neil Brown wrote:
> On Tuesday May 19, raziebe@gmail.com wrote:
> > have raid1 check chunk size in run method instead of in md
> 
> I dropped this patch.  chunk_size is not meaningful for raid1.
how embarrassing.

> NeilBrown
> 
> >  raid1.c |    9 +++++++++
> >  1 file changed, 9 insertions(+)
> > Signed-off-by: raziebe@gmail.com
> > ---
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index 2c8d9e6..8609506 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -1942,6 +1942,15 @@ static int run(mddev_t *mddev)
> >  		       mdname(mddev), mddev->level);
> >  		goto out;
> >  	}
> > +	/*
> > +	 * chunk-size has to be a power of 2
> > +	 */
> > +	if ((1 << ffz(~mddev->chunk_size)) != mddev->chunk_size) {
> > +		printk(KERN_ERR "%s chunk_size of %d not valid\n",
> > +			mdname(mddev),
> > +			mddev->chunk_size);
> > +		return -EINVAL;
> > +	}
> >  	if (mddev->reshape_position != MaxSector) {
> >  		printk("raid1: %s: reshape_position set but not supported\n",
> >  		       mdname(mddev));
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

