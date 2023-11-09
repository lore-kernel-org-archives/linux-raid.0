Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E54B8C4167D
	for <linux-raid@archiver.kernel.org>; Thu,  9 Nov 2023 12:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbjKIMDX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Nov 2023 07:03:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjKIMDW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Nov 2023 07:03:22 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8482F1FEE
        for <linux-raid@vger.kernel.org>; Thu,  9 Nov 2023 04:03:20 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-32f7c80ab33so455356f8f.0
        for <linux-raid@vger.kernel.org>; Thu, 09 Nov 2023 04:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadarastorage.com; s=google; t=1699531399; x=1700136199; darn=vger.kernel.org;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:organization:date:subject:in-reply-to
         :references:cc:to:from:reply-to:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ECBMF2XSv6uoxrZdQ2WN/4CQ2iIPN213p0tVnyOdyvk=;
        b=BBctodPpVotkB7RdtL+CiVJhsA6MRScos9oaT54RGrOLx8KvKFa05w/XSHCwK2evW5
         LF/ccprG/pbjXzKZPLyp4nOIg52Tx63OoB84dRjPpDzmYnx++XVXyLxHM9/xscGQGiFP
         BkhNGE501dLpZCTvyWKOQjDWg5JUyqLhuQTf4kl1dvckGBZu0liZFVzinkFnQgYkZXo8
         TS+72j3WlKxCydgula9PZlPVyKm8nLvP4N4P7NHQAX5XIZJzz/alQYlDhjuhW2qUY/zc
         0ZCWs4gve7EkvYzXzItt5zQH4cQV/0YOCqVokzP+VpPWgTvqr0yTW3IbAWY6bJDz+o1C
         MZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699531399; x=1700136199;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:organization:date:subject:in-reply-to
         :references:cc:to:from:reply-to:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ECBMF2XSv6uoxrZdQ2WN/4CQ2iIPN213p0tVnyOdyvk=;
        b=iC81i3xZJakrPgGTenVogt2fKhaVLUhMh2u/xhywhwoJVfWyibxd3f98DlgbgjGvtZ
         OUFTk2snxlvzp2Uz5lxF5mh0c38C7XBdm+aV019QyNtUajvNoR1xOQ9yrUH8WOpH147B
         4UbAr4gcKq/9Qm4BDW3+A4nMy8h6Tmhbxkp9gLhEKseV3rpHQC1LglNkIvxlcSmDJCyM
         hc3zfez6PoY+ivUxsDY+/k49diz63F8VJZywkfsB7HGUIh/z1FUZ6L+/QAdqOUUVBQOA
         lnHX/ELAeq+q3o4b38pJ39lgJQhTFN1yaKEeX9CIKimREMlYC/E/Ch7kVXxOTcQzZp8/
         CcMg==
X-Gm-Message-State: AOJu0YzjaDg1Tv0mdvEFbsVA0l7YRbNbAD3ohctytIZ/cfTiR/L/m2Tb
        cRodOGaoSmkFocUr6bkQjkEQxA==
X-Google-Smtp-Source: AGHT+IHK4uXGpWYHguDMHrjpt6fTe0Ib0redG3KcVDhbP4izgdxqYvJf76ITI74cE35TE6JCIAiPuw==
X-Received: by 2002:a05:6000:402c:b0:32f:79e5:8109 with SMTP id cp44-20020a056000402c00b0032f79e58109mr3968255wrb.2.1699531398757;
        Thu, 09 Nov 2023 04:03:18 -0800 (PST)
Received: from levpc3 ([82.166.81.77])
        by smtp.gmail.com with ESMTPSA id l6-20020a5d4806000000b0032dbf99bf4fsm7324582wrq.89.2023.11.09.04.03.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Nov 2023 04:03:18 -0800 (PST)
Reply-To: <lev.vainblat@zadara.com>
From:   "Lev Vainblat" <lev@zadarastorage.com>
To:     "'Yu Kuai'" <yukuai1@huaweicloud.com>, <linux-raid@vger.kernel.org>
Cc:     "'Lev Vainblat'" <lev@zadara.com>,
        "'Shyam Kaushik'" <shyam.kaushik@zadara.com>,
        "'Alex Lyakas'" <alex@zadara.com>,
        "'Yaron Presente'" <yaron@zadara.com>
References: <CAH4CUCMS-FBH7mgKUGEwMMjMWQx3ZNDfAAKABbx5dA7XbUREMg@mail.gmail.com> <80b2a590-75b5-b7ef-fc69-b2cf259634b2@huaweicloud.com>
In-Reply-To: <80b2a590-75b5-b7ef-fc69-b2cf259634b2@huaweicloud.com>
Subject: RE: RAID1 possible data corruption following a write failure to superblock
Date:   Thu, 9 Nov 2023 14:03:15 +0200
Organization: Zadara
Message-ID: <028001da1304$b9a97b60$2cfc7220$@zadarastorage.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQEd5BdtRdGIFYcBWHXYlm15f3EvBgMYV58psdF8GFA=
Content-Language: en-us
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Kuai,

On the target side we have a proprietary device mapper that fails write =
to=20
sector 3048 on leg 0 and allows write to sector 3048 on leg1 (matching =
to=20
the sector 1000 at md). After the 1st write to sector 3048, it fails all =

subsequent writes (to any address) to the same device.


This is the status of bad_blocks after we write some data to the md =
device:

root@mantic:~# dd if=3D/dev/urandom bs=3D512 count=3D1 seek=3D1000 =
oflag=3Ddirect of=3D/dev/md0
1+0 records in
1+0 records out
512 bytes copied, 1.9608 s, 0.3 kB/s

root@mantic:~# cat /proc/mdstat=20
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] =
[raid4] [raid10]=20
md0 : active raid1 sdb[0] sdc[1](F)
      31744 blocks super 1.2 [2/1] [U_]
     =20
root@mantic:~# ls -l /sys/block/md0/md/rd*
lrwxrwxrwx 1 root root 0 Nov  9 10:58 /sys/block/md0/md/rd0 -> dev-sdb

root@mantic:~# cat /sys/block/md0/md/rd0/bad_blocks=20
3048 1


If we assemble md with option --update=3Dno-bbl, we're able read the =
recently written
data, that will "disappear" after reassemble:

root@mantic:~# mdadm --verbose --verbose --assemble --update=3Dno-bbl =
/dev/md0 /dev/sdb /dev/sdc
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdb is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdc is identified as a member of /dev/md0, slot 1.
mdadm: added /dev/sdc to /dev/md0 as 1
mdadm: added /dev/sdb to /dev/md0 as 0
mdadm: /dev/md0 has been started with 2 drives.

root@mantic:~# dd if=3D/dev/urandom bs=3D512 count=3D1 seek=3D1000 =
oflag=3Ddirect of=3D/dev/md0
1+0 records in
1+0 records out
512 bytes copied, 1.70216 s, 0.3 kB/s

root@mantic:~# cat /proc/mdstat=20
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] =
[raid4] [raid10]=20
md0 : active raid1 sdb[0](F) sdc[1]
      31744 blocks super 1.2 [2/1] [_U]
	 =20
root@mantic:~# cat /sys/block/md0/md/rd1/bad_blocks=20
root@mantic:~#=20

root@mantic:~# dd if=3D/dev/md0 iflag=3Ddirect bs=3D512 count=3D1 =
skip=3D1000 | hexdump -C | head
1+0 records in
1+0 records out
512 bytes copied, 0.00154344 s, 332 kB/s
00000000  91 1c 6a 3e fa 08 fe 1c  c7 ce 42 71 20 21 68 1f  =
|..j>......Bq !h.|
00000010  e1 40 07 12 b7 97 9b f4  29 2c 7a ae 7f 47 de e5  =
|.@......),z..G..|
00000020  8a b8 27 79 4b 5d 3b 46  4a e5 5b 20 d5 39 a7 4e  |..'yK];FJ.[ =
.9.N|
00000030  f5 53 ae bc cf cb ce c6  4e 4a 25 3b 24 33 ca ee  =
|.S......NJ%;$3..|
00000040  57 15 5b 74 24 93 af 9d  1c ec 92 15 4b 24 95 df  =
|W.[t$.......K$..|
00000050  ef ec e3 d6 9a af 2b 16  23 d9 44 fb ff 42 5c 99  =
|......+.#.D..B\.|
00000060  49 10 1e 17 dc a7 14 a8  ac c6 e5 a1 40 c9 31 4b  =
|I...........@.1K|
00000070  f9 52 cc e0 e1 7c f5 ec  a6 d5 b0 61 22 bc ca b2  =
|.R...|.....a"...|
00000080  d5 77 8d f6 60 a9 c2 e8  9b bf 06 24 9a 30 db fc  =
|.w..`......$.0..|
00000090  d0 25 35 1b eb 11 f2 7c  1c 3b 3a b0 ba 9a e0 90  =
|.%5....|.;:.....|

root@mantic:~# mdadm --stop /dev/md0
mdadm: stopped /dev/md0

root@mantic:~# mdadm --verbose --verbose --assemble --update=3Dno-bbl =
/dev/md0 /dev/sdb /dev/sdc
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdb is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdc is identified as a member of /dev/md0, slot 1.
mdadm: added /dev/sdc to /dev/md0 as 1
mdadm: added /dev/sdb to /dev/md0 as 0
mdadm: /dev/md0 has been started with 2 drives.

root@mantic:~# dd if=3D/dev/md0 iflag=3Ddirect bs=3D512 count=3D1 =
skip=3D1000 | hexdump -C | head
1+0 records in
1+0 records out
512 bytes copied, 0.000770035 s, 665 kB/s
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  =
|................|
*
00000200

Thanks,
  -Lev.


-----Original Message-----
From: Yu Kuai [mailto:yukuai1@huaweicloud.com]=20
Sent: Thursday, November 9, 2023 3:09
To: Yaron Presente; linux-raid@vger.kernel.org
Cc: Lev Vainblat; Shyam Kaushik; Alex Lyakas; Yaron Presente; yukuai (C)
Subject: Re: RAID1 possible data corruption following a write failure to =
superblock

Hi,

=E5=9C=A8 2023/11/08 23:33, Yaron Presente =E5=86=99=E9=81=93:
> Hi All,
> While investigating data corruption that occurred on one of our
> systems, we came across a theoretical RAID1 scenario which we thought
> could be problematic (detail follow below).
> In order to create the scenario we used a VM installed with Ubuntu
> Mantic 23.10 (kernel 6.5.0), configured with a RAID1 on top of 2 iSCSi
> drives that were exported from a second VM.
> On the latter VM we ran a proprietary device mapper on top of the
> drives which allowed us to inject errors at the exact timing that we
> wanted. This is the flow:
> 0. 'zero' a specific block using dd (direct) on top of the raid1. read
> it to make sure that the block was indeed zeroed out
> 1. Issue a 'write' on top of the RAID1 device (using 'dd' direct of =
random data)
> 2. Allow 'write' to the 2nd leg to succeed, but fail 'write' to the
> 1st leg. Then fail also 'write' to the Superblock of both legs so that
> the events counters (on both drives) are not updated

What exactly did you do to inject error, and what cat=20
/sys/block/md0/md/rd*/bad_blocks shows?

Thanks,
Kuai

> 3. 'dd' returns with a success (although at this point the RAID cannot
> tell which leg is more updated)
> 4. Stop the raid device and then re-assemble it, and let it re-sync
> 5. Read the same offset, it reads zeros (as it sync'ed from the wrong
> drive - in the case of matching event counters always from the 1st to
> the 2nd ).
>=20
> Indeed, there are 2 concurrent failures (of different drives) in this
> scenario. However, we still think that once returning 'ok' to a user
> write operation, it is an unexpected behavior of the RAID1 to return
> bad data.
> Regards,
> Yaron
>=20
>=20
> Issue reproduction on kernel 6.5.0 (Ubuntu Mantic 23.10):
>=20
> root@mantic:~# uname -a
> Linux mantic 6.5.0-10-generic #10-Ubuntu SMP PREEMPT_DYNAMIC Fri Oct
> 13 13:49:38 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
>=20
> 1. Create md raid1 with 2 legs:
> root@mantic:~# mdadm --create --verbose /dev/md0 --level=3D1
> --raid-devices=3D2 /dev/sdb /dev/sdc
> mdadm: array /dev/md0 started.
>=20
> 2. Write zeros to md0.
> root@mantic:~# dd if=3D/dev/zero bs=3D512 count=3D1 seek=3D1000 =
oflag=3Ddirect of=3D/dev/md0
> 1+0 records in
> 1+0 records out
> 512 bytes copied, 0.00271111 s, 189 kB/s
>=20
> 3. Read from md0 =E2=80=93 read zeros, as expected
> root@mantic:~# dd if=3D/dev/md0 iflag=3Ddirect bs=3D512 count=3D1 =
skip=3D1000
> 2>/dev/null | hexdump =E2=80=93C
> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  =
|................|
> *
> 00000200
>=20
> 4. Enable error injection on the target
>=20
> 5. Write some random data to md0. Only data write to /dev/sdc
> succeeded, data write to /dev/sdb and all superblock updates failed.
> root@mantic:~# dd if=3D/dev/urandom bs=3D512 count=3D1 seek=3D1000
> oflag=3Ddirect of=3D/dev/md0
> 1+0 records in
> 1+0 records out
> 512 bytes copied, 1.94887 s, 0.3 kB/s
> root@mantic:~# echo $?
> 0
>=20
> root@mantic:~# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : active raid1 sdb[0](F) sdc[1]
>        31744 blocks super 1.2 [2/1] [_U]
>=20
> root@mantic:~# tail -F /var/log/kern.log
> Nov  7 16:01:24.559661 mantic kernel: [ 6443.216430] sd 2:0:0:0: [sdb]
> tag#81 FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK =
cmd_age=3D0s
> Nov  7 16:01:24.559688 mantic kernel: [ 6443.216455] sd 2:0:0:0: [sdb]
> tag#81 Sense Key : Medium Error [current]
> Nov  7 16:01:24.559689 mantic kernel: [ 6443.216458] sd 2:0:0:0: [sdb]
> tag#81 Add. Sense: Peripheral device write fault
> Nov  7 16:01:24.559689 mantic kernel: [ 6443.216462] sd 2:0:0:0: [sdb]
> tag#81 CDB: Write(10) 2a 00 00 00 0b e8 00 00 01 00
> Nov  7 16:01:24.559690 mantic kernel: [ 6443.216465] I/O error, dev
> sdb, sector 3048 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 2
> Nov  7 16:01:25.069779 mantic kernel: [ 6443.726477] sd 2:0:0:0: [sdb]
> tag#87 FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK =
cmd_age=3D0s
> Nov  7 16:01:25.069805 mantic kernel: [ 6443.726495] sd 2:0:0:0: [sdb]
> tag#87 Sense Key : Medium Error [current]
> Nov  7 16:01:25.069806 mantic kernel: [ 6443.726498] sd 2:0:0:0: [sdb]
> tag#87 Add. Sense: Peripheral device write fault
> Nov  7 16:01:25.069807 mantic kernel: [ 6443.726502] sd 2:0:0:0: [sdb]
> tag#87 CDB: Write(10) 2a 00 00 00 0b e8 00 00 01 00
> Nov  7 16:01:25.069808 mantic kernel: [ 6443.726504] I/O error, dev
> sdb, sector 3048 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 2
> Nov  7 16:01:25.153362 mantic kernel: [ 6443.808395] sd 2:0:0:1: [sdc]
> tag#83 FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK =
cmd_age=3D0s
> Nov  7 16:01:25.153367 mantic kernel: [ 6443.808401] sd 2:0:0:1: [sdc]
> tag#83 Sense Key : Medium Error [current]
> Nov  7 16:01:25.153368 mantic kernel: [ 6443.808404] sd 2:0:0:1: [sdc]
> tag#83 Add. Sense: Peripheral device write fault
> Nov  7 16:01:25.153368 mantic kernel: [ 6443.808406] sd 2:0:0:1: [sdc]
> tag#83 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
> Nov  7 16:01:25.153369 mantic kernel: [ 6443.808411] I/O error, dev
> sdc, sector 8 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
> Nov  7 16:01:25.153370 mantic kernel: [ 6443.808459] md: super_written
> gets error=3D-5
> Nov  7 16:01:25.153377 mantic kernel: [ 6443.808480] md/raid1:md0:
> Disk failure on sdc, disabling device.
> Nov  7 16:01:25.153378 mantic kernel: [ 6443.808480] md/raid1:md0:
> Operation continuing on 1 devices.
> Nov  7 16:01:25.157324 mantic kernel: [ 6443.812155] sd 2:0:0:0: [sdb]
> tag#84 FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK =
cmd_age=3D0s
> Nov  7 16:01:25.157334 mantic kernel: [ 6443.812160] sd 2:0:0:0: [sdb]
> tag#84 Sense Key : Medium Error [current]
> Nov  7 16:01:25.157335 mantic kernel: [ 6443.812162] sd 2:0:0:0: [sdb]
> tag#84 Add. Sense: Peripheral device write fault
> Nov  7 16:01:25.157336 mantic kernel: [ 6443.812164] sd 2:0:0:0: [sdb]
> tag#84 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
> Nov  7 16:01:25.157336 mantic kernel: [ 6443.812169] I/O error, dev
> sdb, sector 8 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
> Nov  7 16:01:25.157337 mantic kernel: [ 6443.812193] md: super_written
> gets error=3D-5
> Nov  7 16:01:25.235620 mantic kernel: [ 6443.892311] sd 2:0:0:0: [sdb]
> tag#90 FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK =
cmd_age=3D0s
> Nov  7 16:01:25.235634 mantic kernel: [ 6443.892330] sd 2:0:0:0: [sdb]
> tag#90 Sense Key : Medium Error [current]
> Nov  7 16:01:25.235635 mantic kernel: [ 6443.892333] sd 2:0:0:0: [sdb]
> tag#90 Add. Sense: Peripheral device write fault
> Nov  7 16:01:25.235635 mantic kernel: [ 6443.892336] sd 2:0:0:0: [sdb]
> tag#90 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
> Nov  7 16:01:25.235636 mantic kernel: [ 6443.892341] I/O error, dev
> sdb, sector 24 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
> Nov  7 16:01:25.235637 mantic kernel: [ 6443.892366] md: super_written
> gets error=3D-5
> Nov  7 16:01:25.319616 mantic kernel: [ 6443.976317] sd 2:0:0:0: [sdb]
> tag#80 FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK =
cmd_age=3D0s
> Nov  7 16:01:25.319635 mantic kernel: [ 6443.976336] sd 2:0:0:0: [sdb]
> tag#80 Sense Key : Medium Error [current]
> Nov  7 16:01:25.319637 mantic kernel: [ 6443.976341] sd 2:0:0:0: [sdb]
> tag#80 Add. Sense: Peripheral device write fault
> Nov  7 16:01:25.319638 mantic kernel: [ 6443.976346] sd 2:0:0:0: [sdb]
> tag#80 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
> Nov  7 16:01:25.319639 mantic kernel: [ 6443.976353] I/O error, dev
> sdb, sector 8 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
> Nov  7 16:01:25.319640 mantic kernel: [ 6443.976404] md: super_written
> gets error=3D-5
> Nov  7 16:01:25.414605 mantic kernel: [ 6444.068218] sd 2:0:0:0: [sdb]
> tag#86 FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK =
cmd_age=3D0s
> Nov  7 16:01:25.414621 mantic kernel: [ 6444.068235] sd 2:0:0:0: [sdb]
> tag#86 Sense Key : Medium Error [current]
> Nov  7 16:01:25.414623 mantic kernel: [ 6444.068240] sd 2:0:0:0: [sdb]
> tag#86 Add. Sense: Peripheral device write fault
> Nov  7 16:01:25.414624 mantic kernel: [ 6444.068245] sd 2:0:0:0: [sdb]
> tag#86 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
> Nov  7 16:01:25.414625 mantic kernel: [ 6444.068252] I/O error, dev
> sdb, sector 8 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
> Nov  7 16:01:25.414626 mantic kernel: [ 6444.068320] md: super_written
> gets error=3D-5
> Nov  7 16:01:25.915709 mantic kernel: [ 6444.572401] sd 2:0:0:0: [sdb]
> tag#84 FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK =
cmd_age=3D0s
> Nov  7 16:01:25.915732 mantic kernel: [ 6444.572423] sd 2:0:0:0: [sdb]
> tag#84 Sense Key : Medium Error [current]
> Nov  7 16:01:25.915733 mantic kernel: [ 6444.572427] sd 2:0:0:0: [sdb]
> tag#84 Add. Sense: Peripheral device write fault
> Nov  7 16:01:25.915733 mantic kernel: [ 6444.572430] sd 2:0:0:0: [sdb]
> tag#84 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
> Nov  7 16:01:25.915734 mantic kernel: [ 6444.572448] I/O error, dev
> sdb, sector 8 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
> Nov  7 16:01:25.915735 mantic kernel: [ 6444.572495] md: super_written
> gets error=3D-5
>=20
> 6. Disable error injection on the target
>=20
> 7. Reassemble md raid1
> root@mantic:~# mdadm --stop /dev/md0
> mdadm: stopped /dev/md0
>=20
> root@mantic:~# mdadm --verbose --assemble /dev/md0 /dev/sdb /dev/sdc
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdb is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 1.
> mdadm: added /dev/sdc to /dev/md0 as 1
> mdadm: added /dev/sdb to /dev/md0 as 0
> mdadm: /dev/md0 has been started with 2 drives.
>=20
> root@mantic:~# tail -F /var/log/kern.log
> Nov  7 16:06:27.073412 mantic kernel: [ 6745.728446] md: md0 stopped.
> Nov  7 16:06:27.085369 mantic kernel: [ 6745.740822] md/raid1:md0: not
> clean -- starting background reconstruction
> Nov  7 16:06:27.085382 mantic kernel: [ 6745.740827] md/raid1:md0:
> active with 2 out of 2 mirrors
> Nov  7 16:06:27.085384 mantic kernel: [ 6745.740842] md0: detected
> capacity change from 0 to 63488
> Nov  7 16:06:27.089518 mantic kernel: [ 6745.742959] md: resync of
> RAID array md0
> Nov  7 16:06:27.365351 mantic kernel: [ 6746.019437] md: md0: resync =
done.
>=20
> 8. Read from md0 =E2=80=93 read zeros, although previously write =
random data succeeded
> root@mantic:~# dd if=3D/dev/md0 iflag=3Ddirect bs=3D512 count=3D1 =
skip=3D1000
> 2>/dev/null | hexdump =E2=80=93C
> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  =
|................|
> *
> 00000200
>=20
> .
>=20

