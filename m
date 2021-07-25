Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9A0C4338F
	for <linux-raid@archiver.kernel.org>; Sun, 25 Jul 2021 10:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9C5560F11
	for <linux-raid@archiver.kernel.org>; Sun, 25 Jul 2021 10:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbhGYJsL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 25 Jul 2021 05:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbhGYJrz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 25 Jul 2021 05:47:55 -0400
Received: from sabi.co.uk (unknown [IPv6:2002:b911:ff1d::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2531AC061757
        for <linux-raid@vger.kernel.org>; Sun, 25 Jul 2021 03:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sabi.co.uk;
         s=dkim-00; h=From:References:In-Reply-To:Subject:To:Date:Message-ID:
        Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=skFVLv1UmkkcwXAmmAdiW+0HQ3KHLVQcq7lCFv8Tsgg=; b=HbPWOatsl12IhVl4/hck3beKZ/
        8sXf/0jYrjN6rEutf67TLe56M2jkdJTmlhnLrIdl7G8GfzlgRSwgKAgbV5Fh0jhSn3jl6DbUAIoIP
        GQCAOluh3amKU9Tl08vkQxju+T9aB+9aIzfyU7kTZknUgj0NJFfeXRKMAIyCR1jva9O++XE++H0QI
        8r7s3nTx8ijCbMq+PDP1MDeYoNijPsb9Bv7ULY61srds+YIaegkCMbiF/Tb2LgtzXEvB5MJgpeXl5
        MjDISRzTY6oYFovTpRk/ArTmR6vL+sRdaO1gHoCgsRtJevob2TbqtCdNxdcvieBOC0QzlsZCn4avA
        HQn1BlhA==;
Received: from b2b-37-24-20-172.unitymedia.biz ([37.24.20.172] helo=sabi.co.uk)
        by sabi.co.uk with esmtpsa(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)(Exim 4.93 id 1m7bMs-004kDo-PY   id 1m7bMs-004kDo-PYby authid <sabity>with cram
        for <linux-raid@vger.kernel.org>; Sun, 25 Jul 2021 10:28:22 +0000
Received: from [127.0.0.1] (helo=cyme.ty.sabi.co.uk)
        by sabi.co.uk with esmtp(Exim 4.93 5)
        id 1m7bMn-002el7-Ti
        for <linux-raid@vger.kernel.org>; Sun, 25 Jul 2021 12:28:17 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24829.15553.689641.666563@cyme.ty.sabi.co.uk>
Date:   Sun, 25 Jul 2021 12:28:17 +0200
X-Face: SMJE]JPYVBO-9UR%/8d'mG.F!@.,l@c[f'[%S8'BZIcbQc3/">GrXDwb#;fTRGNmHr^JFb
 SAptvwWc,0+z+~p~"Gdr4H$(|N(yF(wwCM2bW0~U?HPEE^fkPGx^u[*[yV.gyB!hDOli}EF[\cW*S
 H<GG"+i\3#fp@@EeWZWBv;]LA5n1pS2VO%Vv[yH?kY'lEWr30WfIU?%>&spRGFL}{`bj1TaD^l/"[
 msn( /TH#THs{Hpj>)]f><W}Ck9%2?H"AEM)+9<@D;3Kv=^?4$1/+#Qs:-aSsBTUS]iJ$6
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: SSD based sw RAID: is ERC/TLER really important?
In-Reply-To: <e4ecfd01-cffc-f154-5f7c-5ca08a12fd33@turmel.org>
References: <2232919.g0K5C1TF2C@chirone>
        <24828.30134.873619.942883@cyme.ty.sabi.co.uk>
        <e4ecfd01-cffc-f154-5f7c-5ca08a12fd33@turmel.org>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@raid.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
X-Blacklisted-At: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>> * The purpose of having a long device error retry is to instead to
>> minimize the chances of declaring a drive failed, hoping that many
>> retries succeed. (but note the difference between reads and writes).
>> * It is possible to set the kernel timeouts higher than device retry
>> periods, if one does not care about latency, to minimize the
>> chances of declaring a drive failed (not[e] the difference
>> between Linux command timeouts and retry timeouts, the latter
>> can also be long).

> You understanding is incorrect.
> Read errors do *not* kick drives out. It takes several read
> errors in a short time to fail a drive out of an array.

I am sorry that I was not clear enough and therefore:

* You failed to understand the relevance of "note the difference
  between reads and writes" which I added precisely because I
  guessed that someone unfamiliar with storage device would need
  that terse qualifier.

* You failed to understand the relevance of the "to minimize the
  chances of declaring a drive failed".

* You failed to realize that I was addressing tersely the
  original poster's case of a drive being declared failed
  because of a drive timeout longer than the kernel command
  timeout, without going in detail about all other possible
  cases.
