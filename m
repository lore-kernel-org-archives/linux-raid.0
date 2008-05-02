From: Russ Hammer <russ@perneus.com>
Subject: Re: How to grow RAID1 mirror on top of LVM?
Date: Fri, 02 May 2008 11:06:46 -0400
Message-ID: <1209740806.4319.26.camel@russ-ifl90>
References: <25F8EF57-9606-4217-B2D4-2DD3D8E064C4@cam.ac.uk>
	 <18408.36712.100712.499844@notabene.brown>
	 <20080428162556.00ee0d72.taeuber@bbaw.de>
	 <18458.34575.416075.798546@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18458.34575.416075.798546@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Fri, 2008-05-02 at 13:14 +1000, Neil Brown wrote:
> On Monday April 28, taeuber@bbaw.de wrote:
> > Hallo Neil,
> > 
> > Neil Brown <neilb@suse.de> schrieb:
> > > On Thursday March 13, aia21@cam.ac.uk wrote:
> > > > 
> > > > Is there a better way to do this?  I am hoping someone will tell me to  
> > > > use option blah to utility foo that will do this for me without having  
> > > > to break the mirror twice and resync each time.  (-;
> > > 
> > > Sorry, but no.  This mode of operation was never envisaged for md.
> > > I would always put the md/raid1 devices below the LVM.
> > 
> > could you write in some short words what in the design prohibits us to grow a raid1 on a grown lvm?
> 
> By default, the metadata for an md array is stored near the end of
> each device.  If you make the device larger, you lose the metadata.
> This could be address for on-line resizing by having some protocol
> whereby the LVM layer tells whoever is using it that it is about to
> become larger, so that the metadata can be updated and moved, but that
> is probably more hassle than it is worth.
> 
> If you use version 1.1 or 1.2 metadata, the metadata is stored at the
> start of the device, so it doesn't get lost.  However the metadata has
> recorded in it the amount of usable space on the device.  When you
> make the device bigger you would need to update this number.
> There is currently no way to update this for an active array.
> 
> You can stop the array, and the re-assemble it with 
>    --update=devicesize
> 
> this will update the field in the metadata which records the size of
> each device.  You will then be able to grow the array to make use of
> all the space.
> 
> It might not be to hard to make it possible to tell md that devices
> have grown.... maybe one day :-)
> 
> NeilBrown

I'm concerned, I'm currently planning on swapping two 250GB drives with
750GB drives on a RAID1 array using 2.6.9 RHEL 4.6 (mdadm mdadm-1.12.0).

My plan basically was:

# remove one small disk
/sbin/mdadm /dev/md0 --fail /dev/sdb1
/sbin/mdadm /dev/md0 --remove /dev/sdb1

# shutdown and swap in large disk
# (with larger partition for the RAID1 component)
# add large drive into array
/sbin/mdadm /dev/md0 --add /dev/sdb1

# Allow the array to resync
# remove the remaining small drive
/sbin/mdadm /dev/md0 --fail /dev/sda1
/sbin/mdadm /dev/md0 --remove /dev/sda1

# Grow the array
/sbin/mdadm -G /dev/md0 -z max

# shutdown and swap in second large disk
# (with larger partition for the RAID1 component)
# add in the second large drive
/sbin/mdadm /dev/md0 --add /dev/sda1

My concern (based on this discussion) is that this will fail because I
am changing the size of the partition underlying the RAID1 array, much
like the LVM discussion above, while using ver 0.90 superblock.

Do I have a legitimate concern??

Thanks,
Russ Hammer





