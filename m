Return-Path: <SRS0=9hr8=CK=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C43EEC433E7
	for <linux-raid@archiver.kernel.org>; Tue,  1 Sep 2020 17:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A69192071B
	for <linux-raid@archiver.kernel.org>; Tue,  1 Sep 2020 17:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730099AbgIARCH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Sep 2020 13:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729385AbgIARCC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 1 Sep 2020 13:02:02 -0400
Received: from smtp.domeneshop.no (smtp.domeneshop.no [IPv6:2a01:5b40:0:3005::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA226C061244
        for <linux-raid@vger.kernel.org>; Tue,  1 Sep 2020 10:02:01 -0700 (PDT)
Received: from cm-46.212.141.180.getinternet.no ([46.212.141.180]:37168 helo=olstad.com)
        by smtp.domeneshop.no with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <raid+list@olstad.com>)
        id 1kD9fS-0000f9-QW; Tue, 01 Sep 2020 19:01:58 +0200
Date:   Tue, 1 Sep 2020 19:01:58 +0200
From:   Kai Stian Olstad <raid+list@olstad.com>
To:     Ram Ramesh <rramesh2400@gmail.com>
Cc:     Drew <drew.kay@gmail.com>, antlists <antlists@youngman.org.uk>,
        Linux Raid <linux-raid@vger.kernel.org>
Subject: Re: Best way to add caching to a new raid setup.
Message-ID: <20200901170158.acaq54zxfeaiasdk@olstad.com>
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
 <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
 <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
 <1310d10c-1b83-7031-58e3-0f767b1df71b@gmail.com>
 <101d4a60-916c-fe30-ae7c-994098fe2ebe@youngman.org.uk>
 <694be035-4317-26fd-5eaf-8fdc20019d9b@gmail.com>
 <CAAMCDecWsihd4oy1ZAvcVb4aPnntrit2PXx-Zn2uM5rQoKPU=g@mail.gmail.com>
 <d4d38059-eaaa-a577-963a-c348434c260e@verizon.net>
 <CACJz6QvRqq+WLmbOYR=YECNwHzpedUjJEAcoaHseEzEd2Bq8nQ@mail.gmail.com>
 <79c15e0e-5f34-2b1a-282c-8bb36f2e3e81@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79c15e0e-5f34-2b1a-282c-8bb36f2e3e81@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Sep 01, 2020 at 11:12:40AM -0500, Ram Ramesh wrote:
> I really wished overlay fs had a nice merge/clean feature that will allow us
> to move overlay items to underlying file system and start over the overlay.

You should check out mergerfs[1], it can merge multiple directories together
on different disks and you can transparently move files between them.
Mergerfs have a lot of other features too that you might find useful.

[1] https://github.com/trapexit/mergerfs/

-- 
Kai Stian Olstad
