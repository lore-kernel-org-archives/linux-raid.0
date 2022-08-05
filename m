Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F7C8C19F2D
	for <linux-raid@archiver.kernel.org>; Fri,  5 Aug 2022 02:14:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbiHECOt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 Aug 2022 22:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233821AbiHECOt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 Aug 2022 22:14:49 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E3722B3A
        for <linux-raid@vger.kernel.org>; Thu,  4 Aug 2022 19:14:46 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id v131-20020a1cac89000000b003a4bb3f786bso3345299wme.0
        for <linux-raid@vger.kernel.org>; Thu, 04 Aug 2022 19:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc;
        bh=HtPbJn/tMzsvL3dTdQEmduacQt76d+8P7QUgTxGAo24=;
        b=VHOjKsviS0q7EwV5sC+MRU/axPrn0Rz3uwvyxaRI0QU2Ky3tjUzaoGyXWrIU1lZFpV
         apedAwc1J9djLV9HvyNInkbAjd6Uqa2jAdX2/1v0aaAcZJ7FUs8ZDna8wx52spLAezox
         QhCWsxqOtTygU5AKIVFN2BM4u7BkR5wh02qDlueBb0ZdxbG9fVI5XRiQKHE4EJ3jZDMw
         y5lDC2v3ceAWKqzpd3yitarbma5f/hyiEGaEqwx0WXo1aMoVpyteiLiK8XQznVTXEQqV
         0u+BJYQN8y4T44PpnnOU7Ii58rVb08NCw3/zQFLk9i9EPn74BhBEL1ZrvCgnvhcmmpNp
         F3zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc;
        bh=HtPbJn/tMzsvL3dTdQEmduacQt76d+8P7QUgTxGAo24=;
        b=H9++uCX0tB55uqNq3G5O/xpZFsucp6AKwscara12N1tylfo6cHSR7cAkZg2fOwunIH
         pHgOlnB2Hvw1OcaNLWJKKhKkE/RAM7xWS0mA9HPwmO00gvkXu1pY9rfazJYOtwUlIOHm
         mQXerGNhAEc2L2fNBEKopaDqhMFv0nopZSRhG1BKGq2ltI4xVB/wX1/nzZUW8zCUA12v
         KDrVsbg1ZYyT1PSDY9Y9GKFTSYRadMrjhXgHLQURg0Y619nUBe+vEUwwFHZ+HsOOl1oL
         Lkqhp1RnLEzi0Ei+Q2G7ddMIX3kjg7GgvOF6+a7Pza1hkdpauWsy3POsWE+E03kzMK0X
         Ds4g==
X-Gm-Message-State: ACgBeo24lYh4tUdnb0/k7A+PDLjtCfwDBUdd5+ju81rGAjnXJBhyEQKY
        a8BgfjznMSMc3DtiQCoyWx1tyJIkp7uHL8gYgfrPZixHees=
X-Google-Smtp-Source: AA6agR7nJKSQR3GumL5qiaS+f/SVz1QZY+S2eLsx0pulhYd7YGjlLnEaPWmDiJ8pNcCcI9Dz2fjZQksBc9eqVzFPiHA=
X-Received: by 2002:a05:600c:2d02:b0:3a5:e61:d876 with SMTP id
 x2-20020a05600c2d0200b003a50e61d876mr3080090wmf.132.1659665684758; Thu, 04
 Aug 2022 19:14:44 -0700 (PDT)
MIME-Version: 1.0
From:   Taeuk Kim <taeugi323@gmail.com>
Date:   Fri, 5 Aug 2022 11:14:33 +0900
Message-ID: <CACsU5LmWch6Fw5B7sEQRVuWxqEYPU5APW9dU+qwmsFwtQLcp3A@mail.gmail.com>
Subject: mdadm garbage file remains in container environment
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello all.

I have an issue on constructing s/w raid with mdadm in container environmen=
t.
When I create a raid-1 device through mdadm and stop it in privileged
container, garbage files remain in /dev and /sys paths. It causes a
problem when I restart the same raid device.

Commands are like below.

$ docker run --privileged --cap-add=3DALL -it --name testvol -v
/dev:/dev:rshared -v /sys:/sys:rshared -v /lib:/lib:rshared centos:7
/bin/bash

$ capsh --print | grep "Current:" | cut -d' ' -f3
cap_chown,cap_dac_override,cap_dac_read_search,cap_fowner,cap_fsetid,cap_ki=
ll,cap_setgid,cap_setuid,cap_setpcap,cap_linux_immutable,cap_net_bind_servi=
ce,cap_net_broadcast,cap_net_admin,cap_net_raw,cap_ipc_lock,cap_ipc_owner,c=
ap_sys_module,cap_sys_rawio,cap_sys_chroot,cap_sys_ptrace,cap_sys_pacct,cap=
_sys_admin,cap_sys_boot,cap_sys_nice,cap_sys_resource,cap_sys_time,cap_sys_=
tty_config,cap_mknod,cap_lease,cap_audit_write,cap_audit_control,cap_setfca=
p,cap_mac_override,cap_mac_admin,cap_syslog,35,36,37+ep

$ yum install -y nvme-cli nvmetcli mdadm
=E2=80=A6

$ nvme connect --transport tcp --traddr 1.2.3.4 --trsvcid 4420 ...

$ nvme connect --transport tcp --traddr 1.3.5.7 --trsvcid 4420 ...

$ lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
nvme0n1 259:0    0   11G  0 disk
nvme1n1 259:1    0   11G  0 disk
=E2=80=A6

$ /sbin/mdadm --create /dev/md/testvol --assume-clean --failfast
--bitmap=3Dinternal --level=3D1 --raid-devices=3D2 /dev/nvme0n1 /dev/nvme1n=
1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=3D0.90
Continue creating array? yes
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md/testvol started.

$ lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
nvme0n1 259:0    0   11G  0 disk
`-md127   9:127  0   11G  0 raid1
nvme1n1 259:1    0   11G  0 disk
`-md127   9:127  0   11G  0 raid1
=E2=80=A6

$ ls /dev/md*
/dev/md127

/dev/md:
testvol


After creating, I stopped the raid device and I can find garbage files
still remaining like below.

$ /sbin/mdadm --manage /dev/md/testvol --stop
mdadm: stopped /dev/md/testvol

$ lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
nvme0n1 259:0    0   11G  0 disk
nvme1n1 259:1    0   11G  0 disk
=E2=80=A6

$ ls /dev/md*
/dev/md127

/dev/md:
testvol

## All remaining garbage files
$ find / -name md127
/dev/md127
/sys/class/block/md127
/sys/devices/virtual/block/md127
/sys/block/md127


When I did the above command equally in host, there was no garbage file.
There are some differences on kernel events in host and privileged containe=
r.

First of all, below is the kernel event when I do mdadm --stop in
host. I deliver only first line of kernel events for readability.

$ udevadm monitor -p

KERNEL[1245.708850] remove   /devices/virtual/bdi/9:127 (bdi)

KERNEL[1245.709330] remove   /devices/virtual/block/md127 (block)

UDEV  [1245.710526] remove   /devices/virtual/bdi/9:127 (bdi)

UDEV  [1245.716664] remove   /devices/virtual/block/md127 (block)


However, in privileged container, mdadm --stop command incurs "add"
kernel events as well as "remove" events.

$ udevadm monitor -p

KERNEL[92803.756048] remove   /devices/virtual/bdi/9:127 (bdi)

KERNEL[92803.756077] remove   /devices/virtual/block/md127 (block)

UDEV  [92803.757334] remove   /devices/virtual/bdi/9:127 (bdi)

KERNEL[92803.762387] add      /devices/virtual/bdi/9:127 (bdi)

KERNEL[92803.762497] add      /devices/virtual/block/md127 (block)

UDEV  [92803.762865] add      /devices/virtual/bdi/9:127 (bdi)

UDEV  [92803.764697] remove   /devices/virtual/block/md127 (block)

UDEV  [92803.768186] add      /devices/virtual/block/md127 (block)


This may be the direct cause of garbage files, but I don't understand
why "add" kernel events exist when I stop raid device in container.
(The interesting point is that privileged container does not include
"add" kernel events when mdadm --create command is done. If you need
it in analysis, I will share it too)

(JFI)
For bidirectional communication between host and container in
bind-mounted paths, I added the shared flag to docker daemon's
MountFlags parameter.

$ cat /etc/systemd/system/multi-user.target.wants/docker.service
=E2=80=A6
[Service]
=E2=80=A6
MountFlags=3Dshared
=E2=80=A6


Please give me a hand.

Best regards,
Taeuk Kim
