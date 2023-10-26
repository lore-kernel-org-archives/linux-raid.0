Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9353DC25B48
	for <linux-raid@archiver.kernel.org>; Thu, 26 Oct 2023 21:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbjJZVgj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 26 Oct 2023 17:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjJZVgi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 26 Oct 2023 17:36:38 -0400
Received: from sender-op-o9.zoho.eu (sender-op-o9.zoho.eu [136.143.169.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A1BDC
        for <linux-raid@vger.kernel.org>; Thu, 26 Oct 2023 14:36:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1698355275; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=WR9U+hwzW6S00NHps6N/kuj9KFi63KsWTvntNZhM82Q2gNvbxh1pTwmvrGbr4HN58hCPhh/YgdOc/skk+GLPQhyJhXpwAA0NrezzP2VXMe7XFynzg4gdI7LiAxq5/y0c4N3faix9bHiHwCrpuMPMB15DYdkcI7GPpJTZTNL1vWs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1698355275; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
        bh=lf9m3zJgbqWl9sjS1PsMbt1TStLHiKDb6Sra77oV1nI=; 
        b=C7TWJbeJQgt9h0MHbBvg3xnIvJxF2ZUq3183qyW9EzalUyD1NQuHEzK74WdAtc+lDWlq1GFFn2pGfIW+0PXcxjmA19YRUnKBJsw1Ev8+UczUR+6KNCkcEho46aBySdNt7FKBnayF7XZE6/DMv5h89oqAXf8lc+JS74l6UtoCDHY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1698355271659686.3146962418554; Thu, 26 Oct 2023 23:21:11 +0200 (CEST)
Message-ID: <df2a31f1-080b-0150-42f1-c5e9c647d70b@trained-monkey.org>
Date:   Thu, 26 Oct 2023 17:21:09 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] Assemble: fix redundant memory free
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org,
        colyli@suse.de
References: <20230912022701.948-1-kinga.tanska@intel.com>
 <20230912114902.00003e1c@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230912114902.00003e1c@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/12/23 05:49, Mariusz Tkaczyk wrote:
> On Tue, 12 Sep 2023 04:27:01 +0200
> Kinga Tanska <kinga.tanska@intel.com> wrote:
> 
>> Commit e9fb93af0f76 ("Fix memory leak in file Assemble")
>> fixes few memory leaks in Assemble, but it introduces
>> problem with assembling RAID volume. It was caused by
>> clearing metadata too fast, not only on fail in
>> select_devices() function.
>> This commit removes redundant memory free.
>>
>> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
>> ---
>>  Assemble.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/Assemble.c b/Assemble.c
>> index 61e8cd17..5be58e40 100644
>> --- a/Assemble.c
>> +++ b/Assemble.c
>> @@ -428,8 +428,6 @@ static int select_devices(struct mddev_dev *devlist,
>>  
>>  			/* make sure we finished the loop */
>>  			tmpdev = NULL;
>> -			free(st);
>> -			st = NULL;
>>  			goto loop;
>>  		} else {
>>  			content = *contentp;
> 
> Hi Jes,
> It is a regression. Please merge it ASAP, it broke a a lot of our tests.

Applied!

Sorry for missing this.

Thanks,
Jes


