Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C11C4332F
	for <linux-raid@archiver.kernel.org>; Fri,  4 Nov 2022 05:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiKDF4c (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 4 Nov 2022 01:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiKDF4Q (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 4 Nov 2022 01:56:16 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B74F2F00B
        for <linux-raid@vger.kernel.org>; Thu,  3 Nov 2022 22:52:47 -0700 (PDT)
Received: from [192.168.0.185] (ip5f5aed63.dynamic.kabel-deutschland.de [95.90.237.99])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2CF0F61EA192D;
        Fri,  4 Nov 2022 06:52:21 +0100 (CET)
Message-ID: <adf2fc44-f3d4-d96b-09a6-8e916a6f8449@molgen.mpg.de>
Date:   Fri, 4 Nov 2022 06:52:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Problems with email threading (was: [dm-devel] [PATCH] md: fix a
 crash in mempool_free)
To:     NeilBrown <neilb@suse.de>
Cc:     Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Zdenek Kabelac <zkabelac@redhat.com>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com
References: <alpine.LRH.2.21.2211031121070.18305@file01.intranet.prod.int.rdu2.redhat.com>
 <166753684502.19313.12105294223332649758@noble.neil.brown.name>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <166753684502.19313.12105294223332649758@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Neil,


Just a heads-up, Mozilla Thunderbird 102.4.1 does not thread your message.

Your reply contains:

     In-reply-to: 
=?utf-8?q?=3Calpine=2ELRH=2E2=2E21=2E2211031121070=2E18305=40fi?=
  =?utf-8?q?le01=2Eintranet=2Eprod=2Eint=2Erdu2=2Eredhat=2Ecom=3E?=
     References: 
=?utf-8?q?=3Calpine=2ELRH=2E2=2E21=2E2211031121070=2E18305=40fil?=
  =?utf-8?q?e01=2Eintranet=2Eprod=2Eint=2Erdu2=2Eredhat=2Ecom=3E?=

Mikulas’ message has:

     Message-ID: 
<alpine.LRH.2.21.2211031121070.18305@file01.intranet.prod.int.rdu2.redhat.com>

It looks strange, that the message id, that does not seem to contain any 
non-ASCII characters is „reencoded“. No idea, if it violates any 
standards though.


Kind regards,

Paul
