From: Neil Brown <neilb@suse.de>
Subject: Re: Growing RAID1 array with bitmaps enabled
Date: Wed, 24 Dec 2008 11:41:50 +1100
Message-ID: <18769.34126.76529.310514@notabene.brown>
References: <20081219040730.GA6402@atlantis.cc.ndsu.NoDak.edu>
	<18763.10505.701483.494901@notabene.brown>
	<20081219145334.GC29150@atlantis.cc.ndsu.NoDak.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bryan Mesich on Friday December 19
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Mesich <bryan.mesich@ndsu.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday December 19, bryan.mesich@ndsu.edu wrote:
> On Fri, Dec 19, 2008 at 03:54:33PM +1100, Neil Brown wrote:
> 
> [snip...]
> >  
> > > 1) Does the superblock increase in size when the array is grown 
> > > to make room for a larger bitmap?  (This doesn't seem possible 
> > > to me, particularly if using a v1.1 or v1.2 superblock).
> > 
> > The bitmap does not live in the superblock.  It lives near the
> > superblock. For 0.90, the superblock is 4K in size, and lives at 
> > least 60K from the end of the device.  The bitmap lives in that 60K.
> > 
> > For 1.0, the superblock is 1K in size and lives between 8K and 12K
> > from the end of the device.  There is usually some space reserved
> > before the superblock which is not used for data.  The bitmap lives in
> > one of these spaces.
> > 
> > For 1.1 and 1.2, the superblock is 1K in size and lives near the start
> > of the device.  There is usually some space reserved after the
> > superblock and before the data.  The bitmap is stored there.
> >
>  
> Thanks for the explanation and correction. 
> 
> [snip...]
> 
> > > With this in mind (and the adage that patches are welcome), has there 
> > > been any interest in being able to use a write-intent bitmap for this 
> > > kind of use case?  The benefit of this functionality would keep me 
> > > from eating two _full_ re-syncs on the array when growing the block 
> > > devices.
> > 
> > I think you misunderstand.  There is no need for a full resync.
> > You simply
> > 
> >   mdadm --grow /dev/md0 --bitmap none
> >   mdadm --grow /dev/md0 --size max
> >   mdadm --wait /dev/md0
> >   mdadm --grow /dev/md0 --bitmap internal
> > 
> > The "--wait" will wait while the array syncs the data from 40GB to
> > 100GB.
> 
> Before I can grow the array (using your example), I need to fail
> and remove the devices from the array so they can be grown on the
> FC target.  Something like this:

ahh... I hadn't realised that part of the story.  I guess I was
misunderstanding the situation.

> 
>     # Fail and remove the device that is to be grown
>     mdadm /dev/md0 --fail /dev/sdc1
>     mdadm /dev/md0 --remove /dev/sdc1
> 
>     # Remove the device from the system
>     echo '1' >| /sys/block/sdc/device/delete
> 
> Now that the exported device has been removed from the initiator,
> I can grow the volume on the target.
> 
>     # Scan for the block device that is now 100GB
>     echo "- - -" >| /sys/class/scsi_host/host3/scan
> 
> With the system now seeing the larger block device, I can resize
> the partition (I'll need to use v1.1 or v1.2 suberblock to
> prevent the superblock from getting clobbered).
> 
>     # Add device back into the array
>     mdadm /dev/md0 --add /dev/sdc1

That won't quite do what you want.  The metadata for 1.x records how
much of the device is available for use.  Just making the device
bigger doesn't change that number.
When assembling the array you can get it changed with
    --update=devicesize
but that requires taking the array off-line first.
I guess we want to support --update=devicesize with --add.
Maybe we also want something like
   mdadm --save-metadata /dev/sdc
  (change the size of /dev/sdc somehow)
   mdadm --restore-metadata /dev/sdc

That could work when the metadata is at the end of the device too.

> 
> This is where I would like to use a write-intent bitmap.  When the 
> re-sync finishes, I would do the same to the other device (and
> hopefully use the bitmap for its re-sync).

This part should work fine.  The bitmap should make the recovery
happen very quickly.

> 
> Your email about the bitmap not growing has me a bit gun shy.  Can 
> I use a write-intent bitmap in this situation without shooting 
> myself in the foot?

Yes.  Assuming I understand the situation correctly.

> 
> After both devices have been grown, I would grow the array just
> as you pointed out in your example:
> 
>    mdadm --grow /dev/md0 --bitmap none
>    mdadm --grow /dev/md0 --size max
>    mdadm --wait /dev/md0
>    mdadm --grow /dev/md0 --bitmap internal
> 
> If I understand you correctly, its the "mdadm --grow /dev/md0
> --size max" that will bite me if I have a bitmap enabled.  Thus,
> you removed the bitmap from the array while growing.

Correct.

So the bit you need is --update=devicesize support with --add (or
--re-add really, but they are largely synonymous).

I cannot promise to deliver that in any great hurry, but I'll keep it
in mind.

NeilBrown

