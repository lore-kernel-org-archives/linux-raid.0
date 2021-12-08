Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33CCCC433F5
	for <linux-raid@archiver.kernel.org>; Wed,  8 Dec 2021 14:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbhLHOsz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Dec 2021 09:48:55 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17207 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233093AbhLHOsy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Dec 2021 09:48:54 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1638974716; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=NNBuCSXLofUOVqlX0qqxIYFb8VujqYt8dzZomAG7XbEzj/bO5mzghbJnR7S1Sy6CYWBL2Ddu4Tn1X33al6UqyokfLpjV+2A1lBRbMpVBSTG0s7AFPUFZti4MB5fyQN3gYhdkCO1PIw1J9oem/Hc1fw3klSfUShUCPRfSrwpcgGw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1638974716; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=N5ry7Oe7DCSgnI/dXK0rcYHiXYzCfGOB69rM9iziMfY=; 
        b=ch1MXs2ttwP/I462gqupCV7PMwxuXxNTAwKJM0ZpDSM8kTw+GeyFay6eWpo2t8h0Dzhlu4/vHrqn33rw72nIZAHBNL/z7MXt5wfSEBCaBzrSqFjDbFLvNCcRCVV+fUZdWjBWlvq1/oSkLg3zSRVXBEIgjn3x6wluTZ5PVG3GHr4=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.80] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 163897471457617.968039738820153; Wed, 8 Dec 2021 15:45:14 +0100 (CET)
Subject: Re: [PATCH v3] Monitor: print message before quit for no array to
 monitor
To:     Coly Li <colyli@suse.de>
Cc:     George Gkioulis <ggkioulis@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        linux-raid@vger.kernel.org
References: <20210902073220.19177-1-colyli@suse.de>
 <c9e5b8af-1a1d-82c0-1ca0-af4bd1182d75@suse.de>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <46d238f5-0757-b876-4a41-6f89605b7d8a@trained-monkey.org>
Date:   Wed, 8 Dec 2021 09:45:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <c9e5b8af-1a1d-82c0-1ca0-af4bd1182d75@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Coly,

Didn't see this one as it was only copied to my work email. Sorry.

Applied!

Thanks,
Jes

On 12/5/21 8:39 AM, Coly Li wrote:
> Hi  Jes,
> 
> Could you take this one for 4.2? It is posted for a while, which fixes a
> bug report of mine.
> 
> Thanks.
> 
> Coly Li
> 
> On 9/2/21 3:32 PM, Coly Li wrote:
>> If there is no array device to monitor, Monitor() will stop monitoring
>> at line 261 from the following code block,
>>   257                 if (!new_found) {
>>   258                         if (oneshot)
>>   259                                 break;
>>   260                         else if (!anyredundant) {
>>   261                                 break;
>>   262                         }
>>
>> This change was introduced by commit 007087d0898a ("Monitor: stop
>> notifing about containers"). Before this commit, Monitor() will continue
>> and won't quit even there is no array to monitor.
>>
>> It is fine to quit without any array device to monitor, but users may
>> wonder whether there is something wrong with mdadm program or their
>> configuration to make mdadm quit monitoring.
>>
>> This patch adds a simple error message to indicate Monitor() quits for
>> array device to monitor, which makes users have hint to understand why
>> mdadm stops monitoring.
>>
>> Reported-by: George Gkioulis <ggkioulis@suse.com>
>> Suggested-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Cc: Jes Sorensen <jsorensen@fb.com>
>> ---
>> Changelog:
>> v3: modify printed message by suggestion from Mariusz.
>> v2: add CC to Jes, and fix typo.
>> v1: the original version.
>>
>>   Monitor.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/Monitor.c b/Monitor.c
>> index f541229..839ec78 100644
>> --- a/Monitor.c
>> +++ b/Monitor.c
>> @@ -258,6 +258,7 @@ int Monitor(struct mddev_dev *devlist,
>>               if (oneshot)
>>                   break;
>>               else if (!anyredundant) {
>> +                pr_err("No array with redundancy detected, stopping\n");
>>                   break;
>>               }
>>               else {
> 


