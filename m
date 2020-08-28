Return-Path: <SRS0=wQ6l=CG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B385C433E2
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 17:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B7482098B
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 17:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgH1Rq0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Aug 2020 13:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgH1RqZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Aug 2020 13:46:25 -0400
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446B5C061264
        for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2020 10:46:24 -0700 (PDT)
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id 46531410;
        Fri, 28 Aug 2020 17:46:17 +0000 (UTC)
Date:   Fri, 28 Aug 2020 22:46:16 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     "R. Ramesh" <rramesh@verizon.net>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
Subject: Re: Best way to add caching to a new raid setup.
Message-ID: <20200828224616.58a1ad6c@natsu>
In-Reply-To: <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
        <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 27 Aug 2020 21:31:07 -0500
"R. Ramesh" <rramesh@verizon.net> wrote:

> I have two raid6s running on mythbuntu 14.04. The are built on 6 
> enterprise drives. So, no hd issues as of now. Still, I plan to upgrade 
> as it has been a while and the size of the hard drives have become 
> significantly larger (a indication that my disks may be older) I want to 
> build new raid using the 16/14tb drives. Since I am building new raid, I 
> thought I could explore caching options. I see a mention of LVM cache 
> and few other bcache/xyzcache etc.

Once you set up bcache, it cannot be removed. The volume will always stay a
bcache volume, even if you decide to stop using caching. Which feels weird and
potentially troublesome, going through an extra layer (kernel driver) with its
complexity and computational overhead (no matter how small).

On the other hand LVM with caching turned off is just normal LVM, that you'd
likely would have used anyway, for other benefits that it provides.

Also my impression is that LVM has more solid and reliable codebase, but
bcache might provide a somewhat better the performance boost due to caching.

-- 
With respect,
Roman
