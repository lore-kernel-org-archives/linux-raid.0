Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85534C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 29 Jun 2022 11:23:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbiF2LXc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Jun 2022 07:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbiF2LXb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Jun 2022 07:23:31 -0400
Received: from mallaury.nerim.net (smtp-103-wednesday.noc.nerim.net [178.132.17.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F3692529B
        for <linux-raid@vger.kernel.org>; Wed, 29 Jun 2022 04:23:27 -0700 (PDT)
Received: from [192.168.0.250] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id DD230DB17C;
        Wed, 29 Jun 2022 13:23:21 +0200 (CEST)
Message-ID: <144f90ea-384e-1971-30b0-e39cfb9a4aa9@plouf.fr.eu.org>
Date:   Wed, 29 Jun 2022 13:23:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Upgrading motherboard + CPU
Content-Language: en-US
To:     Ram Ramesh <rramesh2400@gmail.com>,
        Alexander Shenkin <al@shenkin.org>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
 <dab2fe0a-c49e-5da7-5df3-4d01c86a65a7@shenkin.org>
 <20220624234453.43cf4c74@nvm>
 <22102e4b-4738-672d-0d00-bbeccb54fe84@shenkin.org>
 <d85093a4-be3e-d4f2-eca0-e20882584bab@youngman.org.uk>
 <b664e4ce-6ebe-86c6-78d9-d5606c0f6555@shenkin.org>
 <5cb8d159-be2a-aa6c-888a-fcb9ed4555c1@youngman.org.uk>
 <20220625030833.3398d8a4@nvm>
 <ae2288f4-ad06-65af-d30c-4aef6d478f27@plouf.fr.eu.org>
 <s6nh748amrs.fsf@blaulicht.dmz.brux>
 <1b6c6601-22a0-af2a-81a9-34599b1b0fa7@youngman.org.uk>
 <f971e15d-9cd4-e6de-c174-f3c6bd338bb6@plouf.fr.eu.org>
 <b1c6b0c2-ff7b-59e0-580c-81d57b8f8ddb@shenkin.org>
 <20220627160558.0ec507ae@nvm> <693d4b1c-ee58-4cc2-854b-4ae445ff7d24@Spark>
 <3e756547-ae18-c0d8-209e-8dd1fc43bb0f@plouf.fr.eu.org>
 <24ac75be-4e0b-0c50-8d87-b673535f7686@shenkin.org>
 <2bece936-f802-3137-3597-6269b1cfc9bb@gmail.com>
 <b6df7f34-befc-0131-f4d3-45b64eff9a94@shenkin.org>
 <0b025627-8496-030a-2971-6ca72d73b428@gmail.com>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <0b025627-8496-030a-2971-6ca72d73b428@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 29/06/2022 04:10, Ram Ramesh wrote :
> 
> Note that you need GPT for UEFI boot disk.

This is only a requirement for Windows (and possibly broken UEFI 
implementations). The UEFI specification allows to boot from a drive 
with a DOS/MBR partition table. Else, assigning a DOS/MBR partition type 
code for EFI system partition (0xef) would be pointless.

> On 6/28/22 20:05, Alexander Shenkin wrote:
>> Once I installed a graphics card, I was able to enable CSM and I've 
>> booted successfully.  Thanks everyone for your help. Converting to 
>> UEFI would be a good idea, though not sure how easy that will be given 
>> that /boot is a RAID1 array (how do you resize all the partitions, etc?).

Setting up redundant EFI boot with software RAID is a pain and a hack.
Resizing RAID partitions is a pain.
So I advise you keep legacy boot as long as you can (but prepare for EFI 
boot on a test machine or VM).
