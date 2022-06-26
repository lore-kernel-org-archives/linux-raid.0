Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC089C43334
	for <linux-raid@archiver.kernel.org>; Sun, 26 Jun 2022 21:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiFZVqS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 26 Jun 2022 17:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiFZVqR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 26 Jun 2022 17:46:17 -0400
Received: from mallaury.nerim.net (smtp-100-sunday.noc.nerim.net [178.132.17.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 70110BBF
        for <linux-raid@vger.kernel.org>; Sun, 26 Jun 2022 14:46:13 -0700 (PDT)
Received: from [192.168.0.250] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id 06AF8DB17C;
        Sun, 26 Jun 2022 23:46:06 +0200 (CEST)
Message-ID: <f971e15d-9cd4-e6de-c174-f3c6bd338bb6@plouf.fr.eu.org>
Date:   Sun, 26 Jun 2022 23:46:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Upgrading motherboard + CPU
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>, Stephan <linux@psjt.org>,
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
 <ae2288f4-ad06-65af-d30c-4aef6d478f27@plouf.fr.eu.org>
 <s6nh748amrs.fsf@blaulicht.dmz.brux>
 <1b6c6601-22a0-af2a-81a9-34599b1b0fa7@youngman.org.uk>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <1b6c6601-22a0-af2a-81a9-34599b1b0fa7@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Le 25/06/2022 à 19:10, Wols Lists wrote :
> On 25/06/2022 14:35, Stephan wrote:
>>
>> Does mdraid with metadata 1 work on the root filesystem w/o initramfs?

No. Why would one not use an initramfs ?

> If you're using v1.0, then you could boot off of one of the mirror 
> members no problem.
>
> You would point the kernel boot line at sda1 say (if that's part of your 
> mirror). IFF that is mounted read-only for boot, then that's not a problem.

Mounting read-only does not guarantee that there won't be any write. See 
man mount(8) :

-r, --read-only
     Mount the filesystem read-only. A synonym is -o ro.

Note that, depending on the filesystem type, state and kernel behavior, 
the system may still write to the device. For example, ext3 and ext4 
will replay the journal if the filesystem is dirty. To prevent this kind 
of write access, you may want to mount an ext3 or ext4 filesystem with 
the ro,noload mount options or set the block device itself to read-only 
mode, see the blockdev(8) command.

> Your fstab would then mount /dev/md0 as root read-write

I don't think so. IME the root device in fstab is ignored, only the 
options are used.
