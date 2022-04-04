Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5256FC433F5
	for <linux-raid@archiver.kernel.org>; Mon,  4 Apr 2022 12:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346786AbiDDMlz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345904AbiDDMlz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Apr 2022 08:41:55 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553B028E28
        for <linux-raid@vger.kernel.org>; Mon,  4 Apr 2022 05:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649075999; x=1680611999;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hbG+yqtTFNi1h5jbi/rk0WgM8sVaHLK8zxQo7Vue4KQ=;
  b=e/rsnGJLmo6okJcFPyrwdkIwtoQFFMcGItH2m+FeYEMSCIFqZck26kzy
   TLQclanXOTmVPJ0leEizWRDSm7zY88htm7Q6nTJsqHIlf8n/bz9vFJHfz
   Ha+oLPYhMgzOQxBwUGImrJRWXdCAcx9YfSWwVT67p5oonKzAZ3OpVIGkK
   vcTWuEeBtUl0I8Nk9IIocBwDOXAl/XFa3whxRsExU47LWOWqK86U1aWFK
   j2aJ+/FfF/mlTA1/dJdSGV2hppQtr7MUhvPK2m++yktit4W+0KDvd/lcb
   Pula8h1pZf3rSSzPiUeqf+404cN1eAO7Mh+bJ+ADMfRh/T2MrteElgHjl
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10306"; a="259334875"
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="259334875"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 05:39:59 -0700
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="569365473"
Received: from ktanska-mobl.ger.corp.intel.com (HELO [10.252.42.48]) ([10.252.42.48])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 05:39:57 -0700
Message-ID: <321885a5-f9c8-f9c2-fab2-2c31ead17b87@linux.intel.com>
Date:   Mon, 4 Apr 2022 14:39:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] Mdmonitor: Fix segfault and improve logging
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org,
        jes@trained-monkey.org, colyli@suse.de
References: <20220321123234.28769-1-kinga.tanska@intel.com>
 <e5502af7-be1c-da7f-af3d-ca36d45e6301@molgen.mpg.de>
 <9a062f0c-fcea-c543-3a46-05395c747fcd@linux.intel.com>
 <9eccf3ed-3db3-7ba7-fd8b-fa4273bc0752@molgen.mpg.de>
From:   "Tanska, Kinga" <kinga.tanska@linux.intel.com>
In-Reply-To: <9eccf3ed-3db3-7ba7-fd8b-fa4273bc0752@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Paul,


I've tried to reproduce it with mdadm 4.1 and mdadm 4.2 and both apps 
exit with

segmentation fault. This patch is not a fix, it adds checking if device 
is md array.

It hasn't been checked before in mdmonitor, so segmentation fault should 
appear.


Regards,

Kinga


On 3/23/2022 11:31 AM, Paul Menzel wrote:
Dear Kinga,


Am 23.03.22 um 10:02 schrieb Tanska, Kinga:

> I will send splitted patches in next messages.

Thank you.

> There are steps to reproduce:
>
> 1. Stop mdmonitor instance e.g.
>
> # systemctl stop mdmonitor
>
> 2. Run mdmonitor for non-md device e.g.
>
> # mdadm --monitor /dev/nvme1n1
>
>
> Call trace:
>
> #0  0x00007ffff7617518 in __strcpy_sse2_unaligned () from 
> /usr/lib64/libc.so.6
> #1  0x000000000042bc9e in check_array ()
> #2  0x000000000042c7af in Monitor ()
> #3  0x0000000000406edc in main ()

I am unable to reproduce it with mdadm 4.1:

     $ sudo strace mdadm --monitor /dev/sda
     execve("/usr/bin/mdadm", ["mdadm", "--monitor", "/dev/sda"], 
0x7ffc8b00e880 /* 14 vars */) = 0
     […]
     openat(AT_FDCWD, "/dev/sda", O_RDONLY)  = 3
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0), ...}) = 0
readlink("/sys/dev/block/8:0", "../../devices/pci0000:00/0000:00"..., 
199) = 91
     close(3)                                = 0
     pselect6(1, NULL, NULL, [], {tv_sec=1000, tv_nsec=0}, NULL) = ? 
ERESTARTNOHAND (To be restarted if no handler)
     --- SIGWINCH {si_signo=SIGWINCH, si_code=SI_KERNEL} ---
     pselect6(1, NULL, NULL, [], {tv_sec=999, tv_nsec=568020697}, NULL) 
= ? ERESTARTNOHAND (To be restarted if no handler)
     --- SIGWINCH {si_signo=SIGWINCH, si_code=SI_KERNEL} ---
pselect6(1, NULL, NULL, [], {tv_sec=999, tv_nsec=521836826}, NULL

Did a specific commit introduce the problem? If so, it’d be great if you 
added a Fixes line.

[…]


Kind regards,

Paul
