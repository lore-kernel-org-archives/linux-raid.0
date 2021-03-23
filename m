Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E90EEC433C1
	for <linux-raid@archiver.kernel.org>; Tue, 23 Mar 2021 16:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDAF46199F
	for <linux-raid@archiver.kernel.org>; Tue, 23 Mar 2021 16:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbhCWQgb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 23 Mar 2021 12:36:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30474 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233381AbhCWQgR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 23 Mar 2021 12:36:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616517376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NBymD2bXq0ZtzcfZuaQr9X6P8GSYf1wU9drzkDCcn/w=;
        b=I89AoDPr4rGMa2MmG74PC+kfZ184xMGdttj5/GyAJC78O5rn3R6KUn97/RMPIX4071+VsZ
        zHlGVEUa7u698QF4ufnfCz7DNtvMJrl7pb7VtjNZ/hJ+tHCgkkX9WB65ceRaHvF1+ExJL/
        oHb0hBOZtyzX5bAp8SdJpeWkL8rQWYM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-cwNvtJ4_P9O8MRKWxjCgNg-1; Tue, 23 Mar 2021 12:36:12 -0400
X-MC-Unique: cwNvtJ4_P9O8MRKWxjCgNg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48E7D81622;
        Tue, 23 Mar 2021 16:36:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E5501002D71;
        Tue, 23 Mar 2021 16:36:11 +0000 (UTC)
Received: from zmail24.collab.prod.int.phx2.redhat.com (zmail24.collab.prod.int.phx2.redhat.com [10.5.83.30])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 186521809C82;
        Tue, 23 Mar 2021 16:36:11 +0000 (UTC)
Date:   Tue, 23 Mar 2021 12:36:10 -0400 (EDT)
From:   Nigel Croxon <ncroxon@redhat.com>
To:     Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Jes Sorensen <jes@trained-monkey.org>
Message-ID: <1361244809.39731072.1616517370775.JavaMail.zimbra@redhat.com>
In-Reply-To: <5339fdf7-0d8a-e099-1fc4-be42a08c8ad3@linux.intel.com>
References: <764426808.38181143.1615910368475.JavaMail.zimbraredhat!com> <08b71ea7-bdd3-722d-d18f-aa065b8756c0@linux.intel.com> <207580597.39647667.1616433400775.JavaMail.zimbra@redhat.com> <5339fdf7-0d8a-e099-1fc4-be42a08c8ad3@linux.intel.com>
Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup file
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.22.2.94, 10.4.195.25]
Thread-Topic: mdadm: fix reshape from RAID5 to RAID6 with backup file
Thread-Index: rtznHumOQnBqmwMi3lrNRHPZqp1OWQ==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



----- Original Message -----
From: "Oleksandr Shchirskyi" <oleksandr.shchirskyi@linux.intel.com>
To: "Nigel Croxon" <ncroxon@redhat.com>
Cc: linux-raid@vger.kernel.org, "Mariusz Tkaczyk" <mariusz.tkaczyk@linux.intel.com>, "Jes Sorensen" <jes@trained-monkey.org>
Sent: Monday, March 22, 2021 1:41:17 PM
Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup file

dmesg output for my test scenario with you patch applied:

[534716.791252] md126: detected capacity change from 0 to 41943040
[534716.797684] md: md126 still in use.
[534716.803334] md: md126 stopped.
[534716.829098] md: md127 stopped.
[534718.036483] md126: detected capacity change from 20971520 to 0
[534741.743609] md/raid:md126: device nvme0n1 operational as raid disk 0
[534741.762739] md/raid:md126: raid level 4 active with 1 out of 2 devices, 
algorithm 5
[534741.822765] md: reshape of RAID array md126
[534747.144197] md: md126: reshape interrupted.
[534747.149098] md: reshape of RAID array md126
[534747.566093] md: md126: reshape interrupted.
[534747.570979] md: reshape of RAID array md126
[534793.916521] md: md126: reshape done.

and w/o:

[534907.642262] md126: detected capacity change from 0 to 20971520
[534907.648697] md: md126 still in use.
[534907.654340] md: md126 stopped.
[534907.679414] md: md127 stopped.
[534911.985080] md126: detected capacity change from 20971520 to 0
[534922.920777] md/raid:md126: device nvme0n1 operational as raid disk 0
[534922.940442] md/raid:md126: raid level 4 active with 1 out of 2 devices, 
algorithm 5
[534922.995454] md: reshape of RAID array md126
[534975.643237] md: md126: reshape done.
[534975.669424] md126: detected capacity change from 41943040 to 20971520

Not sure what is causing errors you see.
btw, I'm working on md-next 5.11.0 kernel from 02/24

On 3/22/2021 6:16 PM, Nigel Croxon wrote:
> 
> 
> ----- Original Message -----
> From: "Oleksandr Shchirskyi" <oleksandr.shchirskyi@linux.intel.com>
> To: "Nigel Croxon" <ncroxon@redhat.com>, linux-raid@vger.kernel.org
> Cc: "Mariusz Tkaczyk" <mariusz.tkaczyk@linux.intel.com>, "Jes Sorensen" <jes@trained-monkey.org>
> Sent: Monday, March 22, 2021 12:21:11 PM
> Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup file
> 
> Hello Nigel,
> 
> I have collected more info regarding this issue.
> I can confirm what Mariusz said, it's a regression caused by patch 4ae96c802203
> The reason for failure during the reshape, is that in this patch sync_max
> value is set to max, but the function wait_for_reshape_imsm, used in some
> reshape scenarios, relies on this parameter, and doesn't expect, that value
> can be max. This leads to reshaping fail.
> Here's an example of a debug log from this method, when the issue is hit:
> 
> mdadm: wait_for_reshape_imsm: wrong next position to set 4096 (2048)
> mdadm: imsm_manage_reshape: wait_for_reshape_imsm returned error!
> 
> With this patch reverted, the issue is not observed. See my logs below:
> 
> # mdadm -CR imsm0 -e imsm -n4 /dev/nvme[0-3]n1 && mdadm -CR volume -l0
> --chunk 64 --size=10G --raid-devices=1 /dev/nvme0n1 --force
> # mdadm -D /dev/md/volume
>   
>                                                                 /dev/md/volume:
>            Container : /dev/md/imsm0, member 0
>           Raid Level : raid0
>           Array Size : 10485760 (10.00 GiB 10.74 GB)
>         Raid Devices : 1
>        Total Devices : 1
>                State : clean
> ...
> # mdadm -G /dev/md/imsm0 -n2
> # mdadm -D /dev/md/volume
> /dev/md/volume:
>            Container : /dev/md/imsm0, member 0
>           Raid Level : raid4
>           Array Size : 10485760 (10.00 GiB 10.74 GB)
>        Used Dev Size : 10485760 (10.00 GiB 10.74 GB)
>         Raid Devices : 3
>        Total Devices : 2
>                State : clean, degraded
> ...
> # git revert 4ae96c802203ec3cfbb089240c56d61f7f4661b3
> Auto-merging Grow.c
> [master 1166854] Revert "mdadm: fix reshape from RAID5 to RAID6 with backup
> file"
>    1 file changed, 2 insertions(+), 5 deletions(-)
> # mdadm -Ss; wipefs -a /dev/nvme[0-3]n1
> # make clean; make; make install-systemd; make install
> # mdadm -CR imsm0 -e imsm -n4 /dev/nvme[0-3]n1 && mdadm -CR volume -l0
> --chunk 64 --size=10G --raid-devices=1 /dev/nvme0n1 --force
> # mdadm -G /dev/md/imsm0 -n2
> # mdadm -D /dev/md/volume
> /dev/md/volume:
>            Container : /dev/md/imsm0, member 0
>           Raid Level : raid0
>           Array Size : 20971520 (20.00 GiB 21.47 GB)
>         Raid Devices : 2
>        Total Devices : 2
> 
>                State : clean
> ...
> #
> 
> On 3/16/2021 4:59 PM, Nigel Croxon wrote:
>> ----- Original Message -----
>> From: "Mariusz Tkaczyk" <mariusz.tkaczyk@linux.intel.com>
>> To: "Jes Sorensen" <jes@trained-monkey.org>, "Nigel Croxon" <ncroxon@redhat=
>> .com>, linux-raid@vger.kernel.org, xni@redhat.com
>> Sent: Tuesday, March 16, 2021 10:54:22 AM
>> Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup fil=
>> e
>>
>> Hello Nigel,
>>
>> Blame told us, that yours patch introduce regression in following
>> scenario:
>>
>> #mdadm -CR imsm0 -e imsm -n4 /dev/nvme[0125]n1
>> #mdadm -CR volume -l0 --chunk 64 --raid-devices=3D1 /dev/nvme0n1 --force
>> #mdadm -G /dev/md/imsm0 -n2
>>
>> At the end of reshape, level doesn't back to RAID0.
>> Could you look into it?
>> Let me know, if you need support.
>>
>> Thanks,
>> Mariusz
>>
>> I=E2=80=99m trying your situation without my patch (its reverted) and I=E2=
>> =80=99m not seeing success.
>> See the dmesg log.
>>
>>
>> [root@fedora33 mdadmupstream]# mdadm -CR volume -l0 --chunk 64 --raid-devic=
>> es=3D1 /dev/nvme0n1 --force
>> mdadm: /dev/nvme0n1 appears to be part of a raid array:
>>         level=3Dcontainer devices=3D0 ctime=3DWed Dec 31 19:00:00 1969
>> mdadm: Creating array inside imsm container md127
>> mdadm: array /dev/md/volume started.
>>
>> [root@fedora33 mdadmupstream]# cat /proc/mdstat=20
>> Personalities : [raid6] [raid5] [raid4] [raid0]=20
>> md126 : active raid0 nvme0n1[0]
>>        500102144 blocks super external:/md127/0 64k chunks
>>
>> md127 : inactive nvme3n1[3](S) nvme2n1[2](S) nvme1n1[1](S) nvme0n1[0](S)
>>        4420 blocks super external:imsm
>>
>> unused devices: <none>
>> [root@fedora33 mdadmupstream]# mdadm -G /dev/md/imsm0 -n2
>> [root@fedora33 mdadmupstream]# cat /proc/mdstat=20
>> Personalities : [raid6] [raid5] [raid4] [raid0]=20
>> md126 : active raid4 nvme3n1[2] nvme0n1[0]
>>        500102144 blocks super external:-md127/0 level 4, 64k chunk, algorithm=
>>    5 [2/1] [U_]
>>
>> md127 : inactive nvme3n1[3](S) nvme2n1[2](S) nvme1n1[1](S) nvme0n1[0](S)
>>        4420 blocks super external:imsm
>>
>> unused devices: <none>
>>
>>
>> dmesg says:
>> [Mar16 11:46] md/raid:md126: device nvme0n1 operational as raid disk 0
>> [  +0.011147] md/raid:md126: raid level 4 active with 1 out of 2 devices, a=
>> lgorithm 5
>> [  +0.044605] md/raid0:md126: raid5 must have missing parity disk!
>> [  +0.000002] md: md126: raid0 would not accept array
>>
>> -Nigel
>>
> 

-- 
Regards,
Oleksandr Shchirskyi


Oleksandr,
Can you post your dmesg output when running the commands?

I've back down from 5.11 to 5.8 and I still see:
[  +0.042694] md/raid0:md126: raid5 must have missing parity disk!
[  +0.000001] md: md126: raid0 would not accept array

Thanks, Nigel

