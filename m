Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9245AC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 23 May 2022 09:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbiEWJv7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 23 May 2022 05:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbiEWJvf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 23 May 2022 05:51:35 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0CA2AC5
        for <linux-raid@vger.kernel.org>; Mon, 23 May 2022 02:51:25 -0700 (PDT)
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1653299483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4X2BoeuRb6BTNtiAEbHzTQcs/z+aFKPk04I1SidY9/k=;
        b=Z8VfEMqFa+hUruuzcz0EiN7LT4A2dBDkvh4yFLfOdnxb0l7i0rpb5M7ncmuLP9EGMlV1Ey
        AqVz7z9H7a+5m39GAibC2Q1fSrgmt1P53pZaGsUsNR6CuQAaXuK4u9mSIKrUFonVvF83Wn
        7hnma2D38HrkEFeaxhqkDX9QJ7/QgDI=
To:     Donald Buczek <buczek@molgen.mpg.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev>
 <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
 <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
 <b4244eab-d9e2-20a0-ebce-1a96e8fadb91@deltatee.com>
 <836b2a93-65be-8d6c-8610-18373b88f86d@molgen.mpg.de>
 <5b0584a3-c128-cb53-7c8a-63744c60c667@linux.dev>
 <4edc9468-d195-6937-f550-211bccbd6756@molgen.mpg.de>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <954f9c33-7801-b6d2-65e3-9e5237905886@linux.dev>
Date:   Mon, 23 May 2022 17:51:18 +0800
MIME-Version: 1.0
In-Reply-To: <4edc9468-d195-6937-f550-211bccbd6756@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



>>>> I noticed a clear regression with mdadm tests with this patch in 
>>>> md-next
>>>> (7e6ba434cc6080).
>>>>
>>>> Before the patch, tests 07reshape5intr and 07revert-grow would fail
>>>> fairly infrequently (about 1 in 4 runs for the former and 1 in 30 runs
>>>> for the latter).
>>>>
>>>> After this patch, both tests always fail.
>>>>
>>>> I don't have time to dig into why this is, but it would be nice if
>>>> someone can at least fix the regression. It is hard to make any 
>>>> progress
>>>> on these tests if we are continuing to further break them.

I have tried with both ubuntu 22.04 kernel which is 5.15 and vanilla 
5.12, none of them
can pass your mentioned tests.

[root@localhost mdadm]# lsblk|grep vd
vda          252:0    0    1G  0 disk
vdb          252:16   0    1G  0 disk
vdc          252:32   0    1G  0 disk
vdd          252:48   0    1G  0 disk
[root@localhost mdadm]# ./test --dev=disk --disks=/dev/vd{a..d} 
--tests=05r1-add-internalbitmap
Testing on linux-5.12.0-default kernel
/root/mdadm/tests/05r1-add-internalbitmap... succeeded
[root@localhost mdadm]# ./test --dev=disk --disks=/dev/vd{a..d} 
--tests=07reshape5intr
Testing on linux-5.12.0-default kernel
/root/mdadm/tests/07reshape5intr... FAILED - see 
/var/tmp/07reshape5intr.log and /var/tmp/fail07reshape5intr.log for details
[root@localhost mdadm]# ./test --dev=disk --disks=/dev/vd{a..d} 
--tests=07revert-grow
Testing on linux-5.12.0-default kernel
/root/mdadm/tests/07revert-grow... FAILED - see 
/var/tmp/07revert-grow.log and /var/tmp/fail07revert-grow.log for details
[root@localhost mdadm]# head -10  /var/tmp/07revert-grow.log | grep mdadm
+ . /root/mdadm/tests/07revert-grow
*++ mdadm -CR --assume-clean /dev/md0 -l5 -n4 -x1 /dev/vda /dev/vdb 
/dev/vdc /dev/vdd /dev/vda /dev/vdb /dev/vdc /dev/vdd --metadata=0.9**
*
The above line is clearly wrong from my understanding.

And let's check ubuntu 22.04.

root@vm:/home/gjiang/mdadm# lsblk|grep vd
vda    252:0    0     1G  0 disk
vdb    252:16   0     1G  0 disk
vdc    252:32   0     1G  0 disk
root@vm:/home/gjiang/mdadm# ./test --dev=disk --disks=/dev/vd{a..d} 
--tests=05r1-failfast
Testing on linux-5.15.0-30-generic kernel
/home/gjiang/mdadm/tests/05r1-failfast... succeeded
root@vm:/home/gjiang/mdadm# ./test --dev=disk --disks=/dev/vd{a..c}   
--tests=07reshape5intr
Testing on linux-5.15.0-30-generic kernel
/home/gjiang/mdadm/tests/07reshape5intr... FAILED - see 
/var/tmp/07reshape5intr.log and /var/tmp/fail07reshape5intr.log for details
root@vm:/home/gjiang/mdadm# ./test --dev=disk --disks=/dev/vd{a..c} 
--tests=07revert-grow
Testing on linux-5.15.0-30-generic kernel
/home/gjiang/mdadm/tests/07revert-grow... FAILED - see 
/var/tmp/07revert-grow.log and /var/tmp/fail07revert-grow.log for details

So I would not consider it is regression.

[ ... ]

> FYI: I've used loop devices on a virtio disk.
>
> I later discovered Logans patches [1], which I were not aware of, as 
> I'm not subscribed to the lists.
>
> [1]: 
> https://lore.kernel.org/linux-raid/20220519191311.17119-6-logang@deltatee.com/T/#u
>
> The series seems to acknowledge that there are open problems and tries 
> to fix them.
> So I've used his md-bug branch from 
> https://github.com/sbates130272/linux-p2pmem but it didn't look better.

Thanks for your effort.

> So I understand, the mdadm tests *are* supposed to work and every bug 
> I see here is worth analyzing? Or is Logan hunting down everything 
> anyway?

Yes, it was supposed to be. But unfortunately, it was kind of broken, 
good news is people are aware
of it and try to make it works/better, pls see other links.

[1] 
https://lore.kernel.org/linux-raid/EA6887B4-2A44-49D0-ACF9-C04CC92AFD87@oracle.com/T/#t
[2] 
https://lore.kernel.org/linux-raid/CALTww2-mbfZRcHu_95Q+WANXZ9ayRwjXvyvqP5Gseeb86dEy=w@mail.gmail.com/T/#t

Thanks,
Guoqing
