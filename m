Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 919DDC4332F
	for <linux-raid@archiver.kernel.org>; Mon, 19 Dec 2022 16:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbiLSQqP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Dec 2022 11:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbiLSQqN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Dec 2022 11:46:13 -0500
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09104330
        for <linux-raid@vger.kernel.org>; Mon, 19 Dec 2022 08:46:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1671468347; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=jDZSERosmDZC8sLtYzM0r0NpItIcTqaAgUcyIITXCMAopX9QgGGQ7P2nqoY9pGSQ9bKxCOiJRyijSEO2TwERp935avHVvziixa0f56FD2eu4QMQC5KbI4YBA9mZG9pKfDUxGspDJDwPA63h8HQnJZwH04IFFVUuX4C9dC2BQ91Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1671468347; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=VFfsq9Ic9JqNBTWSOU8iWDBzjExtgGqEp4xRdqSN6qY=; 
        b=SnId7rxuNkiUldZIsOTX8472QdVvI2K6HNZDHVLiQOhgT+QDqZjgaFhkaaZeS3p6fr0vkacuZ5cpUZ3h1Dj08/QK7qrQ9A5SAx/3albDcKpDxE2B5G7rsLjVcAQkNJdN1gjj+pwmnye5plrhHBXaz5mqiLOFRBmQ2OJbvA/wbV4=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1671468344175923.6132706596629; Mon, 19 Dec 2022 17:45:44 +0100 (CET)
Message-ID: <2e04a8d5-266b-1331-4a23-ddc7a4e3aeb4@trained-monkey.org>
Date:   Mon, 19 Dec 2022 11:45:41 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH V2] Fix NULL dereference in super_by_fd
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        lixiaokeng <lixiaokeng@huawei.com>
Cc:     linux-raid@vger.kernel.org, linfeilong <linfeilong@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        Wu Guanghao <wuguanghao3@huawei.com>
References: <c2cb8668-afc8-459a-9c91-9b0002fbeaa0@huawei.com>
 <20221215125027.00002a45@linux.intel.com>
 <59f29da7-2d07-febd-fc7b-e194bdf3ced8@huawei.com>
 <20221219140845.000030c2@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20221219140845.000030c2@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/19/22 08:08, Mariusz Tkaczyk wrote:
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

Totally agree here!

Jes


