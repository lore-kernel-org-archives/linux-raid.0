From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] Add stripe cache entries to raid6 sysfs
Date: Thu, 30 Mar 2006 16:10:42 +1100
Message-ID: <17451.26706.789624.534981@cse.unsw.edu.au>
References: <442528D7.1050302@wasp.net.au>
	<44252ACE.9020706@wasp.net.au>
	<44253BDC.3020609@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Brad Campbell on Saturday March 25
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Saturday March 25, brad@wasp.net.au wrote:
> Raid-6 did not create sysfs entries for stripe cache
> 
> Signed-off-by: Brad Campbell <brad@wasp.net.au>
> 
> ---
> diff -u vanilla/linux-2.6.16/drivers/md/raid6main.c linux-2.6.16/drivers/md/raid6main.c
> --- vanilla/linux-2.6.16/drivers/md/raid6main.c 2006-03-20 09:53:29.000000000 +0400
> +++ linux-2.6.16/drivers/md/raid6main.c 2006-03-25 16:35:05.000000000 +0400
> @@ -2148,6 +2148,7 @@
>          }
> 
>          /* Ok, everything is just fine now */
> +        sysfs_create_group(&mddev->kobj, &raid6_attrs_group);
>          mddev->array_size =  mddev->size * (mddev->raid_disks - 2);
> 
>          mddev->queue->unplug_fn = raid6_unplug_device;

Gee, I wonder I missed that...
Thanks!

NeilBrown
