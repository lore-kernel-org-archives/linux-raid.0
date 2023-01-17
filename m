Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94657C38159
	for <linux-raid@archiver.kernel.org>; Wed, 18 Jan 2023 00:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjARAKx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjARAKY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 17 Jan 2023 19:10:24 -0500
Received: from smtp-delay1.nerim.net (mailhost-s4-m3.internext.fr [78.40.49.203])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49708367EF
        for <linux-raid@vger.kernel.org>; Tue, 17 Jan 2023 15:26:45 -0800 (PST)
Received: from maiev.nerim.net (smtp-152-tuesday.nerim.net [194.79.134.152])
        by smtp-delay1.nerim.net (Postfix) with ESMTP id 0BA6DC7AC8
        for <linux-raid@vger.kernel.org>; Wed, 18 Jan 2023 00:26:44 +0100 (CET)
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
        by maiev.nerim.net (Postfix) with ESMTP id A77632E012;
        Wed, 18 Jan 2023 00:26:34 +0100 (CET)
Message-ID: <162b3fc0-b5ee-f4e2-7f02-2e95cc20047b@plouf.fr.eu.org>
Date:   Wed, 18 Jan 2023 00:26:32 +0100
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
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <f7b9c725-d807-87c1-0fbd-774c18eeb8dc@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 15/01/2023 at 17:01, Reindl Harald wrote:
> 
> 
> Am 15.01.23 um 16:52 schrieb Reindl Harald:
> 
> in such implementations you have to consider
> 
> * re-add of devices

Not affected. Use the event count and the write-intent bitmap as usual.

> * file-systems with no trim-support

Not affected. An device does not need TRIM support to know which blocks 
have been written and contain valid data.

> * raw-device usage like for "apache trafficserver"

Not affected.

> * power-outage

Same as other live metadata such as the write-intent bitmap and the 
event count, I guess.

> * drive replacements

That's precisely a  use case when a valid/discard bitmap would be useful.

> god beware pass a wrong discard reuqest to the underlying device

The valid/discard bitmap would be only for internal use only and not 
affect TRIM/discard pass-through.

> however, that's all not part of the topic "What does TRIM/discard in 
> RAID do"

Do not pretend to be naive. I intended the topic to go to this direction 
from the start, and you knew where it was going when you replied.
