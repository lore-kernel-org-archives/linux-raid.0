Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29848C433FE
	for <linux-raid@archiver.kernel.org>; Fri, 21 Oct 2022 10:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiJUKvW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Oct 2022 06:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiJUKvT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 21 Oct 2022 06:51:19 -0400
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCFB257CE3
        for <linux-raid@vger.kernel.org>; Fri, 21 Oct 2022 03:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com
        ; s=alpha; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version:
        References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KdrBMjUcfNn/QqjgGJUs73DYv1Nc6KeFnoXxdfGD5c0=; b=QHKzWSLhim18bZGLOz9ZIXhJ44
        bUtaaLM9EyhYGVamSQ9t5iH9iCYDZm1nxP3PTQT1MSUloT22VsJYYLsg/jctK0cZMgqcSEnkv1+s1
        jBlODzLLfnm17afSgTl1IRa3siCCTjlmkHxSV2kZQXA230TocLoNQhTMk5ndkdRxUcs8YuDk7Xqme
        FvJiWtq3RHjwo6KM9xWPn8Wbhd7HV7aBAPMWGGG/WECtGIstZwT1mO4a2oiUHR1pcEGqT0RQwkkJn
        IdVD7W9j+WSwjJ9Ct4ce0Wv/1lKy/QY584T9vaa0LOkWYOhjhoXQTpUIDqis4WtQoMCqtECTjnwJ7
        N8I6cdGw==;
Received: from andy by mail.bitfolk.com with local (Exim 4.89)
        (envelope-from <andy@strugglers.net>)
        id 1olpcJ-0006vP-V7
        for linux-raid@vger.kernel.org; Fri, 21 Oct 2022 10:51:07 +0000
Date:   Fri, 21 Oct 2022 10:51:07 +0000
From:   Andy Smith <andy@strugglers.net>
To:     linux-raid@vger.kernel.org
Subject: Re: Performance Testing MD-RAID10 with 1 failed drive
Message-ID: <20221021105107.nhihftkjck74jg6i@bitfolk.com>
Mail-Followup-To: linux-raid@vger.kernel.org
References: <CAEQ-dADdRd91GBkTzVU0AQiXQ4tLitYsU2uLziWOi=hLtaBK0w@mail.gmail.com>
 <e9feaefd-9ddb-c07a-86b8-3640ca4201af@thelounge.net>
 <7ca2b272-4920-076f-ecaf-5109db0aae46@youngman.org.uk>
 <CAAMCDef4bGs_LnbxEie=2FkxD6YJ_A4WFzW8c647k9MNLGoY3A@mail.gmail.com>
 <CAEQ-dAAYRAg-t3ve9RJV-vJhzqMSe7YOw2bwJVJ_vk0BDp7NZw@mail.gmail.com>
 <20221021001405.2uapizqtsj3wxptb@bitfolk.com>
 <6c31fc94-b70e-88c5-205a-efff32baf594@plouf.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6c31fc94-b70e-88c5-205a-efff32baf594@plouf.fr.eu.org>
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

On Fri, Oct 21, 2022 at 10:15:42AM +0200, Pascal Hambourg wrote:
> Le 21/10/2022 à 02:14, Andy Smith a écrit :
> > Perhaps you could use dm-dust to make an unreliable block device
> > from a real device?
> 
> That seems uselessly complicated to me.

Well I too do not understand why OP can't just fail one existing
device, but it seemed important to them to experience actual errors
and have it kicked out for that. A half way measure might be the
offline / delete poking I mentioned in /sys/block.

*shrug*

Cheers,
Andy

-- 
https://bitfolk.com/ -- No-nonsense VPS hosting
