Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E254C433DB
	for <linux-raid@archiver.kernel.org>; Wed, 10 Mar 2021 15:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42BDF64E38
	for <linux-raid@archiver.kernel.org>; Wed, 10 Mar 2021 15:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbhCJPCX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 10 Mar 2021 10:02:23 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17259 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232956AbhCJPCW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 10 Mar 2021 10:02:22 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1615388528; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=doY0IdpL80cvDmdRZBRvXhVUU2Z53VEZG9Yfkv4+X3LGuhKUALl0b5rtl/jscpXWQ31Baz5Dbwq1AHys/vVdSy7XugfTbzC8ZFm8/MjZ3+l0hS/OQowXn0X0fz2IpULIpBs5+liyYb2AlTPdnemykXb9R80l3GD6f7m/2hj7wnE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1615388528; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=d5x6ew2YT2gmXo86Zz6kccXFr7y0xNKuQDloovr1MoE=; 
        b=CV5tTdmIwDjEWm4IM8aL8v95aMppL8OAWIFNvjqOeP/MQNLQpLm078aE1YVrJVIzGMb9gNQEZKnXtyvoICkLARHZezpY9OHTOmkcfpmS/TjMOIQ7hLf0H0QV8kj+fUcv9JQcKXUWc6hjmyiq4ZPTIPkHLYB4k1tbsRm7/1PLZSE=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1615388527747721.7537513123171; Wed, 10 Mar 2021 16:02:07 +0100 (CET)
Subject: Re: release plan for mdadm
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org,
        Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
References: <de867ab3-9942-77a0-c14d-dbfc67465888@linux.intel.com>
 <2cb77cb7-468d-88ed-a938-63b35e574177@trained-monkey.org>
 <ec3f3d78-5a63-0541-6f87-3836c6026e5a@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <ef3560ec-63de-721e-c31c-15e68a1d11d9@trained-monkey.org>
Date:   Wed, 10 Mar 2021 10:02:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <ec3f3d78-5a63-0541-6f87-3836c6026e5a@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/3/21 3:13 AM, Tkaczyk, Mariusz wrote:
> On 02.03.2021 23:50, Jes Sorensen wrote:
>> I am not aware of anything major pending right now, so if we can get
>> focus on any pending patches and get them in over the next week or two,
>> then I can cut an -rc and we can do a release soon. Especially if you
>> can help out regression testing the -rc candidate(s).
>>
>> Cheers,
>> Jes
>>
> Thanks for answer. Please review all patches in queue, and mark -rc.
> Then I will schedule regression.

I have applied everything in my pipeline, except for Oleksandr's

[PATCH] imsm: nvme multipath support

Once we have that one resolved, I can tag -rc. Which also makes this a
last call for missing patches before the -rc.

Cheers,
Jes
