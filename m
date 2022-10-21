Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A58DC4332F
	for <linux-raid@archiver.kernel.org>; Fri, 21 Oct 2022 00:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiJUA34 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Oct 2022 20:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiJUA3z (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 20 Oct 2022 20:29:55 -0400
X-Greylist: delayed 943 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 20 Oct 2022 17:29:53 PDT
Received: from mail.bitfolk.com (mail.bitfolk.com [IPv6:2001:ba8:1f1:f019::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE4A41988
        for <linux-raid@vger.kernel.org>; Thu, 20 Oct 2022 17:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bitfolk.com
        ; s=alpha; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=O/a2C3kHV2TZjdKXiCCT0+Tgpccdt6GCK0Ikk1ye85M=; b=HVfoVBeX+cu39nKO2UUri7RWau
        dPQYaJSGkEpEUUsOKNSQOvRS0gDTx73V4u8sd5xZkk/gXLHG4sqZkhsct/eB+Cw/GJmt6OPHS20UM
        0ZZbslXrY8obUROS4CCCe7JhfIPhiMWrfbFu+FT2Ix9HrTGioVRiNjAhyvlJQlOKaRQft/EdxoVB0
        lhmpfjJGZtWjqaq4lBp9TS3IUEB7zBYZHNU2n8aDMX6ftI55NOQVcZ1kHC+hI4vUlvZaNn2mVhkyH
        MMK2XIAx7BaeHUj4lVlPHX8TArka80utqr1FMsvPR1zO3PJYJc+zS5UZaPO3Z6cLoTAUkPZP4ZuKG
        wNajmDEg==;
Received: from andy by mail.bitfolk.com with local (Exim 4.89)
        (envelope-from <andy@strugglers.net>)
        id 1olffq-0003oq-3K
        for linux-raid@vger.kernel.org; Fri, 21 Oct 2022 00:14:06 +0000
Date:   Fri, 21 Oct 2022 00:14:05 +0000
From:   Andy Smith <andy@strugglers.net>
To:     linux-raid@vger.kernel.org
Subject: Re: Performance Testing MD-RAID10 with 1 failed drive
Message-ID: <20221021001405.2uapizqtsj3wxptb@bitfolk.com>
Mail-Followup-To: linux-raid@vger.kernel.org
References: <CAEQ-dADdRd91GBkTzVU0AQiXQ4tLitYsU2uLziWOi=hLtaBK0w@mail.gmail.com>
 <e9feaefd-9ddb-c07a-86b8-3640ca4201af@thelounge.net>
 <7ca2b272-4920-076f-ecaf-5109db0aae46@youngman.org.uk>
 <CAAMCDef4bGs_LnbxEie=2FkxD6YJ_A4WFzW8c647k9MNLGoY3A@mail.gmail.com>
 <CAEQ-dAAYRAg-t3ve9RJV-vJhzqMSe7YOw2bwJVJ_vk0BDp7NZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEQ-dAAYRAg-t3ve9RJV-vJhzqMSe7YOw2bwJVJ_vk0BDp7NZw@mail.gmail.com>
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

On Thu, Oct 20, 2022 at 12:13:19PM +0530, Umang Agarwalla wrote:
> But what I am trying to understand is, how to benchmark the
> performance hit in such a condition.

Perhaps you could use dm-dust to make an unreliable block device
from a real device?

    https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/dm-dust.html

1. Create dust device

2. Create an array that includes the dust device

3. Do some work on it while it's in "bypass" mode and benchmark this
   to account for overhead of dm-dust

4. Add some bad sectors, maybe whole device

5. Enable "fail read on bad block" mode

6. Do more work and watch device get kicked out of RAID

7. See if benchmark shows any performance change beyond what you'd
   expect for reduced number of devices

If you have real hardware disks though, can you not just:

# echo offline > /sys/block/$DISK/device/state
# echo 1 > /sys/block/$DISK/device/delete

to power it off mid-operation? (Might need to reboot to get it back after that)

Cheers,
Andy

-- 
https://bitfolk.com/ -- No-nonsense VPS hosting
