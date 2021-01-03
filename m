Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 861AAC433DB
	for <linux-raid@archiver.kernel.org>; Sun,  3 Jan 2021 21:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50D4320782
	for <linux-raid@archiver.kernel.org>; Sun,  3 Jan 2021 21:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbhACVwB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 3 Jan 2021 16:52:01 -0500
Received: from beige.elm.relay.mailchannels.net ([23.83.212.16]:50904 "EHLO
        beige.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725840AbhACVwB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 3 Jan 2021 16:52:01 -0500
X-Sender-Id: xxlwebhosting|x-authuser|rudy+zijlstra-cable.nl@ams109.yourwebhoster.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 595F91220F9;
        Sun,  3 Jan 2021 21:35:01 +0000 (UTC)
Received: from ams109.yourwebhoster.com (100-96-9-178.trex.outbound.svc.cluster.local [100.96.9.178])
        (Authenticated sender: xxlwebhosting)
        by relay.mailchannels.net (Postfix) with ESMTPA id ECDAC121DEE;
        Sun,  3 Jan 2021 21:34:59 +0000 (UTC)
X-Sender-Id: xxlwebhosting|x-authuser|rudy+zijlstra-cable.nl@ams109.yourwebhoster.com
Received: from ams109.yourwebhoster.com (ams109.yourwebhoster.com
 [109.71.54.20])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.11);
        Sun, 03 Jan 2021 21:35:01 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: xxlwebhosting|x-authuser|rudy+zijlstra-cable.nl@ams109.yourwebhoster.com
X-MailChannels-Auth-Id: xxlwebhosting
X-Plucky-Power: 628f7cbf0fec9e5f_1609709700999_600956532
X-MC-Loop-Signature: 1609709700999:2066339456
X-MC-Ingress-Time: 1609709700998
Received: from [2001:470:7b31:0:9bf:7e99:b919:3832] (port=62133 helo=althalus.local)
        by ams109.yourwebhoster.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <rudy@grumpydevil.homelinux.org>)
        id 1kwB1d-00FO5W-3l; Sun, 03 Jan 2021 22:34:57 +0100
Subject: Re: Raid working but stuck at 99.9%
To:     antlists <antlists@youngman.org.uk>, Teejay <teejay@gizzy.co.uk>,
        linux-raid@vger.kernel.org
References: <11a6cdb6-ab69-ec4d-8ffb-b92d80d5b03f@gizzy.co.uk>
 <0d41bab4-e051-cccb-3a63-e77c258ef78f@youngman.org.uk>
 <33f592e7-3408-4f9b-7146-11af526b1af8@gizzy.co.uk>
 <788a1d77-1712-be55-8a66-dc900fd6176e@youngman.org.uk>
From:   Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Message-ID: <c3876f46-e227-b52f-3f25-b2a2afb0c5b0@grumpydevil.homelinux.org>
Date:   Sun, 3 Jan 2021 22:34:59 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <788a1d77-1712-be55-8a66-dc900fd6176e@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: nl
X-AuthUser: rudy+zijlstra-cable.nl@ams109.yourwebhoster.com
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Op 03-01-2021 om 21:26 schreef antlists:
> On 02/01/2021 23:10, Teejay wrote:
>> On 02/01/2021 19:32, antlists wrote:
>> Ahhhhh ... you MAY be able to RMA them. What are they? If they're WD 
>> Reds I'd RMA them as a matter of course as "unfit for purpose". If 
>> they're BarraCudas, well, tough luck but you might get away with it. 
>> RMA? - Newbie here!
>
> Well, I don't know what the letters stand for, but the expression is a 
> pretty standard term for "return to supplier". If you return anything 
> that is defective, the supplier will usually ask you to "fill in an RMA".

Return Material Authorisation

