Return-Path: <SRS0=Qcx5=CV=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59353C433E2
	for <linux-raid@archiver.kernel.org>; Sat, 12 Sep 2020 15:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA64720829
	for <linux-raid@archiver.kernel.org>; Sat, 12 Sep 2020 15:01:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nwp8WIb3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbgILPBA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 12 Sep 2020 11:01:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23525 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725935AbgILPAB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 12 Sep 2020 11:00:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599922799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oyegQIQQIAZUVoK5inqBvLUfFHbpYMmyXukgMGHdoPk=;
        b=Nwp8WIb3G8uL+1S0hYnTmi3Y/Y/wCfNdtD+tWwsIW4IaxNSyJahLuCIyqsbYJ7WIUybgOs
        2pNLd5uJukm8R6LfwmpgF6Bo5yh9kYw4BBbthQvE8C1rWjffZ2RC8vOX2WOIZfLEPZEWjz
        E4HwyW00vBahrqSn8M+ckI8FqrmbWmg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-WoJvsNNlMNC_7KYe7Qh54g-1; Sat, 12 Sep 2020 10:59:55 -0400
X-MC-Unique: WoJvsNNlMNC_7KYe7Qh54g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 216BA1074649;
        Sat, 12 Sep 2020 14:59:54 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B1EAF19D7C;
        Sat, 12 Sep 2020 14:59:51 +0000 (UTC)
Subject: Re: unexpected 'mdadm -S' hang with I/O pressure testing
To:     Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org
Cc:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <songliubraving@fb.com>
References: <a5f14765-4da8-e965-beed-3d01ac496c61@suse.de>
 <0be1a9cf-3a8a-4ed9-91b8-d15787528acf@suse.de>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <dce9b69e-1d22-226a-9a0d-87d8a43c4827@redhat.com>
Date:   Sat, 12 Sep 2020 22:59:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <0be1a9cf-3a8a-4ed9-91b8-d15787528acf@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all

I did a test on single disk (just replace /dev/md0 with /dev/sde), it 
had the same problem too.
Ctrl+c can't stop the fio process. There still are write I/O on /dev/sde 
after ctrl+c. It needs to wait
for all I/O finish.

Regards
Xiao

On 09/12/2020 10:21 PM, Coly Li wrote:
> One thing to correct: the hang is not forever - after I posted the
> previous email, all commands returns and the array stopped. It takes
> around 40 minutes -- still quite unexpected and suspicious.
>
> Thanks.
>
> Coly Li
>
> On 2020/9/12 22:06, Coly Li wrote:
>> Unexpected Behavior:
>> - With Linux v5.9-rc4 mainline kernel and latest mdadm upstream code
>> - After running fio with 10 jobs, 16 iodpes and 64K block size for a
>> while, try to stop the fio process by 'Ctrl + c', the main fio process
>> hangs.
>> - Then try to stop the md raid 5 array by 'mdadm -S /dev/md0', the mdad
>> process hangs.
>> - Reboot the system by 'echo b > /proc/sysrq-trigger', this md raid5
>> array is assembled but inactive. /proc/mdstat shows,
>> 	Personalities : [raid6] [raid5] [raid4]
>> 	md127 : inactive sdc[0] sde[3] sdd[1]
>> 	      35156259840 blocks super 1.2
>>
>> Expectation:
>> - The fio process can stop with 'Ctrl + c'
>> - The raid5 array can be stopped by 'mdadm -S /dev/md0'
>> - This md raid5 array may continue to work (resync and being active)
>> after reboot
>>
>>
>> How to reproduce:
>> 1) Create md raid5 with 3 hard drives (12TB for each SATA spinning disk)
>>    # mdadm -C /dev/md0 -l 5 -n 3 /dev/sd{c,d,e}
>>    # cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4]
>> md0 : active raid5 sde[3] sdd[1] sdc[0]
>>        23437506560 blocks super 1.2 level 5, 512k chunk, algorithm 2
>> [3/2] [UU_]
>>        [>....................]  recovery =  0.0% (2556792/11718753280)
>> finish=5765844.7min speed=33K/sec
>>        bitmap: 2/88 pages [8KB], 65536KB chunk
>>
>> 2) Run fio for random write on the raid5 array
>>    fio job file content:
>> [global]
>> thread=1
>> ioengine=libaio
>> random_generator=tausworthe64
>>
>> [job]
>> filename=/dev/md0
>> readwrite=randwrite
>> blocksize=64K
>> numjobs=10
>> iodepth=16
>> runtime=1m
>>    # fio ./raid5.fio
>>
>> 3) Wait for 10 seconds after the above fio runs, then type 'Ctrl + c' to
>> stop the fio process:
>> x:/home/colyli/fio_test/raid5 # fio ./raid5.fio
>> job: (g=0): rw=randwrite, bs=(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.0KiB,
>> (T) 64.0KiB-64.0KiB, ioengine=libaio, iodepth=16
>> ...
>> fio-3.23-10-ge007
>> Starting 12 threads
>> ^Cbs: 12 (f=12): [w(12)][3.3%][w=6080KiB/s][w=95 IOPS][eta 14m:30s]
>> fio: terminating on signal 2
>> ^C
>> fio: terminating on signal 2
>> ^C
>> fio: terminating on signal 2
>> Jobs: 11 (f=11): [w(5),_(1),w(4),f(1),w(1)][7.5%][eta 14m:20s]
>> ^C
>> fio: terminating on signal 2
>> Jobs: 11 (f=11): [w(5),_(1),w(4),f(1),w(1)][70.5%][eta 15m:00s]
>>
>> Now the fio process is hang forever.
>>
>> 4) try to stop this md raid5 array by mdadm
>>    # mdadm -S /dev/md0
>>    Now the mdadm process hangs for ever
>>
>>
>> Kernel versions to reproduce
>> - Use latest upstream mdadm source code
>> - I tried Linux v5.9-rc4, and Linux v4.12, both of them may stable
>> reproduce the above unexpected behavior.
>>    Therefore I assume maybe at least from v4.12 to v5.9 may have such issue.
>>
>> Just for your information, hope you may have a look into it. Thanks in
>> advance.
>>
>> Coly Li
>>

