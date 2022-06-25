Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A13FC43334
	for <linux-raid@archiver.kernel.org>; Sat, 25 Jun 2022 08:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbiFYIA7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 25 Jun 2022 04:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbiFYIA6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 25 Jun 2022 04:00:58 -0400
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 25 Jun 2022 01:00:57 PDT
Received: from maiev.nerim.net (smtp-156-saturday.nerim.net [194.79.134.156])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F2E54090E
        for <linux-raid@vger.kernel.org>; Sat, 25 Jun 2022 01:00:57 -0700 (PDT)
Received: from [192.168.0.250] (plouf.fr.eu.org [213.41.155.166])
        by maiev.nerim.net (Postfix) with ESMTP id 3D3CF2E00C;
        Sat, 25 Jun 2022 10:00:56 +0200 (CEST)
Message-ID: <a426e881-6e92-1a3d-02b5-78405bc0094e@plouf.fr.eu.org>
Date:   Sat, 25 Jun 2022 10:00:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: a new install - - - putting the system on raid
Content-Language: en-US
To:     Roman Mamedov <rm@romanrm.net>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        o1bigtenor <o1bigtenor@gmail.com>,
        Linux-RAID <linux-raid@vger.kernel.org>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
 <81c50899-7edb-e629-3bbc-16cfa8f17e34@youngman.org.uk>
 <b777865e-b265-1e83-dae0-f89654e86332@plouf.fr.eu.org>
 <5cbd9dd1-73fc-ce11-4a9d-8752f7bea979@youngman.org.uk>
 <1de4bf1f-242b-7d02-23dc-a6d05893db81@plouf.fr.eu.org>
 <20220624232049.502a541e@nvm>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <20220624232049.502a541e@nvm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Le 24/06/2022 à 20:20, Roman Mamedov wrote :
> 
> I think the key decider in whether or not a RAIDed swap should be a must-have,
> is whether the system has hot-swap bays for drives.

Why ? What has hot-swap to do with RAIDed swap ?

> Also, it seemed like the discussion began in the context of setting up a home
> machine, or something otherwise not as mission-critical. And in those cases,
> almost nobody will have hot-swap.
> 
> As such, if you have to bring down the machine to replace a drive anyway, might
> as well tolerate the risk of it going down with a bang (due to a part of swap
> going away)

I disagree. Even without hot-swap, RAIDed swap allows you to control how 
and when the downtime happens in order to replace a faulty drive. 
Without RAIDed swap, you cannot.
