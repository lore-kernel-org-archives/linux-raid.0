Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E7C4C4332F
	for <linux-raid@archiver.kernel.org>; Mon,  7 Nov 2022 01:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiKGBwx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 6 Nov 2022 20:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiKGBww (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 6 Nov 2022 20:52:52 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA6EDED1
        for <linux-raid@vger.kernel.org>; Sun,  6 Nov 2022 17:52:50 -0800 (PST)
Subject: Re: A crash caused by the commit
 0dd84b319352bb8ba64752d4e45396d8b13e6018
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667785968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P5tuk0X9s2nrNCBCC+Lu9kdj56ZJinkQ2kABOyjdW2M=;
        b=Y3N1D1k6s7nJRJgRZNtxb5T0QLeF2JQeDMBVy+bPJ++asv2da15KFdHRFWp4yArhLx4FMv
        ZFI5HgEGNP4bbd3kkqJMm3W9EjYJjz9vA/aS5V10SmfAuMUYZSlMCnM8JbyPfWVdYHujsH
        LsDVd/ICWY3j7ViKt7Tsr1WSHJsmL6g=
To:     Zdenek Kabelac <zkabelac@redhat.com>,
        Heming Zhao <heming.zhao@suse.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, dm-devel@redhat.com
References: <alpine.LRH.2.21.2211021214390.25745@file01.intranet.prod.int.rdu2.redhat.com>
 <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
 <11a466f0-ecfe-c1e2-d967-2d648ce65bcb@suse.com>
 <c31fdd20-c736-5d65-e82e-338e7ed1571c@linux.dev>
 <2f0551c6-44f9-0969-cb8f-c12c4fb44eff@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <57672478-63f3-d214-a2fc-ef06c4200e90@linux.dev>
Date:   Mon, 7 Nov 2022 09:52:45 +0800
MIME-Version: 1.0
In-Reply-To: <2f0551c6-44f9-0969-cb8f-c12c4fb44eff@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 11/4/22 7:10 PM, Zdenek Kabelac wrote:
> Dne 04. 11. 22 v 2:23 Guoqing Jiang napsal(a):
>>
>>
>> On 11/3/22 10:46 PM, Heming Zhao wrote:
>>> On 11/3/22 11:47 AM, Guoqing Jiang wrote:
>>>> Hi,
>>>>
>>>> On 11/3/22 12:27 AM, Mikulas Patocka wrote:
>>>>> Hi
>>>>>
>>>>> There's a crash in the test shell/lvchange-rebuild-raid.sh when 
>>>>> running
>>>>> the lvm testsuite. It can be reproduced by running "make check_local
>>>>> T=shell/lvchange-rebuild-raid.sh" in a loop.
>>>>
>>>> I have problem to run the cmd (not sure what I missed), it would be 
>>>> better if
>>>> the relevant cmds are extracted from the script then I can 
>>>> reproduce it with
>>>> those cmds directly.
>>>>
>>>> [root@localhost lvm2]# git log | head -1
>>>> commit 36a923926c2c27c1a8a5ac262387d2a4d3e620f8
>>>> [root@localhost lvm2]# make check_local 
>>>> T=shell/lvchange-rebuild-raid.sh
>>>> make -C libdm device-mapper
>>>> [...]
>>>> make -C daemons
>>>> make[1]: Nothing to be done for 'all'.
>>>> make -C test check_local
>>>> VERBOSE=0 ./lib/runner \
>>>>          --testdir . --outdir results \
>>>>          --flavours ndev-vanilla --only 
>>>> shell/lvchange-rebuild-raid.sh --skip @
>>>> running 1 tests
>>>> ###      running: [ndev-vanilla] shell/lvchange-rebuild-raid.sh 0
>>>> | [ 0:00] lib/inittest: line 133: 
>>>> /tmp/LVMTEST317948.iCoLwmDhZW/dev/testnull: Permission denied
>>>> | [ 0:00] Filesystem does support devices in 
>>>> /tmp/LVMTEST317948.iCoLwmDhZW/dev (mounted with nodev?)
>>>
>>> I didn't read other mails in this thread, only for above issue.
>>> If you use opensuse, systemd service tmp.mount uses nodev option to 
>>> mount tmpfs on /tmp.
>>> From my experience, there are two methods to fix(work around):
>>> 1. systemctl disable tmp.mount && systemctl mask tmp.mount && reboot
>>> 2. mv /usr/lib/systemd/system/tmp.mount /root/ && reboot
>>
>> I am using centos similar system, I can try leap later. Appreciate 
>> for the tips, Heming.
>
>
> You can always redirect default /tmp dir to some other 
> place/filesystem that allows you to create /dev nodes. Eventually for 
> 'brave men'  you can let lvm2 test suite to play directly with your 
> /dev dir.  Normally nothing bad should happen, but we tend to prefer 
> more controled '/dev' managed for a test.
>
> Here are two envvars to play with:
>
>
> make check_local T=shell/lvchange-rebuild-raid.sh 
> LVM_TEST_DIR=/myhomefsdir  LVM_TEST_DEVDIR=/dev
>
> LVM_TEST_DIR for setting of dir where test creates all its files
>
> LVM_TEST_DEVDIR  you can explicitly tell to keep using system's /dev   
> (instead of dir created within tmpdir)

Thank you! This works for me.

[root@localhost lvm2]# make check_local T=shell/lvchange-rebuild-raid.sh 
LVM_TEST_DIR=/root/test LVM_TEST_DEVDIR=/dev
make -C libdm device-mapper
make[1]: Nothing to be done for 'device-mapper'.

[... ]

make -C test check_local
VERBOSE=0 ./lib/runner \
         --testdir . --outdir results \
         --flavours ndev-vanilla --only shell/lvchange-rebuild-raid.sh 
--skip @
running 1 tests
###       passed: [ndev-vanilla] shell/lvchange-rebuild-raid.sh 20

### 1 tests: 1 passed, 0 skipped, 0 timed out, 0 warned, 0 failed

Thanks,
Guoqing
