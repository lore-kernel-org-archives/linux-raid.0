Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF6F3C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 12 Jul 2022 23:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbiGLXOy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Jul 2022 19:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234095AbiGLXOS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 12 Jul 2022 19:14:18 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B2F2CE1B;
        Tue, 12 Jul 2022 16:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:References:Cc:To:From:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=9+LUIa8fi0KZwpbpSUAEi2kecm8NS6b7ZZDNCe5GTjc=; b=pk3gukehO86ZkxHJ4HcPOaw77A
        LfGqwNjJItWwr46Rs082oPsvDbVzr+1XXL0do+4gCznrznKyGchiZnBavFmIQAjy215HOmJxkObAA
        iPhcQIv30f5kVH3pDAwQSuMQ1ayMi4xZgIHcm2OpQd1wiRRX8EBfLkRDAzWjNfkbRkyAvvS+F+Kar
        EyP4gN/DopkmvU1/BSa1Nsgumd+vU2+hx99oscYsDwFP7xUusac0lN01FNqaF/T4wEBtxVccmyrgq
        rFk92pdcQDbKV7tnYrhvqWZIICMu0xaoRTz3VmLHq8AeNAcjUmEFc9ynIZ4fo4UnzKoH1E65dakEu
        K9neoJ8g==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oBP4f-00DQQY-2t; Tue, 12 Jul 2022 17:13:49 -0600
Message-ID: <85666118-cbb0-83e2-5c27-c3be8c5c6688@deltatee.com>
Date:   Tue, 12 Jul 2022 17:13:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Logan Gunthorpe <logang@deltatee.com>
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, linux-block@vger.kernel.org
References: <20220712070331.1390700-1-hch@lst.de>
 <20220712070331.1390700-3-hch@lst.de>
Content-Language: en-CA
In-Reply-To: <20220712070331.1390700-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: hch@lst.de, song@kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 2/8] md: implement ->free_disk
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-07-12 01:03, Christoph Hellwig wrote:
> Ensure that all private data is only freed once all accesses are done.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/md.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 861d6a9481b2e..ae076a7a87796 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5581,11 +5581,6 @@ static void md_free(struct kobject *ko)
>  		del_gendisk(mddev->gendisk);
>  		put_disk(mddev->gendisk);
>  	}
> -	percpu_ref_exit(&mddev->writes_pending);
> -
> -	bioset_exit(&mddev->bio_set);
> -	bioset_exit(&mddev->sync_set);
> -	kfree(mddev);
>  }
>  
>  static const struct sysfs_ops md_sysfs_ops = {
> @@ -7844,6 +7839,17 @@ static unsigned int md_check_events(struct gendisk *disk, unsigned int clearing)
>  	return ret;
>  }
>  
> +static void md_free_disk(struct gendisk *disk)
> +{
> +	struct mddev *mddev = disk->private_data;
> +
> +	percpu_ref_exit(&mddev->writes_pending);
> +	bioset_exit(&mddev->bio_set);
> +	bioset_exit(&mddev->sync_set);
> +
> +	kfree(mddev);
> +}

I still don't think this is entirely correct. There are error paths that
will put the kobject before the disk is created and if they get hit then
the kfree(mddev) will never be called and the memory will be leaked.

Instead of creating an ugly special path for that, I came up with a solution 
that I think  makes a bit more sense: the kobject is still freed in it's 
own free  function, but the disk holds a reference to the kobject and drops
it in its free function. The sysfs puts and del_gendisk are then moved
into mddev_delayed_delete() so they happen earlier.

Thoughts?

Logan

--

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 78e2588ed43e..330db78a5b38 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5585,15 +5585,6 @@ static void md_free(struct kobject *ko)
 {
        struct mddev *mddev = container_of(ko, struct mddev, kobj);
 
-       if (mddev->sysfs_state)
-               sysfs_put(mddev->sysfs_state);
-       if (mddev->sysfs_level)
-               sysfs_put(mddev->sysfs_level);
-
-       if (mddev->gendisk) {
-               del_gendisk(mddev->gendisk);
-               blk_cleanup_disk(mddev->gendisk);
-       }
        percpu_ref_exit(&mddev->writes_pending);
 
        bioset_exit(&mddev->bio_set);
@@ -5618,6 +5609,17 @@ static void mddev_delayed_delete(struct work_struct *ws)
        struct mddev *mddev = container_of(ws, struct mddev, del_work);
 
        kobject_del(&mddev->kobj);
+
+       if (mddev->sysfs_state)
+               sysfs_put(mddev->sysfs_state);
+       if (mddev->sysfs_level)
+               sysfs_put(mddev->sysfs_level);
+
+       if (mddev->gendisk) {
+               del_gendisk(mddev->gendisk);
+               blk_cleanup_disk(mddev->gendisk);
+       }
+
        kobject_put(&mddev->kobj);
 }
 
@@ -5708,6 +5710,7 @@ int md_alloc(dev_t dev, char *name)
        else
                sprintf(disk->disk_name, "md%d", unit);
        disk->fops = &md_fops;
+       kobject_get(&mddev->kobj);
        disk->private_data = mddev;
 
        mddev->queue = disk->queue;
@@ -7858,6 +7861,13 @@ static unsigned int md_check_events(struct gendisk *disk, unsign>
        return ret;
 }
 
+static void md_free_disk(struct gendisk *disk)
+{
+       struct mddev *mddev = disk->private_data;
+
+       kobject_put(&mddev->kobj);
+}
+
 const struct block_device_operations md_fops =
 {
        .owner          = THIS_MODULE,
@@ -7871,6 +7881,7 @@ const struct block_device_operations md_fops =
        .getgeo         = md_getgeo,
        .check_events   = md_check_events,
        .set_read_only  = md_set_read_only,
+       .free_disk      = md_free_disk,
 };
