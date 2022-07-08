Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F84C433EF
	for <linux-raid@archiver.kernel.org>; Fri,  8 Jul 2022 15:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238861AbiGHP4M (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Jul 2022 11:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238231AbiGHP4K (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Jul 2022 11:56:10 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D0C70E51;
        Fri,  8 Jul 2022 08:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=ZhbelBsJa/6H2udfVLFm+KR3QIH8CfJyNQNmrBUwPGg=; b=ZVGjNgbP1TNRjvkrJFzSGHxFSv
        U92XgdEkzY/TT3JnYvYetH+ag89tcxhnoNnd1DpgP/r/JSdW1LvNuRYoSHDIOG6fhexX1Zu3ejkIc
        YNLU6FYAgKJ9i1w+euxpHjvqRWqnpYgp9NL+lAgPrp8xc6fmhX2R3tTrH+hSbf/Gs1NsFwZ9UsIJ8
        jKu+VKTMlr1F+BTpyKYs+VAuHzHbFxJRAkUawZoneRgUWcBn7yYkopul9MQq9EcJFXTpUGN2ND5Is
        oTMTPOLEnH1NeCApBto0XKJIqf7GOHwe4rY8nL/OYnBYvyqenx/NrcHQLJGd3dJthIhzHagBpgAG1
        6TiCZiSQ==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1o9qKk-009wqN-Qk; Fri, 08 Jul 2022 09:55:59 -0600
Message-ID: <c43e40da-7549-0c81-2a3c-d837b59f7e76@deltatee.com>
Date:   Fri, 8 Jul 2022 09:55:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-CA
To:     Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk, shinichiro.kawasaki@wdc.com,
        dan.j.williams@intel.com, yukuai3@huawei.com, ming.lei@redhat.com,
        linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>
References: <20220614074827.458955-1-hch@lst.de>
 <20220614074827.458955-5-hch@lst.de>
 <72a5bf2e-cd56-a85c-2b99-cb8729a66fed@deltatee.com>
 <20220708060126.GA16457@lst.de>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220708060126.GA16457@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: hch@lst.de, axboe@kernel.dk, shinichiro.kawasaki@wdc.com, dan.j.williams@intel.com, yukuai3@huawei.com, ming.lei@redhat.com, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: REGRESSION: [PATCH 4/4] block: freeze the queue earlier in
 del_gendisk
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-07-08 00:01, Christoph Hellwig wrote:
> On Thu, Jul 07, 2022 at 11:41:40PM -0600, Logan Gunthorpe wrote:
>> I'm not really sure why this is yet, but this patch in rc4 causes some
>> random failures with mdadm tests.
>>
>> It seems the 11spare-migration tests starts failing roughly every other
>> run because the block device is not quite cleaned up after mdadm --stop
>> by the time the next mdadm --create commands starts, or rather there
>> appears to be a race now between the newly created device and the one
>> being cleaned up. This results in an infrequent sysfs panic with a
>> duplicate filename error (see the end of this email).
>>
>> I managed to bisect this and found a09b314005f3a09 to be the problematic
>> commit.
> 
> Taking a look at the mddev code this commit just seems to increase the
> race window of hitting horrible life time problems in md, but I'll also
> try to reproduce and verify it myself.
> 
> Take a look at how md searches for a duplicate name in md_alloc,
> mddev_alloc_unit and mddev_find_locked based on the all_mddevs list,
> and how the mddev gets dropped from all_mddevs very early and long
> before the gendisk is gone in mddev_put.  I think what needs to be
> done is to implement a free_disk method and drop the mddev (and free it)
> from that.  But given how much intricate mess is based on all_mddevs
> we'll have to be very careful about that.

I agree it's a mess, probably buggy and could use a cleanup with a
free_disk method. But I'm not sure the all_mdevs lifetime issues are the
problem here. If the entry in all_mdevs outlasts the disk, then
md_alloc() will just fail earlier. Many test scripts rely on the fact
that you can stop an mddev and recreate it immediately after. We need
some way of ensuring any deleted disks are fully deleted before trying
to make a new mddev, in case the new one has the same name as one being
deleted.

The md code deletes the disk in md_delayed_delete(), a work queue item
on md_misc_wq. That queue is flushed first in md_misc_wq, but somehow,
some of the disk is still not fully deleted by the time
flush_workqueue() returns. I'm not sure why that would be.

Logan
