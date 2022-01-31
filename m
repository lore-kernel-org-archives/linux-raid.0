Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49BACC433F5
	for <linux-raid@archiver.kernel.org>; Mon, 31 Jan 2022 09:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbiAaJGQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 31 Jan 2022 04:06:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:9970 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234044AbiAaJGQ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 31 Jan 2022 04:06:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643619976; x=1675155976;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ifDXkqoZgh4P4SanoD8OgYGNLadDPk3cO0RH0Ch3JvE=;
  b=E9/3M1at/Q2miCuf4EA43W2McRXVT7S1I9AY5XVqNnBJh6noN/eApU6r
   i5NIYskyMNPJhUJnVmsTu6sJDw39u75kLwz5c8vmHa5Kxa0a5HrlNoirj
   IXcpCWpfSivqltv1+Wy6UB1X+IvKpDDoKQwqpM51Obv469bPQ6vAOVgdv
   /4n1qWRzQ2GLv9K4F1rp/8FY6gJ0qyFFzXePypdbBovGTPhACjrSwwC19
   HPRPPw4sBO6dqYSZiW9L2zvVX+yRjAQ8apZqq5cfarXK94SOh4ovLvy9A
   Smk2UUhqtNSl0F+DCWfTldUUIORDaprfvfSQV7lCs2chWHD4rQFH2p9tg
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10243"; a="245018978"
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="245018978"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 01:06:16 -0800
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="537096264"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.29.132])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 01:06:14 -0800
Date:   Mon, 31 Jan 2022 10:06:09 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 2/3] md: Set MD_BROKEN for RAID1 and RAID10
Message-ID: <20220131100609.000069a2@linux.intel.com>
In-Reply-To: <CALTww2_pHsq+=bY4CtimwxvarxQBM0ey7Y3xAfa0dwoJytU9kQ@mail.gmail.com>
References: <20220127153912.26856-1-mariusz.tkaczyk@linux.intel.com>
        <20220127153912.26856-3-mariusz.tkaczyk@linux.intel.com>
        <CALTww2_pHsq+=bY4CtimwxvarxQBM0ey7Y3xAfa0dwoJytU9kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Xiao,
Thanks for review.

On Mon, 31 Jan 2022 16:29:27 +0800
Xiao Ni <xni@redhat.com> wrote:

> > +
> >         if (test_bit(In_sync, &rdev->flags) && !mddev->fail_last_dev
> >             && !enough(conf, rdev->raid_disk)) {
> 
> The check of mddev->fail_last_dev should be removed here.

Ohh, my bad. I mainly tested it on RAID1 and didn't notice it.
Thanks!

> 
> > -               /*
> > -                * Don't fail the drive, just return an IO error.
> > -                */
> 
> It's the same. These comments can directly give people notes. raid10
> will return bio here with an error. Is it better to keep them here?

Sure, let wait for Song opinion first and then I will send v4.

Mariusz



