Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB2DC433EF
	for <linux-raid@archiver.kernel.org>; Sat, 25 Jun 2022 07:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiFYHyV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 25 Jun 2022 03:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiFYHyV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 25 Jun 2022 03:54:21 -0400
Received: from smtp-delay1.nerim.net (unknown [195.5.209.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 08EA43EB85
        for <linux-raid@vger.kernel.org>; Sat, 25 Jun 2022 00:54:18 -0700 (PDT)
Received: from maiev.nerim.net (smtp-156-saturday.nerim.net [194.79.134.156])
        by smtp-delay1.nerim.net (Postfix) with ESMTP id A81F725CC2B
        for <linux-raid@vger.kernel.org>; Sat, 25 Jun 2022 09:54:16 +0200 (CEST)
Received: from [192.168.0.250] (plouf.fr.eu.org [213.41.155.166])
        by maiev.nerim.net (Postfix) with ESMTP id 9090E2E007;
        Sat, 25 Jun 2022 09:54:09 +0200 (CEST)
Message-ID: <ae2288f4-ad06-65af-d30c-4aef6d478f27@plouf.fr.eu.org>
Date:   Sat, 25 Jun 2022 09:54:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Upgrading motherboard + CPU
Content-Language: en-US
To:     Roman Mamedov <rm@romanrm.net>, Wol <antlists@youngman.org.uk>
Cc:     Alexander Shenkin <al@shenkin.org>,
        Linux-RAID <linux-raid@vger.kernel.org>
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
 <5cb8d159-be2a-aa6c-888a-fcb9ed4555c1@youngman.org.uk>
 <20220625030833.3398d8a4@nvm>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <20220625030833.3398d8a4@nvm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Le 25/06/2022 à 00:08, Roman Mamedov a écrit :
> 
> Using RAID1 across all disks with metadata 0.90 for /boot makes sure the BIOS
> can boot no matter which disk it tries first.

Why 0.90 ? It is obsolete. If you need RAID metadata at the end of RAID 
members for whatever ugly reason, you can use metadata 1.0 instead. But 
AFAIK it is only needed as a dirty hack with boot loaders which do not 
really support software RAID and must see RAID partitions as native 
filesystems.

> In fact it could be with recent grub the "0.90" part is not even required
> anymore.

GRUB has supported RAID metadata 1.x since version 1.99 (2010).
