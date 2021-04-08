Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4283C433ED
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 06:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE4A4610A5
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 06:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhDHGeG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Apr 2021 02:34:06 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:49897 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230032AbhDHGeG (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 8 Apr 2021 02:34:06 -0400
Received: from [192.168.0.2] (ip5f5aeede.dynamic.kabel-deutschland.de [95.90.238.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id EC946206473C4;
        Thu,  8 Apr 2021 08:33:54 +0200 (CEST)
Subject: Re: [PATCH] md-cluster: fix use-after-free issue when removing rdev
To:     Heming Zhao <heming.zhao@suse.com>
Cc:     lidong.zhong@suse.com, xni@redhat.com, colyli@suse.com,
        ghe@suse.com, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>
References: <1617850862-26627-1-git-send-email-heming.zhao@suse.com>
 <00bcd9d8-4199-7d4d-32b0-ece055f2186d@molgen.mpg.de>
 <3744902a-2e35-ffc8-7de0-f0ad7dac0cbd@suse.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <7889c84f-b0f8-7ad9-cd10-793362234771@molgen.mpg.de>
Date:   Thu, 8 Apr 2021 08:33:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <3744902a-2e35-ffc8-7de0-f0ad7dac0cbd@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Heming,


Am 08.04.21 um 07:52 schrieb heming.zhao@suse.com:
> On 4/8/21 1:09 PM, Paul Menzel wrote:

>> Am 08.04.21 um 05:01 schrieb Heming Zhao:
>>> md_kick_rdev_from_array will remove rdev, so we should
>>> use rdev_for_each_safe to search list.
>>>
>>> How to trigger:
>>>
>>> ```
>>> for i in {1..20}; do
>>>      echo ==== $i `date` ====;
>>>
>>>      mdadm -Ss && ssh ${node2} "mdadm -Ss"
>>>      wipefs -a /dev/sda /dev/sdb
>>>
>>>      mdadm -CR /dev/md0 -b clustered -e 1.2 -n 2 -l 1 /dev/sda \
>>>         /dev/sdb --assume-clean
>>>      ssh ${node2} "mdadm -A /dev/md0 /dev/sda /dev/sdb"
>>>      mdadm --wait /dev/md0
>>>      ssh ${node2} "mdadm --wait /dev/md0"
>>>
>>>      mdadm --manage /dev/md0 --fail /dev/sda --remove /dev/sda
>>>      sleep 1
>>> done
>>> ```
>>
>> In the test script, I do not understand, what node2 is used for, where 
>> you log in over SSH.
> 
> The bug can only be triggered in cluster env. There are two nodes (in cluster),
> To run this script on node1, and need ssh to node2 to execute some cmds.
> ${node2} stands for node2 ip address. e.g.: ssh 192.168.0.3 "mdadm 
> --wait ..."

Please excuse my ignorance. I guess some other component is needed to 
connect the two RAID devices on each node? At least you never tell mdadm 
directly to use *node2*. Reading *Cluster Multi-device (Cluster MD)* [1] 
a resource agent is needed.

>>> ... ...
>>>
>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>> Reviewed-by: Gang He <ghe@suse.com>
>>
>> If there is a commit, your patch is fixing, please add a Fixes: tag.
>>
> 
> OK, I forgot it, will send v2 patch later.

Awesome.


Kind regards,

Paul


[1]: 
https://documentation.suse.com/sle-ha/12-SP4/html/SLE-HA-all/cha-ha-cluster-md.html
