Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78F1AC4338F
	for <linux-raid@archiver.kernel.org>; Sat, 24 Jul 2021 20:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DD9B60E9C
	for <linux-raid@archiver.kernel.org>; Sat, 24 Jul 2021 20:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbhGXTlX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 24 Jul 2021 15:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhGXTlW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 24 Jul 2021 15:41:22 -0400
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19444C061575
        for <linux-raid@vger.kernel.org>; Sat, 24 Jul 2021 13:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com
        ; s=alpha; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version:
        References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dJaZGtnph23SXBdNw6w3VHJ/UuS6OcfvZj2SyocpbaM=; b=eKiYN5LloZ3dOoIdaPn15dZuPe
        6dKTeYJu6/1wOLFyrW5F2E9H3OsXZLirranMFhuqtuniF1qqHIRtBiZ0DZivLDShMaogrIfLQl3Oy
        Twj2x/DvtOQrQ/A/khJubXJzRzFw+w74osBKIrqF5zpLfn1VY0n3etF+AXMaiLhPijMTnnAxh7vRD
        4Y8hKH2hPoUysNTuGU4kRJMcfLGlSauuUVDAXOHxQRcsOBDj4Xt98UAOCRIVGkdkAJuzDSjuDpUBp
        NOkPArcwYVpImt1sNmGFF1nYt9qtfgjqQKe5b0HNBxDQtfxTEDqvOHN826iLzs5E6GVHAIPi+opRe
        i/wzaYgw==;
Received: from andy by mail.bitfolk.com with local (Exim 4.89)
        (envelope-from <andy@strugglers.net>)
        id 1m7O9g-0000pU-53
        for linux-raid@vger.kernel.org; Sat, 24 Jul 2021 20:21:52 +0000
Date:   Sat, 24 Jul 2021 20:21:52 +0000
From:   Andy Smith <andy@strugglers.net>
To:     linux-raid@vger.kernel.org
Subject: Re: SSD based sw RAID: is ERC/TLER really important?
Message-ID: <20210724202151.4dbct2qeyua4g55d@bitfolk.com>
Mail-Followup-To: linux-raid@vger.kernel.org
References: <2232919.g0K5C1TF2C@chirone>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2232919.g0K5C1TF2C@chirone>
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL:  http://strugglers.net/wiki/User:Andy
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Gianluca,

On Sat, Jul 24, 2021 at 08:41:06PM +0200, Gianluca Frustagli wrote:
> But in the case of SSD drives (where, possibly, the error recovery activities 
> performed by the drive firmware are very fast) does the presence of the 
> ERC/TLER capability really matter?

If the setting is there, why wouldn't you use it? If the error
recovery is always very fast, as you hypothesise, then the low
timeout you set with smartctl -l scterc will never be reached
anyway.

> Is the same scenario from the spinning 
> drives case actually even probable or only theorical? 

I don't know what the typical error recovery behaviour of an SSD is
because in years and years I haven't seen such problems with SSDs,
but where they offer the scterc setting I do use it anyway on the
basis of it's not going to hurt anything.

I see it available on enterprise SSD like Samsung SM883, Intel
D3-S4610. I don't see it on Supermicro DOM modules.

I also don't see it on NVMe drives at all (e.g. Samsung PM983), and
NVMe seems to be the future of flash so maybe this setting dies
soon…

Cheers,
Andy
