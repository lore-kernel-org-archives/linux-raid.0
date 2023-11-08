Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFF3C4167D
	for <linux-raid@archiver.kernel.org>; Wed,  8 Nov 2023 15:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbjKHPdu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Nov 2023 10:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjKHPdt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Nov 2023 10:33:49 -0500
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D511BF7
        for <linux-raid@vger.kernel.org>; Wed,  8 Nov 2023 07:33:47 -0800 (PST)
Received: by mail-ua1-x935.google.com with SMTP id a1e0cc1a2514c-7b9ff2b6f9bso3139642241.3
        for <linux-raid@vger.kernel.org>; Wed, 08 Nov 2023 07:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara.com; s=google; t=1699457626; x=1700062426; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hJYuYwx8ogXPEqH3WNqEK0VxiKsmOfqUyYR7dSZ1eNk=;
        b=K/f8prLzT1x0B6PzCqvKiSABTWIokyVLQVPTDi8ZFPVuI2USkWbY+XVsOaHRzrUHnS
         8iCHi2hAmFb/KarPENwdgj9wSN2Z5m4p3Xb0wmWJi58yixTCqFJIo7LNcRZD/YRScu15
         CpptWqm66AZFa7NRWA6OZAh4S1YHf7sfMEOneC2AX6WUJfphmjthe2DqNS2774ulpDFQ
         vv3sOkk9/fb9f/aLGIE7/ukBmKww+u5Nfc/TQEVxDlsGd4ZDuK5PzmPHp/Zzhg9PSMrC
         IVm0QW8djRjz+v7ke+Yf9Dwl6zKBJmZcsXUVic1fuQPIkDCgHy/mCQscQoZ12Xb9//tg
         Kqiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699457626; x=1700062426;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hJYuYwx8ogXPEqH3WNqEK0VxiKsmOfqUyYR7dSZ1eNk=;
        b=G8EH242GD1kk9UhfdN6bxk4rte1Y5szH0aZdqfqcW6roEGHOdESYNx26wcvs8bZ3rB
         oiGo3TAI/VKBEbEjdNDzjP1rQ9cQTOxxZ0PzDibpYqD7ItjlHAzSnZ6hWomtNDYho3Kg
         4YstcvVFvbK1S3q2wawN2pSUFPaCsUtD+IvOTMAmTJmPB6Gl9YUxiVzgkUPmYYlL9UTY
         9RVBZC0n1MQ+Cyd1MVDO2fnsj5/iyP7gEw3P8uwBrHtBFwu90pCHRnGp+as/CW8qbvHL
         iCqIai/Y4hdhAHePxrhBT05fIF3OoM5HF6M1db56Op1+bh+RqXyc+jnvdzCJX4JLiQYp
         3NOQ==
X-Gm-Message-State: AOJu0Ywn3ZBX/cE3G/pvIVnjyLZthnGQDcMn8pvKGjA8AyliLao6tr3v
        lf6EcgMDX/mPx1lVVFeoWWnKVlOR7+lwQQXUEAX8wgwcZKuFBdP9YwU=
X-Google-Smtp-Source: AGHT+IEfYzT3GWlqvllEJNQoMgf1FftMoMPMHviFZOC7laZmafbP76N5ks/0s6d7UOfqwvOFNFyd5J47Hr4tK1Zy/OU=
X-Received: by 2002:a05:6102:4714:b0:45d:988b:e38c with SMTP id
 ei20-20020a056102471400b0045d988be38cmr2167771vsb.10.1699457626221; Wed, 08
 Nov 2023 07:33:46 -0800 (PST)
MIME-Version: 1.0
From:   Yaron Presente <yaron.presente@zadara.com>
Date:   Wed, 8 Nov 2023 17:33:35 +0200
Message-ID: <CAH4CUCMS-FBH7mgKUGEwMMjMWQx3ZNDfAAKABbx5dA7XbUREMg@mail.gmail.com>
Subject: RAID1 possible data corruption following a write failure to superblock
To:     linux-raid@vger.kernel.org
Cc:     Lev Vainblat <lev@zadara.com>,
        Shyam Kaushik <shyam.kaushik@zadara.com>,
        Alex Lyakas <alex@zadara.com>,
        Yaron Presente <yaron@zadara.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi All,
While investigating data corruption that occurred on one of our
systems, we came across a theoretical RAID1 scenario which we thought
could be problematic (detail follow below).
In order to create the scenario we used a VM installed with Ubuntu
Mantic 23.10 (kernel 6.5.0), configured with a RAID1 on top of 2 iSCSi
drives that were exported from a second VM.
On the latter VM we ran a proprietary device mapper on top of the
drives which allowed us to inject errors at the exact timing that we
wanted. This is the flow:
0. 'zero' a specific block using dd (direct) on top of the raid1. read
it to make sure that the block was indeed zeroed out
1. Issue a 'write' on top of the RAID1 device (using 'dd' direct of random =
data)
2. Allow 'write' to the 2nd leg to succeed, but fail 'write' to the
1st leg. Then fail also 'write' to the Superblock of both legs so that
the events counters (on both drives) are not updated
3. 'dd' returns with a success (although at this point the RAID cannot
tell which leg is more updated)
4. Stop the raid device and then re-assemble it, and let it re-sync
5. Read the same offset, it reads zeros (as it sync'ed from the wrong
drive - in the case of matching event counters always from the 1st to
the 2nd ).

Indeed, there are 2 concurrent failures (of different drives) in this
scenario. However, we still think that once returning 'ok' to a user
write operation, it is an unexpected behavior of the RAID1 to return
bad data.
Regards,
Yaron


Issue reproduction on kernel 6.5.0 (Ubuntu Mantic 23.10):

root@mantic:~# uname -a
Linux mantic 6.5.0-10-generic #10-Ubuntu SMP PREEMPT_DYNAMIC Fri Oct
13 13:49:38 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux

1. Create md raid1 with 2 legs:
root@mantic:~# mdadm --create --verbose /dev/md0 --level=3D1
--raid-devices=3D2 /dev/sdb /dev/sdc
mdadm: array /dev/md0 started.

2. Write zeros to md0.
root@mantic:~# dd if=3D/dev/zero bs=3D512 count=3D1 seek=3D1000 oflag=3Ddir=
ect of=3D/dev/md0
1+0 records in
1+0 records out
512 bytes copied, 0.00271111 s, 189 kB/s

3. Read from md0 =E2=80=93 read zeros, as expected
root@mantic:~# dd if=3D/dev/md0 iflag=3Ddirect bs=3D512 count=3D1 skip=3D10=
00
2>/dev/null | hexdump =E2=80=93C
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..............=
..|
*
00000200

4. Enable error injection on the target

5. Write some random data to md0. Only data write to /dev/sdc
succeeded, data write to /dev/sdb and all superblock updates failed.
root@mantic:~# dd if=3D/dev/urandom bs=3D512 count=3D1 seek=3D1000
oflag=3Ddirect of=3D/dev/md0
1+0 records in
1+0 records out
512 bytes copied, 1.94887 s, 0.3 kB/s
root@mantic:~# echo $?
0

root@mantic:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid1 sdb[0](F) sdc[1]
      31744 blocks super 1.2 [2/1] [_U]

root@mantic:~# tail -F /var/log/kern.log
Nov  7 16:01:24.559661 mantic kernel: [ 6443.216430] sd 2:0:0:0: [sdb]
tag#81 FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK cmd_age=3D0s
Nov  7 16:01:24.559688 mantic kernel: [ 6443.216455] sd 2:0:0:0: [sdb]
tag#81 Sense Key : Medium Error [current]
Nov  7 16:01:24.559689 mantic kernel: [ 6443.216458] sd 2:0:0:0: [sdb]
tag#81 Add. Sense: Peripheral device write fault
Nov  7 16:01:24.559689 mantic kernel: [ 6443.216462] sd 2:0:0:0: [sdb]
tag#81 CDB: Write(10) 2a 00 00 00 0b e8 00 00 01 00
Nov  7 16:01:24.559690 mantic kernel: [ 6443.216465] I/O error, dev
sdb, sector 3048 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 2
Nov  7 16:01:25.069779 mantic kernel: [ 6443.726477] sd 2:0:0:0: [sdb]
tag#87 FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK cmd_age=3D0s
Nov  7 16:01:25.069805 mantic kernel: [ 6443.726495] sd 2:0:0:0: [sdb]
tag#87 Sense Key : Medium Error [current]
Nov  7 16:01:25.069806 mantic kernel: [ 6443.726498] sd 2:0:0:0: [sdb]
tag#87 Add. Sense: Peripheral device write fault
Nov  7 16:01:25.069807 mantic kernel: [ 6443.726502] sd 2:0:0:0: [sdb]
tag#87 CDB: Write(10) 2a 00 00 00 0b e8 00 00 01 00
Nov  7 16:01:25.069808 mantic kernel: [ 6443.726504] I/O error, dev
sdb, sector 3048 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 2
Nov  7 16:01:25.153362 mantic kernel: [ 6443.808395] sd 2:0:0:1: [sdc]
tag#83 FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK cmd_age=3D0s
Nov  7 16:01:25.153367 mantic kernel: [ 6443.808401] sd 2:0:0:1: [sdc]
tag#83 Sense Key : Medium Error [current]
Nov  7 16:01:25.153368 mantic kernel: [ 6443.808404] sd 2:0:0:1: [sdc]
tag#83 Add. Sense: Peripheral device write fault
Nov  7 16:01:25.153368 mantic kernel: [ 6443.808406] sd 2:0:0:1: [sdc]
tag#83 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
Nov  7 16:01:25.153369 mantic kernel: [ 6443.808411] I/O error, dev
sdc, sector 8 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
Nov  7 16:01:25.153370 mantic kernel: [ 6443.808459] md: super_written
gets error=3D-5
Nov  7 16:01:25.153377 mantic kernel: [ 6443.808480] md/raid1:md0:
Disk failure on sdc, disabling device.
Nov  7 16:01:25.153378 mantic kernel: [ 6443.808480] md/raid1:md0:
Operation continuing on 1 devices.
Nov  7 16:01:25.157324 mantic kernel: [ 6443.812155] sd 2:0:0:0: [sdb]
tag#84 FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK cmd_age=3D0s
Nov  7 16:01:25.157334 mantic kernel: [ 6443.812160] sd 2:0:0:0: [sdb]
tag#84 Sense Key : Medium Error [current]
Nov  7 16:01:25.157335 mantic kernel: [ 6443.812162] sd 2:0:0:0: [sdb]
tag#84 Add. Sense: Peripheral device write fault
Nov  7 16:01:25.157336 mantic kernel: [ 6443.812164] sd 2:0:0:0: [sdb]
tag#84 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
Nov  7 16:01:25.157336 mantic kernel: [ 6443.812169] I/O error, dev
sdb, sector 8 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
Nov  7 16:01:25.157337 mantic kernel: [ 6443.812193] md: super_written
gets error=3D-5
Nov  7 16:01:25.235620 mantic kernel: [ 6443.892311] sd 2:0:0:0: [sdb]
tag#90 FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK cmd_age=3D0s
Nov  7 16:01:25.235634 mantic kernel: [ 6443.892330] sd 2:0:0:0: [sdb]
tag#90 Sense Key : Medium Error [current]
Nov  7 16:01:25.235635 mantic kernel: [ 6443.892333] sd 2:0:0:0: [sdb]
tag#90 Add. Sense: Peripheral device write fault
Nov  7 16:01:25.235635 mantic kernel: [ 6443.892336] sd 2:0:0:0: [sdb]
tag#90 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
Nov  7 16:01:25.235636 mantic kernel: [ 6443.892341] I/O error, dev
sdb, sector 24 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
Nov  7 16:01:25.235637 mantic kernel: [ 6443.892366] md: super_written
gets error=3D-5
Nov  7 16:01:25.319616 mantic kernel: [ 6443.976317] sd 2:0:0:0: [sdb]
tag#80 FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK cmd_age=3D0s
Nov  7 16:01:25.319635 mantic kernel: [ 6443.976336] sd 2:0:0:0: [sdb]
tag#80 Sense Key : Medium Error [current]
Nov  7 16:01:25.319637 mantic kernel: [ 6443.976341] sd 2:0:0:0: [sdb]
tag#80 Add. Sense: Peripheral device write fault
Nov  7 16:01:25.319638 mantic kernel: [ 6443.976346] sd 2:0:0:0: [sdb]
tag#80 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
Nov  7 16:01:25.319639 mantic kernel: [ 6443.976353] I/O error, dev
sdb, sector 8 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
Nov  7 16:01:25.319640 mantic kernel: [ 6443.976404] md: super_written
gets error=3D-5
Nov  7 16:01:25.414605 mantic kernel: [ 6444.068218] sd 2:0:0:0: [sdb]
tag#86 FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK cmd_age=3D0s
Nov  7 16:01:25.414621 mantic kernel: [ 6444.068235] sd 2:0:0:0: [sdb]
tag#86 Sense Key : Medium Error [current]
Nov  7 16:01:25.414623 mantic kernel: [ 6444.068240] sd 2:0:0:0: [sdb]
tag#86 Add. Sense: Peripheral device write fault
Nov  7 16:01:25.414624 mantic kernel: [ 6444.068245] sd 2:0:0:0: [sdb]
tag#86 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
Nov  7 16:01:25.414625 mantic kernel: [ 6444.068252] I/O error, dev
sdb, sector 8 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
Nov  7 16:01:25.414626 mantic kernel: [ 6444.068320] md: super_written
gets error=3D-5
Nov  7 16:01:25.915709 mantic kernel: [ 6444.572401] sd 2:0:0:0: [sdb]
tag#84 FAILED Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK cmd_age=3D0s
Nov  7 16:01:25.915732 mantic kernel: [ 6444.572423] sd 2:0:0:0: [sdb]
tag#84 Sense Key : Medium Error [current]
Nov  7 16:01:25.915733 mantic kernel: [ 6444.572427] sd 2:0:0:0: [sdb]
tag#84 Add. Sense: Peripheral device write fault
Nov  7 16:01:25.915733 mantic kernel: [ 6444.572430] sd 2:0:0:0: [sdb]
tag#84 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
Nov  7 16:01:25.915734 mantic kernel: [ 6444.572448] I/O error, dev
sdb, sector 8 op 0x1:(WRITE) flags 0x20800 phys_seg 1 prio class 2
Nov  7 16:01:25.915735 mantic kernel: [ 6444.572495] md: super_written
gets error=3D-5

6. Disable error injection on the target

7. Reassemble md raid1
root@mantic:~# mdadm --stop /dev/md0
mdadm: stopped /dev/md0

root@mantic:~# mdadm --verbose --assemble /dev/md0 /dev/sdb /dev/sdc
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdb is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdc is identified as a member of /dev/md0, slot 1.
mdadm: added /dev/sdc to /dev/md0 as 1
mdadm: added /dev/sdb to /dev/md0 as 0
mdadm: /dev/md0 has been started with 2 drives.

root@mantic:~# tail -F /var/log/kern.log
Nov  7 16:06:27.073412 mantic kernel: [ 6745.728446] md: md0 stopped.
Nov  7 16:06:27.085369 mantic kernel: [ 6745.740822] md/raid1:md0: not
clean -- starting background reconstruction
Nov  7 16:06:27.085382 mantic kernel: [ 6745.740827] md/raid1:md0:
active with 2 out of 2 mirrors
Nov  7 16:06:27.085384 mantic kernel: [ 6745.740842] md0: detected
capacity change from 0 to 63488
Nov  7 16:06:27.089518 mantic kernel: [ 6745.742959] md: resync of
RAID array md0
Nov  7 16:06:27.365351 mantic kernel: [ 6746.019437] md: md0: resync done.

8. Read from md0 =E2=80=93 read zeros, although previously write random dat=
a succeeded
root@mantic:~# dd if=3D/dev/md0 iflag=3Ddirect bs=3D512 count=3D1 skip=3D10=
00
2>/dev/null | hexdump =E2=80=93C
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |..............=
..|
*
00000200
