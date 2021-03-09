Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C80C433DB
	for <linux-raid@archiver.kernel.org>; Tue,  9 Mar 2021 09:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B223065130
	for <linux-raid@archiver.kernel.org>; Tue,  9 Mar 2021 09:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhCIJPH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 9 Mar 2021 04:15:07 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:12157 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhCIJOy (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 9 Mar 2021 04:14:54 -0500
Received: from host86-155-154-65.range86-155.btcentralplus.com ([86.155.154.65] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1lJYS4-000AJ1-Ds; Tue, 09 Mar 2021 09:14:52 +0000
Subject: Re: [PATCH] mdmonitor: check if udev has finished events processing
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
References: <20210114141416.42934-1-oleksandr.shchirskyi@intel.com>
 <a5f929eb-5103-1646-b321-65886157c9cc@trained-monkey.org>
 <51ec46c1-c632-b3a9-010f-8f13aee0e02c@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
From:   Wols Lists <antlists@youngman.org.uk>
Message-ID: <60473C1F.4080602@youngman.org.uk>
Date:   Tue, 9 Mar 2021 09:13:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <51ec46c1-c632-b3a9-010f-8f13aee0e02c@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 09/03/21 09:01, Tkaczyk, Mariusz wrote:
> On 08.03.2021 16:23, Jes Sorensen wrote:
> 
>> I think it is reasonable to require libudev in 2021, so I have applied
>> this. However if someone feels there is a reason to not have this build
>> requirement, I will also accept a patch to make this dependency optional.
> 
> Hi Jes,
> 
> If community agrees for adding this dependency, I think that is a good
> time to drop all legacy code for handling cases if udev is not available.
> This code is dead, we cannot compile mdadm without libudev.
> 
Is udev part of systemd? Are there alternate implementations for the
anti-systemd-holdouts? Iirc you don't need systemd itself to have udev,
but it might provoke a few screams ...

My current (gentoo) system is OpenRC, but that's still on KDE4 and
hasn't been updated in a couple of years (don't ask why). My new system
is currently being built and is gentoo/systemd, but it's clear the
anti-systemd sentiment is still strong ...

Cheers,
Wol

