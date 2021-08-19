Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30188C4338F
	for <linux-raid@archiver.kernel.org>; Thu, 19 Aug 2021 15:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 150B16101A
	for <linux-raid@archiver.kernel.org>; Thu, 19 Aug 2021 15:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238729AbhHSPhi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Aug 2021 11:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238643AbhHSPhi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Aug 2021 11:37:38 -0400
Received: from sabi.co.uk (unknown [IPv6:2002:b911:ff1d::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E0BC061575
        for <linux-raid@vger.kernel.org>; Thu, 19 Aug 2021 08:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sabi.co.uk;
         s=dkim-00; h=From:References:In-Reply-To:Subject:To:Date:Message-ID:
        Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iD+0sZBWMLQiUy3nmUtv811iSfNhza5HT1PIXXzw/j8=; b=BwRGweoUoAsaFyzTuNv8IEtgsx
        /Xq9QkN67bw7qIE8/mB7ToFc26bmcDxx9Hvj7MQsw5JDAp6yWp1Iua2ilLM7DhgDYGfb6HhT/ooEd
        9bsazEd4xRiebGgYP4NTgERgs2v8Ilfsb73LkM4mjjK15zGPG6Ng2xnVenAJqggzc9lSdIKiSfU5W
        pW7P6vlufzuTqQCNzWlQW77hCV8rzma0Q93FXRPUEMo+9HRlHePteWcXWZFnWPouU902V8b6TkaGC
        NxaENPDCNsD2kU5Iyym6mRTZC8ivq3FRSy7NnYtcmSirpW/wE/i1dUqoyFrO1ZDU5wzMhAA+wxYsr
        tDzosqCQ==;
Received: from b2b-37-24-20-172.unitymedia.biz ([37.24.20.172] helo=sabi.co.uk)
        by sabi.co.uk with esmtpsa(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)(Exim 4.93 id 1mGk6F-007WtT-8c   id 1mGk6F-007WtT-8cby authid <sabity>with cram
        for <linux-raid@vger.kernel.org>; Thu, 19 Aug 2021 15:36:59 +0000
Received: from [127.0.0.1] (helo=cyme.ty.sabi.co.uk)
        by sabi.co.uk with esmtp(Exim 4.93 5)
        id 1mGk68-003XYY-Ox
        for <linux-raid@vger.kernel.org>; Thu, 19 Aug 2021 17:36:52 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24862.31380.553122.902326@cyme.ty.sabi.co.uk>
Date:   Thu, 19 Aug 2021 17:36:52 +0200
To:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: [PATCH] disallow create or grow clustered bitmap with writemostly set
In-Reply-To: <20210819151011.2511557-1-ncroxon@redhat.com>
References: <20210819151011.2511557-1-ncroxon@redhat.com>
X-Mailer: VM 8.2.0b under 26.3 (x86_64-pc-linux-gnu)
From:   pg@mdraid.list.sabi.co.UK (Peter Grandi)
X-Disclaimer: This message contains only personal opinions
X-Blacklisted-At: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

[...]
> +				if (dv->writemostly == FlagSet) {
> +					if (major_num == BITMAP_MAJOR_CLUSTERED) {
> +						pr_err("Can not set --write-mostly with a clustered bitmap\n");
> +						goto abort_locked;
[...]
> +			if (((disk.state & (1 << MD_DISK_WRITEMOSTLY)) == 0) &&
> +			   (strcmp(s->bitmap_file, "clustered") == 0)) {
> +				pr_err("disks marked write-mostly are not supported with clustered bitmap\n");
> +				return 1;

It would be more useful for those error messages to give some
information identifying the MD set and disk, as written they are
only slightly better variants of the classic "Cannot open file."
message.
