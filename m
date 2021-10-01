Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CDCCC433EF
	for <linux-raid@archiver.kernel.org>; Fri,  1 Oct 2021 10:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0198B61361
	for <linux-raid@archiver.kernel.org>; Fri,  1 Oct 2021 10:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353656AbhJAKqa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Oct 2021 06:46:30 -0400
Received: from mga17.intel.com ([192.55.52.151]:22110 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353650AbhJAKq2 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 1 Oct 2021 06:46:28 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10123"; a="205552178"
X-IronPort-AV: E=Sophos;i="5.85,337,1624345200"; 
   d="scan'208";a="205552178"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 03:44:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,337,1624345200"; 
   d="scan'208";a="556238256"
Received: from linux.intel.com ([10.54.29.200])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Oct 2021 03:44:44 -0700
Received: from [10.249.134.210] (mtkaczyk-MOBL1.ger.corp.intel.com [10.249.134.210])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 88AAD580689;
        Fri,  1 Oct 2021 03:44:42 -0700 (PDT)
Subject: Re: [PATCH] mdadm: split off shared library
To:     Jes Sorensen <jsorensen@fb.com>,
        Jes Sorensen <jes@trained-monkey.org>
References: <7461b27b-2a4b-fbbb-5cfd-8fab416cbc9f@suse.de>
 <fc647fe7-542e-d8d0-920f-33a4edf92962@suse.de>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>, Coly Li <colyli@suse.de>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <32212d11-204c-eebb-d84a-7e51d61f53b3@linux.intel.com>
Date:   Fri, 1 Oct 2021 12:44:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <fc647fe7-542e-d8d0-920f-33a4edf92962@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 26.08.2021 18:28, Coly Li wrote:
> Hi Hannes,
> 
> It is fine for me to receiving a series with 30+ patches in linux-raid mailing 
> list. And I also can help to review all the patches when they are posted out.
> 
> Hi Jes,
> 
> If you are too busy to take care of mdadm, and you are glad, it is OK for me to 
> take the mdadm maintenance. I can be long term stable for the maintenance task.

Hi Jes,
We have around 40 to 50 patches waiting. We are also waiting for official
4.2 release (it was proposed by me in Jan'21 but it was initially mentioned in
Jul'20!). My preposition for stable release plan was also ignored[1].
I understand that you are busy and mdadm is not in your mind right now.

Coly comes with offer to take care of mdadm, could you answer?
Current model doesn't work, we definitely need to find new solution.
If there any other folk interested in this position, please
speak up loudly!

I will be pleased to cooperate with Coly, or any other maintainer which is
active and responsible. Naturally, VROC team will give support,
especially with external management issues.

It is a time to change something, we shouldn't wait more.

Thanks,
Mariusz


[1] 
https://lore.kernel.org/linux-raid/de867ab3-9942-77a0-c14d-dbfc67465888@linux.intel.com/
