Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC3ABC433E9
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 15:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8145E65103
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 15:52:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237516AbhCPPvr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Mar 2021 11:51:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48193 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232483AbhCPPvb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 16 Mar 2021 11:51:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615909890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7HWEB2+nctUjvUrM77eb5yj7c/C7rQZiJvZDbZIBRsg=;
        b=IYf4SifvxP8l6xnqabh8rH2bmI1gVukX/bW99yUXTBFP4qlziIB51bcXMkwuKY/FKRYqmT
        v5ywt3wrjJUmOjrTxSaIv0V9++AuS2ljL31OxP0HvkmKQ6nfUwrV1juVMf4zmAvE0z1x64
        hN2xZtqwTnNcHZkYJy6K8AbLcXK+5d8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-Ewx4FZ7nP82DKFzX_V5OEg-1; Tue, 16 Mar 2021 11:51:28 -0400
X-MC-Unique: Ewx4FZ7nP82DKFzX_V5OEg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EF38CC625;
        Tue, 16 Mar 2021 15:51:27 +0000 (UTC)
Received: from ovpn-3-68.rdu2.redhat.com (ovpn-3-68.rdu2.redhat.com [10.22.3.68])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 053085C1A1;
        Tue, 16 Mar 2021 15:51:26 +0000 (UTC)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup file
From:   Nigel Croxon <ncroxon@redhat.com>
In-Reply-To: <eb0060d3-756d-c6f9-66d7-bcd7b0468bf7@linux.intel.com>
Date:   Tue, 16 Mar 2021 11:51:25 -0400
Cc:     Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org,
        xni@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <3CE6CB00-853C-4CB3-89CD-308D9DAE9CAC@redhat.com>
References: <20210120200542.19139-1-ncroxon@redhat.com>
 <84ed6e32-3b69-f13d-b1b8-33166c92e5ab@trained-monkey.org>
 <eb0060d3-756d-c6f9-66d7-bcd7b0468bf7@linux.intel.com>
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I=E2=80=99m trying your situation without my patch (its reverted) and =
I=E2=80=99m not seeing success.


[root@fedora33 mdadmupstream]# mdadm -CR volume -l0 --chunk 64 =
--raid-devices=3D1 /dev/nvme0n1 --force
mdadm: /dev/nvme0n1 appears to be part of a raid array:
       level=3Dcontainer devices=3D0 ctime=3DWed Dec 31 19:00:00 1969
mdadm: Creating array inside imsm container md127
mdadm: array /dev/md/volume started.

[root@fedora33 mdadmupstream]# cat /proc/mdstat=20
Personalities : [raid6] [raid5] [raid4] [raid0]=20
md126 : active raid0 nvme0n1[0]
      500102144 blocks super external:/md127/0 64k chunks
     =20
md127 : inactive nvme3n1[3](S) nvme2n1[2](S) nvme1n1[1](S) nvme0n1[0](S)
      4420 blocks super external:imsm
      =20
unused devices: <none>
[root@fedora33 mdadmupstream]# mdadm -G /dev/md/imsm0 -n2
[root@fedora33 mdadmupstream]# cat /proc/mdstat=20
Personalities : [raid6] [raid5] [raid4] [raid0]=20
md126 : active raid4 nvme3n1[2] nvme0n1[0]
      500102144 blocks super external:-md127/0 level 4, 64k chunk, =
algorithm 5 [2/1] [U_]
     =20
md127 : inactive nvme3n1[3](S) nvme2n1[2](S) nvme1n1[1](S) nvme0n1[0](S)
      4420 blocks super external:imsm
      =20
unused devices: <none>


dmesg says:
[Mar16 11:46] md/raid:md126: device nvme0n1 operational as raid disk 0
[  +0.011147] md/raid:md126: raid level 4 active with 1 out of 2 =
devices, algorithm 5
[  +0.044605] md/raid0:md126: raid5 must have missing parity disk!
[  +0.000002] md: md126: raid0 would not accept array



> On Mar 16, 2021, at 10:54 AM, Tkaczyk, Mariusz =
<mariusz.tkaczyk@linux.intel.com> wrote:
>=20
> Hello Nigel,
>=20
> Blame told us, that yours patch introduce regression in following
> scenario:
>=20
> #mdadm -CR imsm0 -e imsm -n4 /dev/nvme[0125]n1
> #mdadm -CR volume -l0 --chunk 64 --raid-devices=3D1 /dev/nvme0n1 =
--force
> #mdadm -G /dev/md/imsm0 -n2
>=20
> At the end of reshape, level doesn't back to RAID0.
> Could you look into it?
> Let me know, if you need support.
>=20
> Thanks,
> Mariusz
>=20

