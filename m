Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C96CC48BC2
	for <linux-raid@archiver.kernel.org>; Fri, 25 Jun 2021 14:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDF5461492
	for <linux-raid@archiver.kernel.org>; Fri, 25 Jun 2021 14:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhFYODf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Jun 2021 10:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbhFYOD2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 25 Jun 2021 10:03:28 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A63C06121D
        for <linux-raid@vger.kernel.org>; Fri, 25 Jun 2021 06:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KiZEIRljY1H7DuZvciZlHEsfn+U5TbSvq61l3FvUvgI=; b=oI5WrpKRNz5ROH6tLbv9KvpuoU
        PX9H/MYs/7DKaIVAzfzK9i+E1RY7TCcS718LJ0U4vH1Xkqp9NXEZRrSNNSr252c0UkZ6Tm/zYIpZp
        LTs/r+TkA5xEpTjHhQFh+VEaz/VzNxSbmWhoizCATUqdHM6FI8fj6ZSmtCYBbK8FXTOgfC0HBYX39
        nmwbHW2jnNvlupb0aMISXrVLEaSxm3+AcedYJC1d4eAbZOPKH+3+GntTWqYEeZxYtszsi4z+SvAl9
        a6A01rTBGuUg852CbmVnjjMVlJJ0g7D3mVX+6oi8+uky2T77Kix9JZxh1xkzY+92EgiIevq7cV+Oq
        OZ5lnW7g==;
Received: from c-98-192-104-236.hsd1.ga.comcast.net ([98.192.104.236] helo=[192.168.19.160])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1lwmMt-0000jP-Qp; Fri, 25 Jun 2021 13:59:39 +0000
Subject: Re: 4-disk RAID6 (non-standard layout) normalise hung, now all disks
 spare
To:     Jason Flood <3mu5555@gmail.com>, linux-raid@vger.kernel.org
References: <007601d769ba$ced0e870$6c72b950$@gmail.com>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <6d412bf3-a7b9-1f08-2da9-96d34d8f112b@turmel.org>
Date:   Fri, 25 Jun 2021 09:59:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <007601d769ba$ced0e870$6c72b950$@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Good morning Jason,

Good report.  Comments inline.

On 6/25/21 8:08 AM, Jason Flood wrote:
> I started with a 4x4TB disk RAID5 array and, over a few years changed all
> the drives to 8TB (WD Red - I hadn't seen the warnings before now, but it
> looks like these ones are OK). I then successfully migrated it to RAID6, but
> it then had a non-standard layout, so I ran:
> 	sudo mdadm --grow /dev/md0 --raid-devices=4
> --backup-file=/root/raid5backup --layout=normalize

Ugh.  You don't have to use a backup file unless mdadm tells you too. 
Now you are stuck with it.

> After a few days it reached 99% complete, but then the "hours remaining"
> counter started counting up. After a few days I had to power the system down
> before I could get a backup of the non-critical data (Couldn't get hold of
> enough storage quickly enough, but it wouldn't be catastrophic to lose it),
> and now the four drives are in standby, with the array thinking it is RAID0.
> Running:
> 	sudo mdadm --assemble /dev/md0 /dev/sd[bcde]
> responds with:
> 	mdadm: /dev/md0 assembled from 4 drives - not enough to start the
> array while not clean - consider --force.

You have to specify the backup file on assembly if a reshape using one 
was interrupted.

> It appears to be similar to https://marc.info/?t=155492912100004&r=1&w=2,
> but before trying --force I was considering using overlay files as I'm not
> sure of the risk of damage. The set-up process that is documented in the "
> Recovering a damaged RAID" Wiki article is excellent, however the latter
> part of the process isn't clear to me. If successful, are the overlay files
> written to the disk like a virtual machine snapshot, or is the process
> stopped, the overlays removed and the process repeated, knowing that it now
> has a low risk of damage?

Using --force is very low risk on assembly.  I would try it (without 
overlays, and with backup file specified) before you do anything else. 
Odds of success are high.

Also try the flags to treat the backup file as garbage if its contents 
don't match what mdadm expects.

Report back here after the above.

> System details follow. Thanks for any help.

[details trimmed]

Your report of the details was excellent.  Thanks for helping us help you.


Phil
