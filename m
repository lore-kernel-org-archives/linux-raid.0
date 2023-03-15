Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92314C6FD1D
	for <linux-raid@archiver.kernel.org>; Wed, 15 Mar 2023 15:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjCOPTS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Mar 2023 11:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjCOPTR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Mar 2023 11:19:17 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BE954C87
        for <linux-raid@vger.kernel.org>; Wed, 15 Mar 2023 08:19:15 -0700 (PDT)
Received: from kwepemm600010.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PcD2R6qQqznXG8;
        Wed, 15 Mar 2023 22:54:55 +0800 (CST)
Received: from [10.174.177.197] (10.174.177.197) by
 kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 22:57:53 +0800
Subject: Re: [QUESTION] How to fix the race of "mdadm --add" and "mdadm mdadm
 --incremental --export"
To:     Martin Wilck <mwilck@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Song Liu <song@kernel.org>
CC:     Jes Sorensen <jes@trained-monkey.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>, Coly Li <colyli@suse.de>,
        <linux-raid@vger.kernel.org>, linfeilong <linfeilong@huawei.com>,
        <louhongxiang@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        miaoguanqin <miaoguanqin@huawei.com>
References: <252cdcda-afcd-ce76-00cf-c138136e70ab@huawei.com>
 <c00c211a3126d7a30c662117d28f3a4a9c81f7dc.camel@suse.com>
 <20230314165938.00003030@linux.intel.com>
 <04a4cc6aac10cd24d5bc0b3485d47f6ccb752eab.camel@suse.com>
 <20230315111027.0000372d@linux.intel.com>
 <cbea1358-768d-d5f7-5733-06687ad3243a@huawei.com>
 <c3d451cc0c96d1a8c8d129448c1d7c3e340e8fac.camel@suse.com>
From:   Li Xiao Keng <lixiaokeng@huawei.com>
Message-ID: <5fe3dfca-10ad-989a-717d-3007b04163ed@huawei.com>
Date:   Wed, 15 Mar 2023 22:57:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c3d451cc0c96d1a8c8d129448c1d7c3e340e8fac.camel@suse.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.197]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600010.china.huawei.com (7.193.23.86)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2023/3/15 22:14, Martin Wilck wrote:
> On Wed, 2023-03-15 at 21:10 +0800, Li Xiao Keng wrote:
>>>
>>   I test move close() after ioctl(). The reason of EBUSY is that
>> mdadm
>> open(sdf) with O_EXCL. So fd should be closed before ioctl. When I
>> remove
>> O_EXCL, ioctl() will return success.
> 
> This makes sense. I suppose mdadm must use O_EXCL if it modifies RAID
> meta data, otherwise data corruption is just too likely. It is also
> impossible to drop the O_EXCL flag with fcntl() without closing the fd.
> 
> So, if mdadm must close the fd before calling ioctl(), the race can
> hardly be avoided. The close() will cause a uevent, and nothing
> prevents the udev rules from running before the ioctl() returns.
> 
  Now I find that close() cause a change udev. Is it necessary to import
"mdadm --incremental --export" when change udev cause? Can we ignore it?

> Unless we want to explore the flag-in-tmpfs idea, I think mdadm must
> expect this to happen, and deal with -EBUSY accordingly.
> 
> But first we should get an answer to Coly's question, which version of
> mdadm is in use?
> 
  I use 4.1 mdadm and 5.10 kernel.
> Martin
> 
> .
> 
