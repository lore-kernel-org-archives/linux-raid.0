Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED388C433ED
	for <linux-raid@archiver.kernel.org>; Thu,  1 Apr 2021 20:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C02B76100C
	for <linux-raid@archiver.kernel.org>; Thu,  1 Apr 2021 20:49:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233827AbhDAUt7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 1 Apr 2021 16:49:59 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17122 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbhDAUt6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 1 Apr 2021 16:49:58 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1617310190; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=iUHKs+3iSkqzjsQM/vWfTzxJrdhJVjOSUAdSoHH4zc2SZPG6BYP6jGsR5NA3PGWtJFXAUfB7gOK8aqtAaX79ytt8o0UzPOFCm2ItJUfBFVUHXPDkjNfNZz4R0ZD8PCkz/Y6Zd0NdH1Sn5NE4AqTN7lMFOPmvtJhWTyF85du22S0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1617310190; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=7hi5FCyqIsJqxed2jhXWnumCUEOQ4pe7Vl3i03WylMU=; 
        b=XSVdkTKmGlyvgOV/0gl98NkHpTzUPmbfdWvFvdkM2tmMLN3p0H02Ek9PnroN5yEYpo0v8va4L+2vG8QW/AI2ySYti3lxu3A/Mnng8Csb87Li+LQUkixTcoicrcHMuB/nF0SK/s20ZWEghpIfIkug1yKfEbx9WWRy9Pd5OwbMt8c=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1617310188525960.610227668454; Thu, 1 Apr 2021 22:49:48 +0200 (CEST)
Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup file
To:     Nigel Croxon <ncroxon@redhat.com>,
        Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
References: <764426808.38181143.1615910368475.JavaMail.zimbraredhat!com>
 <08b71ea7-bdd3-722d-d18f-aa065b8756c0@linux.intel.com>
 <207580597.39647667.1616433400775.JavaMail.zimbra@redhat.com>
 <5339fdf7-0d8a-e099-1fc4-be42a08c8ad3@linux.intel.com>
 <1361244809.39731072.1616517370775.JavaMail.zimbra@redhat.com>
 <b77b55d3-d9b2-fac9-c756-fabced0546a0@linux.intel.com>
 <1876594627.1682680.1616759962103.JavaMail.zimbra@redhat.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <c98c5ee6-e66f-00a7-7eb2-081324cae31f@trained-monkey.org>
Date:   Thu, 1 Apr 2021 16:49:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1876594627.1682680.1616759962103.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/26/21 7:59 AM, Nigel Croxon wrote:> ----- Original Message ----->
From: "Oleksandr Shchirskyi" <oleksandr.shchirskyi@linux.intel.com>> To:
"Nigel Croxon" <ncroxon@redhat.com>
> Cc: linux-raid@vger.kernel.org, "Mariusz Tkaczyk" <mariusz.tkaczyk@linux.intel.com>, "Jes Sorensen" <jes@trained-monkey.org>
> Sent: Tuesday, March 23, 2021 4:58:27 PM
> Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup file
> 
> On 3/23/2021 5:36 PM, Nigel Croxon wrote:
>> Oleksandr,
>> Can you post your dmesg output when running the commands?
>>
>> I've back down from 5.11 to 5.8 and I still see:
>> [  +0.042694] md/raid0:md126: raid5 must have missing parity disk!
>> [  +0.000001] md: md126: raid0 would not accept array
>>
>> Thanks, Nigel
> 
> Hello Nigel,
> 
> I've switched to 4.18.0-240.el8.x86_64 kernel (I have RHEL8.3) and I still 
> have the same results, issue is still easily reproducible when patch 
> 4ae96c8 is applied.
> 
> Cropped test logs with and w/o your patch:
> 
> # git log -n1 --oneline
> f94df5c (HEAD -> master, origin/master, origin/HEAD) imsm: support for 
> third Sata controller
> # make clean; make; make install-systemd; make install
> # mdadm -CR imsm0 -e imsm -n4 /dev/nvme[0-3]n1 && mdadm -CR volume -l0 
> --chunk 64 --size=10G --raid-devices=1 /dev/nvme0n1 --force
> # mdadm -G /dev/md/imsm0 -n2
> # dmesg -c
> [  393.530389] md126: detected capacity change from 0 to 10737418240
> [  407.139318] md/raid:md126: device nvme0n1 operational as raid disk 0
> [  407.153920] md/raid:md126: raid level 4 active with 1 out of 2 devices, 
> algorithm 5
> [  407.246037] md: reshape of RAID array md126
> [  407.357940] md: md126: reshape interrupted.
> [  407.388144] md: reshape of RAID array md126
> [  407.398737] md: md126: reshape interrupted.
> [  407.403486] md: reshape of RAID array md126
> [  459.414250] md: md126: reshape done.
> # cat /proc/mdstat
> Personalities : [raid0] [raid6] [raid5] [raid4]
> md126 : active raid4 nvme3n1[2] nvme0n1[0]
>        10485760 blocks super external:/md127/0 level 4, 64k chunk, 
> algorithm 0 [3/2] [UU_]
> 
> md127 : inactive nvme3n1[3](S) nvme2n1[2](S) nvme1n1[1](S) nvme0n1[0](S)
>        4420 blocks super external:imsm
> 
> unused devices: <none>
> 
> # mdadm -Ss; wipefs -a /dev/nvme[0-3]n1
> # dmesg -C
> # git revert 4ae96c802203ec3cfbb089240c56d61f7f4661b3
> # make clean; make; make install-systemd; make install
> # mdadm -CR imsm0 -e imsm -n4 /dev/nvme[0-3]n1 && mdadm -CR volume -l0 
> --chunk 64 --size=10G --raid-devices=1 /dev/nvme0n1 --force
> # mdadm -G /dev/md/imsm0 -n2
> # dmesg -c
> [  623.772039] md126: detected capacity change from 0 to 10737418240
> [  644.823245] md/raid:md126: device nvme0n1 operational as raid disk 0
> [  644.838542] md/raid:md126: raid level 4 active with 1 out of 2 devices, 
> algorithm 5
> [  644.928672] md: reshape of RAID array md126
> [  697.405351] md: md126: reshape done.
> [  697.409659] md126: detected capacity change from 10737418240 to 21474836480
> # cat /proc/mdstat
> Personalities : [raid0] [raid6] [raid5] [raid4]
> md126 : active raid0 nvme3n1[2] nvme0n1[0]
>        20971520 blocks super external:/md127/0 64k chunks
> 
> md127 : inactive nvme3n1[3](S) nvme2n1[2](S) nvme1n1[1](S) nvme0n1[0](S)
>        4420 blocks super external:imsm
> 
> 
> Do you need more detailed logs? My system/drives configuration details?
> 
> Regards,
> Oleksandr Shchirskyi
> 
> 
> 
> 
> From f0c80c8e90b2ce113b6e22f919659430d3d20efa Mon Sep 17 00:00:00 2001
> From: Nigel Croxon <ncroxon@redhat.com>
> Date: Fri, 26 Mar 2021 07:56:10 -0400
> Subject: [PATCH] mdadm: fix growing containers
> 
> This fixes growing containers which was broken with
> commit 4ae96c802203ec3c (mdadm: fix reshape from RAID5 to RAID6 with
> backup file)
> 
> The issue being that containers use the function
> wait_for_reshape_isms and expect a number value and not a
> string value of "max".  The change is to test for external
> before setting the correct value.
> 
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>

I was about to revert the problematic patch. Oleksandr, can you confirm
if it resolves the issues you were seeing?

Thanks,
Jes

