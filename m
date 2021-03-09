Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12D76C433E0
	for <linux-raid@archiver.kernel.org>; Tue,  9 Mar 2021 14:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9B2A6523A
	for <linux-raid@archiver.kernel.org>; Tue,  9 Mar 2021 14:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbhCIOwh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 9 Mar 2021 09:52:37 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17158 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbhCIOwW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 9 Mar 2021 09:52:22 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1615301532; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=ccUT3U+RQjkHTh2egL68ct9EtprK2R41hUgBXIjj7+Kec6KTLTiaryJD1UHkxZzrOI2MGSZA4nHYTdhJGPYiSxrKlEQCkQUO7lM6W7Qp3xgUYb1u9txOtVYr0VUMbtAB2YPW4wx8doVAVnotqvkVByDEO0pUmMhvNaCBSWfGlOk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1615301532; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=m0GRr5nHQKmCCPq58P3zc6Ees0UlSNgk1TYUpeYp+5w=; 
        b=GtNoADMyzKlOFsbnfRViN1k421Z63q0P0oGIm3yuW5AIZRu0AGX7cFYvsdBXm+PRBRiGyfXJdpYFdZ9Vh1UDnVV+AFf5AgUCLV5EsGVzcPRsPnL5izdMNJOyVqvnUY/V4LgKZUvikRZl/vkj+5XjXSGVigfkpJg1YddiMBx8UmA=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1615301531838644.0186039028309; Tue, 9 Mar 2021 15:52:11 +0100 (CET)
Subject: Re: [PATCH] mdmonitor: check if udev has finished events processing
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>,
        Michael Fritscher <michael@fritscher.net>,
        Wols Lists <antlists@youngman.org.uk>,
        Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20210114141416.42934-1-oleksandr.shchirskyi@intel.com>
 <a5f929eb-5103-1646-b321-65886157c9cc@trained-monkey.org>
 <51ec46c1-c632-b3a9-010f-8f13aee0e02c@linux.intel.com>
 <60473C1F.4080602@youngman.org.uk>
 <1b5b0495-c645-7f81-24f4-07fbad54ca0e@fritscher.net>
 <b604528a-2e5e-e5d7-0d05-e72e14f991e9@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <6c833d95-7610-a3c3-01ca-3167a3e80335@trained-monkey.org>
Date:   Tue, 9 Mar 2021 09:52:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <b604528a-2e5e-e5d7-0d05-e72e14f991e9@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/9/21 6:17 AM, Tkaczyk, Mariusz wrote:
> On 09.03.2021 10:45, Michael Fritscher wrote:
>> Am 09.03.21 um 10:13 schrieb Wols Lists:
>>> Is udev part of systemd? Are there alternate implementations for the
>>> anti-systemd-holdouts? Iirc you don't need systemd itself to have udev,
>>> but it might provoke a few screams ...
>>>
>>> My current (gentoo) system is OpenRC, but that's still on KDE4 and
>>> hasn't been updated in a couple of years (don't ask why). My new system
>>> is currently being built and is gentoo/systemd, but it's clear the
>>> anti-systemd sentiment is still strong ...
>>>
>>> Cheers,
>>> Wol
>>>
>>
>> Good day,
>>
>> there is e.g. eudev ( https://wiki.gentoo.org/wiki/Project:Eudev ) with
>> the explicit target to be used without systemd.
> 
> It is a udev replacement and offers similar functionality.
> I'm wondering on configuration without udev (systemd or other forks).
> Is it still a case?

This is my main concern, small embedded devices that don't use systemd.
I've never been a big systemd fan, but it's how the chips have fallen,
so I am not overly worried about a couple of fanatics.

If eudev can do the trick, that would be great.

Cheers,
Jes
