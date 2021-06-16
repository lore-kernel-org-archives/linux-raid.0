Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA2B3C48BE5
	for <linux-raid@archiver.kernel.org>; Wed, 16 Jun 2021 15:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD14C61166
	for <linux-raid@archiver.kernel.org>; Wed, 16 Jun 2021 15:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbhFPPH7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 16 Jun 2021 11:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234430AbhFPPH6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 16 Jun 2021 11:07:58 -0400
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892D1C061574
        for <linux-raid@vger.kernel.org>; Wed, 16 Jun 2021 08:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com
        ; s=alpha; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version:
        References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MNBkYWbD/OetCm8HcbcRQcg2z9hMqwpNhx9lgklU8LA=; b=22xX0Gdyo5/n6kGOxAaK6ZRfy6
        WNthxzeSVr8aK0KTkBbG9en08NvUD82KhWxIo0mY0veIaeUISN9PgxB3bxZ1CghjSwLNm5txpCPbQ
        OCooMQRJ0pVsVahdBMndv257XIDMZdiO95MEfnM+Elb7rwwAj6TInoU8VzJzH07K3LBVkcetyUOT1
        5/VPDLgiYkja/lJ4X5/XgQpoNjGwYuJ11RPpi6Pnl21a7fMPEAlkTRX+EltBV30I4Mb/rQIzLY7pG
        +LfUlzIKI6ljYseICriVM3iLI4BgkMiVevJZFdL6BwoYt+/CRZEZImLFPpi414Zr7Nj50OTQmye1S
        MManWhyQ==;
Received: from andy by mail.bitfolk.com with local (Exim 4.89)
        (envelope-from <andy@strugglers.net>)
        id 1ltX6z-0002pi-Rc
        for linux-raid@vger.kernel.org; Wed, 16 Jun 2021 15:05:49 +0000
Date:   Wed, 16 Jun 2021 15:05:49 +0000
From:   Andy Smith <andy@strugglers.net>
To:     linux-raid@vger.kernel.org
Subject: Re: Intermittent stalling of all MD IO, Debian buster (4.19.0-16)
Message-ID: <20210616150549.ojm3nvdamkmqb6ev@bitfolk.com>
Mail-Followup-To: linux-raid@vger.kernel.org
References: <20210612124157.hq6da5zouwd53ucy@bitfolk.com>
 <336ddb45-990f-5d52-23b0-c097c124d022@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <336ddb45-990f-5d52-23b0-c097c124d022@gmail.com>
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL:  http://strugglers.net/wiki/User:Andy
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Guoqing,

Thanks for looking at this.

On Wed, Jun 16, 2021 at 11:57:33AM +0800, Guoqing Jiang wrote:
> The above looks like the bio for sb write was throttled by wbt, which caused
> the first calltrace.
> I am wondering if there  were intensive IOs happened to the
> underlying device of md5, which triggered wbt to throttle sb
> write, or can you access the underlying device directly?

Next time it occurs I can check if I am able to read from the SSDs
that make up the MD device, if that information would be helpful.

I have never been able to replicate the problem in a test
environment so it is likely that it needs to be under heavy load for
it to happen.

> And there was a report [1] for raid5 which may related to wbt throttle as
> well, not sure if the
> change [2] could help or not.
> 
> [1]. https://lore.kernel.org/linux-raid/d3fced3f-6c2b-5ffa-fd24-b24ec6e7d4be@xmyslivec.cz/
> [2]. https://lore.kernel.org/linux-raid/cb0f312e-55dc-cdc4-5d2e-b9b415de617f@gmail.com/

All of my MD arrays tend to be RAID-1 or RAID-10, two devices, no
journal, internal bitmap. I see the reporter of this problem was
using RAID-6 with an external write journal. I can still build a
kernel with this patch and try it out, if you think it could possibly
help. The long time between incidents obviously makes things
extra challenging.

The next step I have taken is to put the buster-backports kernel
package (5.10.24-1~bpo10+1) on two test servers, and will also boot
the production hosts into this if they should experience the problem
again.

Thanks,
Andy
