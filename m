Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C2AC433DB
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 16:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BDE0650FB
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 16:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236858AbhCPP7i (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Mar 2021 11:59:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29395 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238312AbhCPP7f (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 16 Mar 2021 11:59:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615910374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GiM7dw1MGx6qMqEeZfcTRdnSvztAL3RBfqR0yqzzwck=;
        b=BTAWIA3fLMV0QpT7dUFu4/U7Sjgr1E9U8+jj7EMrlV6ux47JZQa8EUsox7t7HzDFcct/lE
        Q1a0uU+u+o6qawoXVegrQfmd/xELezgI4NcUWdZLuoZTusR7/esqXIxM0rOERh0rJA1jAW
        YJaLKWIGkiq0c2zC+DTKiqROUQBqoUI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-dRoCquB3OG6zLeNH-SWV6Q-1; Tue, 16 Mar 2021 11:59:30 -0400
X-MC-Unique: dRoCquB3OG6zLeNH-SWV6Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EAB1100CEC1;
        Tue, 16 Mar 2021 15:59:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0328D1017CF5;
        Tue, 16 Mar 2021 15:59:29 +0000 (UTC)
Received: from zmail24.collab.prod.int.phx2.redhat.com (zmail24.collab.prod.int.phx2.redhat.com [10.5.83.30])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id D166C1800657;
        Tue, 16 Mar 2021 15:59:28 +0000 (UTC)
Date:   Tue, 16 Mar 2021 11:59:28 -0400 (EDT)
From:   Nigel Croxon <ncroxon@redhat.com>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org,
        xni@redhat.com
Message-ID: <764426808.38181143.1615910368475.JavaMail.zimbra@redhat.com>
In-Reply-To: <eb0060d3-756d-c6f9-66d7-bcd7b0468bf7@linux.intel.com>
References: <20210120200542.19139-1-ncroxon@redhat.com> <84ed6e32-3b69-f13d-b1b8-33166c92e5ab@trained-monkey.org> <eb0060d3-756d-c6f9-66d7-bcd7b0468bf7@linux.intel.com>
Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup file
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.22.3.68, 10.4.195.24]
Thread-Topic: mdadm: fix reshape from RAID5 to RAID6 with backup file
Thread-Index: 5k6H4z9TEmciRIp4Qy0g8BEKEFg1Gw==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



----- Original Message -----
From: "Mariusz Tkaczyk" <mariusz.tkaczyk@linux.intel.com>
To: "Jes Sorensen" <jes@trained-monkey.org>, "Nigel Croxon" <ncroxon@redhat=
.com>, linux-raid@vger.kernel.org, xni@redhat.com
Sent: Tuesday, March 16, 2021 10:54:22 AM
Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup fil=
e

Hello Nigel,

Blame told us, that yours patch introduce regression in following
scenario:

#mdadm -CR imsm0 -e imsm -n4 /dev/nvme[0125]n1
#mdadm -CR volume -l0 --chunk 64 --raid-devices=3D1 /dev/nvme0n1 --force
#mdadm -G /dev/md/imsm0 -n2

At the end of reshape, level doesn't back to RAID0.
Could you look into it?
Let me know, if you need support.

Thanks,
Mariusz

I=E2=80=99m trying your situation without my patch (its reverted) and I=E2=
=80=99m not seeing success.
See the dmesg log.


[root@fedora33 mdadmupstream]# mdadm -CR volume -l0 --chunk 64 --raid-devic=
es=3D1 /dev/nvme0n1 --force
mdadm: /dev/nvme0n1 appears to be part of a raid array:
      level=3Dcontainer devices=3D0 ctime=3DWed Dec 31 19:00:00 1969
mdadm: Creating array inside imsm container md127
mdadm: array /dev/md/volume started.

[root@fedora33 mdadmupstream]# cat /proc/mdstat=20
Personalities : [raid6] [raid5] [raid4] [raid0]=20
md126 : active raid0 nvme0n1[0]
     500102144 blocks super external:/md127/0 64k chunks

md127 : inactive nvme3n1[3](S) nvme2n1[2](S) nvme1n1[1](S) nvme0n1[0](S)
     4420 blocks super external:imsm

unused devices: <none>
[root@fedora33 mdadmupstream]# mdadm -G /dev/md/imsm0 -n2
[root@fedora33 mdadmupstream]# cat /proc/mdstat=20
Personalities : [raid6] [raid5] [raid4] [raid0]=20
md126 : active raid4 nvme3n1[2] nvme0n1[0]
     500102144 blocks super external:-md127/0 level 4, 64k chunk, algorithm=
 5 [2/1] [U_]

md127 : inactive nvme3n1[3](S) nvme2n1[2](S) nvme1n1[1](S) nvme0n1[0](S)
     4420 blocks super external:imsm

unused devices: <none>


dmesg says:
[Mar16 11:46] md/raid:md126: device nvme0n1 operational as raid disk 0
[  +0.011147] md/raid:md126: raid level 4 active with 1 out of 2 devices, a=
lgorithm 5
[  +0.044605] md/raid0:md126: raid5 must have missing parity disk!
[  +0.000002] md: md126: raid0 would not accept array

-Nigel

