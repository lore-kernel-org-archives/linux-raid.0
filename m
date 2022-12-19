Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 899D5C4332F
	for <linux-raid@archiver.kernel.org>; Mon, 19 Dec 2022 11:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbiLSLu6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Dec 2022 06:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbiLSLu5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Dec 2022 06:50:57 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36AB226CF
        for <linux-raid@vger.kernel.org>; Mon, 19 Dec 2022 03:50:55 -0800 (PST)
Received: from kwepemm600010.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NbJ0f3v17zJqZD;
        Mon, 19 Dec 2022 19:49:54 +0800 (CST)
Received: from [10.174.177.197] (10.174.177.197) by
 kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 19 Dec 2022 19:50:52 +0800
Subject: Re: [PATCH V2] Fix NULL dereference in super_by_fd
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
CC:     Jes Sorensen <jes@trained-monkey.org>,
        <linux-raid@vger.kernel.org>, linfeilong <linfeilong@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        Wu Guanghao <wuguanghao3@huawei.com>
References: <c2cb8668-afc8-459a-9c91-9b0002fbeaa0@huawei.com>
 <20221215125027.00002a45@linux.intel.com>
From:   lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <59f29da7-2d07-febd-fc7b-e194bdf3ced8@huawei.com>
Date:   Mon, 19 Dec 2022 19:50:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20221215125027.00002a45@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.197]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600010.china.huawei.com (7.193.23.86)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022/12/15 19:50, Mariusz Tkaczyk wrote:
> On Wed, 14 Dec 2022 11:17:41 +0800
> lixiaokeng <lixiaokeng@huawei.com> wrote:
> 
>> strcpy(st->devnm, devnm);
> 
> Hi,
> Please use strncpy or snprintf here.

Thanks for your advice, but the length of devnm is not
a defined value. I will keep it as the old codes.

> 
> Thanks,
> Mariusz
> 
> .
> 
