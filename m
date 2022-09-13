Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CEA5C54EE9
	for <linux-raid@archiver.kernel.org>; Tue, 13 Sep 2022 11:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbiIMLRu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Sep 2022 07:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbiIMLRt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 13 Sep 2022 07:17:49 -0400
X-Greylist: delayed 2272 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 13 Sep 2022 04:17:48 PDT
Received: from mallaury.nerim.net (smtp-102-tuesday.noc.nerim.net [178.132.17.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A9C75E652
        for <linux-raid@vger.kernel.org>; Tue, 13 Sep 2022 04:17:48 -0700 (PDT)
Received: from [192.168.0.247] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id 90215DB18B;
        Tue, 13 Sep 2022 13:17:47 +0200 (CEST)
Message-ID: <3fc0b889-3ef9-652e-6452-2eeede918683@plouf.fr.eu.org>
Date:   Tue, 13 Sep 2022 13:17:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: change UUID of RAID devcies
Content-Language: en-US
To:     Reindl Harald <h.reindl@thelounge.net>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <2341a2a9-b86e-f0e5-784a-05dbd474dec5@thelounge.net>
 <729bdc01-b0ae-887a-6d2a-5135d287636c@youngman.org.uk>
 <05a1161b-d798-c68f-d37c-a9fc373c6e73@thelounge.net>
 <0023fefe-aad1-e692-48dd-e354497f6e41@plouf.fr.eu.org>
 <1fb05e0f-34b7-3ec4-bc00-ec540e592f19@thelounge.net>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <1fb05e0f-34b7-3ec4-bc00-ec540e592f19@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 13/09/2022 at 13:12, Reindl Harald wrote:
> 
> Am 13.09.22 um 12:39 schrieb Pascal Hambourg:
>> On 13/09/2022 at 12:28, Reindl Harald wrote:
>>>
>>> BTW: currently the machines are BIOS-boot - am i right that the 2 TB 
>>> limitation only requires that the parts which are needed for booting 
>>> are on the first 2 TB and i can use 4 TB SSD's on the two bigger 
>>> machines?
>>
>> Which 2 TB limitation ? EDD BIOS calls use 64-bit LBA and should not 
>> have any practical limitation unless the BIOS implementation is flawed.
(...)
> "For example, you cannot create 3TB or 4TB partition size (RAID based) 
> using the fdisk command. It will not allow you to create a partition 
> that is greater than 2TB" makes me nervous

This is a DOS/MBR partition scheme limitation, not a BIOS limitation, 
and irrelevant with GPT partition scheme.

> how to get a > 3 TB partition for /dev/md2

Use GPT.
