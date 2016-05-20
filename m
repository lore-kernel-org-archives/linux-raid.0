From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] Need update superblock on time when deciding to do
 reshape
Date: Fri, 20 May 2016 10:59:46 -0700
Message-ID: <20160520175946.GA76216@kernel.org>
References: <1463475249-18658-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1463475249-18658-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

On Tue, May 17, 2016 at 04:54:09PM +0800, Xiao Ni wrote:
> Hi all
> 
> If the disks are not enough to have spaces for relocating the data_offset,
> it needs to run start_reshape and then run mdadm --grow --continue by 
> systemd. But mdadm --grow --continue fails because it checkes that 
> info->reshape_active is 0. 
> 
> The info->reshape_active is set to 1 when the superblock feature_map
> have the flag MD_FEATURE_RESHAPE_ACTIVE. Superblock feature_map is set
> MD_FEATURE_RESHAPE_ACTIVE as mddev->reshape_position != MaxSector.
> 
> Function start_reshape calls raid5_start_reshape which changes 
> mddev->reshape_position to 0. Then in md_check_recovery it updates the
> superblock to underlying devices. But there is a chance that the superblock
> haven't written to underlying devices, the mdadm reads the superblock data.
> So mdadm --grow --continue fails.
> 
> The steps to reproduce this:
> mdadm -CR /dev/md0 -l5 -n3 /dev/loop[0-2] --bitmap=internal
> mdadm --wait /dev/md0
> mdadm /dev/md0 -a /dev/loop3
> mdadm --grow --raid-devices  4 /dev/md0
> The loop device size is 500MB
> 
> [root@storageqe-09 ~]# cat /proc/mdstat 
> Personalities : [raid6] [raid5] [raid4] 
> md0 : active raid5 loop3[4] loop2[3] loop1[1] loop0[0]
>       1021952 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]
>       [>....................]  reshape =  0.0% (1/510976) finish=0.0min speed=255488K/sec
>       bitmap: 1/1 pages [4KB], 65536KB chunk

what's the bad effect of the --continue failure? I think reshape will still
continue. Doing a update super there is ok, but I'm wondering if it's the good
way. Could mdadm wait for MD_FEATURE_RESHAPE_ACTIVE then let systemd run?
Because sounds like we are working around systemd bug, kernel itself will write
superblock anyway soon, so we probably working around in userspace.

> unused devices: <none>
> 
> So if we update the superblock on time, mdadm can read the right superblock data.
> 
> Signed-off-by <xni@redhat.com>
> 
> ---
>  drivers/md/md.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 14d3b37..7919606 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4350,6 +4350,7 @@ action_store(struct mddev *mddev, const char *page, size_t len)
>  			else {
>  				clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>  				err = mddev->pers->start_reshape(mddev);
> +				md_update_sb(mddev, 1);

write super even err != 0?

Thanks,
Shaohua
