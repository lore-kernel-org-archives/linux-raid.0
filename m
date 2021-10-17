Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 528D7C43217
	for <linux-raid@archiver.kernel.org>; Sun, 17 Oct 2021 01:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3484360F23
	for <linux-raid@archiver.kernel.org>; Sun, 17 Oct 2021 01:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241369AbhJQBOP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 16 Oct 2021 21:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbhJQBOO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 16 Oct 2021 21:14:14 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF480C061765
        for <linux-raid@vger.kernel.org>; Sat, 16 Oct 2021 18:12:05 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id n12so8163070qvk.3
        for <linux-raid@vger.kernel.org>; Sat, 16 Oct 2021 18:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=Khh9ndnmLhy/QDKlCLnvtRQFuKWWqNKuY+j/mk/ehA0=;
        b=IjjuBOsYNosM0kdZ/Lsuy8ZtguNR4hYuz76RYLxzzS0XX6XQCOmdhwC5Kv3r1LfFKD
         1B3v9Eas832XiKJ+1YrkKm2Oa+BZiS/HzS6hKS59rc5aUuSwS91aRJCowbvdKdlgzzV1
         JXJjQNlG8LNf9XL7tKI86o7Y+qPZt30QvIAvQ4S1KuB1Oh2oYxL1sknhX2Fx6iHrAE1a
         aZjbRM2ciqI4ydMUnk8aM31uk5ggqJUfG1D1lpE2kf4bIlJqf7nHRZhFa+P3chVrhHAT
         V4/4ZReQOZRFHoJ8wN+dxGGRGGSBWdjowF+y3yj1DYugUNYTK7GHjZ1slHurg6ihdLyE
         YZEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Khh9ndnmLhy/QDKlCLnvtRQFuKWWqNKuY+j/mk/ehA0=;
        b=MtTPX5xfiIZTDPIYtxcr/fPRETtDzjTUvJBmw8mTPVV+Btn4n/1mDP2DYNf/Gg1sUX
         9cUzgaVq+AjsrMNa+fafi02gxdqf5g4Al70H8H+ypnYum2XHYUJqcdDjtpFRL6nzCqmy
         FLz+D0k/yNDrTGjrNeOtxJx3QDyVJpCr9aM+prrv9KwKVHnVbwTYuPlVQzcSlPDnNE5k
         pIqfjUWYLvDRQbYzGhptmQjxYUKza15WwX0Tw4B6LD5hfD3mpcy+2ygYZTkqDWpP9djQ
         n5fZoJHn0gGbjZQ2kT6DqOz33k3dsVZBYXckL6rTc5qbt2/ix12xIUmY5TG+2YvP6UzU
         0b5w==
X-Gm-Message-State: AOAM530P6tlob2hFkASfWo2WhSAHWO6mloyNUcNGfkbBz0wcmMKss4nC
        Cp8Tg3Hy/gEboBwYTAASOi5y7LrpLkRobb+WdNHmDfDVrx8=
X-Google-Smtp-Source: ABdhPJz0zx1VsemmXjQ9wkytaNLILgiSR/GGHCVPaUgJM0MTxaYZrkqZ4qB3FKYGntIvqbQnm0CjCH5Z4ovZHghbDck=
X-Received: by 2002:ad4:4691:: with SMTP id bq17mr18899978qvb.56.1634433124963;
 Sat, 16 Oct 2021 18:12:04 -0700 (PDT)
MIME-Version: 1.0
From:   Romulo Albuquerque <romulo.albuquerque@gmail.com>
Date:   Sat, 16 Oct 2021 21:11:28 -0400
Message-ID: <CACKE2TBmcQ12tyujnWzPUGCM6fYjzcUhFgmZQCT2usBAHb6MmQ@mail.gmail.com>
Subject: RAID5 - can't assemble array of 5
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi All,

I've 5 disks array 3TB each, but one of the disks /dev/sdb can't be recognized.
Using mdadm - v3.4 - 28th January 2016 on Debian GNU/Linux 9.11 (stretch).

So, I tried to assemble the array with 4 disks, but it didn't work, see below:

sudo mdadm --assemble --verbose /dev/md0 /dev/sd[acde]
mdadm: looking for devices for /dev/md0
mdadm: /dev/sda is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdc is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdd is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sde is identified as a member of /dev/md0, slot 4.
mdadm: ignoring /dev/sdc as it reports /dev/sda as failed
mdadm: ignoring /dev/sdd as it reports /dev/sda as failed
mdadm: ignoring /dev/sde as it reports /dev/sda as failed
mdadm: no uptodate device for slot 1 of /dev/md0
mdadm: no uptodate device for slot 2 of /dev/md0
mdadm: no uptodate device for slot 3 of /dev/md0
mdadm: no uptodate device for slot 4 of /dev/md0
mdadm: added /dev/sda to /dev/md0 as 0
mdadm: /dev/md0 assembled from 1 drive - not enough to start the array.

Also tried to get more details and noticed some inconsistencies
related to update times, etc:
# mdadm --examine /dev/sd[acde]

/dev/sda:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 90dee075:e0f72577:2bc039c0:a6287075
           Name : andromedabr:0  (local to host andromedabr)
  Creation Time : Thu Nov 21 00:37:08 2019
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
     Array Size : 11720540160 (11177.58 GiB 12001.83 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=944 sectors
          State : clean
    Device UUID : 4cc19a0b:912f64bb:f51c74bf:abace527

    Update Time : Mon Jul 12 21:16:46 2021
       Checksum : 79ab8eb2 - correct
         Events : 600481

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 90dee075:e0f72577:2bc039c0:a6287075
           Name : andromedabr:0  (local to host andromedabr)
  Creation Time : Thu Nov 21 00:37:08 2019
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
     Array Size : 11720540160 (11177.58 GiB 12001.83 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=944 sectors
          State : active
    Device UUID : 35e0f4ea:89dfbd34:051ee297:d22e25b7

    Update Time : Fri Oct 15 09:27:03 2021
       Checksum : 3a8a6dd3 - correct
         Events : 597632

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : .AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 90dee075:e0f72577:2bc039c0:a6287075
           Name : andromedabr:0  (local to host andromedabr)
  Creation Time : Thu Nov 21 00:37:08 2019
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
     Array Size : 11720540160 (11177.58 GiB 12001.83 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=944 sectors
          State : clean
    Device UUID : 1ac77da2:86d63b86:5ad27b38:7c6555de

    Update Time : Fri Oct 15 11:13:37 2021
       Checksum : b5c5acd - correct
         Events : 600481

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : .A.AA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 90dee075:e0f72577:2bc039c0:a6287075
           Name : andromedabr:0  (local to host andromedabr)
  Creation Time : Thu Nov 21 00:37:08 2019
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
     Array Size : 11720540160 (11177.58 GiB 12001.83 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=944 sectors
          State : clean
    Device UUID : 5d468b76:81c27d1b:455adc02:2545ccee

    Update Time : Fri Oct 15 11:13:37 2021
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 4f8b2de7 - correct
         Events : 600481

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : .A.AA ('A' == active, '.' == missing, 'R' == replacing)

Please, let me know if there is anything I can do to fix this issue.

Thanks,
Romulo.
