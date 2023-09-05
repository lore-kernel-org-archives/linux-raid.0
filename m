Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59DDDCA1001
	for <linux-raid@archiver.kernel.org>; Tue,  5 Sep 2023 19:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbjIETYz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Sep 2023 15:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbjIETYv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 5 Sep 2023 15:24:51 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2ED8CE5
        for <linux-raid@vger.kernel.org>; Tue,  5 Sep 2023 12:24:28 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 684561FEDE;
        Tue,  5 Sep 2023 16:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1693930659; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nez4k2sc0HgAzIfVbaGUBkTXkHxEHHeV4LsM1KTlVVA=;
        b=Bfy9ac8BQQgu6Bhpa83ZV3v6Yhf9e2mOxDoZIQ7rdQlssHtt/D1Q60R6xjjGBpXmcFG2Jz
        2017Y94SH7C1u6OcgSEYhV0CWV8dn7juP5XawSz+0DCHb1o0EpNaoKp5Col/QFY3/2mFPf
        eQMPrM8bclNMOaHYfNb/Js/tvDMWlKI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1693930659;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nez4k2sc0HgAzIfVbaGUBkTXkHxEHHeV4LsM1KTlVVA=;
        b=rNhZ6bw3iadQkIcaEegXDVR8LOfUPY05bPC5Qo6kiefzNP18xhGykrdziXnFCv3Zv6lBH7
        vPrcrfivceAM2JCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B778613911;
        Tue,  5 Sep 2023 16:17:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TjWgHKBU92ROFgAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 05 Sep 2023 16:17:36 +0000
Date:   Wed, 6 Sep 2023 00:17:31 +0800
From:   Coly Li <colyli@suse.de>
To:     Li Xiao Keng <lixiaokeng@huawei.com>
Cc:     Jes Sorensen <jes@trained-monkey.org>,
        Martin Wilck <mwilck@suse.com>, linux-raid@vger.kernel.org,
        louhongxiang@huawei.com, miaoguanqin <miaoguanqin@huawei.com>
Subject: Re: [PATCH v2] Fix race of "mdadm --add" and "mdadm --incremental"
Message-ID: <kjdwwbkqj6fuaijow2nldh5ofbxymto2mzqcullb57jtx6q6h2@46kropdd4lql>
References: <bcc2d161-521b-ea19-b090-9822925645e5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bcc2d161-521b-ea19-b090-9822925645e5@huawei.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Xiao Keng,

Thanks for the updated version, I add my comments inline.

On Tue, Sep 05, 2023 at 08:02:06PM +0800, Li Xiao Keng wrote:
> When we add a new disk to a raid, it may return -EBUSY.

Where is above -EBUSY from? do you mean mdadm command returns
-EBUSY or it is returned by some specific function in mdadm
source code.

> 
> The main process of --add:
> 1. dev_open
> 2. store_super1(st, di->fd) in write_init_super1
> 3. fsync(di->fd) in write_init_super1
> 4. close(di->fd)
> 5. ioctl(ADD_NEW_DISK)
> 
> However, there will be some udev(change) event after step4. Then
> "/usr/sbin/mdadm --incremental ..." will be run, and the new disk
> will be add to md device. After that, ioctl will return -EBUSY.
>

Dose returning -EBUSY hurt anything? Or only returns -EBUSY and
other stuffs all work as expected?

 
> Here we add map_lock before write_init_super in "mdadm --add"
> to fix this race.
> 

I am not familiar this part of code, but I see ignoring the failure
from map_lock() in Assemble() is on purpose by Neil. Therefore I
just guess simply return from Assemble when map_lock() fails might
not be what you wanted.


> Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
> Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>
> ---
>  Assemble.c |  5 ++++-
>  Manage.c   | 25 +++++++++++++++++--------
>  2 files changed, 21 insertions(+), 9 deletions(-)
> 
> diff --git a/Assemble.c b/Assemble.c
> index 49804941..086890ed 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1479,8 +1479,11 @@ try_again:
>  	 * to our list.  We flag them so that we don't try to re-add,
>  	 * but can remove if they turn out to not be wanted.
>  	 */
> -	if (map_lock(&map))
> +	if (map_lock(&map)) {
>  		pr_err("failed to get exclusive lock on mapfile - continue anyway...\n");
> +		return 1;

Especially when the error message noticed "continue anyway" but a return 1
followed, the behavior might be still confusing.

> +	}
> +
>  	if (c->update == UOPT_UUID)
>  		mp = NULL;
>  	else
> diff --git a/Manage.c b/Manage.c
> index f54de7c6..6a101bae 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -703,6 +703,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  	struct supertype *dev_st;
>  	int j;
>  	mdu_disk_info_t disc;
> +	struct map_ent *map = NULL;
> 
>  	if (!get_dev_size(tfd, dv->devname, &ldsize)) {
>  		if (dv->disposition == 'M')
> @@ -900,6 +901,10 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  		disc.raid_disk = 0;
>  	}
> 
> +	if (map_lock(&map)) {
> +		pr_err("failed to get exclusive lock on mapfile when add disk\n");
> +		return -1;
> +	}
>  	if (array->not_persistent==0) {
>  		int dfd;
>  		if (dv->disposition == 'j')
> @@ -911,9 +916,9 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
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
> @@ -971,14 +976,14 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
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
> @@ -987,7 +992,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  					  dv->devname, INVALID_SECTORS)) {
>  			close(dfd);
>  			close(container_fd);
> -			return -1;
> +			goto unlock;
>  		}
>  		if (!mdmon_running(tst->container_devnm))
>  			tst->ss->sync_metadata(tst);
> @@ -998,7 +1003,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  			       dv->devname);
>  			close(container_fd);
>  			tst->ss->free_super(tst);
> -			return -1;
> +			goto unlock;
>  		}
>  		sra->array.level = LEVEL_CONTAINER;
>  		/* Need to set data_offset and component_size */
> @@ -1013,7 +1018,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  			pr_err("add new device to external metadata failed for %s\n", dv->devname);
>  			close(container_fd);
>  			sysfs_free(sra);
> -			return -1;
> +			goto unlock;
>  		}
>  		ping_monitor(devnm);
>  		sysfs_free(sra);
> @@ -1027,7 +1032,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  			else
>  				pr_err("add new device failed for %s as %d: %s\n",
>  				       dv->devname, j, strerror(errno));
> -			return -1;
> +			goto unlock;
>  		}
>  		if (dv->disposition == 'j') {
>  			pr_err("Journal added successfully, making %s read-write\n", devname);
> @@ -1038,7 +1043,11 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
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

I am not challenging, just before I understand what you are trying to fix,
it is quite hard for me to join the discussion with you for this change.

And, this version is much more informative, and thank you for the effort.

-- 
Coly Li
