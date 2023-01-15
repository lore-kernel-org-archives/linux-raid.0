Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A894C677F1
	for <linux-raid@archiver.kernel.org>; Sun, 15 Jan 2023 16:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbjAOQDi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 15 Jan 2023 11:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjAOQC5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 15 Jan 2023 11:02:57 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6A818151
        for <linux-raid@vger.kernel.org>; Sun, 15 Jan 2023 08:01:21 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4Nw0J05W23zXKm;
        Sun, 15 Jan 2023 17:01:04 +0100 (CET)
Message-ID: <f7b9c725-d807-87c1-0fbd-774c18eeb8dc@thelounge.net>
Date:   Sun, 15 Jan 2023 17:01:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: What does TRIM/discard in RAID do ?
Content-Language: en-US
From:   Reindl Harald <h.reindl@thelounge.net>
To:     Wols Lists <antlists@youngman.org.uk>,
        Pascal Hambourg <pascal@plouf.fr.eu.org>,
        linux-raid <linux-raid@vger.kernel.org>
References: <f8531fc8-6928-5300-b43e-1cad0a4ab03b@plouf.fr.eu.org>
 <dbca2904-1200-a81f-cc6d-300e8def6a96@thelounge.net>
 <2d0a1dad-1961-78df-4c89-e404537c1350@plouf.fr.eu.org>
 <61723f2a-8447-c694-f0b2-1b2b538aa5d0@thelounge.net>
 <68262873-6ceb-f28a-0dae-67d373af7d1f@youngman.org.uk>
 <28fe352b-1391-0227-5a1d-a3122c5e2e78@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <28fe352b-1391-0227-5a1d-a3122c5e2e78@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 15.01.23 um 16:52 schrieb Reindl Harald:
>> to improve things, and actively supporting TRIM at the raid level is 
>> such an obvious advance ...
> 
> but that is NOT the topic of a question "What DOES TRIM/discard in RAID do"
> 
> DOES versus COULD DO
> 
>> Whether it's worth the effort is a different question ... :-)
BTW:

in such implementations you have to consider

* re-add of devices
* file-systems with no trim-support
* raw-devcie usage like for "apache trafficserver"
* power-outage
* drive replacements

god beware pass a wrong discard reuqest to the underlying device

there are more important things like keep the idiotic 
"/sys/block/md0/md/mismatch_cnt" at 0 and until that isn't solveable 
after decades don't risk my data with advanced experiments

however, that's all not part of the topic "What does TRIM/discard in 
RAID do"

