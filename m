Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A34C3C433DB
	for <linux-raid@archiver.kernel.org>; Tue,  9 Mar 2021 11:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C43365253
	for <linux-raid@archiver.kernel.org>; Tue,  9 Mar 2021 11:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhCILRu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 9 Mar 2021 06:17:50 -0500
Received: from mga18.intel.com ([134.134.136.126]:39749 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229546AbhCILRY (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 9 Mar 2021 06:17:24 -0500
IronPort-SDR: 6idYoSBOjSr2NMyunbpF4WDi8cq+ovrPXHJ4HgreMt1V9W6VT+z5KXfog6sKeMrYmq1qwOzh+4
 Y5hAHDbh5lUA==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="175816384"
X-IronPort-AV: E=Sophos;i="5.81,234,1610438400"; 
   d="scan'208";a="175816384"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 03:17:24 -0800
IronPort-SDR: AppieSNTT3zSQgv53vyCC6bWfBTy0ivb/Q3+kvIf7amvFhwgOusnPk8hD7HiApcqX5Hmru3tsp
 TMJbDTX/8P6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,234,1610438400"; 
   d="scan'208";a="447467318"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga001.jf.intel.com with ESMTP; 09 Mar 2021 03:17:24 -0800
Received: from [10.213.24.57] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.24.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 04FE0580866;
        Tue,  9 Mar 2021 03:17:22 -0800 (PST)
Subject: Re: [PATCH] mdmonitor: check if udev has finished events processing
To:     Michael Fritscher <michael@fritscher.net>,
        Wols Lists <antlists@youngman.org.uk>,
        Jes Sorensen <jes@trained-monkey.org>,
        Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20210114141416.42934-1-oleksandr.shchirskyi@intel.com>
 <a5f929eb-5103-1646-b321-65886157c9cc@trained-monkey.org>
 <51ec46c1-c632-b3a9-010f-8f13aee0e02c@linux.intel.com>
 <60473C1F.4080602@youngman.org.uk>
 <1b5b0495-c645-7f81-24f4-07fbad54ca0e@fritscher.net>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <b604528a-2e5e-e5d7-0d05-e72e14f991e9@linux.intel.com>
Date:   Tue, 9 Mar 2021 12:17:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1b5b0495-c645-7f81-24f4-07fbad54ca0e@fritscher.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 09.03.2021 10:45, Michael Fritscher wrote:
> Am 09.03.21 um 10:13 schrieb Wols Lists:
>> Is udev part of systemd? Are there alternate implementations for the
>> anti-systemd-holdouts? Iirc you don't need systemd itself to have udev,
>> but it might provoke a few screams ...
>>
>> My current (gentoo) system is OpenRC, but that's still on KDE4 and
>> hasn't been updated in a couple of years (don't ask why). My new system
>> is currently being built and is gentoo/systemd, but it's clear the
>> anti-systemd sentiment is still strong ...
>>
>> Cheers,
>> Wol
>>
> 
> Good day,
> 
> there is e.g. eudev ( https://wiki.gentoo.org/wiki/Project:Eudev ) with
> the explicit target to be used without systemd.
> 
> Best regards,
> Michael Fritscher
> 

It is a udev replacement and offers similar functionality.
I'm wondering on configuration without udev (systemd or other forks).
Is it still a case?

Thanks,
Mariusz
