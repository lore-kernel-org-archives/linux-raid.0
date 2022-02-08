Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5197FC433F5
	for <linux-raid@archiver.kernel.org>; Tue,  8 Feb 2022 09:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353378AbiBHJPK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Feb 2022 04:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240554AbiBHJPJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Feb 2022 04:15:09 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2DAC0401F0
        for <linux-raid@vger.kernel.org>; Tue,  8 Feb 2022 01:15:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644311708; x=1675847708;
  h=date:from:to:subject:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=K9kiqqK1eZYx/5tarIShqAhFZKKq8PENjqQgV7U50PQ=;
  b=iLzbU544t4XAha5AbDNvLS011NawMvol7SkbkazaB1L+yFMHZgheBVcn
   Nx5TNzJy6rWSfcRnPWW42XsL0O3Yz/RxIikTabMMNNeMhFBhCjNkyjzBq
   CbgZ3Rm70DvtPvVV3UFXpYg28QvmmPoWkjNqozo0nqmQ8O5kUie41r+Dl
   SGi/wruNscRQ+ZDkcnnzF503nZ0z9+LMvlMgQLTYKkO9UFrHlmeo1dgnG
   5y2xT8Qe4OVhnwo4Yj0zztKjZaH2MwzGlr1mwJeQsNGxhBTkj4s9uobkk
   +x7F9Bo96uKlWCTcICvyNMLYpSuITDBH4Jhpj9gqTjkoYrzq+zm/5fEkf
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="248856539"
X-IronPort-AV: E=Sophos;i="5.88,352,1635231600"; 
   d="scan'208";a="248856539"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 01:14:57 -0800
X-IronPort-AV: E=Sophos;i="5.88,352,1635231600"; 
   d="scan'208";a="525475363"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.30.243])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 01:14:55 -0800
Date:   Tue, 8 Feb 2022 10:14:50 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Nigel Croxon <ncroxon@redhat.com>, jes@trained-monkey.org,
        linux-raid@vger.kernel.org, Wu Guanghao <wuguanghao3@huawei.com>,
        Coly Li <colyli@suse.de>
Subject: Re: [PATCH] mdadm: fix msg when removing a device using the short
 arg -r
Message-ID: <20220208101450.00007baf@linux.intel.com>
In-Reply-To: <20220207221519.3169427-1-ncroxon@redhat.com>
References: <20220207221519.3169427-1-ncroxon@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon,  7 Feb 2022 17:15:19 -0500
Nigel Croxon <ncroxon@redhat.com> wrote:

> The change from commit mdadm: fix coredump of mdadm
> --monitor -r broke the printing of the return message when
> passing -r to mdadm --manage, the removal of a device from
> an array.
> 
> If the current code reverts this commit, both issues are
> still fixed.
> 
> The original problem reported that the fix tried to address
> was:  The --monitor -r option requires a parameter,
> otherwise a null pointer will be manipulated when
> converting to integer data, and a core dump will appear.
> 
> The original problem was really fixed with:
> 60815698c0a Refactor parse_num and use it to parse optarg.
> Which added a check for NULL in 'optarg' before moving it
> to the 'increments' variable.
> 
> New issue: When trying to remove a device using the short
> argument -r, instead of the long argument --remove, the
> output is empty. The problem started when commit 
> 546047688e1c was added.
> 
> Steps to Reproduce:
> 1. create/assemble /dev/md0 device
> 2. mdadm --manage /dev/md0 -r /dev/vdxx
> 
> Actual results:
> Nothing, empty output, nothing happens, the device is still
> connected to the array.
> 
> The output should have stated "mdadm: hot remove failed
> for /dev/vdxx: Device or resource busy", if the device was
> still active. Or it should remove the device and print
> a message:
> 
> # mdadm --set-faulty /dev/md0 /dev/vdd
> mdadm: set /dev/vdd faulty in /dev/md0
> # mdadm --manage /dev/md0 -r /dev/vdd
> mdadm: hot removed /dev/vdd from /dev/md0
> 
> 
> The following commit should be reverted as it breaks
> mdadm --manage -r.
> 
> commit 546047688e1c64638f462147c755b58119cabdc8
> Author: Wu Guanghao <wuguanghao3@huawei.com>
> Date:   Mon Aug 16 15:24:51 2021 +0800
> mdadm: fix coredump of mdadm --monitor -r
> 
> -Nigel
> 
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> 
> 
Hi,
Thanks for the reminder. Revert is obviously correct. Jes could you
merge it?

In systemd world mdmonitor is rarely started from cmdline. If
"increment" option is not settable via config then it is probably
unused. I consider this option as deprecated and I suspect that no one
is using it now. Can we remove it completely?

If you disagree with that, then we should add support for it in config
file to make it usable. Additionally, I suggest to change "-r" for
"increments" to short opt always used with parameter.

Thanks,
Mariusz
