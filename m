From: Xiao Ni <xni@redhat.com>
Subject: Re: [MD PATCH 1/1] Raid5 should update rdev->sectors after reshape
Date: Wed, 5 Jul 2017 05:27:26 -0400 (EDT)
Message-ID: <141634312.28707480.1499246846766.JavaMail.zimbra@redhat.com>
References: <1499149794-7309-1-git-send-email-xni@redhat.com> <5ae7006a-ae4f-d5c2-7d89-93535457d570@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5ae7006a-ae4f-d5c2-7d89-93535457d570@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com, tbskyd@gmail.com, shli@kernel.org
List-Id: linux-raid.ids



----- Original Message -----
> From: "Guoqing Jiang" <gqjiang@suse.com>
> To: "Xiao Ni" <xni@redhat.com>, linux-raid@vger.kernel.org
> Cc: ncroxon@redhat.com, tbskyd@gmail.com, shli@kernel.org
> Sent: Wednesday, July 5, 2017 4:51:59 PM
> Subject: Re: [MD PATCH 1/1] Raid5 should update rdev->sectors after reshape
> 
> 
> 
> On 07/04/2017 02:29 PM, Xiao Ni wrote:
> > The raid5 md device is created by the disks which we don't use the total
> > size. For example,
> > the size of the device is 5G and it just uses 3G of the devices to create
> > one raid5 device.
> > Then change the chunksize and wait reshape to finish. After reshape
> > finishing stop the raid
> > and assemble it again. It fails.
> > mdadm -CR /dev/md0 -l5 -n3 /dev/loop[0-2] --size=3G --chunk=32
> > --assume-clean
> > mdadm /dev/md0 --grow --chunk=64
> > wait reshape to finish
> > mdadm -S /dev/md0
> > mdadm -As
> > The error messages:
> > [197519.814302] md: loop1 does not have a valid v1.2 superblock, not
> > importing!
> > [197519.821686] md: md_import_device returned -22
> >
> > After reshape the data offset is changed. It selects backwards direction in
> > this condition.
> > In function super_1_load it compares the available space of the underlying
> > device with
> > sb->data_size. The new data offset gets bigger after reshape. So
> > super_1_load returns -EINVAL.
> > sb->data_size is updated in md_finish_reshape. So add md_finish_reshape in
> > end_reshape.
> 
> IMO, md_finish_reshape doesn't update sb->data_size directly, but it
> updates rdev->sectors,
> then super_1_sync sets sb->data_size based on rdev->sectors.

Ah yes, thanks for pointing this. It should be rdev->sectors is updated
in md_finish_reshape. 

Regards
Xiao
> 
> Acked-by: Guoqing Jiang <gqjiang@suse.com>
> 
> Thanks,
> Guoqing
> 
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   drivers/md/raid5.c | 4 +---
> >   1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index ec0f951..e7f527c 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -7947,12 +7947,10 @@ static void end_reshape(struct r5conf *conf)
> >   {
> >   
> >   	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
> > -		struct md_rdev *rdev;
> >   
> >   		spin_lock_irq(&conf->device_lock);
> >   		conf->previous_raid_disks = conf->raid_disks;
> > -		rdev_for_each(rdev, conf->mddev)
> > -			rdev->data_offset = rdev->new_data_offset;
> > +		md_finish_reshape(conf->mddev);
> >   		smp_wmb();
> >   		conf->reshape_progress = MaxSector;
> >   		conf->mddev->reshape_position = MaxSector;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
