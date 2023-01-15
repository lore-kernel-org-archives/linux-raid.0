Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39080C63797
	for <linux-raid@archiver.kernel.org>; Sun, 15 Jan 2023 17:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbjAORJT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 15 Jan 2023 12:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbjAORJP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 15 Jan 2023 12:09:15 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E2C10AA3
        for <linux-raid@vger.kernel.org>; Sun, 15 Jan 2023 09:09:06 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pH6VE-000CMV-Ej;
        Sun, 15 Jan 2023 17:09:04 +0000
Message-ID: <c52cceda-6ec8-c364-c427-660109fe0890@youngman.org.uk>
Date:   Sun, 15 Jan 2023 17:09:04 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: What does TRIM/discard in RAID do ?
Content-Language: en-GB
To:     Reindl Harald <h.reindl@thelounge.net>,
        Pascal Hambourg <pascal@plouf.fr.eu.org>,
        linux-raid <linux-raid@vger.kernel.org>
References: <f8531fc8-6928-5300-b43e-1cad0a4ab03b@plouf.fr.eu.org>
 <dbca2904-1200-a81f-cc6d-300e8def6a96@thelounge.net>
 <2d0a1dad-1961-78df-4c89-e404537c1350@plouf.fr.eu.org>
 <61723f2a-8447-c694-f0b2-1b2b538aa5d0@thelounge.net>
 <68262873-6ceb-f28a-0dae-67d373af7d1f@youngman.org.uk>
 <28fe352b-1391-0227-5a1d-a3122c5e2e78@thelounge.net>
 <f7b9c725-d807-87c1-0fbd-774c18eeb8dc@thelounge.net>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <f7b9c725-d807-87c1-0fbd-774c18eeb8dc@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 15/01/2023 16:01, Reindl Harald wrote:
> there are more important things like keep the idiotic 
> "/sys/block/md0/md/mismatch_cnt" at 0 and until that isn't solveable 
> after decades don't risk my data with advanced experiments
> 
> however, that's all not part of the topic "What does TRIM/discard in 
> RAID do"

Except - may I suggest you go back and read your very first reply to the 
OP - "trim makes no sense in the raid layer". YOU said, in effect, "it's 
not implemented because there's no point".

This whole drift away from the subject was sparked by that comment - 
your comment - when in fact trim DOES make a lot of sense. It's a shame 
it isn't implemented.

Cheers,
Wol
