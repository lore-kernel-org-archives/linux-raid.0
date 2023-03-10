Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18FC7C6FA99
	for <linux-raid@archiver.kernel.org>; Fri, 10 Mar 2023 14:43:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbjCJOnw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Mar 2023 09:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbjCJOnd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 10 Mar 2023 09:43:33 -0500
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAABD13C7
        for <linux-raid@vger.kernel.org>; Fri, 10 Mar 2023 06:43:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1678459397; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=fp4Dpq2sffM/HHVswHM7H0igryXw8UvVFTkmI1MSwB+5JFNpEG+Ugj4BCbry/ruuBUcM7DuKiJxsCbE6lnl6swUKlOJTDd46YbdBqyJRm3cszPj4maQ784n2/siLpUm8+FSsY/QNvw5BXoenmIWCl/Kfwwi6dCsimzlxBcNEObw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1678459397; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=xZt8RGeS8fIpgpZkhCcxmqzsmTv2eRogBjqb33r0Bj0=; 
        b=DvDaoN/j9OCXP53vgih5ntYHiilZvQEy/lwWRoLtFTj+d3/lEGwqXhY3ExCl5YbKEOKuHNb1m7xZtsABORuDDg611WT+HyWglHw6NgShdsGo4o0Hwtncpgok2l71BTcVfRkltXKy6BiUPxBdQA6eBBcAwKVjN5ob21ER5x/p7mA=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1678459394332800.980885178361; Fri, 10 Mar 2023 15:43:14 +0100 (CET)
Message-ID: <3f1f7b12-397a-d363-d075-e074c0913e64@trained-monkey.org>
Date:   Fri, 10 Mar 2023 09:43:11 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 2/3] mdadm: refactor ident->name handling
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     colyli@suse.de, linux-raid@vger.kernel.org
References: <20221221115019.26276-1-mariusz.tkaczyk@linux.intel.com>
 <20221221115019.26276-3-mariusz.tkaczyk@linux.intel.com>
 <bef57069-acdb-3a2f-b691-2c438c4247fb@trained-monkey.org>
 <20221229103931.00006ff0@linux.intel.com>
 <0017b6dc-b0c0-7d4e-4765-fcc429b41862@trained-monkey.org>
 <20230303130410.000043e0@linux.intel.com>
 <824b2eca-cada-43b2-be8f-100676654bb2@trained-monkey.org>
 <20230309090207.00002769@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230309090207.00002769@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/9/23 03:02, Mariusz Tkaczyk wrote:
> On Wed, 8 Mar 2023 14:04:12 -0500
>> Maybe it would be worth starting the enum outside the range of the
>> regular errno so they can overlap? Not sure if it adds any value, just a
>> thought.
>>
> I see no value either.
> What if someone will add new error definition to errno? Should we change our
> enum start then? I think that nobody will notice it until issue but it is
> unlikely too. For that reason I think that it is pointless from the beggining
> because we are defnining rule which won't be honored later.
> 
> I think that we can just to redefine errno codes in enum if they are needed. We
> are free to change particular enum constant value to make room for errno
> compatible codes if there will be need to. That should be safe if some code
> does not have ugly trick like calling external function and comparing it with
> enum constant:
> 
> */ let's say that SUCCESS is 0 */
> if (strncmp(arg, arg1, arg2) == ENUM_STATUS_SUCCESS)
> 
> but it is our job to catch it on review so we are safe here, right? :)

Fair enough

Jes

