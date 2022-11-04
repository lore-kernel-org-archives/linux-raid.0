Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB943C4332F
	for <linux-raid@archiver.kernel.org>; Fri,  4 Nov 2022 11:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiKDLL3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 4 Nov 2022 07:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiKDLL2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 4 Nov 2022 07:11:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA371BE87
        for <linux-raid@vger.kernel.org>; Fri,  4 Nov 2022 04:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667560232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2PzS9018RgBAW4yyqUHERxR9PWOAy/bET1gLcP7JwqA=;
        b=cytyBC+bo0THiGQQJZGjzfHMb4mDEW3dP8AD0mzzKsYW+9EskBX38GQiSWBwacgKM67IFD
        nxFdhHPil3FldUXDDmhwBfu8MU6xVC+BEGK1+rx0lT+zyC8jYqgorImpOrlHFTlWw+B8ZJ
        pi5vZUH8d43OUynPCIli0jeFafVhE+g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-388-Qq7YzNuXNo2H7kvSMXJ-6Q-1; Fri, 04 Nov 2022 07:10:29 -0400
X-MC-Unique: Qq7YzNuXNo2H7kvSMXJ-6Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9939D858F13;
        Fri,  4 Nov 2022 11:10:28 +0000 (UTC)
Received: from [10.43.17.48] (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A403B4A9257;
        Fri,  4 Nov 2022 11:10:27 +0000 (UTC)
Message-ID: <2f0551c6-44f9-0969-cb8f-c12c4fb44eff@redhat.com>
Date:   Fri, 4 Nov 2022 12:10:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.0
Subject: Re: A crash caused by the commit
 0dd84b319352bb8ba64752d4e45396d8b13e6018
To:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Heming Zhao <heming.zhao@suse.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, dm-devel@redhat.com
References: <alpine.LRH.2.21.2211021214390.25745@file01.intranet.prod.int.rdu2.redhat.com>
 <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
 <11a466f0-ecfe-c1e2-d967-2d648ce65bcb@suse.com>
 <c31fdd20-c736-5d65-e82e-338e7ed1571c@linux.dev>
Content-Language: en-US
From:   Zdenek Kabelac <zkabelac@redhat.com>
In-Reply-To: <c31fdd20-c736-5d65-e82e-338e7ed1571c@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dne 04. 11. 22 v 2:23 Guoqing Jiang napsal(a):
>
>
> On 11/3/22 10:46 PM, Heming Zhao wrote:
>> On 11/3/22 11:47 AM, Guoqing Jiang wrote:
>>> Hi,
>>>
>>> On 11/3/22 12:27 AM, Mikulas Patocka wrote:
>>>> Hi
>>>>
>>>> There's a crash in the test shell/lvchange-rebuild-raid.sh when running
>>>> the lvm testsuite. It can be reproduced by running "make check_local
>>>> T=shell/lvchange-rebuild-raid.sh" in a loop.
>>>
>>> I have problem to run the cmd (not sure what I missed), it would be better if
>>> the relevant cmds are extracted from the script then I can reproduce it with
>>> those cmds directly.
>>>
>>> [root@localhost lvm2]# git log | head -1
>>> commit 36a923926c2c27c1a8a5ac262387d2a4d3e620f8
>>> [root@localhost lvm2]# make check_local T=shell/lvchange-rebuild-raid.sh
>>> make -C libdm device-mapper
>>> [...]
>>> make -C daemons
>>> make[1]: Nothing to be done for 'all'.
>>> make -C test check_local
>>> VERBOSE=0 ./lib/runner \
>>>          --testdir . --outdir results \
>>>          --flavours ndev-vanilla --only shell/lvchange-rebuild-raid.sh 
>>> --skip @
>>> running 1 tests
>>> ###      running: [ndev-vanilla] shell/lvchange-rebuild-raid.sh 0
>>> | [ 0:00] lib/inittest: line 133: 
>>> /tmp/LVMTEST317948.iCoLwmDhZW/dev/testnull: Permission denied
>>> | [ 0:00] Filesystem does support devices in 
>>> /tmp/LVMTEST317948.iCoLwmDhZW/dev (mounted with nodev?)
>>
>> I didn't read other mails in this thread, only for above issue.
>> If you use opensuse, systemd service tmp.mount uses nodev option to mount 
>> tmpfs on /tmp.
>> From my experience, there are two methods to fix(work around):
>> 1. systemctl disable tmp.mount && systemctl mask tmp.mount && reboot
>> 2. mv /usr/lib/systemd/system/tmp.mount /root/ && reboot
>
> I am using centos similar system, I can try leap later. Appreciate for the 
> tips, Heming.


You can always redirect default /tmp dir to some other place/filesystem that 
allows you to create /dev nodes. Eventually for 'brave men'  you can let lvm2 
test suite to play directly with your /dev dir.  Normally nothing bad should 
happen, but we tend to prefer more controled '/dev' managed for a test.

Here are two envvars to play with:


make check_local T=shell/lvchange-rebuild-raid.sh LVM_TEST_DIR=/myhomefsdir  
LVM_TEST_DEVDIR=/dev

LVM_TEST_DIR for setting of dir where test creates all its files

LVM_TEST_DEVDIR  you can explicitly tell to keep using system's /dev   
(instead of dir created within tmpdir)


Regards


Zdenek


