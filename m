Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED85CC3DA78
	for <linux-raid@archiver.kernel.org>; Sun, 15 Jan 2023 17:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjAORQD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 15 Jan 2023 12:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjAORQB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 15 Jan 2023 12:16:01 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F1535AD
        for <linux-raid@vger.kernel.org>; Sun, 15 Jan 2023 09:16:00 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4Nw1yN1JYpzXKm;
        Sun, 15 Jan 2023 18:15:56 +0100 (CET)
Message-ID: <7b79c746-2340-36a4-05b6-8d368eb08504@thelounge.net>
Date:   Sun, 15 Jan 2023 18:15:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: What does TRIM/discard in RAID do ?
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>,
        Pascal Hambourg <pascal@plouf.fr.eu.org>,
        linux-raid <linux-raid@vger.kernel.org>
References: <f8531fc8-6928-5300-b43e-1cad0a4ab03b@plouf.fr.eu.org>
 <dbca2904-1200-a81f-cc6d-300e8def6a96@thelounge.net>
 <2d0a1dad-1961-78df-4c89-e404537c1350@plouf.fr.eu.org>
 <61723f2a-8447-c694-f0b2-1b2b538aa5d0@thelounge.net>
 <68262873-6ceb-f28a-0dae-67d373af7d1f@youngman.org.uk>
 <28fe352b-1391-0227-5a1d-a3122c5e2e78@thelounge.net>
 <f7b9c725-d807-87c1-0fbd-774c18eeb8dc@thelounge.net>
 <c52cceda-6ec8-c364-c427-660109fe0890@youngman.org.uk>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <c52cceda-6ec8-c364-c427-660109fe0890@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 15.01.23 um 18:09 schrieb Wols Lists:
> On 15/01/2023 16:01, Reindl Harald wrote:
>> there are more important things like keep the idiotic 
>> "/sys/block/md0/md/mismatch_cnt" at 0 and until that isn't solveable 
>> after decades don't risk my data with advanced experiments
>>
>> however, that's all not part of the topic "What does TRIM/discard in 
>> RAID do"
> 
> Except - may I suggest you go back and read your very first reply to the 
> OP - "trim makes no sense in the raid layer". YOU said, in effect, "it's 
> not implemented because there's no point".

because i responded to the question "what does" and not "what would be nice"

> This whole drift away from the subject was sparked by that comment - 
> your comment - when in fact trim DOES make a lot of sense. It's a shame 
> it isn't implemented

a lot of things would be nice - like people only talk about things the 
know at least a little bit

in conext of RAID and your "degraded reshape of a 4 drive RAID10 to 
RAID1 should be only a metadata update" i doubt that strongly
