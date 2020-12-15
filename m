Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554E0C3526B
	for <linux-raid@archiver.kernel.org>; Wed, 16 Dec 2020 00:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E97122D05
	for <linux-raid@archiver.kernel.org>; Wed, 16 Dec 2020 00:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgLPABc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:01:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:37566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgLOXy2 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 15 Dec 2020 18:54:28 -0500
X-Gm-Message-State: AOAM530T7b14xnLTAASn4VShEpu4arF9Z2O8N3VJFSXBKXhZuPaSdbyV
        jEQGRG0xiW3rnsn7dTNscQy3b/YIiLmpIVAxCOE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608076427;
        bh=YoNtWJowPHhZupPuvAQvqlAC1/1S5jRkK9eujKywPjo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Zx0oiLHx7OADcSjJaH+hzPVAhCTJJIlDoHBqnhRJ/u10W4C3cW21Yp54jCB5zctxq
         7rj7barPfBWu4PjcGzv7AIHnGFuwfJPGvt/WRpkemSXe7L9jiH0o2NUeNdWuMM41ZV
         QdPPBqqTO6scrwpb6rO5hl5qv0Uy9z3ONamK2d0PmKGlNIFl3jW0kgQpU30vIqauyf
         E+zelnYmPtpII/aXfGFZquH9DZFdA5CDXBUMiC7SeLdF/RONwvfUpRcQwTJyjcb0FA
         /UrS2tzusOnfNKhNo9ss0lbjkKeI2ZWtXeUNAd2D/LHSx6IX+prujeRoEBGbWZc5tx
         VGsX7nrqcPQVQ==
X-Google-Smtp-Source: ABdhPJzdyKniD9T2gom/0rGW18BenAVBJDOqdZVbkNM34ESCfYtlnEx9BJ6g7CbTVTZRaIFs4eVz6+DVmqvO/j8MGzE=
X-Received: by 2002:ac2:456e:: with SMTP id k14mr2553088lfm.176.1608076425154;
 Tue, 15 Dec 2020 15:53:45 -0800 (PST)
MIME-Version: 1.0
References: <89d2eb88e6a300631862718024e687fc3102a4e1.camel@seblu.net>
In-Reply-To: <89d2eb88e6a300631862718024e687fc3102a4e1.camel@seblu.net>
From:   Song Liu <song@kernel.org>
Date:   Tue, 15 Dec 2020 15:53:34 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4upOOUq13argQ_0VK0Xwrof7K9vzKO8NjKxL7qPMKtDg@mail.gmail.com>
Message-ID: <CAPhsuW4upOOUq13argQ_0VK0Xwrof7K9vzKO8NjKxL7qPMKtDg@mail.gmail.com>
Subject: Re: Array size dropped from 40TB to 7TB when upgrading to 5.10
To:     =?UTF-8?Q?S=C3=A9bastien_Luttringer?= <seblu@seblu.net>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Dec 15, 2020 at 10:40 AM S=C3=A9bastien Luttringer <seblu@seblu.net=
> wrote:
>
> Hello,
>
> After a clean reboot to the new kernel 5.10.0 my 40TB md raid5 array size
> droped to 7TB.
> The previous kernel was 5.9.5. Rebooting back to the 5.9.5 didn't fix the
> issue.
>
> # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdf[9] sdd[10] sda[7] sdb[6] sdc[11] sde[8]
>       6857871360 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6]
> [UUUUUU]
>
> unused devices: <none>
>
>
> journalctl -oshort-iso --no-hostname -b -6|grep md0
> 2020-12-04T02:30:47+0100 kernel: md/raid:md0: device sdf operational as r=
aid
> disk 0
> 2020-12-04T02:30:47+0100 kernel: md/raid:md0: device sda operational as r=
aid
> disk 5
> 2020-12-04T02:30:47+0100 kernel: md/raid:md0: device sdd operational as r=
aid
> disk 4
> 2020-12-04T02:30:47+0100 kernel: md/raid:md0: device sde operational as r=
aid
> disk 2
> 2020-12-04T02:30:47+0100 kernel: md/raid:md0: device sdc operational as r=
aid
> disk 1
> 2020-12-04T02:30:47+0100 kernel: md/raid:md0: device sdb operational as r=
aid
> disk 3
> 2020-12-04T02:30:47+0100 kernel: md/raid:md0: raid level 5 active with 6 =
out of
> 6 devices, algorithm 2
> 2020-12-04T02:30:47+0100 kernel: md0: detected capacity change from 0 to
> 40007809105920
> 2020-12-04T02:31:47+0100 kernel: EXT4-fs (md0): mounted filesystem with o=
rdered
> data mode. Opts: (null)
>
> # journalctl -oshort-iso --no-hostname -b -5|grep md0
> 2020-12-15T03:53:00+0100 kernel: md/raid:md0: device sdf operational as r=
aid
> disk 0
> 2020-12-15T03:53:00+0100 kernel: md/raid:md0: device sda operational as r=
aid
> disk 5
> 2020-12-15T03:53:00+0100 kernel: md/raid:md0: device sde operational as r=
aid
> disk 2
> 2020-12-15T03:53:00+0100 kernel: md/raid:md0: device sdd operational as r=
aid
> disk 4
> 2020-12-15T03:53:00+0100 kernel: md/raid:md0: device sdc operational as r=
aid
> disk 1
> 2020-12-15T03:53:00+0100 kernel: md/raid:md0: device sdb operational as r=
aid
> disk 3
> 2020-12-15T03:53:00+0100 kernel: md/raid:md0: raid level 5 active with 6 =
out of
> 6 devices, algorithm 2
> 2020-12-15T03:53:00+0100 kernel: md0: detected capacity change from 0 to
> 7022460272640
> 2020-12-15T03:54:20+0100 systemd-fsck[1009]: fsck.ext4: Invalid argument =
while
> trying to open /dev/md0
>
> There is no log of hardware errors or unclean unmounting.
>
> # mdadm -D /dev/md0
> /dev/md0:
>            Version : 1.2
>      Creation Time : Mon Jan 24 02:53:21 2011
>         Raid Level : raid5
>         Array Size : 6857871360 (6540.18 GiB 7022.46 GB)
>      Used Dev Size : 1371574272 (1308.04 GiB 1404.49 GB)
>       Raid Devices : 6
>      Total Devices : 6
>        Persistence : Superblock is persistent
>
>        Update Time : Tue Dec 15 17:53:13 2020
>              State : clean
>     Active Devices : 6
>    Working Devices : 6
>     Failed Devices : 0
>      Spare Devices : 0
>
>             Layout : left-symmetric
>         Chunk Size : 512K
>
> Consistency Policy : resync
>
>               Name : white:0  (local to host white)
>               UUID : affd87df:da503e3b:52a8b97f:77b80c0c
>             Events : 1791763
>
>     Number   Major   Minor   RaidDevice State
>        9       8       80        0      active sync   /dev/sdf
>       11       8       32        1      active sync   /dev/sdc
>        8       8       64        2      active sync   /dev/sde
>        6       8       16        3      active sync   /dev/sdb
>       10       8       48        4      active sync   /dev/sdd
>        7       8        0        5      active sync   /dev/sda
>
> The mdadm userspace as not been updated.
> # mdadm -V
> mdadm - v4.1 - 2018-10-01
>
> An `mdadm --action check /dev/md0` was run without errors.
>
> 1) What's the best option to restore the size without loosing the data?
> 2) Is this issue can be related to the kernel upgrade or it's fortuitous?

Hi,

I am very sorry for this problem. This is a bug in 5.10 which is fixed
in 5.10.1.
To fix it, please upgrade your kernel to 5.10.1 (or downgrade to previous
version). In many cases, the array should be back normal. If not, please tr=
y

       mdadm --grow --size <size> /dev/mdXXX.

If the original array uses the full disk/partition, you can use "max" for <=
size>
to safe some calculation.

Please let me know if you have future problem with it.

Thanks,
Song
