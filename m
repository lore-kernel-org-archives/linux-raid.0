Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF707C4742C
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 10:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB3C82072C
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 10:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgKKKqH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 Nov 2020 05:46:07 -0500
Received: from eva.aplu.fr ([91.224.149.41]:43818 "EHLO eva.aplu.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgKKKqG (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 11 Nov 2020 05:46:06 -0500
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Nov 2020 05:46:06 EST
Received: from eva.aplu.fr (eva.aplu.fr [127.0.0.1])
        by eva.aplu.fr (Postfix) with ESMTP id B9346235F
        for <linux-raid@vger.kernel.org>; Wed, 11 Nov 2020 11:39:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aplu.fr; s=s4096;
        t=1605091178; bh=S2ChV0bAvt1IGpIAbq0A0C08KZrugbKQ3BuPLGNhMEA=;
        h=To:From:Subject:Date:From;
        b=pLtYlZcdktW4Nvkk8oUcfD9IW2uBwumYuQSWlxfwtnc5yArYMzBvvZ8tV9g6PVfX+
         azsmlTWSDQ6ZaVE4N35A+DDgNCPfD0ik08CSdSS7cWHqYR0zIBYtlAfVMVps5Jarle
         FtlkAkMJZekXYLnK1xvLI/E9Zf8QStmqcUcDalI3jlfvqDoy2jPVPZg0413hYXkRJ0
         w8U7r+COcYeYtWP5KCs5ChShYpo9+v0cp0K9mArPBBv1PCjnN08LNdmXIk7Sb6k7GU
         bC1LR04cvpsiYDrgeaVw0DJVUWLjQaM3Wo6d7UOXQ33f/LWuadJg0rfhL09SgKNHKm
         9Hc84B2lLh2v+F8HIMsF1j++T5Bc5m7u8Xuofr0T7T36TFaIYmQPxMWAevCTOrPuGX
         /u0/UYdt1qKjjL+m+txQE613qC7MpjuKMyckPOTHINPLvFK5Ylm6a20f2fut7/9bcv
         fOi31zNY9jUPfWaG/kGBH6MhqaEiHW2cgeAfGCWH4vaugU/MCXdetf3iL0qI8GHVmZ
         FZLLgsRv+RiHGhbwH+gmeXfYwlUXYwoAFVwtA+H05rL+5QknQnJeNiDf7bYltfY+vC
         f3e9FOjLvh9pStDMuVzs31i0kkEnvRfIjEfREQ+7AXtmlSmBxuUT5ivHz9HeXugAgQ
         /bN8O2TFkNLUaPdIG413QcbE=
Received: from [IPv6:2a01:cb19:84c8:25ad:f66d:4ff:fefd:a905] (unknown [IPv6:2a01:cb19:84c8:25ad:f66d:4ff:fefd:a905])
        by eva.aplu.fr (Postfix) with ESMTPSA id 7868B1297
        for <linux-raid@vger.kernel.org>; Wed, 11 Nov 2020 11:39:38 +0100 (CET)
Authentication-Results: eva.aplu.fr; dmarc=fail (p=none dis=none) header.from=aplu.fr
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aplu.fr; s=s4096;
        t=1605091178; bh=S2ChV0bAvt1IGpIAbq0A0C08KZrugbKQ3BuPLGNhMEA=;
        h=To:From:Subject:Date:From;
        b=pLtYlZcdktW4Nvkk8oUcfD9IW2uBwumYuQSWlxfwtnc5yArYMzBvvZ8tV9g6PVfX+
         azsmlTWSDQ6ZaVE4N35A+DDgNCPfD0ik08CSdSS7cWHqYR0zIBYtlAfVMVps5Jarle
         FtlkAkMJZekXYLnK1xvLI/E9Zf8QStmqcUcDalI3jlfvqDoy2jPVPZg0413hYXkRJ0
         w8U7r+COcYeYtWP5KCs5ChShYpo9+v0cp0K9mArPBBv1PCjnN08LNdmXIk7Sb6k7GU
         bC1LR04cvpsiYDrgeaVw0DJVUWLjQaM3Wo6d7UOXQ33f/LWuadJg0rfhL09SgKNHKm
         9Hc84B2lLh2v+F8HIMsF1j++T5Bc5m7u8Xuofr0T7T36TFaIYmQPxMWAevCTOrPuGX
         /u0/UYdt1qKjjL+m+txQE613qC7MpjuKMyckPOTHINPLvFK5Ylm6a20f2fut7/9bcv
         fOi31zNY9jUPfWaG/kGBH6MhqaEiHW2cgeAfGCWH4vaugU/MCXdetf3iL0qI8GHVmZ
         FZLLgsRv+RiHGhbwH+gmeXfYwlUXYwoAFVwtA+H05rL+5QknQnJeNiDf7bYltfY+vC
         f3e9FOjLvh9pStDMuVzs31i0kkEnvRfIjEfREQ+7AXtmlSmBxuUT5ivHz9HeXugAgQ
         /bN8O2TFkNLUaPdIG413QcbE=
To:     linux-raid@vger.kernel.org
From:   Aymeric <mulx@aplu.fr>
Subject: How mdadm react with disk corruption during check?
Message-ID: <ec374580-6b69-85df-0342-27d42c5e515e@aplu.fr>
Date:   Wed, 11 Nov 2020 11:39:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-AV-Checked: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

I've searched a bit on the wiki but didn't find any clear answer.

So let assume we have a raid 1 with two disks : sda and sdb.
You can read and write on both disks without I/O error, so no drive are
going to be kicked out the array.
The only stuff is that sda will not read what has been written on some
sectors.

I know that mdadm can not detect integrity during normal usage, and as
read on the array will be performed by chunck randomly on the two disks
you get a partial corrupted reading.

Now, during checkarray command, mdadm is reading the whole disk, it will
detect that sda and sdb does not contain the same data (at least I hope
that checkarray is comparing data on both disks).

How does it decide which drive (sda or sdb) have correct data to write
it back the other disks?
Is there any messages available in such case?

And I've the same question with raid 1 on 3 disks and same behavior on sda. 

Thanks,

Aymeric.
