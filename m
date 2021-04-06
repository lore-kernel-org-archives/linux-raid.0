Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C47C433ED
	for <linux-raid@archiver.kernel.org>; Tue,  6 Apr 2021 18:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87070613B3
	for <linux-raid@archiver.kernel.org>; Tue,  6 Apr 2021 18:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbhDFScG convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 6 Apr 2021 14:32:06 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17025 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbhDFScG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 6 Apr 2021 14:32:06 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1617733909; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=Wrh4RsJQAAqIVHTvpa/WvA8zjfiz3JRlrmzSy+KY6BUoK8kuu/dQH7CCs18v8Hvl98VVO2X2SvXqvo38TXknrX8mh2qZK+B+itzrJVl+aACu1peQbb2Ag9C3psrYOwEn7XLzRB0N3A/3oeVFpGB7RFDh6Ccue4oHqnyjlubjXkM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1617733909; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=fLSLXfN2VC9matj+bseKgQau/3SkJQAl82EeElTXO3A=; 
        b=EJp5d8BplcV8EMCTdkAHghTgheQkwFKqxos0BC3VE3/wnLEpbqxpo/wVD/cJ0sKQBl6ykOPHScCI/GMkjKy58RYpaL9NvDJQqiWQmcA1qZGjGeI14OdcziBTEsLWLT8u5Sb2AsZnSlkZy1z1LSWgcjT2yrnYGpZ/rUr3UUoXqPA=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1617733908105759.0145948969479; Tue, 6 Apr 2021 20:31:48 +0200 (CEST)
Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup file
To:     Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>,
        Nigel Croxon <ncroxon@redhat.com>
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
References: <764426808.38181143.1615910368475.JavaMail.zimbraredhat!com>
 <08b71ea7-bdd3-722d-d18f-aa065b8756c0@linux.intel.com>
 <207580597.39647667.1616433400775.JavaMail.zimbra@redhat.com>
 <5339fdf7-0d8a-e099-1fc4-be42a08c8ad3@linux.intel.com>
 <1361244809.39731072.1616517370775.JavaMail.zimbra@redhat.com>
 <b77b55d3-d9b2-fac9-c756-fabced0546a0@linux.intel.com>
 <1876594627.1682680.1616759962103.JavaMail.zimbra@redhat.com>
 <c98c5ee6-e66f-00a7-7eb2-081324cae31f@trained-monkey.org>
 <c1830ac0-913f-e32e-bf3e-547c00027642@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <90bbc936-36fe-540c-c958-4bc47ed554b8@trained-monkey.org>
Date:   Tue, 6 Apr 2021 14:31:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <c1830ac0-913f-e32e-bf3e-547c00027642@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/2/21 5:40 AM, Oleksandr Shchirskyi wrote:
> On 4/1/2021 10:49 PM, Jes Sorensen wrote:
>> On 3/26/21 7:59 AM, Nigel Croxon wrote:> ----- Original Message ----->
>> From: "Oleksandr Shchirskyi" <oleksandr.shchirskyi@linux.intel.com>> To:
>>>  From f0c80c8e90b2ce113b6e22f919659430d3d20efa Mon Sep 17 00:00:00 2001
>>> From: Nigel Croxon <ncroxon@redhat.com>
>>> Date: Fri, 26 Mar 2021 07:56:10 -0400
>>> Subject: [PATCH] mdadm: fix growing containers
>>>
>>> This fixes growing containers which was broken with
>>> commit 4ae96c802203ec3c (mdadm: fix reshape from RAID5 to RAID6 with
>>> backup file)
>>>
>>> The issue being that containers use the function
>>> wait_for_reshape_isms and expect a number value and not a
>>> string value of "max".  The change is to test for external
>>> before setting the correct value.
>>>
>>> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
>>
>> I was about to revert the problematic patch. Oleksandr, can you confirm
>> if it resolves the issues you were seeing?
>>
>> Thanks,
>> Jes
>>
> 
> Hi Jes,
> 
> Yes, I can confirm that the issue has been resolved with this patch.
> 
> Thanks,
> Oleksandr Shchirskyi

Thanks, I have applied this patch!

Jes

