Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27357C433ED
	for <linux-raid@archiver.kernel.org>; Thu,  6 May 2021 12:38:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E604760FD9
	for <linux-raid@archiver.kernel.org>; Thu,  6 May 2021 12:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbhEFMjH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 May 2021 08:39:07 -0400
Received: from mail.thelounge.net ([91.118.73.15]:27049 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbhEFMjG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 May 2021 08:39:06 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4FbY5V2cP2zXN5;
        Thu,  6 May 2021 14:38:01 +0200 (CEST)
To:     d tbsky <tbskyd@gmail.com>, Xiao Ni <xni@redhat.com>
Cc:     list Linux RAID <linux-raid@vger.kernel.org>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com>
 <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Subject: Re: raid10 redundancy
Message-ID: <6db10ef4-e087-3940-4870-e5d9717b853f@thelounge.net>
Date:   Thu, 6 May 2021 14:38:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 06.05.21 um 11:57 schrieb d tbsky:
> if losing two disks will madam find out the raid can be rebuilded safely or not?

it's pretty simple

* if you lose the wrong disks all is gone
* if you lsoe the right disks no problem

RAID10 with 4 disk is prcatically a stripe over the data which is 
mirrored, wehn you lose two disks containg both mirrors of one of the 
stripes your data are done

pretty easy to test  - pull out two disks and move them to another 
machine, if you take the right ones you have on both a degraded RAID, 
can add two blank disks and resync it

that's how i clone machines for years
