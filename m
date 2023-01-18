Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC60C38147
	for <linux-raid@archiver.kernel.org>; Wed, 18 Jan 2023 10:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjARKvL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 18 Jan 2023 05:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjARKtD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 18 Jan 2023 05:49:03 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF734C0F
        for <linux-raid@vger.kernel.org>; Wed, 18 Jan 2023 01:57:11 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4Nxh4h1gBrzXKm;
        Wed, 18 Jan 2023 10:57:08 +0100 (CET)
Message-ID: <964b05d3-4782-55be-1487-613fd9c5019f@thelounge.net>
Date:   Wed, 18 Jan 2023 10:57:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: What does TRIM/discard in RAID do ?
Content-Language: en-US
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
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
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <162b3fc0-b5ee-f4e2-7f02-2e95cc20047b@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 18.01.23 um 00:26 schrieb Pascal Hambourg:
> On 15/01/2023 at 17:01, Reindl Harald wrote:
>>
>>
>> Am 15.01.23 um 16:52 schrieb Reindl Harald:
>>
>> in such implementations you have to consider
>>
>> * re-add of devices
> 
> Not affected. Use the event count and the write-intent bitmap as usual.
> 
>> * file-systems with no trim-support
> 
> Not affected. An device does not need TRIM support to know which blocks 
> have been written and contain valid data

well, fstrim/discard don't do anything on a HDD at the FS layer

[root@localhost:~]$ lsscsi
[0:0:0:0]    disk    ATA      WDC WD10EZEX-60Z 0A80  /dev/sda
[1:0:0:0]    disk    ATA      ST1000DM003-1ER1 CC43  /dev/sdb

[root@localhost:~]$ fstrim -v  /
fstrim: /: the discard operation is not supported


