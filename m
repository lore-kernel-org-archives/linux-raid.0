Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF69FC11F67
	for <linux-raid@archiver.kernel.org>; Mon, 12 Jul 2021 07:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6E5061360
	for <linux-raid@archiver.kernel.org>; Mon, 12 Jul 2021 07:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241006AbhGLHNK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Jul 2021 03:13:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49919 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244382AbhGLHKp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 12 Jul 2021 03:10:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626073676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7m3vneTsrH4wCJRV8lHgccHJxxT+KMuhhR7HvbM1t3s=;
        b=dkuO83YUFH4xDMTGhToIGPKU9WuZEFj9/jRd7rjG7Cu4Gg9otSilyfHQ/l4WqzNWFaf0LA
        EphcrVWUZqAy9YshOm/py5sCNS0f1E1wMVNnQnGt63STYIHFXWLEzVVRJusgQ8PMMASsLG
        SU4F9t7mcKR5D//a6OHu8JBGvdDPK4Y=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196--pDwHGOQOz-PKph8taqXNQ-1; Mon, 12 Jul 2021 03:07:52 -0400
X-MC-Unique: -pDwHGOQOz-PKph8taqXNQ-1
Received: by mail-yb1-f198.google.com with SMTP id a7-20020a5b00070000b02904ed415d9d84so20913540ybp.0
        for <linux-raid@vger.kernel.org>; Mon, 12 Jul 2021 00:07:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7m3vneTsrH4wCJRV8lHgccHJxxT+KMuhhR7HvbM1t3s=;
        b=mlP+DGkosdhOJk6KrbUt3eJFLI+lEhaat3edjEAzemEPu0jndI4UtL2yfRd7eNlJIV
         rJANP5owpSV6UKo1YN7Lzul0UTjSaebcn3pg8MR9xUUBOPNIz+7QNV94I+rP1dlxJci0
         Usj/lwzOFqIGUUirJba/OghgpU7/uTERFWGiFr+5c04op1mQprKo6xA2r57L3frOdQ/Y
         +phzbhlkmNmRSV+Mpfol/GDn8BxdHD7ZwKyAbFkAkQcBTHUIReAHu2Jk33F75zIZNXjd
         jmU0RVlIqfsa/+vte1gQIk2adr/PXjJBX7KhNBcSDlfV5+fbWx7fQt7mmytuGmAg38ZH
         1KsA==
X-Gm-Message-State: AOAM530LzRMBKKZz2PEkHtwfhflzSWcuCyFQI9kYxM1tRSv7BuErZI6s
        wNDuia6beASyj0Ewu8NeGWIJyLzFzbOt7jcW/F33FnTVPkmiuhXlZhQGzGuKURvVqQG+XorGcUg
        aGOm8yjsRz8Ep5yYqxiiyO3uXis435NJzZ0hJtg==
X-Received: by 2002:a5b:b48:: with SMTP id b8mr23506176ybr.179.1626073671284;
        Mon, 12 Jul 2021 00:07:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyGFOWTHx47QdiX8OM51Yuz9NBbX6zEXebWfJSD6AywkP7qjWhvRd/lkDu7qMP0BLZvy1JH5vQe1ZQsT/Avmc=
X-Received: by 2002:a5b:b48:: with SMTP id b8mr23506152ybr.179.1626073670933;
 Mon, 12 Jul 2021 00:07:50 -0700 (PDT)
MIME-Version: 1.0
References: <C3C9F935-DD1C-409C-8C9D-56F97B13B676@gmail.com>
In-Reply-To: <C3C9F935-DD1C-409C-8C9D-56F97B13B676@gmail.com>
From:   Fine Fan <ffan@redhat.com>
Date:   Mon, 12 Jul 2021 15:08:21 +0800
Message-ID: <CAOaDVC5+UG9vEo4owJfG8hX0sSWE12Rf_KavOUih=vf4FvLG+w@mail.gmail.com>
Subject: Re: RAID5 now recognized as RAID1
To:     Nicolas Martin <nicolas.martin.3d@gmail.com>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi ,
I actually have a QNAP NAS in my house.

[admin@NASXXXXX /]# cat /etc/issue
Welcome to TS-431(192.168.1.XXX), QNAP Systems, Inc.  <<<<< As you can
see this is an old version device and out of date.


It has 3 1T disks RAID5 on it but only 2disks work now, I bought a new
one, still waiting for the shipment.
The web UI still working on my side, even I reboot it for times.

I think the most important thing for now is to copy your important data out=
.

I think you could find your data path via "df -h"
Here is my output:
[admin@NASXXXXX bin]# df -h
Filesystem                Size      Used Available Use% Mounted on
...
...
...
/dev/mapper/cachedev1     1.8T      1.2T    548.1G  70% /share/CACHEDEV1_DA=
TA
...
...
...

Go to /dev/mapper/cachedev1  directory and then use "scp <your
important files>
root@other_ip_address_in_your_LAN:/path/to/directory"

You could use cat /proc/disks to check if other disks here.
[admin@NASXXXXX /]# cat /proc/diskstats   # I like to use "lsblk" but
it doesn't have it.
...
...
...  # As you could see that it only has sda and sdb there:   sdc is
pluged in the NAS ,but it's not here, it means it doesn't workout now.
  43      14 nbd14 0 0 0 0 0 0 0 0 0 0 0
  43      15 nbd15 0 0 0 0 0 0 0 0 0 0 0
   8       0 sda 2666861 242260046 1982460610 47733070 164771 1228360
10752008 15960880 0 15367000 63725850
   8       1 sda1 47492 10036 3846782 3169370 49715 76658 840503
2781750 0 4585920 5950920
   8       2 sda2 2699 3160 46772 471070 17555 21902 264929 583500 0
756970 1054680
   8       3 sda3 2446860 242235903 1972738628 40493400 77962 792166
6842863 10862250 0 9402270 115057530
   8       4 sda4 169688 10947 5827481 3598940 19288 337634 2803664
1730950 0 1990760 5329690
   8       5 sda5 112 0 867 290 14 0 49 210 0 500 500
   8      16 sdb 2691840 242249364 1980699749 51394800 166919 1228269
10768808 16194030 0 15714940 67632830
   8      17 sdb1 46538 2740 2857410 4336940 49658 76714 840487
2817990 0 4794540 7154720
   8      18 sdb2 2735 3549 50410 353200 17690 21768 264929 598910 0
740140 952170
   8      19 sdb3 2443821 242238229 1972683584 42970960 80052 792134
6859679 11226530 0 9529510 54241740
   8      20 sdb4 198631 4846 5107279 3733440 19268 337653 2803664
1548260 0 1968070 5281580
   8      21 sdb5 105 0 986 190 14 0 49 200 0 390 390
  31       0 mtdblock0 20 0 160 4450 0 0 0 0 0 4450 4450
  31       1 mtdblock1 169 0 1352 19230 0 0 0 0 0 19070 19220

...
...
...

Why  it happended ?
I actually don't know, you know hard disks are consumable.
About one year ago the same NAS (I made a 4 1T-disks RAID5 on it that
time) 's 4th slot doesn't workout suddenly and it cause the 4th disk
broken.
I contacted QNAP , they asked me to send the whole NAS (without disks)
to them to test, I did, the result is the chip which has 4 SATA ports
and connected to disks is broken (actually the 4th SATA port on that
chip is broken ). I have to buy a new one from QNAP cause my device is
out of date.
But when I got my NAS back with new chip on it, plugin a new disk into
the 4th port, it still can't be detected, So I spend about 20 hours to
move my data out , and re-create my 4-disks RAID5  into 3-disks RAID5
on it. and then copy my data into that 3-disks RAID5 QNAP NAS.


How can I recover from this?
1.Copy out your important data first  (use scp as I mentioned.)
2.Check if the disks are still there (cat /proc/diskstats), if the
disks are ther, you may need to reinstall the NAS OS on your device.
if not you got broken disks.
3.Contact QNAP, or , Buy new disks build new RAID copy data back.


On Thu, Jul 8, 2021 at 6:07 PM Nicolas Martin
<nicolas.martin.3d@gmail.com> wrote:
>
> Hi,
>
> For a bit of context :I had a RAID5 with 4 disks running on a QNAP NAS.
> One disk started failing, so I ordered a replacement disk, but in the mea=
n time the NAS became irresponsive and I had to reboot it.
> Now the NAS does not (really) come back alive, and I can only log onto it=
 with ssh.
>
> When I run cat /proc/mdstatus, this is what I get :
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]=
 [multipath]
> md322 : active raid1 sdd5[3](S) sdc5[2](S) sdb5[1] sda5[0]
>       7235136 blocks super 1.0 [2/2] [UU]
>       bitmap: 0/1 pages [0KB], 65536KB chunk
>
> md256 : active raid1 sdd2[3](S) sdc2[2](S) sdb2[1] sda2[0]
>       530112 blocks super 1.0 [2/2] [UU]
>       bitmap: 0/1 pages [0KB], 65536KB chunk
>
> md13 : active raid1 sdc4[24] sda4[1] sdb4[0] sdd4[25]
>       458880 blocks super 1.0 [24/4] [UUUU____________________]
>       bitmap: 1/1 pages [4KB], 65536KB chunk
>
> md9 : active raid1 sdb1[0] sdd1[25] sdc1[24] sda1[26]
>       530048 blocks super 1.0 [24/4] [UUUU____________________]
>       bitmap: 1/1 pages [4KB], 65536KB chunk
>
> unused devices: <none>
>
> So, I don=E2=80=99t know how this could happen ? I looked up on the FAQ, =
but I can=E2=80=99t seem to see what could explain this, nor how I can reco=
ver from this ?
>
> Any help appreciated.
>
> Thanks
>


--=20




Fine Fan

Kernel Storage QE

ffan@redhat.com

T: 8388117
M: (+86)-15901470329

