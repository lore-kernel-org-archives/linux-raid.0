Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E414C433DB
	for <linux-raid@archiver.kernel.org>; Wed, 17 Mar 2021 08:35:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3EC864F2B
	for <linux-raid@archiver.kernel.org>; Wed, 17 Mar 2021 08:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhCQIfE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:35:04 -0400
Received: from mga07.intel.com ([134.134.136.100]:45358 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229467AbhCQIeh (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 17 Mar 2021 04:34:37 -0400
IronPort-SDR: G58Vf6g1tk1Wq/XXrErf41UZssSEK+KrOE1qZTdjMwcD4Rq5XhC9aREghHbVLLaTcYj33dmoml
 LKjDh2sc259A==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="253428658"
X-IronPort-AV: E=Sophos;i="5.81,255,1610438400"; 
   d="scan'208";a="253428658"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 01:34:36 -0700
IronPort-SDR: tmtsxV98T3jqEFUwYeaV+Qs3b6oHmu2fMILSX4vZQdatBr7Eu/63iJjwJGwaFbvI8SnfOTiVa4
 AAcPMdyqY/gA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,255,1610438400"; 
   d="scan'208";a="379199671"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga007.fm.intel.com with ESMTP; 17 Mar 2021 01:34:35 -0700
Received: from [10.213.18.95] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.18.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 6160C580812;
        Wed, 17 Mar 2021 01:34:34 -0700 (PDT)
Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup file
To:     Nigel Croxon <ncroxon@redhat.com>
Cc:     Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org,
        xni@redhat.com
References: <20210120200542.19139-1-ncroxon@redhat.com>
 <84ed6e32-3b69-f13d-b1b8-33166c92e5ab@trained-monkey.org>
 <eb0060d3-756d-c6f9-66d7-bcd7b0468bf7@linux.intel.com>
 <764426808.38181143.1615910368475.JavaMail.zimbra@redhat.com>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <cbaed953-90e8-3cc1-0e28-5ada3938c60e@linux.intel.com>
Date:   Wed, 17 Mar 2021 09:34:32 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <764426808.38181143.1615910368475.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 16.03.2021 16:59, Nigel Croxon wrote:
> 
> 
> ----- Original Message -----
> From: "Mariusz Tkaczyk" <mariusz.tkaczyk@linux.intel.com>
> To: "Jes Sorensen" <jes@trained-monkey.org>, "Nigel Croxon" <ncroxon@redhat.com>, linux-raid@vger.kernel.org, xni@redhat.com
> Sent: Tuesday, March 16, 2021 10:54:22 AM
> Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup file
> 
> Hello Nigel,
> 
> Blame told us, that yours patch introduce regression in following
> scenario:
> 
> #mdadm -CR imsm0 -e imsm -n4 /dev/nvme[0125]n1
> #mdadm -CR volume -l0 --chunk 64 --raid-devices=1 /dev/nvme0n1 --force
> #mdadm -G /dev/md/imsm0 -n2
> 
> At the end of reshape, level doesn't back to RAID0.
> Could you look into it?
> Let me know, if you need support.
> 
> Thanks,
> Mariusz
> 
> I’m trying your situation without my patch (its reverted) and I’m not seeing success.
> See the dmesg log.
> 
> 
> [root@fedora33 mdadmupstream]# mdadm -CR volume -l0 --chunk 64 --raid-devices=1 /dev/nvme0n1 --force
> mdadm: /dev/nvme0n1 appears to be part of a raid array:
>        level=container devices=0 ctime=Wed Dec 31 19:00:00 1969
> mdadm: Creating array inside imsm container md127
> mdadm: array /dev/md/volume started.
> 
> [root@fedora33 mdadmupstream]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [raid0]
> md126 : active raid0 nvme0n1[0]
>       500102144 blocks super external:/md127/0 64k chunks
> 
> md127 : inactive nvme3n1[3](S) nvme2n1[2](S) nvme1n1[1](S) nvme0n1[0](S)
>       4420 blocks super external:imsm
> 
> unused devices: <none>
> [root@fedora33 mdadmupstream]# mdadm -G /dev/md/imsm0 -n2
> [root@fedora33 mdadmupstream]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [raid0]
> md126 : active raid4 nvme3n1[2] nvme0n1[0]
>       500102144 blocks super external:-md127/0 level 4, 64k chunk, algorithm 5 [2/1] [U_]
> 
> md127 : inactive nvme3n1[3](S) nvme2n1[2](S) nvme1n1[1](S) nvme0n1[0](S)
>       4420 blocks super external:imsm
> 
> unused devices: <none>
> 
> 
> dmesg says:
> [Mar16 11:46] md/raid:md126: device nvme0n1 operational as raid disk 0
> [  +0.011147] md/raid:md126: raid level 4 active with 1 out of 2 devices, algorithm 5
> [  +0.044605] md/raid0:md126: raid5 must have missing parity disk!
> [  +0.000002] md: md126: raid0 would not accept array
> 
> -Nigel
> 
Hello Nigel,
It looks strange. Could you try to reproduce it with --size, less than
smaller drive in array (e.g. 10G)?

If it doesn't help please provide me your kernel version. I will try to
reproduce it myself.

Thanks,
Mariusz
