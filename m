Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CFAC433F4
	for <linux-raid@archiver.kernel.org>; Mon, 22 Mar 2021 16:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 001136199F
	for <linux-raid@archiver.kernel.org>; Mon, 22 Mar 2021 16:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbhCVQr0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 22 Mar 2021 12:47:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59676 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231544AbhCVQrQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 22 Mar 2021 12:47:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616431631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H4pE+089f/yt0IDYj/7OgaE43rMdHLdfxYhWmt21n0o=;
        b=Zz77j2e6kfzLnjTWt2Qz5O4dXSxwy7juJT040GKk0hLhIlDdS47whvuUIyLi3LBTYMytLk
        VtSkrhLufRWZXQGCQFTeig6+CwjVZ7xzvjRNiNDKKsy81Garqw53IVCA4teNnQmYmgTNND
        ir0qGzPZPs01dHGcdGDyS6XzcNk2BuI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-QYLebrTRM1SVaC_wPOKq0Q-1; Mon, 22 Mar 2021 12:47:09 -0400
X-MC-Unique: QYLebrTRM1SVaC_wPOKq0Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09E5780006E;
        Mon, 22 Mar 2021 16:47:08 +0000 (UTC)
Received: from ovpn-114-97.rdu2.redhat.com (ovpn-114-97.rdu2.redhat.com [10.10.114.97])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 479E79CA0;
        Mon, 22 Mar 2021 16:47:06 +0000 (UTC)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup file
From:   Nigel Croxon <ncroxon@redhat.com>
In-Reply-To: <08b71ea7-bdd3-722d-d18f-aa065b8756c0@linux.intel.com>
Date:   Mon, 22 Mar 2021 12:47:05 -0400
Cc:     linux-raid@vger.kernel.org,
        "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>,
        Jes Sorensen <jes@trained-monkey.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <2D9512A3-9D7B-4044-B4E2-5733A05CA9FE@redhat.com>
References: <764426808.38181143.1615910368475.JavaMail.zimbra () redhat ! com>
 <08b71ea7-bdd3-722d-d18f-aa065b8756c0@linux.intel.com>
To:     Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Jes,

Can we have a revert until the issue has been resolved for all?

Thanks Oleskandr for the diagnose.

-Nigel

> On Mar 22, 2021, at 12:21 PM, Oleksandr Shchirskyi =
<oleksandr.shchirskyi@linux.intel.com> wrote:
>=20
> Hello Nigel,
>=20
> I have collected more info regarding this issue.
> I can confirm what Mariusz said, it's a regression caused by patch =
4ae96c802203
> The reason for failure during the reshape, is that in this patch =
sync_max value is set to max, but the function wait_for_reshape_imsm, =
used in some reshape scenarios, relies on this parameter, and doesn't =
expect, that value can be max. This leads to reshaping fail.
> Here's an example of a debug log from this method, when the issue is =
hit:
>=20
> mdadm: wait_for_reshape_imsm: wrong next position to set 4096 (2048)
> mdadm: imsm_manage_reshape: wait_for_reshape_imsm returned error!
>=20
> With this patch reverted, the issue is not observed. See my logs =
below:
>=20
> # mdadm -CR imsm0 -e imsm -n4 /dev/nvme[0-3]n1 && mdadm -CR volume -l0 =
--chunk 64 --size=3D10G --raid-devices=3D1 /dev/nvme0n1 --force
> # mdadm -D /dev/md/volume                                              =
                 /dev/md/volume:
>         Container : /dev/md/imsm0, member 0
>        Raid Level : raid0
>        Array Size : 10485760 (10.00 GiB 10.74 GB)
>      Raid Devices : 1
>     Total Devices : 1
>             State : clean
> ...
> # mdadm -G /dev/md/imsm0 -n2
> # mdadm -D /dev/md/volume
> /dev/md/volume:
>         Container : /dev/md/imsm0, member 0
>        Raid Level : raid4
>        Array Size : 10485760 (10.00 GiB 10.74 GB)
>     Used Dev Size : 10485760 (10.00 GiB 10.74 GB)
>      Raid Devices : 3
>     Total Devices : 2
>             State : clean, degraded
> ...
> # git revert 4ae96c802203ec3cfbb089240c56d61f7f4661b3
> Auto-merging Grow.c
> [master 1166854] Revert "mdadm: fix reshape from RAID5 to RAID6 with =
backup file"
> 1 file changed, 2 insertions(+), 5 deletions(-)
> # mdadm -Ss; wipefs -a /dev/nvme[0-3]n1
> # make clean; make; make install-systemd; make install
> # mdadm -CR imsm0 -e imsm -n4 /dev/nvme[0-3]n1 && mdadm -CR volume -l0 =
--chunk 64 --size=3D10G --raid-devices=3D1 /dev/nvme0n1 --force
> # mdadm -G /dev/md/imsm0 -n2
> # mdadm -D /dev/md/volume
> /dev/md/volume:
>         Container : /dev/md/imsm0, member 0
>        Raid Level : raid0
>        Array Size : 20971520 (20.00 GiB 21.47 GB)
>      Raid Devices : 2
>     Total Devices : 2
>=20
>             State : clean
> ...
> #
>=20
> On 3/16/2021 4:59 PM, Nigel Croxon wrote:
>> ----- Original Message -----
>> From: "Mariusz Tkaczyk" <mariusz.tkaczyk@linux.intel.com>
>> To: "Jes Sorensen" <jes@trained-monkey.org>, "Nigel Croxon" =
<ncroxon@redhat=3D
>> .com>, linux-raid@vger.kernel.org, xni@redhat.com
>> Sent: Tuesday, March 16, 2021 10:54:22 AM
>> Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with =
backup fil=3D
>> e
>> Hello Nigel,
>> Blame told us, that yours patch introduce regression in following
>> scenario:
>> #mdadm -CR imsm0 -e imsm -n4 /dev/nvme[0125]n1
>> #mdadm -CR volume -l0 --chunk 64 --raid-devices=3D3D1 /dev/nvme0n1 =
--force
>> #mdadm -G /dev/md/imsm0 -n2
>> At the end of reshape, level doesn't back to RAID0.
>> Could you look into it?
>> Let me know, if you need support.
>> Thanks,
>> Mariusz
>> I=3DE2=3D80=3D99m trying your situation without my patch (its =
reverted) and I=3DE2=3D
>> =3D80=3D99m not seeing success.
>> See the dmesg log.
>> [root@fedora33 mdadmupstream]# mdadm -CR volume -l0 --chunk 64 =
--raid-devic=3D
>> es=3D3D1 /dev/nvme0n1 --force
>> mdadm: /dev/nvme0n1 appears to be part of a raid array:
>>       level=3D3Dcontainer devices=3D3D0 ctime=3D3DWed Dec 31 19:00:00 =
1969
>> mdadm: Creating array inside imsm container md127
>> mdadm: array /dev/md/volume started.
>> [root@fedora33 mdadmupstream]# cat /proc/mdstat=3D20
>> Personalities : [raid6] [raid5] [raid4] [raid0]=3D20
>> md126 : active raid0 nvme0n1[0]
>>      500102144 blocks super external:/md127/0 64k chunks
>> md127 : inactive nvme3n1[3](S) nvme2n1[2](S) nvme1n1[1](S) =
nvme0n1[0](S)
>>      4420 blocks super external:imsm
>> unused devices: <none>
>> [root@fedora33 mdadmupstream]# mdadm -G /dev/md/imsm0 -n2
>> [root@fedora33 mdadmupstream]# cat /proc/mdstat=3D20
>> Personalities : [raid6] [raid5] [raid4] [raid0]=3D20
>> md126 : active raid4 nvme3n1[2] nvme0n1[0]
>>      500102144 blocks super external:-md127/0 level 4, 64k chunk, =
algorithm=3D
>>  5 [2/1] [U_]
>> md127 : inactive nvme3n1[3](S) nvme2n1[2](S) nvme1n1[1](S) =
nvme0n1[0](S)
>>      4420 blocks super external:imsm
>> unused devices: <none>
>> dmesg says:
>> [Mar16 11:46] md/raid:md126: device nvme0n1 operational as raid disk =
0
>> [  +0.011147] md/raid:md126: raid level 4 active with 1 out of 2 =
devices, a=3D
>> lgorithm 5
>> [  +0.044605] md/raid0:md126: raid5 must have missing parity disk!
>> [  +0.000002] md: md126: raid0 would not accept array
>> -Nigel
>=20
> --=20
> Regards,
> Oleksandr Shchirskyi
>=20

