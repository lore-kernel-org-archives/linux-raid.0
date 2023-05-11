Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC56C7EE23
	for <linux-raid@archiver.kernel.org>; Thu, 11 May 2023 14:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238195AbjEKOir (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 11 May 2023 10:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238507AbjEKOha (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 11 May 2023 10:37:30 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D2210E40
        for <linux-raid@vger.kernel.org>; Thu, 11 May 2023 07:37:18 -0700 (PDT)
Received: from kwepemm600010.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QHDrs5L5pzpSvr;
        Thu, 11 May 2023 22:33:01 +0800 (CST)
Received: from [10.174.177.197] (10.174.177.197) by
 kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 22:37:14 +0800
Subject: Re: [PATCH] Fix race of "mdadm --add" and "mdadm --incremental"
To:     Martin Wilck <mwilck@suse.com>, <jes@trained-monkey.org>,
        <pmenzel@molgen.mpg.de>, <colyli@suse.de>,
        <linux-raid@vger.kernel.org>
CC:     <miaoguanqin@huawei.com>, <louhongxiang@huawei.com>
References: <20230417140144.3013024-1-lixiaokeng@huawei.com>
 <ad5ba0f238f3919a125fb3ad18a2d228758a4ee0.camel@suse.com>
From:   Li Xiao Keng <lixiaokeng@huawei.com>
Message-ID: <1af8c5cf-4c50-cbdd-d87e-6bb94470acfc@huawei.com>
Date:   Thu, 11 May 2023 22:37:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ad5ba0f238f3919a125fb3ad18a2d228758a4ee0.camel@suse.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.197]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600010.china.huawei.com (7.193.23.86)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2023/5/8 21:35, Martin Wilck wrote:
>> -       if (map_lock(&map))
>> +       if (map_lock(&map)) {
>>                 pr_err("failed to get exclusive lock on mapfile -
>> continue anyway...\n");
> As you added a "return 1" here, the "continue anyway" message is wrong.
> You need to change it.
> 

After resolving doubts of Coly Li, I will change it to

pr_err("failed to get exclusive lock on mapfile when assemble raid.")

Regards,
Li Xiao Keng
