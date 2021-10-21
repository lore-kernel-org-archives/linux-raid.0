Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2652C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 21 Oct 2021 09:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7AF160FE8
	for <linux-raid@archiver.kernel.org>; Thu, 21 Oct 2021 09:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhJUJPy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 21 Oct 2021 05:15:54 -0400
Received: from mga06.intel.com ([134.134.136.31]:39946 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231326AbhJUJPx (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 21 Oct 2021 05:15:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10143"; a="289828697"
X-IronPort-AV: E=Sophos;i="5.87,169,1631602800"; 
   d="scan'208";a="289828697"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 02:13:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,169,1631602800"; 
   d="scan'208";a="595027559"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga004.jf.intel.com with ESMTP; 21 Oct 2021 02:13:18 -0700
Received: from [10.249.131.253] (mtkaczyk-MOBL1.ger.corp.intel.com [10.249.131.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 23F455808AD;
        Thu, 21 Oct 2021 02:13:16 -0700 (PDT)
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Subject: Re: [PATCH 1/1] mdadm/Detail: Can't show container name correctly
 when unpluging disks
To:     Xiao Ni <xni@redhat.com>, jes@trained-monkey.org
Cc:     ncroxon@redhat.com, ffan@redhat.com, linux-raid@vger.kernel.org
References: <1634740723-5298-1-git-send-email-xni@redhat.com>
Message-ID: <974e4fc3-f85c-bfa7-176e-a440fbdfc001@linux.intel.com>
Date:   Thu, 21 Oct 2021 11:13:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1634740723-5298-1-git-send-email-xni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Xiao,
On 20.10.2021 16:38, Xiao Ni wrote:
> +		char dv[32], dv_rep[32];
> +
> +		sprintf(dv, "/sys/dev/block/%d:%d",
> +				disks[d*2].major, disks[d*2].minor);
> +		sprintf(dv_rep, "/sys/dev/block/%d:%d",
> +				disks[d*2+1].major, disks[d*2+1].minor);Please use snprintf and PATH_MAX instead 32.
> +
> +		if ((!access(dv, R_OK) &&
> +		    (disks[d*2].state & (1<<MD_DISK_SYNC))) ||
IMO not correct style, please verify with checkpatch.
should be: [d * 2]
> +		    (!access(dv_rep, R_OK) &&
> +		    (disks[d*2+1].state & (1<<MD_DISK_SYNC)))) {

Could you define function for that?
something like (you can add access() verification if needed):
is_dev_alive(mdu_disk_info_t *disk)
{
	char *devnm = devid2kname(makedev..);
	if (devnm)
		return true;
	return false;
}

using true/false will require to add #include <stdbool.h>.
Jes suggests to use meaningful return values. This is only
suggestion so you can ignore it and use 0 and 1.

and then check:
if (is_dev_alive([d * 2]) & disks[d * 2].state & (1<<MD_DISK_SYNC) ||
    (is_dev_alive([d * 2 + 1]) & disks[d * 2 + 1].state & (1<<MD_DISK_SYNC))

What do you think?
Thanks,
Mariusz


