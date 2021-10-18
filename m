Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C45AC433F5
	for <linux-raid@archiver.kernel.org>; Mon, 18 Oct 2021 07:15:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 587D960FDC
	for <linux-raid@archiver.kernel.org>; Mon, 18 Oct 2021 07:15:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhJRHR1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Oct 2021 03:17:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:44713 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230006AbhJRHR0 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 18 Oct 2021 03:17:26 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10140"; a="225643953"
X-IronPort-AV: E=Sophos;i="5.85,381,1624345200"; 
   d="scan'208";a="225643953"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2021 00:15:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,381,1624345200"; 
   d="scan'208";a="629050867"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga001.fm.intel.com with ESMTP; 18 Oct 2021 00:15:11 -0700
Received: from [10.249.147.163] (mtkaczyk-MOBL1.ger.corp.intel.com [10.249.147.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 2238E580978;
        Mon, 18 Oct 2021 00:15:09 -0700 (PDT)
Subject: Re: [PATCH 1/1] mdadm/Detail: Can't show container name correctly
 when unpluging disks
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>, jes@trained-monkey.org
Cc:     ncroxon@redhat.com, ffan@redhat.com, linux-raid@vger.kernel.org
References: <1634289920-5037-1-git-send-email-xni@redhat.com>
 <92351bf8-b0e3-89da-48c0-993b0dc29db2@linux.intel.com>
Message-ID: <150ef21b-91eb-2c9f-d813-e8791eded0c1@linux.intel.com>
Date:   Mon, 18 Oct 2021 09:15:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <92351bf8-b0e3-89da-48c0-993b0dc29db2@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>> +        dv = devid2kname(makedev(disks[d*2].major, disks[d*2].minor));
>> +        dv_rep = devid2kname(makedev(disks[d*2+1].major, disks[d*2+1].minor));

devid2kname() returns static memory. If both drive and replacement
are available then dv value will be overwritten. Not sure if it is
possible.

Mariusz
