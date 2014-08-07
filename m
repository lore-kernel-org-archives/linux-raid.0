From: Xiao Ni <xni@redhat.com>
Subject: Re: After reshaping raid1 to raid0 with bitmap, then stop md panic
Date: Thu, 7 Aug 2014 06:03:37 -0400 (EDT)
Message-ID: <1783178354.19231525.1407405817606.JavaMail.zimbra@redhat.com>
References: <324320204.17911195.1407221719669.JavaMail.zimbra@redhat.com> <11051344.17913061.1407222186494.JavaMail.zimbra@redhat.com> <20140806163702.15592dc6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140806163702.15592dc6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Jes Sorensen <jes.sorensen@redhat.com>
List-Id: linux-raid.ids



----- Original Message -----
> From: "NeilBrown" <neilb@suse.de>
> To: "Xiao Ni" <xni@redhat.com>
> Cc: linux-raid@vger.kernel.org, "Jes Sorensen" <jes.sorensen@redhat.com>
> Sent: Wednesday, August 6, 2014 2:37:02 PM
> Subject: Re: After reshaping raid1 to raid0 with bitmap, then stop md panic
> 
> On Tue, 5 Aug 2014 03:03:06 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:
> 
> > Dear all
> > 
> > 
> >    I faced one problem that the system panic after reshaping raid1 to raid0
> >    with bitmap.
> > The dmesg and calltrace information is like this:
> > 
> >    You can easily reproduce this by those steps:
> >    1. mdadm -CR /dev/md0 -l1 -n2 /dev/loop[0-1] --bitmap=internal
> >    2. mdadm --wait /dev/md0
> >    3. mdadm --grow -l0 /dev/md0
> >    4. mdadm -S /dev/md0
> ...
> > 
> > [ 1485.646746] BUG: unable to handle kernel NULL pointer dereference at
> > 0000000000000038
> > [ 1485.654724] IP: [<ffffffff8148db2e>] bitmap_daemon_work+0x24e/0x450
> 
> Yes, RAID0 doesn't support bitmaps, so this cannot possibly work.
> 
> Following patch should turn the crash into a clean failure.
> 
> Thanks for the report,
> NeilBrown
> 
> 
> From 1bdb20e16166240a4ca3b861c48defefaf218874 Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Wed, 6 Aug 2014 16:34:27 +1000
> Subject: [PATCH] md: check for bitmap compatability when changing raid
> levels.
> 
> If an array has a bitmap, then it cannot be converted to
> a level which does not support bitmaps.
> 
> Reported-by: Xiao Ni <xni@redhat.com>
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1379b1a3b9ff..3bd13b276e45 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3500,6 +3500,12 @@ level_store(struct mddev *mddev, const char *buf,
> size_t len)
>  		       mdname(mddev), clevel);
>  		return -EINVAL;
>  	}
> +	if (mddev->bitmap && !pers->quiesce) {
> +		module_put(pers->owner);
> +		printk(KERN_WARNING "md: %s: %s does not support a bitmap\n",
> +		       mdname(mddev), clevel);
> +		return -EINVAL;
> +	}
>  
>  	rdev_for_each(rdev, mddev)
>  		rdev->new_raid_disk = rdev->raid_disk;
> 

Hi Neil

   I have tried the patch, but it can reshape to raid0 still, then stop the raid0, the system
panics.

   What does pers->quiesce mean? I'm not familiar with md code. 

Best Regards
Xiao
