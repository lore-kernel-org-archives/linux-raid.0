Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C422AC7EE2D
	for <linux-raid@archiver.kernel.org>; Fri, 24 Feb 2023 16:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjBXQo3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Feb 2023 11:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjBXQo1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Feb 2023 11:44:27 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAF01A961
        for <linux-raid@vger.kernel.org>; Fri, 24 Feb 2023 08:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=q7a1MMJej8spZZqPqzyK6/2I+gSBfKSUT7n2BdpTGQU=; b=VwpEWZ401rUZkuXxk3Puz4Re75
        QP7pHI9lSfHUA375awxAZUzelJO59ImwTORehqA++RsCwiO6vsHHYLHkkFzAL9xG86pPkgdSoXpNK
        O6ue+tL8jTJNpPDXULqz2C5tDV3Yac8B8BKglru+mbD6xJp1rEG5b2Tz/O/5vs2kwNQKW9/QNC4Re
        bkAVWyqS8pPCzgja76AUMUAjfiYOEwi5D0T2uXHNQs51rRLhT5tSQ0SxBLxOW5tMVadVk1qonaE0w
        7nMngGeXtZ2mvmDDRqMy9KC4J30QjM2GWy3H+p2Iq4lOJcGes8qHoo3iXZNuJlOxFU+b0iXkkhVD3
        lfjuLmRA==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1pVbB8-002QTk-Hq; Fri, 24 Feb 2023 09:44:15 -0700
Message-ID: <9317d93a-92b0-8239-5eb9-531e73433784@deltatee.com>
Date:   Fri, 24 Feb 2023 09:44:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
To:     Hou Tao <houtao1@huawei.com>, david.sloan@eideticom.com
Cc:     linux-raid@vger.kernel.org, yangerkun@huawei.com,
        yukuai@huawei.com, song@kernel.org,
        Li Nan <linan666@huaweicloud.com>
References: <639bcf6e-b8b1-e002-a61f-93ec7ad04bbd@huaweicloud.com>
 <bd26c2c9-9ab6-71e0-b73f-c0ed9a81f4a0@huawei.com>
Content-Language: en-CA
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <bd26c2c9-9ab6-71e0-b73f-c0ed9a81f4a0@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: houtao1@huawei.com, david.sloan@eideticom.com, linux-raid@vger.kernel.org, yangerkun@huawei.com, yukuai@huawei.com, song@kernel.org, linan666@huaweicloud.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: =?UTF-8?Q?Re=3a_question_about_5e8daf906f89_=28=22md=3a_Flush_workq?=
 =?UTF-8?B?dWV1ZSBtZF9yZGV2X21pc2Nfd3EgaW4gbWRfYWxsb2MoKeKAnSk=?=
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2023-02-23 19:11, Hou Tao wrote:
> Hi,
> 
> On 2/10/2023 10:10 AM, Li Nan wrote:
>> Hi,
>> Commit log says there is race condition in md_rdev_misc_wq, but I find nothing
>> wrong with it. Could you tell me how to trigger the bug?
>>
>> Thansks,
>> nan.
>>
> We want to back-port commit 5e8daf906f89 ("md: Flush workqueue md_rdev_misc_wq
> in md_alloc()") into v5.10 LTS, but only judging from its commit message, we
> don't know whether it is a good candidate or not. According to my understanding,
> the commit tries to wait for the deletion and the release of rdev kobject. The
> release of rdev kobject will call rdev_free() to free the allocated memory and
> it will not being related with any race, so I think the race mentioned in commit
> message must be related with the deletion of rdev kobject. Because the parent of
> rdev kobject is mddev and rdev kobject must have been acquired one reference of
> mddev kobject, so if the deletion of rdev kobject doesn't completes,
> md_kobj_release() and its callee del_gendisk() will be not called, right ? If
> the previous created mddev has not already called del_gendisk(), the current
> creation of mddev with the same name will fail in add_disk() or kobject_add(). I
> think this is the mentioned race in the commit message, right ? If that is the
> case, v5.10 LTS also have the same race problem. We will try to reproduce the
> problem and post it to v5.10 LTS.


Yes, that sounds correct. I expect v5.10 will have the same problem and
it is a good candidate to back port.

Logan


