Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB73DC4332F
	for <linux-raid@archiver.kernel.org>; Tue, 20 Dec 2022 01:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbiLTBqi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Dec 2022 20:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbiLTBqH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Dec 2022 20:46:07 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5439C774
        for <linux-raid@vger.kernel.org>; Mon, 19 Dec 2022 17:35:36 -0800 (PST)
Received: from kwepemm600010.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NbfJ16jNfzRq7K;
        Tue, 20 Dec 2022 09:34:25 +0800 (CST)
Received: from [10.174.177.197] (10.174.177.197) by
 kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 20 Dec 2022 09:35:34 +0800
Subject: Re: [PATCH V2] Fix NULL dereference in super_by_fd
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
CC:     Jes Sorensen <jes@trained-monkey.org>,
        <linux-raid@vger.kernel.org>, linfeilong <linfeilong@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        Wu Guanghao <wuguanghao3@huawei.com>
References: <c2cb8668-afc8-459a-9c91-9b0002fbeaa0@huawei.com>
 <20221215125027.00002a45@linux.intel.com>
 <59f29da7-2d07-febd-fc7b-e194bdf3ced8@huawei.com>
 <20221219140845.000030c2@linux.intel.com>
From:   lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <4589f5de-8343-79fb-6b14-731c26399b8c@huawei.com>
Date:   Tue, 20 Dec 2022 09:35:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20221219140845.000030c2@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.197]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600010.china.huawei.com (7.193.23.86)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022/12/19 21:08, Mariusz Tkaczyk wrote:
> On Mon, 19 Dec 2022 19:50:52 +0800
> lixiaokeng <lixiaokeng@huawei.com> wrote:
> 
>> On 2022/12/15 19:50, Mariusz Tkaczyk wrote:
>>> On Wed, 14 Dec 2022 11:17:41 +0800
>>> lixiaokeng <lixiaokeng@huawei.com> wrote:
>>>   
>>>> strcpy(st->devnm, devnm);  
>>>
>>> Hi,
>>> Please use strncpy or snprintf here.  
>>
>> Thanks for your advice, but the length of devnm is not
>> a defined value. I will keep it as the old codes.
> 
> Supertype devnm is a array defined to be 32.
> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/mdadm.h#n1256
> 
> 32 should be changed to MD_NAME_MAX - you can use this define.
> I traveled fd2devnm and I can see that at the end devid2devnm returns:
> static char devnm[32]
> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/lib.c#n123
> 
> For that reason usage of strcpy in this case seems to be safe, unless we change
> something deeper. My recommendation comes from general safe development rules-
> we know dest buffer size so we can esnure that it will be ended properly by
> '\0', whatever comes to write from fd2devnm().
> 
> Thanks,
> Mariusz
> 
> 
Thanks, I understand it. I will modify the patch as V4.

Regards,
Li Xiaokeng

> .
> 
