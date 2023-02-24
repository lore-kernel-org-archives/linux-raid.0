Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B596C64ED6
	for <linux-raid@archiver.kernel.org>; Fri, 24 Feb 2023 02:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjBXCL5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Feb 2023 21:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBXCL4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Feb 2023 21:11:56 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403175E84A
        for <linux-raid@vger.kernel.org>; Thu, 23 Feb 2023 18:11:55 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PNCxr5qL6znWSm;
        Fri, 24 Feb 2023 10:09:20 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Fri, 24 Feb 2023 10:11:52 +0800
Subject: =?UTF-8?Q?Re=3a_question_about_5e8daf906f89_=28=22md=3a_Flush_workq?=
 =?UTF-8?B?dWV1ZSBtZF9yZGV2X21pc2Nfd3EgaW4gbWRfYWxsb2MoKeKAnSk=?=
To:     <david.sloan@eideticom.com>, Logan Gunthorpe <logang@deltatee.com>
CC:     <linux-raid@vger.kernel.org>, <yangerkun@huawei.com>,
        <yukuai@huawei.com>, <song@kernel.org>,
        Li Nan <linan666@huaweicloud.com>
References: <639bcf6e-b8b1-e002-a61f-93ec7ad04bbd@huaweicloud.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <bd26c2c9-9ab6-71e0-b73f-c0ed9a81f4a0@huawei.com>
Date:   Fri, 24 Feb 2023 10:11:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <639bcf6e-b8b1-e002-a61f-93ec7ad04bbd@huaweicloud.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

On 2/10/2023 10:10 AM, Li Nan wrote:
> Hi,
> Commit log says there is race condition in md_rdev_misc_wq, but I find nothing
> wrong with it. Could you tell me how to trigger the bug?
>
> Thansks,
> nan.
>
We want to back-port commit 5e8daf906f89 ("md: Flush workqueue md_rdev_misc_wq
in md_alloc()") into v5.10 LTS, but only judging from its commit message, we
don't know whether it is a good candidate or not. According to my understanding,
the commit tries to wait for the deletion and the release of rdev kobject. The
release of rdev kobject will call rdev_free() to free the allocated memory and
it will not being related with any race, so I think the race mentioned in commit
message must be related with the deletion of rdev kobject. Because the parent of
rdev kobject is mddev and rdev kobject must have been acquired one reference of
mddev kobject, so if the deletion of rdev kobject doesn't completes,
md_kobj_release() and its callee del_gendisk() will be not called, right ? If
the previous created mddev has not already called del_gendisk(), the current
creation of mddev with the same name will fail in add_disk() or kobject_add(). I
think this is the mentioned race in the commit message, right ? If that is the
case, v5.10 LTS also have the same race problem. We will try to reproduce the
problem and post it to v5.10 LTS.
>
> .

