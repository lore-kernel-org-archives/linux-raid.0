Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D7A6C25B48
	for <linux-raid@archiver.kernel.org>; Thu, 26 Oct 2023 21:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbjJZVfV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 26 Oct 2023 17:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjJZVfU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 26 Oct 2023 17:35:20 -0400
Received: from sender-op-o10.zoho.eu (sender-op-o10.zoho.eu [136.143.169.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F70EC1
        for <linux-raid@vger.kernel.org>; Thu, 26 Oct 2023 14:35:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1698356109; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=DccRrAnm8n2yTQBAmf4XIBqYky/TAa8QZ5MNmGg3EDqO5bMVsExojCDUmHBRLxwT7y22zNaD9mBWcS0Hui8YY2DoUMnDopOBML4d2xdyexpQimtfGRei0/igfLIS2+x0jAVCP9S5qbegBbS03QGfG/lBBjJW/U9rVPIWhcs9o14=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1698356109; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
        bh=B5szUlrjPEodfe4IwDJZlEsLhGfClGFD5nz3gj6G58g=; 
        b=GGLvQtPFx5EsrgNXdwr7Bzh3xmMOfiOoQNj5Y56hv+zb5pQbB9Y+PuuqSwS3ZA6V+s9lu4zRFSzIZgR5ftkbdWlVOo1m86e1wXtk3F8FFem/RtDhKWct4gAPde9TIPgQAUqm0mzDPJAenS0HZKS9qzzIsW8Rs1ylj/ro4FsKmpE=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1698356106997454.1054082337779; Thu, 26 Oct 2023 23:35:06 +0200 (CEST)
Message-ID: <bca30a85-b4f1-51bf-6530-ec1f4925154e@trained-monkey.org>
Date:   Thu, 26 Oct 2023 17:35:05 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 1/2] Mdmonitor: Improve udev event handling
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20230705145020.31144-1-mateusz.grzonka@intel.com>
 <52f43128-6f68-49fd-9b25-c3026d007d83@trained-monkey.org>
 <20230911161820.00007e6f@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230911161820.00007e6f@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/11/23 10:18, Mariusz Tkaczyk wrote:
> On Fri, 1 Sep 2023 11:35:57 -0400
> Jes Sorensen <jes@trained-monkey.org> wrote:
> 
>> On 7/5/23 10:50, Mateusz Grzonka wrote:
>>> Mdmonitor is waiting for udev queue to become empty.
>>> Even if the queue becomes empty, udev might still be processing last event.
>>> However we want to wait and wake up mdmonitor when udev finished
>>> processing events..
>>>
>>> Also, the udev queue interface is considered legacy and should not be
>>> used outside of udev.
>>>
>>> Use udev monitor instead, and wake up mdmonitor on every event triggered
>>> by udev for md block device.
>>>
>>> We need to generate more change events from kernel, because they are
>>> missing in some situations, for example, when rebuild started.
>>> This will be addressed in a separate patch.
>>>
>>> Move udev specific code into separate functions, and place them in udev.c
>>> file. Also move use_udev() logic from lib.c into newly created file.
>>>
>>> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>  
>>
>> Generally looks good to me.
>>
>> One question, is there a minimum version of udev required for this to
>> work or has it been around long enough that we don't need to worry?
>>
>> Thanks,
>> Jes
>>
>>
> 
> Hi Jes,
> We don't need to worry. I checked one random commit (25e773e) from 2014 and
> udev_monitor stuff is there.

Unfortunately this set no longer applies. If you want to send an updated
version I'll do my best to look at it quickly.

Thanks,
Jes


