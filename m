Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5185C00144
	for <linux-raid@archiver.kernel.org>; Mon,  1 Aug 2022 08:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiHAIIG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 1 Aug 2022 04:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiHAIIE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 1 Aug 2022 04:08:04 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFFB18E07
        for <linux-raid@vger.kernel.org>; Mon,  1 Aug 2022 01:08:03 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Lx9cg4t5VzWfnD;
        Mon,  1 Aug 2022 16:04:03 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 1 Aug 2022 16:07:43 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 1 Aug 2022 16:07:42 +0800
Message-ID: <3b232f33-f2f7-dced-b823-302ea0647894@huawei.com>
Date:   Mon, 1 Aug 2022 16:07:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH 1/5 v2] parse_layout_faulty: fix memleak
To:     Jes Sorensen <jes@trained-monkey.org>,
        <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
CC:     <linfeilong@huawei.com>, <lixiaokeng@huawei.com>
References: <fd86d427-2d3e-b337-6de8-d70dcbbd6ce1@huawei.com>
 <00ae6b42-b561-6542-0421-4ab8542d5d75@huawei.com>
 <e4affbf6-621c-4bdd-b8dd-b4a60ef1b0a6@trained-monkey.org>
From:   Wu Guanghao <wuguanghao3@huawei.com>
In-Reply-To: <e4affbf6-621c-4bdd-b8dd-b4a60ef1b0a6@trained-monkey.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



在 2022/7/29 5:15, Jes Sorensen 写道:
> On 6/8/22 23:06, Wu Guanghao wrote:
>> char *m is allocated by xstrdup but not free() before return, will cause
>> a memory leak.
>>
>> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
>> ---
>>  util.c | 3 +++
>>  1 file changed, 3 insertions(+)
> 
> Hi Wu
> 
> This no longer seems to apply, would you mind rebasing and resending the
> series?
> 
> Thanks,
> Jes
OK, I will rebase and resend later.

Wu
> 
>> diff --git a/util.c b/util.c
>> index cc94f96e..46b04afb 100644
>> --- a/util.c
>> +++ b/util.c
>> @@ -427,8 +427,11 @@ int parse_layout_faulty(char *layout)
>>         int ln = strcspn(layout, "0123456789");
>>         char *m = xstrdup(layout);
>>         int mode;
>> +
>>         m[ln] = 0;
>>         mode = map_name(faultylayout, m);
>> +       free(m);
>> +
>>         if (mode == UnSet)
>>                 return -1;
>>
>> --
>> 2.27.0
> 
> .
> 
