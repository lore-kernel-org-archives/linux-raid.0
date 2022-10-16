Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B40CC433FE
	for <linux-raid@archiver.kernel.org>; Sun, 16 Oct 2022 21:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiJPVi7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 16 Oct 2022 17:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJPVi6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 16 Oct 2022 17:38:58 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984D430F66
        for <linux-raid@vger.kernel.org>; Sun, 16 Oct 2022 14:38:57 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id f37so14784157lfv.8
        for <linux-raid@vger.kernel.org>; Sun, 16 Oct 2022 14:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3bQpeb7qbgz7OnKA4Ek9nSQvzAXF8C8FDtCTFu1YNAM=;
        b=Za8dL20qAFhRRZyq/hSCRlsvJCt39fTZSSoZybDaoSdffCNmRqPIeYdYb5WtgHBeBz
         Tee+XW7qTPBPDv5WtRj+2ZqhNiFkm1UCZq012XWtY5rCxLMGaE2uG6CwyUA6rbAST53b
         yl4xUHHaYrpEElwbhS3C0Ynjy1dj8FcrJX+zKcWliyToyfZanGOq0bBaEM8C6Y49pmhm
         BDPK7g1uZ4qe0kCi4A1D2fpFlyLFQcbEX4gPJdaSaZCPmFgcbmGWKlAh0dQ2juWza0V1
         f9q+JX7nLec79mLurt2ZAOJuT52GHs6UqRIX7PnYasWR1r6vdO9DLqy9noI5MrXhU3gO
         vvzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3bQpeb7qbgz7OnKA4Ek9nSQvzAXF8C8FDtCTFu1YNAM=;
        b=3kjL9rdHta0DwB8FuZmbc3W1UhoSboueXAFfkHgYIVWBtRwX/cpQgTe8kq36KYtpm+
         OTHtXXGUbcVJYGPYMM9QLiLU6qcnMzSh3+ZM2rAYH2fDz02mXNkdm3Pm/Q+S8uMZGe6q
         qfx+GyIpXtBmrle90SWkp1bE1NEW0epv1pBmvILeDz9ZhvjNOmlYEhqbpvsNuk9qdZEu
         8auO7Vg3kiHHN18O8kgVjj4KO2CdkgpK229JvFzqOhgs14qte6I2d2F02nHYidrPa5p0
         gsNf+zXRk1lJDYELY/hLpr3bHGZ2zvJVjZRdnidnF+St9D0f9q4kCch7Asjam3zPbpGQ
         vvTg==
X-Gm-Message-State: ACrzQf1Cd1wjDmxw6DiVn7EwuVAYiRbYZg2+9q2DB5jKu3/KO8io28mj
        AbiB6viQpe8uytnVfg4XY5NPh8wU4v8jBdUxUbKFFRe5rjc=
X-Google-Smtp-Source: AMsMyM7o0Ekl4zphCcjjeK0IctmyjwviOZ03RtgRVa1UiJHI4BhGi3KBSVCJQpthnwfeuZ7+HpekNorFib1TNXvXT9k=
X-Received: by 2002:a05:6512:2310:b0:4a2:a50a:82d5 with SMTP id
 o16-20020a056512231000b004a2a50a82d5mr2578333lfu.266.1665956335241; Sun, 16
 Oct 2022 14:38:55 -0700 (PDT)
MIME-Version: 1.0
From:   Steve Kolk <stevekolk@gmail.com>
Date:   Sun, 16 Oct 2022 17:38:40 -0400
Message-ID: <CACZftsg4Cg5UM8derE46m2JgHWFAoNYFvDXbFKfoU4Jrbmhx_g@mail.gmail.com>
Subject: Rebuilding mdadm RAID array after OS drive failure
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I have a system that was running Ubuntu 18.04 server with a 5 drive
RAID 6 array using mdadm. I had a hard drive failure, but instead of
the array it was the OS hard drive that completely failed. I also do
not have access to the original mdadm.conf file.

In an attempt to get my array back up, I booted Ubuntu 22.04 from a
USB and tried to assemble and mount the array.  It did not work.
Trying some diagnostic steps I found online, it seems to be claiming
that there is no md superblock on any of the drives.

I've included the commands I ran and their output below. Does anyone
have any advice on what next steps I can take? I have no reason to
think these drives have failed mechanically (much less all of them). I
also tried with Ubuntu 18.04 and got the same results.

ubuntu@ubuntu:~$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop0    7:0    0   2.2G  1 loop /rofs
loop1    7:1    0  32.3M  1 loop /snap/snapd/12883
loop2    7:2    0  55.4M  1 loop /snap/core18/2128
loop3    7:3    0  61.8M  1 loop /snap/core20/1081
loop4    7:4    0  65.1M  1 loop /snap/gtk-common-themes/1515
loop5    7:5    0   219M  1 loop /snap/gnome-3-34-1804/72
loop6    7:6    0 241.4M  1 loop /snap/gnome-3-38-2004/70
loop7    7:7    0   2.5M  1 loop /snap/gnome-calculator/884
loop8    7:8    0   704K  1 loop /snap/gnome-characters/726
loop9    7:9    0   548K  1 loop /snap/gnome-logs/106
loop10   7:10   0   2.5M  1 loop /snap/gnome-system-monitor/163
sda      8:0    0   9.1T  0 disk
=E2=94=9C=E2=94=80sda1   8:1    0   9.1T  0 part
=E2=94=94=E2=94=80sda9   8:9    0     8M  0 part
sdb      8:16   0   9.1T  0 disk
=E2=94=9C=E2=94=80sdb1   8:17   0   9.1T  0 part
=E2=94=94=E2=94=80sdb9   8:25   0     8M  0 part
sdc      8:32   0   9.1T  0 disk
=E2=94=9C=E2=94=80sdc1   8:33   0   9.1T  0 part
=E2=94=94=E2=94=80sdc9   8:41   0     8M  0 part
sdd      8:48   0   9.1T  0 disk
=E2=94=9C=E2=94=80sdd1   8:49   0   9.1T  0 part
=E2=94=94=E2=94=80sdd9   8:57   0     8M  0 part
sde      8:64   0   9.1T  0 disk
=E2=94=9C=E2=94=80sde1   8:65   0   9.1T  0 part
=E2=94=94=E2=94=80sde9   8:73   0     8M  0 part
sdf      8:80   1   7.6G  0 disk
=E2=94=94=E2=94=80sdf1   8:81   1   7.6G  0 part /cdrom

ubuntu@ubuntu:~$ sudo mdadm --assemble /dev/sda1 /dev/sdb1 /dev/sdc1
/dev/sdd1 /dev/sde1
mdadm: device /dev/sda1 exists but is not an md array.

ubuntu@ubuntu:~$ sudo mdadm --examine --verbose /dev/sd[a-e]1
mdadm: No md superblock detected on /dev/sda1.
mdadm: No md superblock detected on /dev/sdb1.
mdadm: No md superblock detected on /dev/sdc1.
mdadm: No md superblock detected on /dev/sdd1.
mdadm: No md superblock detected on /dev/sde1.

ubuntu@ubuntu:~$ sudo mdadm --assemble --scan --verbose
mdadm: looking for devices for further assembly
mdadm: no recogniseable superblock on /dev/loop10
mdadm: no recogniseable superblock on /dev/loop9
mdadm: no recogniseable superblock on /dev/loop8
mdadm: Cannot assemble mbr metadata on /dev/sdf1
mdadm: Cannot assemble mbr metadata on /dev/sdf
mdadm: no recogniseable superblock on /dev/sdb9
mdadm: no recogniseable superblock on /dev/sdb1
mdadm: Cannot assemble mbr metadata on /dev/sdb
mdadm: no recogniseable superblock on /dev/sde9
mdadm: no recogniseable superblock on /dev/sde1
mdadm: Cannot assemble mbr metadata on /dev/sde
mdadm: no recogniseable superblock on /dev/sdd9
mdadm: no recogniseable superblock on /dev/sdd1
mdadm: Cannot assemble mbr metadata on /dev/sdd
mdadm: no recogniseable superblock on /dev/sdc9
mdadm: no recogniseable superblock on /dev/sdc1
mdadm: Cannot assemble mbr metadata on /dev/sdc
mdadm: no recogniseable superblock on /dev/sda9
mdadm: no recogniseable superblock on /dev/sda1
mdadm: Cannot assemble mbr metadata on /dev/sda
mdadm: no recogniseable superblock on /dev/loop7
mdadm: no recogniseable superblock on /dev/loop6
mdadm: no recogniseable superblock on /dev/loop5
mdadm: no recogniseable superblock on /dev/loop4
mdadm: no recogniseable superblock on /dev/loop3
mdadm: no recogniseable superblock on /dev/loop2
mdadm: no recogniseable superblock on /dev/loop1
mdadm: no recogniseable superblock on /dev/loop0
mdadm: No arrays found in config file or automatically

Steve
