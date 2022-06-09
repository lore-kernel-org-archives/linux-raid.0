Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD723C43334
	for <linux-raid@archiver.kernel.org>; Thu,  9 Jun 2022 22:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239754AbiFIWOK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Jun 2022 18:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbiFIWOJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Jun 2022 18:14:09 -0400
X-Greylist: delayed 185 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 09 Jun 2022 15:14:05 PDT
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA32242A34
        for <linux-raid@vger.kernel.org>; Thu,  9 Jun 2022 15:14:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1654812838; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=ja7CCOBG3EYvIEiSswRaQ9NKJjQ4DkfpyxLJlXzD2j7Q7DVs2hQb4M+8xVBAr88LKF+Byi32jOOBQoDYd9HWSXqdTtU07ApbdU0MdPiKbibW4yhn1/mfNNjFKSTpApBRv06curnDe6oCFVRNO5+pMi2vP8NKG73KdQNtWM0ge58=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1654812838; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=BfrMwlwP70rlkx8Ax1+2LPHVvq4mo3rTCk3g5h2q6jg=; 
        b=HnZEdgGCVz08aKnavpJ6BiNarQ6cMlvm9BpSRyyd32C70U84v1pWdAjo88Zxn0UXBcEbgjLIu9oQEM8xyIPz6O9tTZAqIKYxffFu6nhwa/VlMoxXQD6lpgqLtTtpsQzLgsOq/OQheeVzWMApY1UZUJJW8/wtVoS9FeHy1sDIqn4=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [172.30.27.237] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 1654812837163410.9577372848131; Fri, 10 Jun 2022 00:13:57 +0200 (CEST)
Message-ID: <07c203b3-a230-4f52-ac95-acadb8881d58@trained-monkey.org>
Date:   Thu, 9 Jun 2022 18:13:55 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] Grow: block -n on external volumes.
Content-Language: en-US
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>,
        linux-raid@vger.kernel.org
Cc:     colyli@suse.de
References: <20220519071608.26259-1-mateusz.kusiak@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220519071608.26259-1-mateusz.kusiak@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/19/22 03:16, Mateusz Kusiak wrote:
> Performing --raid-devices on external metadata volume should be blocked
> as it causes unwanted behaviour.
> 
> Eg. Performing
> mdadm -G /dev/md/volume -l10 -n4
> on r0_d2 inside 4 disk container, returns
> mdadm: Need 2 spares to avoid degraded array, only have 0.
> 
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
> ---
>  Grow.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Applied!

Thanks,
Jes

