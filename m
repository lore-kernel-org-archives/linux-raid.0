Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE44C43334
	for <linux-raid@archiver.kernel.org>; Wed, 13 Jul 2022 16:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237145AbiGMQbo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Jul 2022 12:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiGMQbn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Jul 2022 12:31:43 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77AC22BCE;
        Wed, 13 Jul 2022 09:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:References:Cc:To:From:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=C7deXBJkld9dKOb+9dmge4oavMjDnk9mwBlB++tFQbg=; b=pgom7nhehqOdPFtPzEiqxAEERB
        oC3Esu9pkpiUpv9Ix6nW2vJDp1iKJeOZ5LMt9WlV6MnlvLZNW64RDueqgWaCgUeAu0916Rlqwwc+I
        GXOX8rvFfv7y1I4tTB6ELUScQmU7r6wiZ9d2Rj6tSpYf6Jw7tF3BgutBEFc6YbF74ubashazYgXfu
        fYfG8L8kjB77zxJcDyS+ll2ToV/X5cL+M8gZ/eLIbkYxYLRHWbDFJ4uRAvLZZinEmZIqUrn54MyXV
        zn279DqOaSk+C75j0cnB780O9PdU7Or7fQcp6zqH0768Zr0AAs1TICiDJc5ZcvsfD3y54svvQeqZf
        CAI4S4MQ==;
Received: from s0106ac1f6bb1ecac.cg.shawcable.net ([70.73.163.230] helo=[192.168.11.155])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oBfH0-00E9Ob-S6; Wed, 13 Jul 2022 10:31:39 -0600
Message-ID: <663a32ea-fb8c-2a5e-253e-29582ba99f3d@deltatee.com>
Date:   Wed, 13 Jul 2022 10:31:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
From:   Logan Gunthorpe <logang@deltatee.com>
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, linux-block@vger.kernel.org
References: <20220713113125.2232975-1-hch@lst.de>
 <20220713113125.2232975-2-hch@lst.de>
 <1f9beba5-3fa0-a0e6-c810-a82cec8e3496@deltatee.com>
In-Reply-To: <1f9beba5-3fa0-a0e6-c810-a82cec8e3496@deltatee.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 70.73.163.230
X-SA-Exim-Rcpt-To: hch@lst.de, song@kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 1/9] md: fix error handling in md_alloc
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-07-13 09:26, Logan Gunthorpe wrote:
> 
> 
> 
> On 2022-07-13 05:31, Christoph Hellwig wrote:
>> Error handling in md_alloc is a mess.  Untangle it to just free the mddev
>> directly before add_disk is called and thus the gendisk is globally
>> visible.  After that clear the hold flag and let the mddev_put take care
>> of cleaning up the mddev through the usual mechanisms.
>>
>> Fixes: 5e55e2f5fc95 ("[PATCH] md: convert compile time warnings into runtime warnings")
>> Fixes: 9be68dd7ac0e ("md: add error handling support for add_disk()")
>> Fixes: 7ad1069166c0 ("md: properly unwind when failing to add the kobject in md_alloc")
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>>
>> Note: the put_disk here is not fully correct on md-next, but will
>> do the right thing once merged with the block tree.
>>
>>  drivers/md/md.c | 45 ++++++++++++++++++++++++++++++++-------------
>>  1 file changed, 32 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index b64de313838f2..7affddade8b6b 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -791,6 +791,15 @@ static struct mddev *mddev_alloc(dev_t unit)
>>  	return ERR_PTR(error);
>>  }
>>  
>> +static void mddev_free(struct mddev *mddev)
>> +{
>> +	spin_lock(&all_mddevs_lock);
>> +	list_del(&mddev->all_mddevs);
>> +	spin_unlock(&all_mddevs_lock);
>> +
>> +	kfree(mddev);
>> +}
> 
> Sadly, I still don't think this is correct. mddev_init() has already
> called kobject_init() and according to the documentation it *must* be
> cleaned up with a call to kobject_put(). That doesn't happen in this
> path -- so I believe this will cause memory leaks.

What about something along these lines:



diff --git a/drivers/md/md.c b/drivers/md/md.c
index 78e2588ed43e..1d13840cec6d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5581,6 +5581,15 @@ md_attr_store(struct kobject *kobj, struct
attribute *at>
        return rv;
 }

+static void mddev_free(struct mddev *mddev)
+{
+       percpu_ref_exit(&mddev->writes_pending);
+       bioset_exit(&mddev->bio_set);
+       bioset_exit(&mddev->sync_set);
+
+       kfree(mddev);
+}
+
 static void md_free(struct kobject *ko)
 {
        struct mddev *mddev = container_of(ko, struct mddev, kobj);
@@ -5593,12 +5602,9 @@ static void md_free(struct kobject *ko)
        if (mddev->gendisk) {
                del_gendisk(mddev->gendisk);
                blk_cleanup_disk(mddev->gendisk);
+       } else {
+               mddev_free(mddev);
        }
-       percpu_ref_exit(&mddev->writes_pending);
-
-       bioset_exit(&mddev->bio_set);
-       bioset_exit(&mddev->sync_set);
-       kfree(mddev);
 }

 static const struct sysfs_ops md_sysfs_ops = {
@@ -7858,6 +7864,13 @@ static unsigned int md_check_events(struct
gendisk *disk>
        return ret;
 }

+static void md_free_disk(struct gendisk *disk)
+{
+       struct mddev *mddev = disk->private_data;
+
+       mddev_free(mddev);
+}
+
 const struct block_device_operations md_fops =
 {
        .owner          = THIS_MODULE,
@@ -7871,6 +7884,7 @@ const struct block_device_operations md_fops =
        .getgeo         = md_getgeo,
        .check_events   = md_check_events,
        .set_read_only  = md_set_read_only,
+       .free_disk      = md_free_disk,
 };
