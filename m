Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF8AAC433C1
	for <linux-raid@archiver.kernel.org>; Tue, 23 Mar 2021 20:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 841FA619C2
	for <linux-raid@archiver.kernel.org>; Tue, 23 Mar 2021 20:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbhCWU7Q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 23 Mar 2021 16:59:16 -0400
Received: from mga14.intel.com ([192.55.52.115]:17449 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233441AbhCWU6z (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 23 Mar 2021 16:58:55 -0400
IronPort-SDR: INOvyQOMSzUtTzFwsHQR5s5Jnyn6m8Yc8vkfo0svzXBIci8sma9HsTZOyzsxe71x9a9W8PiyF9
 S260jobYOENg==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="189966127"
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="189966127"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 13:58:54 -0700
IronPort-SDR: OlCQ9fCRNynIC2Az0CcSvRZ1YDd3m+QF3HEFtcKSsB4ue6PQ5v2WaagvKU/zqSdOejxAWeN/iL
 KY/KqE51GqMA==
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="415157507"
Received: from oshchirs-mobl.ger.corp.intel.com (HELO [10.213.9.28]) ([10.213.9.28])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 13:58:52 -0700
Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup file
To:     Nigel Croxon <ncroxon@redhat.com>
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Jes Sorensen <jes@trained-monkey.org>
References: <764426808.38181143.1615910368475.JavaMail.zimbraredhat!com>
 <08b71ea7-bdd3-722d-d18f-aa065b8756c0@linux.intel.com>
 <207580597.39647667.1616433400775.JavaMail.zimbra@redhat.com>
 <5339fdf7-0d8a-e099-1fc4-be42a08c8ad3@linux.intel.com>
 <1361244809.39731072.1616517370775.JavaMail.zimbra@redhat.com>
From:   Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
Message-ID: <b77b55d3-d9b2-fac9-c756-fabced0546a0@linux.intel.com>
Date:   Tue, 23 Mar 2021 21:58:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1361244809.39731072.1616517370775.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/23/2021 5:36 PM, Nigel Croxon wrote:
> Oleksandr,
> Can you post your dmesg output when running the commands?
> 
> I've back down from 5.11 to 5.8 and I still see:
> [  +0.042694] md/raid0:md126: raid5 must have missing parity disk!
> [  +0.000001] md: md126: raid0 would not accept array
> 
> Thanks, Nigel

Hello Nigel,

I've switched to 4.18.0-240.el8.x86_64 kernel (I have RHEL8.3) and I still 
have the same results, issue is still easily reproducible when patch 
4ae96c8 is applied.

Cropped test logs with and w/o your patch:

# git log -n1 --oneline
f94df5c (HEAD -> master, origin/master, origin/HEAD) imsm: support for 
third Sata controller
# make clean; make; make install-systemd; make install
# mdadm -CR imsm0 -e imsm -n4 /dev/nvme[0-3]n1 && mdadm -CR volume -l0 
--chunk 64 --size=10G --raid-devices=1 /dev/nvme0n1 --force
# mdadm -G /dev/md/imsm0 -n2
# dmesg -c
[  393.530389] md126: detected capacity change from 0 to 10737418240
[  407.139318] md/raid:md126: device nvme0n1 operational as raid disk 0
[  407.153920] md/raid:md126: raid level 4 active with 1 out of 2 devices, 
algorithm 5
[  407.246037] md: reshape of RAID array md126
[  407.357940] md: md126: reshape interrupted.
[  407.388144] md: reshape of RAID array md126
[  407.398737] md: md126: reshape interrupted.
[  407.403486] md: reshape of RAID array md126
[  459.414250] md: md126: reshape done.
# cat /proc/mdstat
Personalities : [raid0] [raid6] [raid5] [raid4]
md126 : active raid4 nvme3n1[2] nvme0n1[0]
       10485760 blocks super external:/md127/0 level 4, 64k chunk, 
algorithm 0 [3/2] [UU_]

md127 : inactive nvme3n1[3](S) nvme2n1[2](S) nvme1n1[1](S) nvme0n1[0](S)
       4420 blocks super external:imsm

unused devices: <none>

# mdadm -Ss; wipefs -a /dev/nvme[0-3]n1
# dmesg -C
# git revert 4ae96c802203ec3cfbb089240c56d61f7f4661b3
# make clean; make; make install-systemd; make install
# mdadm -CR imsm0 -e imsm -n4 /dev/nvme[0-3]n1 && mdadm -CR volume -l0 
--chunk 64 --size=10G --raid-devices=1 /dev/nvme0n1 --force
# mdadm -G /dev/md/imsm0 -n2
# dmesg -c
[  623.772039] md126: detected capacity change from 0 to 10737418240
[  644.823245] md/raid:md126: device nvme0n1 operational as raid disk 0
[  644.838542] md/raid:md126: raid level 4 active with 1 out of 2 devices, 
algorithm 5
[  644.928672] md: reshape of RAID array md126
[  697.405351] md: md126: reshape done.
[  697.409659] md126: detected capacity change from 10737418240 to 21474836480
# cat /proc/mdstat
Personalities : [raid0] [raid6] [raid5] [raid4]
md126 : active raid0 nvme3n1[2] nvme0n1[0]
       20971520 blocks super external:/md127/0 64k chunks

md127 : inactive nvme3n1[3](S) nvme2n1[2](S) nvme1n1[1](S) nvme0n1[0](S)
       4420 blocks super external:imsm


Do you need more detailed logs? My system/drives configuration details?

Regards,
Oleksandr Shchirskyi
