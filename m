Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 737B2C433B4
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 07:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4671B61244
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 07:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239411AbhESH1n (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 May 2021 03:27:43 -0400
Received: from mga04.intel.com ([192.55.52.120]:9926 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230292AbhESH1n (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 May 2021 03:27:43 -0400
IronPort-SDR: Scu3u763XciwIquQpVhLUbAshuRTZzMuXJ1XXOpgYYilzhIGu8uJ8rn+6Nn7NcFhueKaSGntyl
 nEPDDijaTREg==
X-IronPort-AV: E=McAfee;i="6200,9189,9988"; a="198959802"
X-IronPort-AV: E=Sophos;i="5.82,312,1613462400"; 
   d="scan'208";a="198959802"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2021 00:26:24 -0700
IronPort-SDR: 6RwAc0rFMxg0amHFXm1Vy/LqdB6rivH8Cbq6NMX8wHORXybALOkvL6gq0dIHDpRHO/0hC0Sz9e
 4FgDpGC86YFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,312,1613462400"; 
   d="scan'208";a="544449297"
Received: from apaszkie-desk.igk.intel.com ([10.102.102.225])
  by orsmga004.jf.intel.com with ESMTP; 19 May 2021 00:26:22 -0700
Subject: Re: [PATCH 2/5] md: the latest try for improve io stats accounting
To:     Guoqing Jiang <jgq516@gmail.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org, Guoqing Jiang <jiangguoqing@kylinos.cn>
References: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
 <20210518053225.641506-3-jiangguoqing@kylinos.cn>
 <2887bc44-dd0b-0b24-ee97-b0a95f0c4936@intel.com>
 <2bfe7f2b-5b5b-634d-3996-3c4ed77e74ff@gmail.com>
From:   Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Message-ID: <d788bc1f-3fd9-a293-2f2a-6047fdd45625@intel.com>
Date:   Wed, 19 May 2021 09:26:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <2bfe7f2b-5b5b-634d-3996-3c4ed77e74ff@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 19.05.2021 03:30, Guoqing Jiang wrote:
> Hmm, raid0 allocates split bio from mddev->bio_set, but raid5 is
> different, it splits bio from r5conf->bio_split. So either let raid5 also
> splits bio from mddev->bio_set, or add an additional checking for
> raid5. Thoughts?

It looks like raid5 has a different bio set for that because it uses
mddev->bio_set for something else - allocating a bio for rdev. So I 
think it can be changed to split from mddev->bio_set and have a private
bio set for the rdev bio allocation.
