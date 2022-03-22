Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5938AC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 22 Mar 2022 08:07:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiCVIIi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Mar 2022 04:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiCVIIg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 22 Mar 2022 04:08:36 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7117822516
        for <linux-raid@vger.kernel.org>; Tue, 22 Mar 2022 01:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647936429; x=1679472429;
  h=date:from:to:subject:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=vS4Jo5Fu1vmQcrGG+Vu3LpZeIMsh/xbiP2sklBn4GPw=;
  b=MwGQFhusovgeze2XJQwXVirWOBmEHWfDYWAoIL8APVo8uubQdYop52eK
   ZxE1hXzlp82aZr5uhx1ltXaGi0lq7Y1CQnXrpNpTeRSAEc2Kb7nWbKEP5
   QMJ709tHkVWCURMbDxanf8sF5kELLleZk3VdMOfbKlYlD0f6ogmiE84Qk
   Ab15xH6f1fwEUv7XfpoyiqavcyfNrtD3fES1ARVQLt9WhK1pOqp9B2X2r
   HYl86K8EFHufrV02aUTEM+y2bTKu09EVuSSbEGK1ZNwYS3jvcSkl1M7pV
   7evsOLc6xPXP+J1Ia7T9oOPXhmcI0tfMbkBgN6+oYveZvLgEjbIk/XGJS
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10293"; a="257706604"
X-IronPort-AV: E=Sophos;i="5.90,201,1643702400"; 
   d="scan'208";a="257706604"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 01:07:09 -0700
X-IronPort-AV: E=Sophos;i="5.90,201,1643702400"; 
   d="scan'208";a="543587093"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.10.5])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 01:07:07 -0700
Date:   Tue, 22 Mar 2022 09:07:02 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Nigel Croxon <ncroxon@redhat.com>, jes@trained-monkey.org,
        linux-raid@vger.kernel.org, Wu Guanghao <wuguanghao3@huawei.com>,
        Coly Li <colyli@suse.de>
Subject: Re: [PATCH] mdadm: fix msg when removing a device using the short
 arg -r
Message-ID: <20220322090702.00006d65@linux.intel.com>
In-Reply-To: <20220208101450.00007baf@linux.intel.com>
References: <20220207221519.3169427-1-ncroxon@redhat.com>
        <20220208101450.00007baf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 8 Feb 2022 10:14:50 +0100
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> On Mon,  7 Feb 2022 17:15:19 -0500
> Nigel Croxon <ncroxon@redhat.com> wrote:
> 
> > The change from commit mdadm: fix coredump of mdadm
> > --monitor -r broke the printing of the return message when
> > passing -r to mdadm --manage, the removal of a device from
> > an array.
> > 
> > If the current code reverts this commit, both issues are
> > still fixed.
> > 
> > The original problem reported that the fix tried to address
> > was:  The --monitor -r option requires a parameter,
> > otherwise a null pointer will be manipulated when
> > converting to integer data, and a core dump will appear.
> > 
> > The original problem was really fixed with:
> > 60815698c0a Refactor parse_num and use it to parse optarg.
> > Which added a check for NULL in 'optarg' before moving it
> > to the 'increments' variable.
> > 
> > New issue: When trying to remove a device using the short
> > argument -r, instead of the long argument --remove, the
> > output is empty. The problem started when commit 
> > 546047688e1c was added.
> > 
> > Steps to Reproduce:
> > 1. create/assemble /dev/md0 device
> > 2. mdadm --manage /dev/md0 -r /dev/vdxx
> > 
> > Actual results:
> > Nothing, empty output, nothing happens, the device is still
> > connected to the array.
> > 
> > The output should have stated "mdadm: hot remove failed
> > for /dev/vdxx: Device or resource busy", if the device was
> > still active. Or it should remove the device and print
> > a message:
> > 
> > # mdadm --set-faulty /dev/md0 /dev/vdd
> > mdadm: set /dev/vdd faulty in /dev/md0
> > # mdadm --manage /dev/md0 -r /dev/vdd
> > mdadm: hot removed /dev/vdd from /dev/md0
> > 
> > 
> > The following commit should be reverted as it breaks
> > mdadm --manage -r.
> > 
> > commit 546047688e1c64638f462147c755b58119cabdc8
> > Author: Wu Guanghao <wuguanghao3@huawei.com>
> > Date:   Mon Aug 16 15:24:51 2021 +0800
> > mdadm: fix coredump of mdadm --monitor -r
> > 
> > -Nigel
> > 
> > Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> > 
> > 
> Hi,
> Thanks for the reminder. Revert is obviously correct. Jes could you
> merge it?
> 
> In systemd world mdmonitor is rarely started from cmdline. If
> "increment" option is not settable via config then it is probably
> unused. I consider this option as deprecated and I suspect that no one
> is using it now. Can we remove it completely?
> 
> If you disagree with that, then we should add support for it in config
> file to make it usable. Additionally, I suggest to change "-r" for
> "increments" to short opt always used with parameter.
> 

Hi Coly,
Could you take a look?

Thanks,
Mariusz
