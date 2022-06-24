Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92809C43334
	for <linux-raid@archiver.kernel.org>; Fri, 24 Jun 2022 22:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiFXWAG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Jun 2022 18:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiFXWAF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Jun 2022 18:00:05 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC6A4DF57
        for <linux-raid@vger.kernel.org>; Fri, 24 Jun 2022 15:00:04 -0700 (PDT)
Received: from host86-158-155-35.range86-158.btcentralplus.com ([86.158.155.35] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1o4rLO-0008x8-8L;
        Fri, 24 Jun 2022 23:00:02 +0100
Message-ID: <5cb8d159-be2a-aa6c-888a-fcb9ed4555c1@youngman.org.uk>
Date:   Fri, 24 Jun 2022 23:00:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Upgrading motherboard + CPU
Content-Language: en-GB
To:     Alexander Shenkin <al@shenkin.org>, Roman Mamedov <rm@romanrm.net>
Cc:     Linux-RAID <linux-raid@vger.kernel.org>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
 <81c50899-7edb-e629-3bbc-16cfa8f17e34@youngman.org.uk>
 <b777865e-b265-1e83-dae0-f89654e86332@plouf.fr.eu.org>
 <5cbd9dd1-73fc-ce11-4a9d-8752f7bea979@youngman.org.uk>
 <1de4bf1f-242b-7d02-23dc-a6d05893db81@plouf.fr.eu.org>
 <20220624232049.502a541e@nvm>
 <dab2fe0a-c49e-5da7-5df3-4d01c86a65a7@shenkin.org>
 <20220624234453.43cf4c74@nvm>
 <22102e4b-4738-672d-0d00-bbeccb54fe84@shenkin.org>
 <d85093a4-be3e-d4f2-eca0-e20882584bab@youngman.org.uk>
 <b664e4ce-6ebe-86c6-78d9-d5606c0f6555@shenkin.org>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <b664e4ce-6ebe-86c6-78d9-d5606c0f6555@shenkin.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 24/06/2022 21:23, Alexander Shenkin wrote:
> Smart, thanks Wol.  I'm good on the UUIDs.  Not sure what you mean by 
> 'device 1' though?

Sata port 1. /dev/sda.

So your boot device is currently in physical connector 1 on the mobo. If 
you move it across, you need to make sure it stays in physical position 
1, otherwise the mobo will try to boot off whatever disk is in position 
1, and there won't be a boot system to boot off!

Remember, uuids rely on linux being running. But linux can't run until 
AFTER the boot code has run, so the boot code knows nothing about uuids 
and relies on physical locations. Cart before horse, catch-22, all that 
palaver you know :-)

Cheers,
Wol
