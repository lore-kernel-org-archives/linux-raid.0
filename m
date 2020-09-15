Return-Path: <SRS0=ezIp=CY=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E38C0C433E2
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 19:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FFF32078D
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 19:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgIOTxN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Sep 2020 15:53:13 -0400
Received: from bonobo.birch.relay.mailchannels.net ([23.83.209.22]:21443 "EHLO
        bonobo.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727721AbgIOTwx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 15 Sep 2020 15:52:53 -0400
X-Greylist: delayed 47797 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Sep 2020 15:52:52 EDT
X-Sender-Id: xxlwebhosting|x-authuser|rudy+zijlstra-cable.nl@ams109.yourwebhoster.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id E9466361686;
        Tue, 15 Sep 2020 19:52:44 +0000 (UTC)
Received: from ams109.yourwebhoster.com (100-96-8-77.trex.outbound.svc.cluster.local [100.96.8.77])
        (Authenticated sender: xxlwebhosting)
        by relay.mailchannels.net (Postfix) with ESMTPA id 81570361430;
        Tue, 15 Sep 2020 19:52:43 +0000 (UTC)
X-Sender-Id: xxlwebhosting|x-authuser|rudy+zijlstra-cable.nl@ams109.yourwebhoster.com
Received: from ams109.yourwebhoster.com (ams109.yourwebhoster.com
 [109.71.54.20])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.8);
        Tue, 15 Sep 2020 19:52:44 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: xxlwebhosting|x-authuser|rudy+zijlstra-cable.nl@ams109.yourwebhoster.com
X-MailChannels-Auth-Id: xxlwebhosting
X-Continue-Robust: 228f2350318f5370_1600199564735_3827254302
X-MC-Loop-Signature: 1600199564735:2887415547
X-MC-Ingress-Time: 1600199564735
Received: from ip-109-40-128-56.web.vodafone.de ([109.40.128.56]:22741 helo=[192.168.43.53])
        by ams109.yourwebhoster.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <rudy@grumpydevil.homelinux.org>)
        id 1kIH0G-00EJPC-De; Tue, 15 Sep 2020 21:52:36 +0200
Subject: Re: Linux raid-like idea
To:     John Stoffel <john@stoffel.org>
Cc:     Brian Allen Vanderburg II <brianvanderburg2@aim.com>,
        Wols Lists <antlists@youngman.org.uk>,
        linux-raid@vger.kernel.org
References: <1cf0d18c-2f63-6bca-9884-9544b0e7c54e.ref@aim.com>
 <1cf0d18c-2f63-6bca-9884-9544b0e7c54e@aim.com>
 <e3cb1bbe-65eb-5b75-8e99-afba72156b6e@youngman.org.uk>
 <ef3719a9-ae53-516e-29ee-36d1cdf91ef1@aim.com>
 <5F54146F.40808@youngman.org.uk>
 <274cb804-9cf1-f56c-9ee4-56463f052c09@aim.com>
 <ddd9b5b9-88e6-e730-29f4-30dfafd3a736@youngman.org.uk>
 <38f9595b-963e-b1f5-3c29-ad8981e677a7@aim.com>
 <9220ea81-3a81-bb98-22e3-be1a123113a1@youngman.org.uk>
 <24413.1342.676749.275674@quad.stoffel.home>
 <9ba44595-8986-0b22-7495-d8a15fb96dbd@youngman.org.uk>
 <24414.5523.261076.733659@quad.stoffel.home>
 <5F5E425B.3040501@youngman.org.uk>
 <f9144d16-3c8d-821c-c951-1fb5e6a7d317@aim.com>
 <24416.8959.80816.985785@quad.stoffel.home>
 <43ce60a7-64d1-51bc-f29c-7a6388ad91d5@grumpydevil.homelinux.org>
 <24417.1026.44632.86763@quad.stoffel.home>
From:   Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Message-ID: <af648b96-2c2d-6d80-0f06-a9f75ef32836@grumpydevil.homelinux.org>
Date:   Tue, 15 Sep 2020 21:52:38 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <24417.1026.44632.86763@quad.stoffel.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: nl
X-AuthUser: rudy+zijlstra-cable.nl@ams109.yourwebhoster.com
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


> Brian> for 24 3.5 drives in a 4U chassis.  There is also NetApp shelf
> Brian> I was looking at but from reading looks like it uses a QSFP
> Brian> connector on it's IOM, and the cables that converted from
> Brian> SFF-8088 were quite expensive.
>      
> Rudy> I'd take a look at HP D2600
>
> Looks like it would be too loud for a home office, with those small
> fans.  And probably overkill for my needs.  But thank you for pointing
> this out!
I've got mine in the cellar, and more quiet than the one it replaces. Do 
not hear it... but then, i have a noisy server running there :)
