Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C58C433DB
	for <linux-raid@archiver.kernel.org>; Thu, 11 Mar 2021 12:59:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 938CD64FE0
	for <linux-raid@archiver.kernel.org>; Thu, 11 Mar 2021 12:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbhCKM6u (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 11 Mar 2021 07:58:50 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17198 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbhCKM6S (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 11 Mar 2021 07:58:18 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1615467486; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=aaXFCrZZKgDbC/VqyThVCge1Y2zV1tSNTq2vLuNc0wPGQm2A2D4HHy/6/T9P+bALN0lYxj7n7o99UbnC+q8EFIzqHB3rEvUlmmvWP2O4xXetVujGo3KefpDDg8AMhP4wtZRbeZUK1u7qF3CcDWTOPfTVheGLjawraU8TYoQIIvg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1615467486; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Qz90IAd0tYxsZKK4mo1dSwxv3b6hs1wVl43VHzPADf8=; 
        b=lUoNKfT9tt7HcbUjzfIgTLYJg0eI5LE3xZ/EnasL6+faaLahFOvVSbUYI/uVHK9wFGu9oPN0QxGKMZqm9LSQg+8MZLqotaBpUN5No8qWfnfn9pe0z7qnc5rBhfQZl8PCboOPTAbKDZ72kSCA5j456Z1ekKDsJ7kbmpC1BWR/vIU=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1615467485268399.8704279807614; Thu, 11 Mar 2021 13:58:05 +0100 (CET)
Subject: Re: [PATCH] mdmonitor: check if udev has finished events processing
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>,
        Michael Fritscher <michael@fritscher.net>,
        Wols Lists <antlists@youngman.org.uk>,
        Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
Cc:     linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
References: <20210114141416.42934-1-oleksandr.shchirskyi@intel.com>
 <a5f929eb-5103-1646-b321-65886157c9cc@trained-monkey.org>
 <51ec46c1-c632-b3a9-010f-8f13aee0e02c@linux.intel.com>
 <60473C1F.4080602@youngman.org.uk>
 <1b5b0495-c645-7f81-24f4-07fbad54ca0e@fritscher.net>
 <b604528a-2e5e-e5d7-0d05-e72e14f991e9@linux.intel.com>
 <6c833d95-7610-a3c3-01ca-3167a3e80335@trained-monkey.org>
 <4c6c4262-7590-df44-e8cb-eca6bc936287@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <7ac8d403-7624-10de-04ed-f3e12bac2955@trained-monkey.org>
Date:   Thu, 11 Mar 2021 07:58:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <4c6c4262-7590-df44-e8cb-eca6bc936287@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/10/21 11:46 AM, Tkaczyk, Mariusz wrote:
> On 09.03.2021 15:52, Jes Sorensen wrote:
>> This is my main concern, small embedded devices that don't use systemd.
>> I've never been a big systemd fan, but it's how the chips have fallen,
>> so I am not overly worried about a couple of fanatics.
>>
>> If eudev can do the trick, that would be great.
>>
>> Cheers,
>> Jes
>>
> Hello,
> 
> Mdadm is in use in openwrt without udev (thanks to Artur for research).
> They are using hotplug scripts:
> https://openwrt.org/docs/guide-user/base-system/hotplug#coldplug
> To provide compatibility with libudev dependency they wrote small shim:
> https://openwrt.org/packages/pkgdata/libudev-fbsd
> Unfortunately, not all libudev functions are defined, mdadm compilation
> there might be problematic:
> https://openwrt.org/packages/pkgdata_lede17_1/mdadm
> 
> Now, it makes sense to define libudev as optional dependency.
> It should be done before new release, Intel will do that.
> 
> Anyway, I still think that we should drop udev detection from mdadm.
> I there is no systemd-udevd, we should expect other tool to provide
> similar functionality, like hotplug scripts, eudev.
> IMO mdadm doesn't need to create any link.

Thanks for checking into this and taking care of it, appreciate it!

Cheers,
Jes

