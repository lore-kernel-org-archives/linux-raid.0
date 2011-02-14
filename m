From: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Subject: RE: Single-drive RAID0
Date: Mon, 14 Feb 2011 17:04:38 +0000
Message-ID: <BE2BFE91933D1B4089447C644860408068FB2C6E@irsmsx503.ger.corp.intel.com>
References: <BE2BFE91933D1B4089447C644860408067197930@irsmsx503.ger.corp.intel.com>
	<20110209134557.4e607451@notabene.brown>
	<BE2BFE91933D1B4089447C644860408068C4429D@irsmsx503.ger.corp.intel.com>
 <20110214131149.7f0655a3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110214131149.7f0655a3@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Monday, February 14, 2011 3:12 AM
> To: Wojcik, Krzysztof
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Single-drive RAID0
> 
> On Wed, 9 Feb 2011 14:33:01 +0000 "Wojcik, Krzysztof"
> <krzysztof.wojcik@intel.com> wrote:
> 
> >
> > Steps to reproduce:
> > 1. Create partition on disk (for example: 1 partition, size=half of
> /dev/sda disk)
> > 2. Create filesystem on partition (ext3)
> > 3. Mount partition and create some control data on partition
> > 4. Unmount partition
> > 5. Create RAID0 on disk (mdadm -C /dev/md/vol_1 -amd -e 0.9 -c 64 -l
> 0 -n 1 /dev/sda --force)
> > 6. md127 and md127p1 appears in /dev as expected
> > 7. Try to mount md127p1 and verify control data on them
> 
> I couldn't get this to fail for me.
> It is possible that there is something subtle about the precise device
> geometry.
> Could you send me
>    sfdisk -l /dev/sda
> (or whatever device you are using)
> 
> However when I ran the script without requesting native metadata I did
> get some results somewhat similar to yours - and they were not
> consistent
> which is an important similarity.
> 
> This patch should fix that particular problem.  Let me know if you
> can still produce any of these errors with the patch applied.


Unfortunately issue is reproducible with path applied.
I tried to reproduce it on other setup (other PC and disks) also... issue exists :(

Interesting observation is that when I stop array just after creation and then reassemble it again, everything work fine.
On older kernel version (I tried 2.6.34) issue is NOT reproducible also.

Regards
Krzysztof

> 
> Thanks,
> NeilBrown
> 
> 
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0cc30ec..6818ff4 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4138,10 +4138,10 @@ array_size_store(mddev_t *mddev, const char
> *buf, size_t len)
>  	}
> 
>  	mddev->array_sectors = sectors;
> -	set_capacity(mddev->gendisk, mddev->array_sectors);
> -	if (mddev->pers)
> +	if (mddev->pers) {
> +		set_capacity(mddev->gendisk, mddev->array_sectors);
>  		revalidate_disk(mddev->gendisk);
> -
> +	}
>  	return len;
>  }
> 
