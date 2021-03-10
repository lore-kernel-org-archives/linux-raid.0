Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B54CC433DB
	for <linux-raid@archiver.kernel.org>; Wed, 10 Mar 2021 16:47:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3685F64DE7
	for <linux-raid@archiver.kernel.org>; Wed, 10 Mar 2021 16:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhCJQqt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 10 Mar 2021 11:46:49 -0500
Received: from mga17.intel.com ([192.55.52.151]:29227 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232897AbhCJQqS (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 10 Mar 2021 11:46:18 -0500
IronPort-SDR: F5UdMpwQ9TCtVCxNersPagI+L7vJ5v0TLbtE7U2oWhv+fYCLaune76kUgwEHtIIDBsFXKgWFgG
 8ahFnUos3IxQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9919"; a="168426360"
X-IronPort-AV: E=Sophos;i="5.81,237,1610438400"; 
   d="scan'208";a="168426360"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 08:46:17 -0800
IronPort-SDR: Sds4hKTkWchtDN71VgM2MRAuXkwKsgw53XHFCjqIMXLUsOznZPp210pmlL9nNNqrYIl0n5uO3/
 7drXJ3gJVLng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,237,1610438400"; 
   d="scan'208";a="603163275"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga005.fm.intel.com with ESMTP; 10 Mar 2021 08:46:17 -0800
Received: from [10.249.151.8] (mtkaczyk-MOBL1.ger.corp.intel.com [10.249.151.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id EEB9F580816;
        Wed, 10 Mar 2021 08:46:15 -0800 (PST)
Subject: Re: [PATCH] mdmonitor: check if udev has finished events processing
To:     Jes Sorensen <jes@trained-monkey.org>,
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
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <4c6c4262-7590-df44-e8cb-eca6bc936287@linux.intel.com>
Date:   Wed, 10 Mar 2021 17:46:13 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <6c833d95-7610-a3c3-01ca-3167a3e80335@trained-monkey.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 09.03.2021 15:52, Jes Sorensen wrote:
> On 3/9/21 6:17 AM, Tkaczyk, Mariusz wrote:
>> On 09.03.2021 10:45, Michael Fritscher wrote:
>>> Am 09.03.21 um 10:13 schrieb Wols Lists:
>>>> Is udev part of systemd? Are there alternate implementations for the
>>>> anti-systemd-holdouts? Iirc you don't need systemd itself to have udev,
>>>> but it might provoke a few screams ...
>>>>
>>>> My current (gentoo) system is OpenRC, but that's still on KDE4 and
>>>> hasn't been updated in a couple of years (don't ask why). My new system
>>>> is currently being built and is gentoo/systemd, but it's clear the
>>>> anti-systemd sentiment is still strong ...
>>>>
>>>> Cheers,
>>>> Wol
>>>>
>>>
>>> Good day,
>>>
>>> there is e.g. eudev ( https://wiki.gentoo.org/wiki/Project:Eudev ) with
>>> the explicit target to be used without systemd.
>>
>> It is a udev replacement and offers similar functionality.
>> I'm wondering on configuration without udev (systemd or other forks).
>> Is it still a case?
> 
> This is my main concern, small embedded devices that don't use systemd.
> I've never been a big systemd fan, but it's how the chips have fallen,
> so I am not overly worried about a couple of fanatics.
> 
> If eudev can do the trick, that would be great.
> 
> Cheers,
> Jes
> 
Hello,

Mdadm is in use in openwrt without udev (thanks to Artur for research).
They are using hotplug scripts:
https://openwrt.org/docs/guide-user/base-system/hotplug#coldplug
To provide compatibility with libudev dependency they wrote small shim:
https://openwrt.org/packages/pkgdata/libudev-fbsd
Unfortunately, not all libudev functions are defined, mdadm compilation
there might be problematic:
https://openwrt.org/packages/pkgdata_lede17_1/mdadm

Now, it makes sense to define libudev as optional dependency.
It should be done before new release, Intel will do that.

Anyway, I still think that we should drop udev detection from mdadm.
I there is no systemd-udevd, we should expect other tool to provide
similar functionality, like hotplug scripts, eudev.
IMO mdadm doesn't need to create any link.

Mariusz

