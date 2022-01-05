Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3DA8C433F5
	for <linux-raid@archiver.kernel.org>; Wed,  5 Jan 2022 10:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239415AbiAEKVc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 5 Jan 2022 05:21:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:36482 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239410AbiAEKVb (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 5 Jan 2022 05:21:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641378091; x=1672914091;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=grurCe6FbxiiQONRFJpaIdjpTfEzs7NqkXaQfWwv3EE=;
  b=aTZSu8Gnq5Pq4O5dngP3HPm1ZbzhQ1cynAN3Ikrn42y9WidGxwHklP3m
   hSdQN5M/5IxHE7Y06l5er0jDM3/sdqxRpzinhoMlN6rer2x9KkDeNU7/E
   jafqZ1TF6w+qOq3Df3zJwr3FQjxSkXPU6eV98MdWTxH0M2CZPcJpMlJoi
   EAKsPetrHI0JXqW5AcEnTstdUB/O4mapMJRnMFw7zfzFq2uUdVIZeTLM8
   WarL5gTKXSKhh/gN7G5TgvHZpWXqPwolVL8NIHtZFC3FsjvMnXPRNlVL3
   wQOl2u7MAfm4hbZCtF+r2OwWo7yqbfcdbiAhwjWMKbJ/K1sO6aSC0q7WQ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="229730814"
X-IronPort-AV: E=Sophos;i="5.88,263,1635231600"; 
   d="scan'208";a="229730814"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 02:21:31 -0800
X-IronPort-AV: E=Sophos;i="5.88,263,1635231600"; 
   d="scan'208";a="512891865"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.0.94])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 02:21:29 -0800
Date:   Wed, 5 Jan 2022 11:21:24 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Subject: Re: ANNOUNCE mdadm-4.2
Message-ID: <20220105112124.00006a92@linux.intel.com>
In-Reply-To: <28fdbc45-96ca-7cdb-3ced-a5f65d978048@trained-monkey.org>
References: <28fdbc45-96ca-7cdb-3ced-a5f65d978048@trained-monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 30 Dec 2021 14:52:44 -0500
Jes Sorensen <jes@trained-monkey.org> wrote:

> Hi,
> 
> Finally here it is, mdadm-4.2. Thanks for all the contributions and
> your patience.
> 
> Happy New Year everyone!
> 
> Jes
> 
> From the announce file:
> 
> I am pleased to finally announce the availability of mdadm-4.2.
> get 4.2 out the door soon.
> 
> It is available at the usual places:
>    http://www.kernel.org/pub/linux/utils/raid/mdadm/
> and via git at
>    git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
>    http://git.kernel.org/cgit/utils/mdadm/
> 

Hi Jes,
I can see a tarball in the first link but I cannot find 4.2 tag in git:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git

Could you push the tag to repository?

Thanks,
Mariusz

