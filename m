Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1EBDECAAD5
	for <linux-raid@archiver.kernel.org>; Sun, 28 Aug 2022 17:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiH1RWP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 28 Aug 2022 13:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiH1RWO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 28 Aug 2022 13:22:14 -0400
X-Greylist: delayed 615 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 28 Aug 2022 10:22:13 PDT
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6021C2F645
        for <linux-raid@vger.kernel.org>; Sun, 28 Aug 2022 10:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com
        ; s=alpha; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fcQwMCEmjMkSKYn/YlRn4YPIkwjR6Na/39+bBZ5XJKk=; b=EI3j4vnstZaFdNekSqyS5j6Sey
        lfpZJFvVRa4Lo95IY5Roy/DjtuYYUDYMiU8Jcs5vTFcL4hDPN1eYTuSfqf/51FnQ39OrplqoKNrag
        xSbPG8aNitu4g7ELnJ1Apnh3eqZw+ibZOG/oGqms5Ehig/wqhx4KILrLaIr/fHrx1pLbslhZqKfWd
        gj2HYQPhpIzreiNjoTps4/XBKisTD4tZSHfMwCM9sZ17D/2HwUyZ5n5/7Z7EdEXNPJYHaCtm+NF5+
        KLuJqrws7rj/IdgCAl8SILCZ4WS1pO5lLr5YSXI0k4VBbJQy1drUjuUpvUpyNhVhY/lz8tXOhyy//
        pOsW0Okg==;
Received: from andy by mail.bitfolk.com with local (Exim 4.89)
        (envelope-from <andy@strugglers.net>)
        id 1oSLz9-0003j0-NU
        for linux-raid@vger.kernel.org; Sun, 28 Aug 2022 17:22:11 +0000
Date:   Sun, 28 Aug 2022 17:22:11 +0000
From:   Andy Smith <andy@strugglers.net>
To:     linux-raid@vger.kernel.org
Subject: Re: RAID 6, 6 device array - all devices lost superblock
Message-ID: <20220828172211.bugbzc5xv3bkp72o@bitfolk.com>
Mail-Followup-To: linux-raid@vger.kernel.org
References: <CAKAPSkJLd836Zp3xU=zSOHg3qcEmi29Y2qOwWzeAFaDp+dNTvg@mail.gmail.com>
 <20220828171156.56iqcps7z6hvzarp@bitfolk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220828171156.56iqcps7z6hvzarp@bitfolk.com>
OpenPGP: id=BF15490B; url=http://strugglers.net/~andy/pubkey.asc
X-URL:  http://strugglers.net/wiki/User:Andy
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: andy@strugglers.net
X-SA-Exim-Scanned: No (on mail.bitfolk.com); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Aug 28, 2022 at 05:11:56PM +0000, Andy Smith wrote:
> I'm wondering if this is one of those motherboards that at boot
> helpfully writes a new empty GPT

Sorry, all the other replies speculating the same have just arrived
in my inbox!
