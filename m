Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50487C433C1
	for <linux-raid@archiver.kernel.org>; Mon, 22 Mar 2021 17:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C3C1619A9
	for <linux-raid@archiver.kernel.org>; Mon, 22 Mar 2021 17:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbhCVRll (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 22 Mar 2021 13:41:41 -0400
Received: from mga12.intel.com ([192.55.52.136]:34843 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231750AbhCVRlV (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 22 Mar 2021 13:41:21 -0400
IronPort-SDR: d3g87H1YpKzklVSiYbxncoqrkkyN72unXbfB6K2QAwP2tv66VUEby5ANV9vTUlM/mjT25cnOx1
 uJoxIn7BE8vg==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="169650093"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="169650093"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 10:41:21 -0700
IronPort-SDR: QIIn2AvwhKPlrtvD4zVultHOWuLRqK+wkJKNCdAcurPSAW/J+49ugm1HJvJQ6cPY2beFpoTe3L
 8xOdnV/A498w==
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="451816337"
Received: from oshchirs-mobl.ger.corp.intel.com (HELO [10.213.7.90]) ([10.213.7.90])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 10:41:19 -0700
Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup file
To:     Nigel Croxon <ncroxon@redhat.com>
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Jes Sorensen <jes@trained-monkey.org>
References: <764426808.38181143.1615910368475.JavaMail.zimbraredhat!com>
 <08b71ea7-bdd3-722d-d18f-aa065b8756c0@linux.intel.com>
 <207580597.39647667.1616433400775.JavaMail.zimbra@redhat.com>
From:   Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
Message-ID: <5339fdf7-0d8a-e099-1fc4-be42a08c8ad3@linux.intel.com>
Date:   Mon, 22 Mar 2021 18:41:17 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <207580597.39647667.1616433400775.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

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
