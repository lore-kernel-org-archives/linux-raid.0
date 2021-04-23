Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 739CFC433B4
	for <linux-raid@archiver.kernel.org>; Fri, 23 Apr 2021 07:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FA07613D7
	for <linux-raid@archiver.kernel.org>; Fri, 23 Apr 2021 07:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhDWH1C (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Apr 2021 03:27:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:62677 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229935AbhDWH1C (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 23 Apr 2021 03:27:02 -0400
IronPort-SDR: 6B62IAaR/4oy+jh5RgwReYyGj7ufK6IN2iGdpfEeBpoKjiN7iJLngN+7LcClTVJ++5Aw7wA80D
 UP7ldFYQv9qw==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="183159385"
X-IronPort-AV: E=Sophos;i="5.82,245,1613462400"; 
   d="scan'208";a="183159385"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 00:26:24 -0700
IronPort-SDR: KUUE5eWqx9N29bVxh1o8GwkOeYUnbHC+4xQ64roSXHg3I1vJY2ANZn0Z8kS4qj0Fh8m+ffXHoT
 K30Dby6RNUoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,245,1613462400"; 
   d="scan'208";a="456120344"
Received: from apaszkie-desk.igk.intel.com ([10.102.102.225])
  by fmsmga002.fm.intel.com with ESMTP; 23 Apr 2021 00:26:22 -0700
Subject: Re: Cannot add replacement hard drive to mdadm RAID5 array
To:     Devon Beets <devon@sigmalabsinc.com>,
        "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc:     Glenn Wikle <gwikle@sigmalabsinc.com>
References: <CY4PR1301MB215210F6808E6C0BA5D751ABCA6F9@CY4PR1301MB2152.namprd13.prod.outlook.com>
 <027a7faa-8858-2488-2771-0d412ef73866@intel.com>
 <45914472-b918-8a34-e531-fa145ec670fc@linux.intel.com>
 <CY4PR1301MB215250DF9BB395E3D2233CF0CA769@CY4PR1301MB2152.namprd13.prod.outlook.com>
 <2c14c3cd-d171-88fc-f770-8ab27fd8c0d0@intel.com>
 <CY4PR1301MB2152C29CB86A1512996B422ECA469@CY4PR1301MB2152.namprd13.prod.outlook.com>
From:   Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Message-ID: <8dcf97d2-0980-e8bd-5607-be118b0fea47@intel.com>
Date:   Fri, 23 Apr 2021 09:26:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CY4PR1301MB2152C29CB86A1512996B422ECA469@CY4PR1301MB2152.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 22.04.2021 19:56, Devon Beets wrote:
> I ran with sudo since my user is not root in this case:
> 
> printf "%llu\n" -1 > sudo /sys/block/md126/md/resync_start
> -bash: printf: /sys/block/md126/md/resync_start: invalid number
> 
> So, we assumed that you simply wanted us to edit the resync_start file value to the number 18446744073709551615. I did it by hand using a text editor. After doing so, the value of the file changed to none.

That's right, sorry I forgot about sudo. It's a bit tricky to use it with
redirections. Something like this should work:

sudo sh -c 'printf "%llu\n" -1 > /sys/block/md126/md/resync_start'

> After that, I proceeded to reconstruct the array. But I changed the order of the commands. Not sure if that mattered.
> 
> sudo mdadm -S /dev/md125
> mdadm: stopped /dev/md125
> 
> sudo mdadm -a /dev/md127 /dev/sdb
> mdadm: added /dev/sdb
> 
> sudo mdadm -R --force /dev/md126
> mdadm: Started /dev/md/Data with 3 devices (0 new)
> 
> Even though it only reported 3 devices (0 new) during the last command's output, it successfully added the new /dev/sdb drive as a spare, started the array resync, and is recovering now as reported by cat /proc/mdstat.
> 
> Thank you so much for the assistance!

No problem, I'm glad you got it working.

Regards,
Artur
