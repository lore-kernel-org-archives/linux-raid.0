Return-Path: <SRS0=H5I/=DN=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F386C4363D
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 13:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46AD42078E
	for <linux-raid@archiver.kernel.org>; Tue,  6 Oct 2020 13:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgJFNRG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 6 Oct 2020 09:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgJFNRF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 6 Oct 2020 09:17:05 -0400
X-Greylist: delayed 84732 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 06 Oct 2020 06:17:05 PDT
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74578C061755
        for <linux-raid@vger.kernel.org>; Tue,  6 Oct 2020 06:17:05 -0700 (PDT)
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id 6DCF98C2;
        Tue,  6 Oct 2020 13:17:03 +0000 (UTC)
Date:   Tue, 6 Oct 2020 18:17:02 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Kenneth Emerson <kenneth.emerson@gmail.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: Need Help with Corrupted RAID6 Array
Message-ID: <20201006181702.09543eb2@natsu>
In-Reply-To: <CADzwnhXJBRuCNPsGhPHt-h1J3MU2HmH3_ZWkxW_auJ7FQyqJ0w@mail.gmail.com>
References: <CADzwnhXJBRuCNPsGhPHt-h1J3MU2HmH3_ZWkxW_auJ7FQyqJ0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 6 Oct 2020 06:05:40 -0500
Kenneth Emerson <kenneth.emerson@gmail.com> wrote:

> If I assemble and force it to run, the drives are no longer spare but
> even with a --force, the array will not go active:
> 
> root@MythTV:/home/ken# mdadm --assemble --run /dev/md3
> root@MythTV:/home/ken# cat /proc/mdstat
> Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
> [raid4] [raid10]
> md0 : active raid1 sdc1[2] sde1[4] sdd1[3] sdb1[1]
>       292800 blocks [5/4] [_UUUU]
> 
> md1 : active raid1 sdc2[4] sde2[1] sdd2[3] sdb2[2]
>       292968384 blocks [5/4] [_UUUU]
> 
> md3 : inactive sdc4[9] sde4[4] sdd4[2] sdb4[3]
>       10532388320 blocks super 1.0

Would be nice to see 'mdadm --detail /dev/md3' when it's in this state, and 
what it says in 'dmesg' after you tried --force.

-- 
With respect,
Roman
