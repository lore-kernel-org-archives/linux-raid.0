Return-Path: <SRS0=ezIp=CY=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 852D8C433E2
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 11:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51AAF20872
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 11:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbgIOLdE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Sep 2020 07:33:04 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:44412 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgIOLcr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Sep 2020 07:32:47 -0400
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.15.2/8.15.2) with ESMTP id 08FBW678005720;
        Tue, 15 Sep 2020 12:32:06 +0100
From:   Nix <nix@esperi.org.uk>
To:     Brian Allen Vanderburg II <brianvanderburg2@aim.com>
Cc:     antlists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
Subject: Re: Linux raid-like idea
References: <1cf0d18c-2f63-6bca-9884-9544b0e7c54e.ref@aim.com>
        <1cf0d18c-2f63-6bca-9884-9544b0e7c54e@aim.com>
        <e3cb1bbe-65eb-5b75-8e99-afba72156b6e@youngman.org.uk>
        <ef3719a9-ae53-516e-29ee-36d1cdf91ef1@aim.com>
Emacs:  indefensible, reprehensible, and fully extensible.
Date:   Tue, 15 Sep 2020 12:32:06 +0100
In-Reply-To: <ef3719a9-ae53-516e-29ee-36d1cdf91ef1@aim.com> (Brian Allen
        Vanderburg, II's message of "Sat, 5 Sep 2020 17:47:50 -0400")
Message-ID: <87pn6nz361.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-DCC-wuwien-Metrics: loom 1290; Body=3 Fuz1=3 Fuz2=3
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5 Sep 2020, Brian Allen Vanderburg, II verbalised:

> The idea is actually to be able to use more than two disks, like raid 5
> or raid 6, except with parity on their own disks instead of distributed
> across disks, and data kept own their own disks as well.  I've used
> SnapRaid a bit and was just making some changes to my own setup when I
> got the idea as to why something similar can't be done in block device
> level, but keeping one of the advantages of SnapRaid-like systems which
> is if any data disk is lost beyond recovery, then only the data on that
> data disk is lost due to the fact that the data on the other data disks
> are still their own complete filesystem, and providing real-time updates
> to the parity data.
>
>
> So for instance
>
> /dev/sda - may be data disk 1, say 1TB
>
> /dev/sdb - may be data disk 2, 2TB
>
> /dev/sdc - may be data disk 3, 2TB
>
> /dev/sdd - may be parity disk 1 (maybe a raid-5-like setup), 2TB
>
> /dev/sde - may be parity disk 2 (maybe a raid-6-like setup), 2TB

Why use something as crude as parity? There's *lots* of space there. You
could store full-blown Reed-Solomon stuff in there in much less space
than parity would require with far more likelihood of repairing even
very large errors. A separate device-mapper target would seem to be
perfect for this: like dm-integrity, only with a separate set of
"error-correcting disks" rather than expanding every sector like
dm-integrity does.

-- 
NULL && (void)
