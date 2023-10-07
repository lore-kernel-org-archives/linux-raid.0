Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE09E95A61
	for <linux-raid@archiver.kernel.org>; Sat,  7 Oct 2023 09:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343666AbjJGJ0c (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 7 Oct 2023 05:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjJGJ0b (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 7 Oct 2023 05:26:31 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404A5BC
        for <linux-raid@vger.kernel.org>; Sat,  7 Oct 2023 02:26:29 -0700 (PDT)
Received: from kwepemm000010.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4S2fxT2Ntvz1P7s1;
        Sat,  7 Oct 2023 17:23:57 +0800 (CST)
Received: from [10.174.177.197] (10.174.177.197) by
 kwepemm000010.china.huawei.com (7.193.23.169) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Sat, 7 Oct 2023 17:26:24 +0800
Subject: Re: [PATCH v3] Fix race of "mdadm --add" and "mdadm --incremental"
From:   Li Xiao Keng <lixiaokeng@huawei.com>
To:     Jes Sorensen <jes@trained-monkey.org>,
        Martin Wilck <mwilck@suse.com>, Coly Li <colyli@suse.de>,
        <linux-raid@vger.kernel.org>
CC:     <louhongxiang@huawei.com>, miaoguanqin <miaoguanqin@huawei.com>
References: <a25e4d75-ebc3-0841-832c-34b8e5f4cbb7@huawei.com>
Message-ID: <b6b71a52-016e-7285-f399-43a6cbcf903b@huawei.com>
Date:   Sat, 7 Oct 2023 17:26:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a25e4d75-ebc3-0841-832c-34b8e5f4cbb7@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.197]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm000010.china.huawei.com (7.193.23.169)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

ping

On 2023/9/7 19:37, Li Xiao Keng wrote:
> There is a raid1 with sda and sdb. And we add sdc to this raid,
> it may return -EBUSY.
> 
> The main process of --add:
> 1. dev_open（sdc) in Manage_add
> 2. store_super1(st, di->fd) in write_init_super1
> 3. fsync(fd) in store_super1
> 4. close(di->fd) in write_init_super1
> 5. ioctl(ADD_NEW_DISK)
> 
> Step 2 and 3 will add sdc to metadata of raid1. There will be
> udev(change of sdc) event after step4. Then "/usr/sbin/mdadm
> --incremental --export $devnode --offroot $env{DEVLINKS}"
> will be run, and the sdc will be added to the raid1. Then
> step 5 will return -EBUSY because it checks if device isn't
> claimed in md_import_device()->lock_rdev()->blkdev_get_by_dev()
> ->blkdev_get().
> 
> It will be confusing for users because sdc is added first time.
> The "incremental" will get map_lock before add sdc to raid1.
> So we add map_lock before write_init_super in "mdadm --add"
> to fix the race of "add" and "incremental".
> 
> Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
> Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>
> ---
>  Manage.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/Manage.c b/Manage.c
> index f997b163..075dd720 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -704,6 +704,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  	struct supertype *dev_st;
>  	int j;
>  	mdu_disk_info_t disc;
> +	struct map_ent *map = NULL;
> 
>  	if (!get_dev_size(tfd, dv->devname, &ldsize)) {
>  		if (dv->disposition == 'M')
> @@ -907,6 +908,9 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  		disc.raid_disk = 0;
>  	}
> 
> +	if (map_lock(&map))
> +		pr_err("failed to get exclusive lock on mapfile when add disk\n");
> +
>  	if (array->not_persistent==0) {
>  		int dfd;
>  		if (dv->disposition == 'j')
> @@ -918,9 +922,9 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  		dfd = dev_open(dv->devname, O_RDWR | O_EXCL|O_DIRECT);
>  		if (tst->ss->add_to_super(tst, &disc, dfd,
>  					  dv->devname, INVALID_SECTORS))
> -			return -1;
> +			goto unlock;
>  		if (tst->ss->write_init_super(tst))
> -			return -1;
> +			goto unlock;
>  	} else if (dv->disposition == 'A') {
>  		/*  this had better be raid1.
>  		 * As we are "--re-add"ing we must find a spare slot
> @@ -978,14 +982,14 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  			pr_err("add failed for %s: could not get exclusive access to container\n",
>  			       dv->devname);
>  			tst->ss->free_super(tst);
> -			return -1;
> +			goto unlock;
>  		}
> 
>  		/* Check if metadata handler is able to accept the drive */
>  		if (!tst->ss->validate_geometry(tst, LEVEL_CONTAINER, 0, 1, NULL,
>  		    0, 0, dv->devname, NULL, 0, 1)) {
>  			close(container_fd);
> -			return -1;
> +			goto unlock;
>  		}
> 
>  		Kill(dv->devname, NULL, 0, -1, 0);
> @@ -994,7 +998,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  					  dv->devname, INVALID_SECTORS)) {
>  			close(dfd);
>  			close(container_fd);
> -			return -1;
> +			goto unlock;
>  		}
>  		if (!mdmon_running(tst->container_devnm))
>  			tst->ss->sync_metadata(tst);
> @@ -1005,7 +1009,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  			       dv->devname);
>  			close(container_fd);
>  			tst->ss->free_super(tst);
> -			return -1;
> +			goto unlock;
>  		}
>  		sra->array.level = LEVEL_CONTAINER;
>  		/* Need to set data_offset and component_size */
> @@ -1020,7 +1024,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  			pr_err("add new device to external metadata failed for %s\n", dv->devname);
>  			close(container_fd);
>  			sysfs_free(sra);
> -			return -1;
> +			goto unlock;
>  		}
>  		ping_monitor(devnm);
>  		sysfs_free(sra);
> @@ -1034,7 +1038,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  			else
>  				pr_err("add new device failed for %s as %d: %s\n",
>  				       dv->devname, j, strerror(errno));
> -			return -1;
> +			goto unlock;
>  		}
>  		if (dv->disposition == 'j') {
>  			pr_err("Journal added successfully, making %s read-write\n", devname);
> @@ -1045,7 +1049,11 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  	}
>  	if (verbose >= 0)
>  		pr_err("added %s\n", dv->devname);
> +	map_unlock(&map);
>  	return 1;
> +unlock:
> +	map_unlock(&map);
> +	return -1;
>  }
> 
>  int Manage_remove(struct supertype *tst, int fd, struct mddev_dev *dv,
> 
