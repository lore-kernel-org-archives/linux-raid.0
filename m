Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 944CEC5DF62
	for <linux-raid@archiver.kernel.org>; Wed, 26 Jan 2022 20:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiAZUcJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 Jan 2022 15:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiAZUcI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 26 Jan 2022 15:32:08 -0500
Received: from box.sotapeli.fi (sotapeli.fi [IPv6:2001:41d0:302:2200::1c0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA1FC06161C
        for <linux-raid@vger.kernel.org>; Wed, 26 Jan 2022 12:32:08 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C74B182A77;
        Wed, 26 Jan 2022 21:31:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sotapeli.fi; s=dkim;
        t=1643229124; h=from:subject:date:message-id:to:mime-version:content-type:
         content-transfer-encoding:in-reply-to:references;
        bh=0Upgt/lXjbG5MFRkUNG8oPtZxL6x2yNYIBm8yr51jeg=;
        b=BzL5vRCr/5j6IDMQpAiN9dA5hrZDkP41BNfImwvflQR/7CfcGXH2XwdcPMWzmEAneNmdSe
        5/reozYI38vDGG9WQAY9cxFTyWA0SxCVajLSKfUc3HC3orA0m1dZYsjrb75bSTdGRUwGHv
        RRuuv2LIFOi0x6eFsP7phZPpb/ckOh0X2xztXes7BSmj9H4UodpFkIyMWogQOaoptvEc0A
        dYF03aKOz5wCzOtO35ZMwVCZZM/GXQCeNHcT89I0dAuEl33eKlcZDV+iTlJqzfkVGQvd/O
        lHalj8/TF0i+fxXshkJ+dMxsamxxZvr2oTcsJI6wAgRgYUN5xl1HhoHhvPUapw==
Message-ID: <fade7009-48d6-356a-dc65-a66fac2d216b@sotapeli.fi>
Date:   Wed, 26 Jan 2022 22:31:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: Showing my ignorance - kernel workers
To:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <5EAED86C53DED2479E3E145969315A23892829E5@UMECHPA7B.easf.csd.disa.mil>
From:   Jani Partanen <jiipee@sotapeli.fi>
In-Reply-To: <5EAED86C53DED2479E3E145969315A23892829E5@UMECHPA7B.easf.csd.disa.mil>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello, are both systems identical what comes to hardware? Mainly mobo.

If no and they are dual socket systems, then it may be that one of the 
systems is designed to route all PCI-e via one socket so that all drive 
slots can be used just 1 socked populated. And another is designed so 
taht only half of the drive slots works when only 1 socket is populated.
At least I have read something like this previously from this list.

// JiiPee


Finlayson, James M CIV (USA) kirjoitti 26/01/2022 klo 22.17:
> I apologize in advance if you can point me to something I can read about mdraid besides the source code.  I'm beyond the bounds of my understanding of Linux.   Background, I do a bunch of NUMA aware computing.   I have two systems configured identically with a NUMA node 0 focused RAID5 LUN containing NUMA node 0 nvme drives  and a NUMA node 1 focused RAID5 LUN identically configured.  9+1 nvme, 128KB stripe, xfs sitting on top, 64KB O_DIRECT reads from the application.

