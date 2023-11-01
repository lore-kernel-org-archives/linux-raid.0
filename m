Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD317C4332F
	for <linux-raid@archiver.kernel.org>; Wed,  1 Nov 2023 02:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344973AbjKACj2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 Oct 2023 22:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344638AbjKACj1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 Oct 2023 22:39:27 -0400
X-Greylist: delayed 553 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 31 Oct 2023 19:39:25 PDT
Received: from lists.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB0BBD
        for <linux-raid@vger.kernel.org>; Tue, 31 Oct 2023 19:39:25 -0700 (PDT)
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4SKrZV2djyz9Q3L
        for <linux-raid@vger.kernel.org>; Wed,  1 Nov 2023 13:30:10 +1100 (AEDT)
Received: from [IPV6:2405:6e00:494:92f5:21b:21ff:fe3a:5672] (unknown [IPv6:2405:6e00:494:92f5:21b:21ff:fe3a:5672])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4SKrZV02vGz9Q1B
        for <linux-raid@vger.kernel.org>; Wed,  1 Nov 2023 13:30:09 +1100 (AEDT)
Message-ID: <50c2f6a0-8a52-4ccd-b95f-3149492d51eb@eyal.emu.id.au>
Date:   Wed, 1 Nov 2023 13:29:59 +1100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To:     linux-raid@vger.kernel.org
Content-Language: en-US
From:   eyal@eyal.emu.id.au
Subject: How to safely stop an array using magic sysrq
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I have a degraded raid6 (waiting for a replacement disk).

The system is unresponsive (shutdown did not complete) but I can still use sysrq with e,i,s,u,b
When the boot completes it drops into emergency shell with the array having all members spare in mdstat.

1) How do I properly stop the array in the above situation (before the boot)?

2) How do I properly start the array (after the failed boot).

TIA

-- 
Eyal at Home (eyal@eyal.emu.id.au)
