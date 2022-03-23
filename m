Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB514C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 23 Mar 2022 10:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242016AbiCWKdN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Mar 2022 06:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243578AbiCWKcz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Mar 2022 06:32:55 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9624576E22
        for <linux-raid@vger.kernel.org>; Wed, 23 Mar 2022 03:31:24 -0700 (PDT)
Received: from [192.168.0.3] (ip5f5ae903.dynamic.kabel-deutschland.de [95.90.233.3])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id C0C6661EA1923;
        Wed, 23 Mar 2022 11:31:22 +0100 (CET)
Message-ID: <9eccf3ed-3db3-7ba7-fd8b-fa4273bc0752@molgen.mpg.de>
Date:   Wed, 23 Mar 2022 11:31:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] Mdmonitor: Fix segfault and improve logging
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@linux.intel.com>
Cc:     Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org,
        jes@trained-monkey.org, colyli@suse.de
References: <20220321123234.28769-1-kinga.tanska@intel.com>
 <e5502af7-be1c-da7f-af3d-ca36d45e6301@molgen.mpg.de>
 <9a062f0c-fcea-c543-3a46-05395c747fcd@linux.intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <9a062f0c-fcea-c543-3a46-05395c747fcd@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

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
     openat(AT_FDCWD, "/dev/sda", O_RDONLY)  = 3
fstat(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(0x8, 0), ...}) = 0
readlink("/sys/dev/block/8:0", "../../devices/pci0000:00/0000:00"..., 
199) = 91
     close(3)                                = 0
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
