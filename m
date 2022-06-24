Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71983C43334
	for <linux-raid@archiver.kernel.org>; Fri, 24 Jun 2022 19:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbiFXTOY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Jun 2022 15:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiFXTOY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Jun 2022 15:14:24 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7AAE81D89
        for <linux-raid@vger.kernel.org>; Fri, 24 Jun 2022 12:14:22 -0700 (PDT)
Received: from host86-158-155-35.range86-158.btcentralplus.com ([86.158.155.35] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1o4ol2-00083M-5c;
        Fri, 24 Jun 2022 20:14:20 +0100
Message-ID: <d85093a4-be3e-d4f2-eca0-e20882584bab@youngman.org.uk>
Date:   Fri, 24 Jun 2022 20:14:20 +0100
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
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <22102e4b-4738-672d-0d00-bbeccb54fe84@shenkin.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 24/06/2022 19:46, Alexander Shenkin wrote:
> Fantastic, thanks Roman.
> 
> On 6/24/2022 11:44 AM, Roman Mamedov wrote:
>> On Fri, 24 Jun 2022 11:27:08 -0700
>> Alexander Shenkin <al@shenkin.org> wrote:
>>
>>> I have 1 RAID6 (root) and 1 RAID1 (boot) array running across 7 drives
>>> in my Ubuntu 20.04 system.  I bought a new motherboard and CPU that I'd
>>> like to replace my current ones.  In non-raid systems, I get the sense
>>> that it's not a very risky operation.  However, I suspect RAID makes it
>>> more tricky.
>>
>> Luckily with software RAID using mdadm it does not.
>>
Just make sure fstab (and anywhere else you may have manually altered) 
is using uuids, and not device references (like /dev/sdxn).

Oh - and EFI / BIOS will always look for device 1. So that's a minor pain.

And both of those rules apply raid or not :-)

Cheers,
Wol
