Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85638C433E6
	for <linux-raid@archiver.kernel.org>; Wed, 27 Jan 2021 22:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F66464DD9
	for <linux-raid@archiver.kernel.org>; Wed, 27 Jan 2021 22:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhA0WyO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Jan 2021 17:54:14 -0500
Received: from moglen4.apt.columbia.edu ([160.39.60.15]:33488 "EHLO
        mx.sflc.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231749AbhA0WyK (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 27 Jan 2021 17:54:10 -0500
X-Greylist: delayed 2252 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jan 2021 17:54:10 EST
Received: from [10.65.72.101] (onering.p.sflc.info [10.65.72.101])
        by mx.sflc.info (Postfix) with ESMTPSA id BF811C1F520
        for <linux-raid@vger.kernel.org>; Wed, 27 Jan 2021 17:15:56 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=softwarefreedom.org;
        s=dkim; t=1611785756; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:in-reply-to:
         references; bh=N2UyQl2+nOWZEhoWwsGNmM75K43vwFrM89omIN63a+o=;
        b=lANccaTcErADoDJbxkQf7zk6tOsoP6e1DSmzvPd0CyOF9+/clF13ia0WZvn0lRFyjeLLIB
        T8EozHvOCWxeeDasedTUCWhUF9hCNxtQiuU1hukvbgZQ4rjFHksvfV5cdYfUCCyl4DXM6L
        QZATKljoK3QH0LDNAIUybGRaA9HVlKE=
From:   Daniel Gnoutcheff <gnoutchd@softwarefreedom.org>
Subject: "attempt to access beyond end of device" when reshaping raid10 from
 near=2 to offset=2
To:     linux-raid@vger.kernel.org
Message-ID: <09505ed1-ad29-28f1-627e-8a6a0b8df3a4@softwarefreedom.org>
Date:   Wed, 27 Jan 2021 17:15:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Greets,

Whilst experimenting with array reshaping, I've found that if I create a 
near=2 raid10 like so:

   for i in 0 1 2 3 ; do
     truncate --size=1G disk$i
     losetup /dev/loop$i disk$i
   done
   mdadm --create /dev/md0 --level=raid10 --raid-devices=4 --layout=n2 \
     --data-offset=10M /dev/loop{0,1,2,3}
   mdadm --wait /dev/md0  # wait for resync

and then try to reshape it to offset=2:

   mdadm --grow /dev/md0 --layout=o2

the reshape repeatedly fails and restarts with something like this in 
dmesg (repetitive messages snipped):

> Jan 27 15:47:07 snaptest kernel: md: reshape of RAID array md0
> Jan 27 15:47:07 snaptest kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> Jan 27 15:47:07 snaptest kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
> Jan 27 15:47:07 snaptest kernel: md: using 128k window, over a total of 2076672k.
> Jan 27 15:47:08 snaptest kernel: attempt to access beyond end of device
> Jan 27 15:47:08 snaptest kernel: loop2: rw=536870912, want=2097280, limit=2097152
> Jan 27 15:47:08 snaptest kernel: md/raid10:md0: Disk failure on loop2, disabling device.
>                                  md/raid10:md0: Operation continuing on 3 devices.
> Jan 27 15:47:08 snaptest kernel: attempt to access beyond end of device
> Jan 27 15:47:08 snaptest kernel: loop0: rw=536870912, want=2097280, limit=2097152
> Jan 27 15:47:08 snaptest kernel: md/raid10:md0: Disk failure on loop0, disabling device.
>                                  md/raid10:md0: Operation continuing on 2 devices.
> Jan 27 15:47:08 snaptest kernel: attempt to access beyond end of device
> Jan 27 15:47:08 snaptest kernel: loop1: rw=536870912, want=2097280, limit=2097152
> Jan 27 15:47:08 snaptest kernel: attempt to access beyond end of device
> Jan 27 15:47:08 snaptest kernel: loop1: rw=536870912, want=2097408, limit=2097152
> Jan 27 15:47:08 snaptest kernel: attempt to access beyond end of device
> Jan 27 15:47:08 snaptest kernel: loop1: rw=536870912, want=2097536, limit=2097152
> Jan 27 15:47:08 snaptest kernel: attempt to access beyond end of device
> Jan 27 15:47:08 snaptest kernel: loop1: rw=536870912, want=2097664, limit=2097152
<snip>
> Jan 27 15:47:09 snaptest kernel: loop3: rw=536870912, want=2097408, limit=2097152
> Jan 27 15:47:09 snaptest kernel: attempt to access beyond end of device
> Jan 27 15:47:09 snaptest kernel: loop3: rw=536870912, want=2097536, limit=2097152
> Jan 27 15:47:09 snaptest kernel: attempt to access beyond end of device
> Jan 27 15:47:09 snaptest kernel: loop3: rw=536870912, want=2097664, limit=2097152
<snip>
> Jan 27 15:47:09 snaptest kernel: loop3: rw=536870912, want=2106368, limit=2097152
> Jan 27 15:47:09 snaptest kernel: md: md0: reshape interrupted.
> Jan 27 15:47:09 snaptest kernel: md: reshape of RAID array md0
> Jan 27 15:47:09 snaptest kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> Jan 27 15:47:09 snaptest kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
> Jan 27 15:47:09 snaptest kernel: md: using 128k window, over a total of 2076672k.
> Jan 27 15:47:09 snaptest kernel: attempt to access beyond end of device
> Jan 27 15:47:09 snaptest kernel: loop1: rw=536870912, want=2107520, limit=2097152
<snip>

and so on until the array is stopped.

This log came from a Debian stretch VM (mdadm v3.4 and kernel 4.9.246 as 
patched and built by Debian), but I see the same behavior in Debian 
buster (mdadm v4.1) with stock and backport kernels (4.19.160 and 
5.9.15, respectively).

I notice that if I stop, re-assemble, and add back the "failed" devices, 
eg.:

   mdadm --assemble /dev/md0 /dev/loop{0,1,2,3}
   mdadm /dev/md0 --add /dev/loop0
   mdadm /dev/md0 --add /dev/loop2

then it recovers and reshapes without complaint.

Have I encountered a bug?

Many thanks,
-- 
Daniel Gnoutcheff
Systems Administrator
Software Freedom Law Center
