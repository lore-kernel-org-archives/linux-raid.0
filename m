Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 971F7C25B70
	for <linux-raid@archiver.kernel.org>; Thu, 26 Oct 2023 21:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344853AbjJZVhQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 26 Oct 2023 17:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344860AbjJZVhP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 26 Oct 2023 17:37:15 -0400
Received: from sender-op-o11.zoho.eu (sender-op-o11.zoho.eu [136.143.169.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023251B2
        for <linux-raid@vger.kernel.org>; Thu, 26 Oct 2023 14:37:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1698356226; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=I5Bd6fgNDbLy/48rqAoSJJAJnEPMeKuovRH/vHO6VLb5KqLLGLXzz18b53gNkqF0NFt/cce7qcwF67cJ6Rj/KstIXbM/cR17nDUuN0kmvWgxQbBeLGb8BLBPXqbJUpWaLCC/zR6KvvNqlYZNBZKb+6IGe3TSsEsGFT4/1Ip96ug=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1698356226; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
        bh=z7jrUQFeY1GwH7i70Ocjfj4u0WHpY4qhYs6/BEsq3wU=; 
        b=NglmoxtOQn5Sahr/sxHx0DVmGEhinYqy7s/mTjOVzPNVR9R5sPYwXFpS7qM2hIKbfDBKeFviLCBZcVs2DHbA0Hn69CdbbrTlh78oTOMIYV5AA4BH10eODg7kv8idJOI8e2TE6GBkUNLTMeltWymtZILxb1S34nqsgln+8RbtXqc=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1698356223343168.68718483329576; Thu, 26 Oct 2023 23:37:03 +0200 (CEST)
Message-ID: <13054f53-4b9b-77f4-bd36-42ad50e40858@trained-monkey.org>
Date:   Thu, 26 Oct 2023 17:37:02 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v5] Incremental: remove obsoleted calls to udisks
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org
References: <20230813164613.11912-1-colyli@suse.de>
 <3dddeea7-cfda-63d3-7169-e42ef05f9467@trained-monkey.org>
 <20230904094832.000033a7@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230904094832.000033a7@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/4/23 03:48, Mariusz Tkaczyk wrote:
> On Fri, 1 Sep 2023 11:47:09 -0400
> Jes Sorensen <jes@trained-monkey.org> wrote:
> 
>> On 8/13/23 12:46, Coly Li wrote:
>>> Utility udisks is removed from udev upstream, calling this obsoleted
>>> command in run_udisks() doesn't make any sense now.
>>>
>>> This patch removes the calls chain of udisks, which includes routines
>>> run_udisk(), force_remove(), and 2 locations where force_remove() are
>>> called. Considering force_remove() is removed with udisks util, it is
>>> fair to remove Manage_stop() inside force_remove() as well.
>>>
>>> In the two modifications where calling force_remove() are removed,
>>> the failure from Manage_subdevs() can be safely ignored, because,
>>> 1) udisks doesn't exist, no need to check the return value to umount
>>>    the file system by udisks and remove the component disk again.
>>> 2) After the 'I' inremental remove, there is another 'r' hot remove
>>>    following up. The first incremental remove is a best-try effort.
>>>
>>> Therefore in this patch, where force_remove() is removed, the return
>>> value of calling Manage_subdevs() is not checked too.
>>>
>>> Signed-off-by: Coly Li <colyli@suse.de>
>>> Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
>>> Cc: Jes Sorensen <jes@trained-monkey.org>
>>> ---
>>> Changelog,
>>> v5: change Mariusz's email address as he suggested
>>> v4: add Reviewed-by from Mariusz.
>>> v3: remove the almost-useless warning message, and make the change
>>>    more simplified.
>>> v2: improve based on code review comments from Mariusz.
>>> v1: initial version.
>>>
>>>  Incremental.c | 64 +++++++++++----------------------------------------
>>>  1 file changed, 13 insertions(+), 51 deletions(-)  
>>
>> Been out of the loop for a while, trying to catch up.
>>
>> Mariusz, do you consider this one good to go now? You were the one
>> providing feedback multiple times.
>>
>> Thanks,
>> Jes
>>
>>
> 
> Hi Jes,
> 
> Yes, I see this as a good change. The current behavior is not stable, because
> udev is not able to "umount"- if array is not mounted it is stopped, otherwise
> not.
> 
> With the change, we will not try to stop it at all- fair for me, behavior is
> same every time. If we cannot stop array every time we should not try to.

Applied!

Thanks,
Jes


