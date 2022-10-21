Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E77E5C4332F
	for <linux-raid@archiver.kernel.org>; Fri, 21 Oct 2022 15:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiJUPYs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Oct 2022 11:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiJUPYq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 21 Oct 2022 11:24:46 -0400
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAB9402CE
        for <linux-raid@vger.kernel.org>; Fri, 21 Oct 2022 08:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com
        ; s=alpha; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=r8xqAI8ZnePcnR6uKDR2B5WbKnoX0BGQCcHMDY6BznA=; b=ro6K0EjLhNFfgfny8d8iYjHoCe
        33Wn6OofhCqJOK+GCv7iG9YNuYWj7tPsIOUWtsHusZ07wLAN7YGKBuywxZShs7EQdA/uK0l2T8y1i
        5BPFlQyI5DQlcWqPt0yy9smKQhbSSm1407muKS3x35L8Rdbk2SOb3e8XPh41CjgVZpMOwTipNj7q6
        eAEDIw2IqZFR61+tx2+nFEr+uUmYmxJ60UYgo61G0JQlPEeKoTt4xTjH+bzswCPuOxopMVubWucMr
        SMxKCWEn5WfRIaop4I/cEZYB11w0pTUm7cTS0g5aBmBdJg8cZ7GTm3/a7P8xnDlNEf792sP22/MpJ
        PK0bbVUg==;
Received: from andy by mail.bitfolk.com with local (Exim 4.89)
        (envelope-from <andy@strugglers.net>)
        id 1oltsv-0007V1-Rs
        for linux-raid@vger.kernel.org; Fri, 21 Oct 2022 15:24:33 +0000
Date:   Fri, 21 Oct 2022 15:24:33 +0000
From:   Andy Smith <andy@strugglers.net>
To:     linux-raid@vger.kernel.org
Subject: Re: Performance Testing MD-RAID10 with 1 failed drive
Message-ID: <20221021152433.jeylw7ynkn4iczyj@bitfolk.com>
Mail-Followup-To: linux-raid@vger.kernel.org
References: <CAEQ-dADdRd91GBkTzVU0AQiXQ4tLitYsU2uLziWOi=hLtaBK0w@mail.gmail.com>
 <e9feaefd-9ddb-c07a-86b8-3640ca4201af@thelounge.net>
 <7ca2b272-4920-076f-ecaf-5109db0aae46@youngman.org.uk>
 <CAAMCDef4bGs_LnbxEie=2FkxD6YJ_A4WFzW8c647k9MNLGoY3A@mail.gmail.com>
 <CAEQ-dAAYRAg-t3ve9RJV-vJhzqMSe7YOw2bwJVJ_vk0BDp7NZw@mail.gmail.com>
 <20221021001405.2uapizqtsj3wxptb@bitfolk.com>
 <6c31fc94-b70e-88c5-205a-efff32baf594@plouf.fr.eu.org>
 <20221021105107.nhihftkjck74jg6i@bitfolk.com>
 <CAAMCDec5k2AvTik6SA_3c48pfH+VxAi9cRb4Qj-xpcAAcOpp0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAMCDec5k2AvTik6SA_3c48pfH+VxAi9cRb4Qj-xpcAAcOpp0g@mail.gmail.com>
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL:  http://strugglers.net/wiki/User:Andy
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

On Fri, Oct 21, 2022 at 06:51:41AM -0500, Roger Heflin wrote:
> The original poster needs to get sar or iostat stat to see what the
> actual io rates are, but if they don't understand what the spinning
> disk array can do fully redundant and with a disk failed it is not
> unlikely that the IO load is higher than a can be sustained with a
> single disk failed.

Though OP is using RAID-10 not RAID-1, and with more than 2 devices
IIRC. OP wants to check the performance and I agree they should do
that for both the normal case and the degraded case, but what are we
expecting *in theory*? For RAID-10 on 4 devices we wouldn't expect
much performance hit would we? Since a read is striped across 2
devices and there's a mirror of each so it'll read from the good
half of the mirror for each read IO.

-- 
https://bitfolk.com/ -- No-nonsense VPS hosting
