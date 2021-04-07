Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0AA4C43460
	for <linux-raid@archiver.kernel.org>; Wed,  7 Apr 2021 10:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DED0613A3
	for <linux-raid@archiver.kernel.org>; Wed,  7 Apr 2021 10:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237823AbhDGKZs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Apr 2021 06:25:48 -0400
Received: from mga18.intel.com ([134.134.136.126]:63064 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244271AbhDGKZo (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 7 Apr 2021 06:25:44 -0400
IronPort-SDR: SYsj4XPQsG7T3a7chmfK/BAJiVZlA6DS515dt6RcV/PPp3VpAuocTyJJ/7gcvkST9BYMZnE/So
 IH9yS/Af7Jzg==
X-IronPort-AV: E=McAfee;i="6000,8403,9946"; a="180821267"
X-IronPort-AV: E=Sophos;i="5.82,203,1613462400"; 
   d="scan'208";a="180821267"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 03:25:34 -0700
IronPort-SDR: M7ABK2KunqBhR2ECix7XqxWerBZ0c4O+Kc/FZrZJQ2VUfyWc00qKoW7OYrIqpCCnYGAQcWmyLU
 i494Vgc4bwRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,203,1613462400"; 
   d="scan'208";a="448193008"
Received: from apaszkie-desk.igk.intel.com ([10.102.102.225])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Apr 2021 03:25:33 -0700
Subject: Re: Cannot add replacement hard drive to mdadm RAID5 array
To:     Devon Beets <devon@sigmalabsinc.com>,
        "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc:     Glenn Wikle <gwikle@sigmalabsinc.com>
References: <CY4PR1301MB215210F6808E6C0BA5D751ABCA6F9@CY4PR1301MB2152.namprd13.prod.outlook.com>
 <027a7faa-8858-2488-2771-0d412ef73866@intel.com>
 <45914472-b918-8a34-e531-fa145ec670fc@linux.intel.com>
 <CY4PR1301MB215250DF9BB395E3D2233CF0CA769@CY4PR1301MB2152.namprd13.prod.outlook.com>
From:   Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Message-ID: <2c14c3cd-d171-88fc-f770-8ab27fd8c0d0@intel.com>
Date:   Wed, 7 Apr 2021 12:25:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CY4PR1301MB215250DF9BB395E3D2233CF0CA769@CY4PR1301MB2152.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 06.04.2021 22:05, Devon Beets wrote:
> Output of the recommended commands for adding the new disk to the RAID5 array:
> 
> sudo mdadm -R --force /dev/md126
> mdadm: array /dev/md/Data now has 3 devices (0 new)
> 
> sudo mdadm -S /dev/md125
> mdadm: stopped /dev/md125
> 
> sudo mdadm -a /dev/md127 /dev/sdb
> mdadm: added /dev/sdb
> 
> Output of mdstat after running the commands. Shows that both md126 and md127 are inactive, and there is no RAID resync happening.
> 
> cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [raid1] [raid10]
> md126 : inactive sda[2] sdc[1] sdd[0]
>       5567507712 blocks super external:/md127/0
> 
> md127 : inactive sdb[3](S) sdc[2](S) sdd[1](S) sda[0](S)
>       10564 blocks super external:imsm
> 
> unused devices: <none>

It looks like mdadm still does not handle this case correctly. Please do this
before the "mdadm -R --force /dev/md126":

printf "%llu\n" -1 > /sys/block/md126/md/resync_start

Regards,
Artur
