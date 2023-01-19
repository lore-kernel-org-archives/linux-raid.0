Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67889C004D4
	for <linux-raid@archiver.kernel.org>; Thu, 19 Jan 2023 18:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjASSoK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Jan 2023 13:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbjASSoH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Jan 2023 13:44:07 -0500
Received: from mallaury.nerim.net (smtp-104-thursday.noc.nerim.net [178.132.17.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 02947792B4
        for <linux-raid@vger.kernel.org>; Thu, 19 Jan 2023 10:44:03 -0800 (PST)
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id C4A9FDB17D;
        Thu, 19 Jan 2023 19:43:56 +0100 (CET)
Message-ID: <b4af98c2-c621-f2c0-1f55-d7fcf4959871@plouf.fr.eu.org>
Date:   Thu, 19 Jan 2023 19:43:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: What does TRIM/discard in RAID do ?
Content-Language: en-US
To:     Reindl Harald <h.reindl@thelounge.net>,
        Wols Lists <antlists@youngman.org.uk>,
        linux-raid <linux-raid@vger.kernel.org>
References: <f8531fc8-6928-5300-b43e-1cad0a4ab03b@plouf.fr.eu.org>
 <dbca2904-1200-a81f-cc6d-300e8def6a96@thelounge.net>
 <2d0a1dad-1961-78df-4c89-e404537c1350@plouf.fr.eu.org>
 <61723f2a-8447-c694-f0b2-1b2b538aa5d0@thelounge.net>
 <68262873-6ceb-f28a-0dae-67d373af7d1f@youngman.org.uk>
 <28fe352b-1391-0227-5a1d-a3122c5e2e78@thelounge.net>
 <f7b9c725-d807-87c1-0fbd-774c18eeb8dc@thelounge.net>
 <162b3fc0-b5ee-f4e2-7f02-2e95cc20047b@plouf.fr.eu.org>
 <964b05d3-4782-55be-1487-613fd9c5019f@thelounge.net>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <964b05d3-4782-55be-1487-613fd9c5019f@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 18/01/2023 at 10:57, Reindl Harald wrote:
> Am 18.01.23 um 00:26 schrieb Pascal Hambourg:
>>>
>>> in such implementations you have to consider
>>
>>> * file-systems with no trim-support
>>
>> Not affected. A device does not need TRIM support to know which 
>> blocks have been written and contain valid data
> 
> well, fstrim/discard don't do anything on a HDD at the FS layer

(Hard disks with SMR technology may support TRIM to avoid useless 
read-modify-write operations, but SMR is not recommended for RAID so it 
is a bit out-topic.)

Not sure I get your point. How is a filesystem with no TRIM support 
related with a hard disk with no TRIM support ?

Currently the RAID layer does TRIM/discard pass-through only, so it 
returns the status of the underlying devices. If it stored information 
about which blocks contain valid data, I guess it would have to 
advertise TRIM/discard support for itself regardless of the underlying 
devices.
