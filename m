Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2BBC433E0
	for <linux-raid@archiver.kernel.org>; Thu, 11 Feb 2021 03:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 452D764E8B
	for <linux-raid@archiver.kernel.org>; Thu, 11 Feb 2021 03:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhBKDWt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 10 Feb 2021 22:22:49 -0500
Received: from mail.snapdragon.cc ([103.26.41.109]:51892 "EHLO
        mail.snapdragon.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhBKDWs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 10 Feb 2021 22:22:48 -0500
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Feb 2021 22:22:47 EST
Received: by mail.snapdragon.cc (Postfix, from userid 65534)
        id EA99219E03A2; Thu, 11 Feb 2021 03:15:02 +0000 (UTC)
Content-Type: text/plain;
        charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=snapdragon.cc;
        s=default; t=1613013297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BurH8Xc6zofwJAxlEf0cGHi7c59Ad13vqle4nJ0Yj4c=;
        b=kH5+HV4QZsPfF6BebKFNV4/707eMFRvrggRJwodmmODkQXldpNv+Xd4HW1+P3YlAImjdA9
        eeKvpb8BMYD8fjQT8xKBP1VijZalX/6184UlAu+jf7OqoXiRHvwwdIstnAMYllOdk6x8lO
        kCGsEIVBHM8oZaq+gdsYAPyn6Xxrx/Y=
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: Linux RAID with btrfs stuck and consume 100 % CPU
From:   Manuel Riel <manu@snapdragon.cc>
In-Reply-To: <0c792470-6ee9-8254-dd57-a7a90ac95bcd@xmyslivec.cz>
Date:   Thu, 11 Feb 2021 11:14:56 +0800
Cc:     Chris Murphy <lists@colorremedies.com>,
        Michal Moravec <michal.moravec@logicworks.cz>,
        Linux-RAID <linux-raid@vger.kernel.org>, songliubraving@fb.com,
        guoqing.jiang@cloud.ionos.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <DBB07C8C-0D83-47DC-9B91-78AD385775E3@snapdragon.cc>
References: <d3fced3f-6c2b-5ffa-fd24-b24ec6e7d4be@xmyslivec.cz>
 <CAJCQCtSfz+b38fW3zdcHwMMtO1LfXSq+0xgg_DaKShmAumuCWQ@mail.gmail.com>
 <29509e08-e373-b352-d696-fcb9f507a545@xmyslivec.cz>
 <CAJCQCtRx7NJP=-rX5g_n5ZL7ypX-5z_L6d6sk120+4Avs6rJUw@mail.gmail.com>
 <695936b4-67a2-c862-9cb6-5545b4ab3c42@xmyslivec.cz>
 <CAJCQCtQWNSd123OJ_Rp8NO0=upY2Mn+SE7pdMqmyizJP028Yow@mail.gmail.com>
 <2f2f1c21-c81b-55aa-6f77-e2d3f32d32cb@xmyslivec.cz>
 <CAJCQCtTQN60V=DEkNvDedq+usfmFB+SQP2SBezUaSeUjjY46nA@mail.gmail.com>
 <4b0dd0aa-f77b-16c8-107b-0182378f34e6@xmyslivec.cz>
 <CAJCQCtQWh2JBAL_SDRG-gMd9Z1TXad7aKjZVUGdY1Akj7fn5Qg@mail.gmail.com>
 <5e79d1f8-7632-48ef-de56-9e79cba87434@xmyslivec.cz>
 <CAJCQCtTR1JZTLr+xTEZxrwh8xSfb+zpKjc+_S2tJGFofVMUdSQ@mail.gmail.com>
 <0c792470-6ee9-8254-dd57-a7a90ac95bcd@xmyslivec.cz>
To:     Vojtech Myslivec <vojtech@xmyslivec.cz>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I'm also hitting the exact same problem with XFS on RAID6 using a RAID1=20=

write journal on two NVMes. CentOS 8, 4.18.0-240.10.1.el8_3.x86_64.

Symptoms:

- high CPU usage of md4_raid6 process
- IO wait goes up
- IO on that file system locks up for tens of minutes and the kernel =
reports:

[Wed Feb 10 23:23:05 2021] INFO: task md4_reclaim:1070 blocked for more =
than 20 seconds.
[Wed Feb 10 23:23:05 2021]       Not tainted =
4.18.0-240.10.1.el8_3.x86_64 #1
[Wed Feb 10 23:23:05 2021] "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Wed Feb 10 23:23:05 2021] md4_reclaim     D    0  1070      2 =
0x80004000

Already confirmed it's not a timeout mismatch. No drive errors reported. =
SCT Error Recovery
Control is set to 7 seconds

>> It's kindof a complicated setup. When this problem happens, can you
>> check swap pressure?

There is a RAID1 SWAP partition, but it's almost unused, since the =
server has ample of RAM.

>>=20
>> /sys/fs/cgroup/memory.stat
>>=20
>> pgfault and maybe also pgmajfault - see if they're going up; or also
>> you can look at vmstat and see how heavy swap is being used at the
>> time. The thing is.
>>=20
>> Because any heavy eviction means writes to dm-0->md0 raid1->sdg+sdh
>> SSDs, which are the same SSDs that you have the md1 raid6 mdadm
>> journal going to. So if you have any kind of swap pressure, it very
>> likely will stop the journal or at least substantially slow it down,
>> and now you get blocked tasks as the pressure builds more and more
>> because now you have a ton of dirty writes in Btrfs that can't make =
it
>> to disk.

I've disabled SWAP to test this theory.

>> If there is minimal swap usage, then this hypothesis is false and
>> something else is going on. I also don't have an explanation why your
>> work around works.
>=20
> Sadly, I am not able to _disable the journal_ if I do - just by =
removing
> the device from the array - the MD device instantly fails and btrfs
> volume remounts read-only. I can not find any other way how to disable
> the journal, it seems it is not supported. I can see only
> `--add-journal` option and no corresponding `--delete-journal` one.
>=20
> I welcome any advice how to exchange write-journal with internal =
bitmap.

I read that the array needs to be in read-only mode. Then you can fail =
and replace
the write journal. (not tested)

# mdadm --readonly /dev/md0
# mdadm /dev/md0 --fail /dev/<journal>
# mdadm --manage /dev/md0 --add-journal /dev/<new-journal>

> Any other possible changes that comes to my mind are:
> - Enlarge write-journal

My write journal is about 180 GB

> - Move write-journal to physical sdg/sdh SSDs (out from md0 raid1
>  device).

I may try this, but as you say it's risky, especially when using =
"write-back"
journal mode

> I find the later a bit risky, as the write-journal is not redundant
> then. That's the reason we choose write journal on RAID device.

I'm also experimenting with write-back/write-through mode and different
stripe_cache_size. Hoping to find something. If nothing helps, it may =
not
be possible/supported to put a write journal on another RAID device?


