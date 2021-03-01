Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A80C433E0
	for <linux-raid@archiver.kernel.org>; Mon,  1 Mar 2021 12:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E51364D90
	for <linux-raid@archiver.kernel.org>; Mon,  1 Mar 2021 12:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbhCAMYl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 1 Mar 2021 07:24:41 -0500
Received: from mga14.intel.com ([192.55.52.115]:8809 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234427AbhCAMYe (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 1 Mar 2021 07:24:34 -0500
IronPort-SDR: PyCPyPPKpRuj5gWBQvG4wMZjcJlAUJlsYJImSYpeTQ74nHZXfMUk/IPFmJgNJELa/+kG4Fc1Rr
 Ct5jZTAoAmsQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9909"; a="185767197"
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="185767197"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 04:22:47 -0800
IronPort-SDR: SFVnTWytJu+Gxfhp3fRmz1wK46A6BRq+uNxYat4IqpM+kspLfD2kOVEsuAknDf7G/OEIGTXZv4
 Z9D0z/HnX7sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="383033671"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga002.jf.intel.com with ESMTP; 01 Mar 2021 04:22:47 -0800
Received: from [10.213.20.12] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.20.12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 9A289580224;
        Mon,  1 Mar 2021 04:22:46 -0800 (PST)
Subject: Re: release plan for mdadm
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
To:     jes@trained-monkey.org, Jes Sorensen <jes.sorensen@gmail.com>
Cc:     linux-raid@vger.kernel.org
References: <de867ab3-9942-77a0-c14d-dbfc67465888@linux.intel.com>
Message-ID: <e7d61078-bfb9-fd39-ba26-75e3a8c325a4@linux.intel.com>
Date:   Mon, 1 Mar 2021 13:22:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <de867ab3-9942-77a0-c14d-dbfc67465888@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 27.01.2021 12:39, Tkaczyk, Mariusz wrote:
> Hi Jes,
> 
> It's been a while since last mdadm release. Mdadm-4.2 release that was
> mentioned back in July does not happened yet. It's getting messy to
> manage mdadm across multiple distributions.
> 
> Also, not all OSVs are willing to cherry-pick the patches, especially
> for stable project - like mdadm, so only critical bugfixes are landing
> in the distros.
> As a result - new OSes has various forks of mdadm-4.1 and the difference
> is growing with every backported patch. It leads us to situation where
> those forks may have own bugs, caused by many missing bugfixes or wrongly
> resolved merge conflicts.
> To be honest - it becomes more and more problematic for us to track all
> fixes in different supported distros.
> 
> We are searching for solutions for those problems and we are counting on
> your support:
> Short term - is there any way that we can help you to release next version
> of mdadm soon?
> 
> Long term - what do you think about smaller, more frequent releases of
> mdadm? Maybe twice a year is an option (similar to RedHat/Ubuntu
> schedule)? That would be better for us and for vendors. They will need
> to follow upstream instead resolving bugs reported by us or community.
> 
> The benefits will be gained by everyone. User will get up-to-date
> software much faster, with minimal vendor input and modifications.
> Mdadm bugs will be predictable across distros. We could help with
> testing IMSM and basic functionality of native metadata.
> 
> What are your thoughts?
> Regards,
> Mariusz

Hi Jes,
Any feedback?

Mariusz
