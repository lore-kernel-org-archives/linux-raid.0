Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,T_FILL_THIS_FORM_LOAN,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CABD9C433DB
	for <linux-raid@archiver.kernel.org>; Fri, 29 Jan 2021 00:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70AA661481
	for <linux-raid@archiver.kernel.org>; Fri, 29 Jan 2021 00:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhA2AjM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jan 2021 19:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbhA2AiC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jan 2021 19:38:02 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F21C06174A
        for <linux-raid@vger.kernel.org>; Thu, 28 Jan 2021 16:37:06 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id v15so5583861ljk.13
        for <linux-raid@vger.kernel.org>; Thu, 28 Jan 2021 16:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=powerlamerz-org.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=RwIIwOcbZCjix4/ZqF+Ejga0atl2lNKs/2p4/6q1244=;
        b=QiOpOPWTEMQJmlfAHgjIPIL3cf5TH48Z06WEV9AOvJqWPnbAxAHGi4pxPB/xQHz6Bd
         VxEJTGAR3vWY8/+ojDXsQ8V6aSrz90eiUqEXj7koepvYQOrU3bT5P+b1X1ZlZeK9qX5F
         OGaGlKvG09ayDq0hFQlk0Uzymg1xa8eEVwPvibyf6WgjBD5ANjet3oJo4lpCEtKuo2Yc
         dBADdQRhyvefxRRhhXMa599VY++GaPpGspSgrdZUq5RMoQg1fvnSU5eff5xBSOef9xKL
         23W1blFRLqoem2/VO6svVQMnPTk0DyqUFONjqvL1AI9uPJfMZ2lrDXNlxvyO/wQTfsO3
         vDFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=RwIIwOcbZCjix4/ZqF+Ejga0atl2lNKs/2p4/6q1244=;
        b=kdhBNELV5rp/+E9Ij2sliv/+ecLpI4sQjl/tiGo/Wj55dm6T/1EWBTfG2ZkZsuDHUE
         n9PfZ0ijxStlBiSAsXJkYOmMBW0FWiiWmQxOIbxm5ZhJlhUWJL6A523NmcbwyTClsIIs
         HMPW+bX4z4XCvFwhhkNy8MztZ3kdNb6iFFMfkCC55saLAmQUov4PZxbTTRZHGc4ySlM3
         CoONVTKRDqLJ+1rKTQZBA3Sw14TsG/Jbia6NL2ADvrX94yiFXiCfO5zX0//aZ7gq2sAx
         r+fIp4/Sxz+co5kakTg23o5AcRSsJZ7KeSJOjvhk0LgTJK/XvDPszf2zYo7kDHVWMKBA
         8DgQ==
X-Gm-Message-State: AOAM530BzBLO++7aOMNooe98Bg70VFt5fojU/oEUKLfqzSJwS5AwcW2f
        uvVXG7KDjuyFplu1loEIDzfQwN501mAng4PYIq4=
X-Google-Smtp-Source: ABdhPJzMdOv3EHaFDaHcGg6gDA2v+bPPKA0g5Ua5AtVOoVOwymfunts89tnntN9MszBP6vQt65N5AQ==
X-Received: by 2002:a2e:2c11:: with SMTP id s17mr977557ljs.468.1611880624671;
        Thu, 28 Jan 2021 16:37:04 -0800 (PST)
Received: from [192.168.77.207] ([212.85.71.156])
        by smtp.gmail.com with ESMTPSA id n11sm1829712lfa.188.2021.01.28.16.37.03
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 16:37:04 -0800 (PST)
To:     linux-raid@vger.kernel.org
From:   =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>
Subject: I trashed my superblocks after reshape from raid5 to raid6 stalled -
 need help recovering
Message-ID: <1e6c1c18-38c3-3419-505c-b310e9f55dd6@powerlamerz.org>
Date:   Fri, 29 Jan 2021 01:37:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

Logs and disk information is located at the end of this email. Please
note that I also have a USB stick plugged into this computer that
sometimes comes up as sda and sometimes sdi, which means that some of
the collected data might be off-by-one (sda -> sdb, etc.).

I will try to be as thorough as possible to explain what has happened
and don't waste your time. The short version first:

* Start reshape of raid5 with 7 disks to raid6 with 8 disks
* Reshape stalls
* Panic
* Fail to create overlays
* Become overconfident
* Overwrite superblock (wrongly) without overlays
* Realize mistake
* Stop
* Get overlays working
* Much hard thinking and experimenting with device mapper
* Successfully mount raid volume by combining 2 overlay sets
* Need help restoring array

If this is enough information, please skip to "Where I am now" below.
For details on what I've written to my superblock, see "Frakking up".

Long version
============
This story begins with a perfectly healthy raid5 array with 7 x 10 TB
drives. Well, mostly healthy. I had started to see these lines pop up
in my syslog:

Jan 21 18:01:06 rack-server-1 smartd[1586]: Device: /dev/sdb [SAT], 16 Currently unreadable (pending) sectors

Because of this, I started to become paranoid that I would loose data
when replacing the bad drive. I decided I should add another 10 TB to
the array and convert to raid6. These are the commands I used to kick
off that conversion:

(mdadm 4.1 and Linux 4.15.0-132-generic)

$ sudo mdadm --add /dev/md0 /dev/sdg
$ sudo mdadm --grow /dev/md0 --level=6 --raid-disk=8

This kicked off the reshape process successfully. A few days later, I
started to notice I/O issues. More precisely: timeouts. It looks like
the reshape process had stalled and any kind of I/O to the raid mount
mount point would also stall, until some timeout error occurred. This
was most likely caused by BBL, but I didn't know that at the time. At
this point these messages started to show up in my kernel log:

Jan 20 21:55:06 rack-server-1 kernel: INFO: task md0_reshape:29278 blocked for more than 120 seconds.
Jan 20 21:55:06 rack-server-1 kernel:       Tainted: G           OE    4.15.0-132-generic #136-Ubuntu
Jan 20 21:55:06 rack-server-1 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan 20 21:55:06 rack-server-1 kernel: md0_reshape     D    0 29278      2 0x80000000
Jan 20 21:55:06 rack-server-1 kernel: Call Trace:
Jan 20 21:55:06 rack-server-1 kernel:  __schedule+0x24e/0x880
Jan 20 21:55:06 rack-server-1 kernel:  schedule+0x2c/0x80
Jan 20 21:55:06 rack-server-1 kernel:  md_do_sync+0xdf1/0xfa0
Jan 20 21:55:06 rack-server-1 kernel:  ? wait_woken+0x80/0x80
Jan 20 21:55:06 rack-server-1 kernel:  ? __switch_to_asm+0x35/0x70
Jan 20 21:55:06 rack-server-1 kernel:  md_thread+0x129/0x170
Jan 20 21:55:06 rack-server-1 kernel:  ? md_seq_next+0x90/0x90
Jan 20 21:55:06 rack-server-1 kernel:  ? md_thread+0x129/0x170
Jan 20 21:55:06 rack-server-1 kernel:  kthread+0x121/0x140
Jan 20 21:55:06 rack-server-1 kernel:  ? find_pers+0x70/0x70
Jan 20 21:55:06 rack-server-1 kernel:  ? kthread_create_worker_on_cpu+0x70/0x70
Jan 20 21:55:06 rack-server-1 kernel:  ret_from_fork+0x35/0x40

Other tasks or user processes also started to become blocked. Almost
anything I did would become blocked because it would access this mount
point and stall. If I rebooted the server, it would stall during boot,
when assembling the raid.

By removing all the drives, I was able to at least boot the server. I
decided to update to Ubuntu 20.04 and try again - no dice. I still got
blocked. I did notice that the reshape progressed a little bit every
time I booted.

I figured I would revert the reshape and start from scratch and I found
out that there is something called "--assemble --update=revert-reshape":

(mdadm v4.1 and Linux-5.4.0-64-generic, USB stick is sda)

$ sudo mdadm --detail /dev/md0
/dev/md0:         
           Version : 1.2
     Creation Time : Sat Apr 29 16:21:11 2017
        Raid Level : raid6
        Array Size : 58597880832 (55883.29 GiB 60004.23 GB)
     Used Dev Size : 9766313472 (9313.88 GiB 10000.70 GB)
      Raid Devices : 8
     Total Devices : 8
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Thu Jan 21 20:32:24 2021
             State : clean, degraded, reshaping 
    Active Devices : 7
   Working Devices : 8
    Failed Devices : 0
     Spare Devices : 1

            Layout : left-symmetric-6
        Chunk Size : 512K

Consistency Policy : bitmap

    Reshape Status : 59% complete
        New Layout : left-symmetric

              Name : rack-server-1:1  (local to host rack-server-1)
              UUID : 7f289c7a:570e2f7e:2ac6f909:03b3970f
            Events : 728221

    Number   Major   Minor   RaidDevice State
       8       8       48        0      active sync   /dev/sdd
      13       8       64        1      active sync   /dev/sde
      12       8       96        2      active sync   /dev/sdg
       7       8      128        3      active sync   /dev/sdi
      10       8       80        4      active sync   /dev/sdf
       9       8       16        5      active sync   /dev/sdb
      11       8       32        6      active sync   /dev/sdc
      14       8      112        7      spare rebuilding   /dev/sdh
$ sudo mdadm --stop /dev/md0
$ sudo mdadm --assemble --update=revert-reshape /dev/md0

This did not do what I expected. Unfortunately, I forgot to save the
output of "mdadm --detail /dev/md0" after the last command, but if I
remember correctly it marked all my drives, except sdh, as faulty. I
expected it to start going backwards in the reshape progress.

At this point, I saved away the output of these commands:

(mdadm v4.1 and Linux-5.4.0-64-generic, USB stick is sda)

$ sudo mdadm --examine /dev/sdb
$ sudo mdadm --examine /dev/sdc
$ sudo mdadm --examine /dev/sdd
$ sudo mdadm --examine /dev/sde
$ sudo mdadm --examine /dev/sdf
$ sudo mdadm --examine /dev/sdg
$ sudo mdadm --examine /dev/sdh
$ sudo mdadm --examine /dev/sdg
$ sudo mdadm --examine /dev/sdh
$ sudo mdadm --examine /dev/sdi

(output located at the end)

Fail to create overlays
=======================
I realized that I needed to start using overlays unless I mess up even
more. However, that was easier said than done. No matter what I did, I
always got this error as a result of "dmsetup create":

Jan 21 21:19:10 rack-server-1 kernel: device-mapper: table: 253:1: snapshot: Cannot get origin device
Jan 21 21:19:10 rack-server-1 kernel: device-mapper: ioctl: error adding target to table

Frakking up
===========
Now, what would be the sane thing to do when you can't create overlays?

Stop. Ask for help.

If this was a test on how I perform under pressure, I failed. After all,
this wasn't my first time recovering from a failed reshape. Just search
the mailing list for my name. I was confident in my abilities, and flew
straight into the sun:

(mdadm v4.1 and Linux-5.4.0-64-generic, USB stick is sdi)

$ sudo mdadm --create --level=6 --raid-devices=8 --size=4883156736 /dev/md0 /dev/sdc /dev/sdd /dev/sdf /dev/sdh /dev/sde /dev/sda /dev/sdb missing

Notice the lack of "--assume-clean" and the wrong "--size" parameter,
not to mention the missing "--data-offset" since it was "non-default".

This kicked off a rebuild of disk sdb (the last non-missing device).
Fortunately, I realized my mistake within a few seconds - 39 seconds in
fact, if my command history can be trusted - and stopped the array.

What follows is a series of more attempts at re-creating the superblock
with different parameters to "mdadm --create --assume-clean". The last
one (I think) being:

(mdadm v4.1 and Linux-5.4.0-64-generic, USB stick is sdi)

$ sudo mdadm --create --assume-clean --level=6 --raid-devices=8 --size=9766313472 --data-offset=61440 /dev/md0 /dev/sdc /dev/sdd /dev/sdf /dev/sdh /dev/sde /dev/sda /dev/sdb missing

Running "fsck.ext4 -n /dev/md0" on this array would at least start.
However, it would eventually reach a point where it would start spewing
a ton of errors. My guess is that it reaches the point where the array
has not yet been reshaped.

Getting overlays to work again
==============================

Although my command history has no memory of it, "journalctl" tell me
that I rebooted my server one more time after I failed to create
overlays. After that, the "overlay_create" and "overlay_remove"
functions just worked. Every. <censored>. Time.

Once overlays were working, I got to work at thinking hard and
experimenting. Some experiments quickly grew the overlay files
and my storage space for them were only ~80 GB. I decided to
scrap the newly added disk and re-use it as storage space for
overlay files. In hindsight, I realize that I could have used
the other 10 TB drive I had laying on the shelf below...

Where I am now
==============

I am able to mount my raid volume by creating 2 separate sets of overlay
files, create an array on each set, and then use device mapper in linear
mode to "stitch together" the 2 arrays at the exact reshape position:

(mdadm v4.1 and Linux-5.4.0-64-generic)

$ sudo mdadm --create --assume-clean --level=6 --raid-devices=8 --size=9766313472 --layout=left-symmetric --data-offset=61440 /dev/md0 /dev/dm-3 /dev/dm-4 /dev/dm-6 /dev/dm-7 /dev/dm-5 /dev/dm-1 /dev/dm-2 missing
$ sudo mdadm --create --assume-clean --level=6 --raid-devices=8 --size=9766313472 --layout=left-symmetric-6 --data-offset=123392 /dev/md1 /dev/dm-10 /dev/dm-11 /dev/dm-13 /dev/dm-14 /dev/dm-12 /dev/dm-8 /dev/dm-9 missing
$ echo "0 69529589760 linear /dev/md0 0
69529589760 47666171904 linear /dev/md1 69529589760" | sudo dmsetup create joined
$ sudo mount -o ro /dev/dm-15 /storage

The numbers are taken from the "mdadm -E <dev>" commands I ran earlier,
only recalculated to fit the expected unit. The last drive in the array
has been re-purposed as overlay storage.

What now?
=========

This is where I need some more help:
* How can I resume the reshape or otherwise fix my array?
* Is resuming a reshape something that would be a useful feature?
  If so, I could look into adding support for it. Maybe used like this?

  # mdadm --create --assume-clean /dev/md0 <array definition>
  # mdadm --manage /dev/md0 --grow --reshape-pos=<number> <grow params>

* Does wiping or overwriting the superblock also clear the BBL?
* Is there any information missing?

I re-read a mailing list thread today that I initially brushed aside for
some reason, and I believe my initial problem with a stalled reshape was
caused by BBL. Looking back at the saved output of "mdadm -E <dev>", the
log clearly show 512 entries at offset 32 or 72 sectors for every device
in the raid. Some devices even say "bad blocks present". I guess the BBL
is lost now.

Information about my system
===========================
If you need the output of "smartctl --xall <dev>", let me know.

$ uname -a
Linux rack-server-1 5.4.0-64-generic #72-Ubuntu SMP Fri Jan 15 10:27:54 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux

$ mdadm --version
mdadm - v4.1 - 2018-10-01

(USB stick is sdi)

# smartctl -H -i -l scterc /dev/sda
smartctl 7.1 2019-12-30 r5022 [x86_64-linux-5.4.0-64-generic] (local build)
Copyright (C) 2002-19, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD100EFAX-68LHPN0
Serial Number:    JEGK2KAN
LU WWN Device Id: 5 000cca 267c7c3ea
Firmware Version: 83.H0A83
User Capacity:    10,000,831,348,736 bytes [10.0 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Jan 29 01:12:29 2021 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

# smartctl -H -i -l scterc /dev/sdb
smartctl 7.1 2019-12-30 r5022 [x86_64-linux-5.4.0-64-generic] (local build)
Copyright (C) 2002-19, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD100EFAX-68LHPN0
Serial Number:    1SG7363Z
LU WWN Device Id: 5 000cca 26bc33a99
Firmware Version: 83.H0A83
User Capacity:    10,000,831,348,736 bytes [10.0 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Jan 29 01:12:58 2021 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

root@rack-server-1:~/lsdrv# smartctl -H -i -l scterc /dev/sdc
smartctl 7.1 2019-12-30 r5022 [x86_64-linux-5.4.0-64-generic] (local build)
Copyright (C) 2002-19, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD100EFAX-68LHPN0
Serial Number:    2TKYUB2D
LU WWN Device Id: 5 000cca 26af7d476
Firmware Version: 83.H0A83
User Capacity:    10,000,831,348,736 bytes [10.0 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Jan 29 01:13:12 2021 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

root@rack-server-1:~/lsdrv# smartctl -H -i -l scterc /dev/sdd
smartctl 7.1 2019-12-30 r5022 [x86_64-linux-5.4.0-64-generic] (local build)
Copyright (C) 2002-19, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD100EFAX-68LHPN0
Serial Number:    JEJRAT3N
LU WWN Device Id: 5 000cca 267e657a1
Firmware Version: 83.H0A83
User Capacity:    10,000,831,348,736 bytes [10.0 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Jan 29 01:13:13 2021 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

root@rack-server-1:~/lsdrv# smartctl -H -i -l scterc /dev/sde
smartctl 7.1 2019-12-30 r5022 [x86_64-linux-5.4.0-64-generic] (local build)
Copyright (C) 2002-19, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD100EFAX-68LHPN0
Serial Number:    2YJB2MHD
LU WWN Device Id: 5 000cca 273e138f5
Firmware Version: 83.H0A83
User Capacity:    10,000,831,348,736 bytes [10.0 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Jan 29 01:13:14 2021 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

root@rack-server-1:~/lsdrv# smartctl -H -i -l scterc /dev/sdf
smartctl 7.1 2019-12-30 r5022 [x86_64-linux-5.4.0-64-generic] (local build)
Copyright (C) 2002-19, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD100EFAX-68LHPN0
Serial Number:    JEJW1TLN
LU WWN Device Id: 5 000cca 267e87bc2
Firmware Version: 83.H0A83
User Capacity:    10,000,831,348,736 bytes [10.0 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Jan 29 01:13:15 2021 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

root@rack-server-1:~/lsdrv# smartctl -H -i -l scterc /dev/sdg
smartctl 7.1 2019-12-30 r5022 [x86_64-linux-5.4.0-64-generic] (local build)
Copyright (C) 2002-19, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD100EFAX-68LHPN0
Serial Number:    JEHRV47N
LU WWN Device Id: 5 000cca 267d879c8
Firmware Version: 83.H0A83
User Capacity:    10,000,831,348,736 bytes [10.0 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Jan 29 01:13:16 2021 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

root@rack-server-1:~/lsdrv# smartctl -H -i -l scterc /dev/sdh
smartctl 7.1 2019-12-30 r5022 [x86_64-linux-5.4.0-64-generic] (local build)
Copyright (C) 2002-19, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD100EFAX-68LHPN0
Serial Number:    2TK3JVUD
LU WWN Device Id: 5 000cca 26aebe2ef
Firmware Version: 83.H0A83
User Capacity:    10,000,831,348,736 bytes [10.0 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Jan 29 01:13:18 2021 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

(USB stick is sdi)

# mdadm -E /dev/sda
/dev/sda:             
          Magic : a92b4efc
        Version : 1.2 
    Feature Map : 0x6d
     Array UUID : 7f289c7a:570e2f7e:2ac6f909:03b3970f
           Name : rack-server-1:1  (local to host rack-server-1)
  Creation Time : Sat Apr 29 16:21:11 2017
     Raid Level : raid6
   Raid Devices : 8   
                      
 Avail Dev Size : 19532750848 (9313.94 GiB 10000.77 GB)
     Array Size : 58597880832 (55883.29 GiB 60004.23 GB)
  Used Dev Size : 19532626944 (9313.88 GiB 10000.70 GB)
    Data Offset : 122880 sectors
     New Offset : 246784 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : aa8831f9:86574262:4c8e342f:b5815a2d
                      
Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 34764794880 (33154.29 GiB 35599.15 GB)
     New Layout : left-symmetric-6

    Update Time : Thu Jan 21 20:32:24 2021
  Bad Block Log : 512 entries available at offset 32 sectors - bad blocks present.
       Checksum : 80ef79ac - correct
         Events : 728221
         
         Layout : left-symmetric
     Chunk Size : 512K
   
   Device Role : Active device 5
   Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
# mdadm -E /dev/sdb
/dev/sdb: 
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x6d
     Array UUID : 7f289c7a:570e2f7e:2ac6f909:03b3970f
           Name : rack-server-1:1  (local to host rack-server-1)
  Creation Time : Sat Apr 29 16:21:11 2017
     Raid Level : raid6
   Raid Devices : 8
 
 Avail Dev Size : 19532750848 (9313.94 GiB 10000.77 GB)
     Array Size : 58597880832 (55883.29 GiB 60004.23 GB)
  Used Dev Size : 19532626944 (9313.88 GiB 10000.70 GB)
    Data Offset : 122880 sectors
     New Offset : 246784 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : e234c9bb:7bc05c43:a3506172:4974548b

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 34764794880 (33154.29 GiB 35599.15 GB)
     New Layout : left-symmetric-6
                      
    Update Time : Thu Jan 21 20:32:24 2021
  Bad Block Log : 512 entries available at offset 32 sectors - bad blocks present.
       Checksum : c5c845e6 - correct
         Events : 728221
                      
         Layout : left-symmetric
     Chunk Size : 512K
                      
   Device Role : Active device 6
   Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
# mdadm -E /dev/sdc
/dev/sdc:             
          Magic : a92b4efc
        Version : 1.2 
    Feature Map : 0x65
     Array UUID : 7f289c7a:570e2f7e:2ac6f909:03b3970f
           Name : rack-server-1:1  (local to host rack-server-1)
  Creation Time : Sat Apr 29 16:21:11 2017
     Raid Level : raid6
   Raid Devices : 8   
                      
 Avail Dev Size : 19532750848 (9313.94 GiB 10000.77 GB)
     Array Size : 58597880832 (55883.29 GiB 60004.23 GB)
  Used Dev Size : 19532626944 (9313.88 GiB 10000.70 GB)
    Data Offset : 122880 sectors
     New Offset : 246784 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : a1f9fcf6:65194ebf:fd8209c7:04f93e0e
                      
Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 34764794880 (33154.29 GiB 35599.15 GB)
     New Layout : left-symmetric-6
                      
    Update Time : Thu Jan 21 20:32:24 2021
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 548bb762 - correct
         Events : 728221
                      
         Layout : left-symmetric
     Chunk Size : 512K
                      
   Device Role : Active device 0
   Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
# mdadm -E /dev/sdd
/dev/sdd:             
          Magic : a92b4efc
        Version : 1.2 
    Feature Map : 0x6d
     Array UUID : 7f289c7a:570e2f7e:2ac6f909:03b3970f
           Name : rack-server-1:1  (local to host rack-server-1)
  Creation Time : Sat Apr 29 16:21:11 2017
     Raid Level : raid6
   Raid Devices : 8
 
 Avail Dev Size : 19532750848 (9313.94 GiB 10000.77 GB)
     Array Size : 58597880832 (55883.29 GiB 60004.23 GB)
  Used Dev Size : 19532626944 (9313.88 GiB 10000.70 GB)
    Data Offset : 122880 sectors
     New Offset : 246784 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : dacf8c2f:2ac8cc48:bffc9d56:7972d688

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 34764794880 (33154.29 GiB 35599.15 GB)
     New Layout : left-symmetric-6

    Update Time : Thu Jan 21 20:32:24 2021
  Bad Block Log : 512 entries available at offset 32 sectors - bad blocks present.
       Checksum : 20ba90bb - correct
         Events : 728221
         
         Layout : left-symmetric
     Chunk Size : 512K
   
   Device Role : Active device 1
   Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
# mdadm -E /dev/sde
/dev/sde:             
          Magic : a92b4efc
        Version : 1.2 
    Feature Map : 0x6d
     Array UUID : 7f289c7a:570e2f7e:2ac6f909:03b3970f
           Name : rack-server-1:1  (local to host rack-server-1)
  Creation Time : Sat Apr 29 16:21:11 2017
     Raid Level : raid6
   Raid Devices : 8   
                      
 Avail Dev Size : 19532750848 (9313.94 GiB 10000.77 GB)
     Array Size : 58597880832 (55883.29 GiB 60004.23 GB)
  Used Dev Size : 19532626944 (9313.88 GiB 10000.70 GB)
    Data Offset : 122880 sectors
     New Offset : 246784 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 75d3620a:217dde9d:3fcb7674:a67e7c6d
                      
Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 34764794880 (33154.29 GiB 35599.15 GB)
     New Layout : left-symmetric-6
                      
    Update Time : Thu Jan 21 20:32:24 2021
  Bad Block Log : 512 entries available at offset 32 sectors - bad blocks present.
       Checksum : 532123f7 - correct
         Events : 728221
                      
         Layout : left-symmetric
     Chunk Size : 512K
                      
   Device Role : Active device 4
   Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
# mdadm -E /dev/sdf
/dev/sdf: 
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x6d
     Array UUID : 7f289c7a:570e2f7e:2ac6f909:03b3970f
           Name : rack-server-1:1  (local to host rack-server-1)
  Creation Time : Sat Apr 29 16:21:11 2017
     Raid Level : raid6
   Raid Devices : 8
 
 Avail Dev Size : 19532750848 (9313.94 GiB 10000.77 GB)
     Array Size : 58597880832 (55883.29 GiB 60004.23 GB)
  Used Dev Size : 19532626944 (9313.88 GiB 10000.70 GB)
    Data Offset : 122880 sectors
     New Offset : 246784 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : b2cde04d:40390ca1:a1fa2881:c935cf6e

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 34764794880 (33154.29 GiB 35599.15 GB)
     New Layout : left-symmetric-6

    Update Time : Thu Jan 21 20:32:24 2021
  Bad Block Log : 512 entries available at offset 32 sectors - bad blocks present.
       Checksum : a7d1c0da - correct
         Events : 728221
         
         Layout : left-symmetric
     Chunk Size : 512K
                      
   Device Role : Active device 2
   Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
# mdadm -E /dev/sdg
/dev/sdg: 
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x67
     Array UUID : 7f289c7a:570e2f7e:2ac6f909:03b3970f
           Name : rack-server-1:1  (local to host rack-server-1)
  Creation Time : Sat Apr 29 16:21:11 2017
     Raid Level : raid6
   Raid Devices : 8
 
 Avail Dev Size : 19532750848 (9313.94 GiB 10000.77 GB)
     Array Size : 58597880832 (55883.29 GiB 60004.23 GB)
  Used Dev Size : 19532626944 (9313.88 GiB 10000.70 GB)
    Data Offset : 122880 sectors
     New Offset : 246784 sectors
   Super Offset : 8 sectors
Recovery Offset : 11588264960 sectors
          State : active
    Device UUID : 0b77c5b3:20d7c3da:caa01e02:ac272a74

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 34764794880 (33154.29 GiB 35599.15 GB)
     New Layout : left-symmetric-6
                      
    Update Time : Thu Jan 21 20:32:24 2021
  Bad Block Log : 512 entries available at offset 32 sectors
       Checksum : 80829a4e - correct
         Events : 728221
                      
         Layout : left-symmetric
     Chunk Size : 512K
                      
   Device Role : Active device 7
   Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
# mdadm -E /dev/sdh
/dev/sdh: 
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x65
     Array UUID : 7f289c7a:570e2f7e:2ac6f909:03b3970f
           Name : rack-server-1:1  (local to host rack-server-1)
  Creation Time : Sat Apr 29 16:21:11 2017
     Raid Level : raid6
   Raid Devices : 8
 
 Avail Dev Size : 19532750848 (9313.94 GiB 10000.77 GB)
     Array Size : 58597880832 (55883.29 GiB 60004.23 GB)
  Used Dev Size : 19532626944 (9313.88 GiB 10000.70 GB)
    Data Offset : 122880 sectors
     New Offset : 246784 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 4ab47b40:029385ad:0bf5192e:eaee4627

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 34764794880 (33154.29 GiB 35599.15 GB)
     New Layout : left-symmetric-6

    Update Time : Thu Jan 21 20:32:24 2021
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : c5bcb0a - correct
         Events : 728221
                      
         Layout : left-symmetric
     Chunk Size : 512K
                      
   Device Role : Active device 3
   Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

(USB stick is sda)

# mdadm --detail /dev/mdN
/dev/md0:         
           Version : 1.2
     Creation Time : Sat Apr 29 16:21:11 2017
        Raid Level : raid6
        Array Size : 58597880832 (55883.29 GiB 60004.23 GB)
     Used Dev Size : 9766313472 (9313.88 GiB 10000.70 GB)
      Raid Devices : 8
     Total Devices : 8
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Thu Jan 21 20:32:24 2021
             State : clean, degraded, reshaping 
    Active Devices : 7
   Working Devices : 8
    Failed Devices : 0
     Spare Devices : 1

            Layout : left-symmetric-6
        Chunk Size : 512K

Consistency Policy : bitmap

    Reshape Status : 59% complete
        New Layout : left-symmetric

              Name : rack-server-1:1  (local to host rack-server-1)
              UUID : 7f289c7a:570e2f7e:2ac6f909:03b3970f
            Events : 728221

    Number   Major   Minor   RaidDevice State
       8       8       48        0      active sync   /dev/sdd
      13       8       64        1      active sync   /dev/sde
      12       8       96        2      active sync   /dev/sdg
       7       8      128        3      active sync   /dev/sdi
      10       8       80        4      active sync   /dev/sdf
       9       8       16        5      active sync   /dev/sdb
      11       8       32        6      active sync   /dev/sdc
      14       8      112        7      spare rebuilding   /dev/sdh

(USB stick is sdi)

# python2 lsdrv 
Creating device for node 8:131 ...
Creating device for node 8:129 ...
PCI [nvme] 01:00.0 Non-Volatile memory controller: Intel Corporation PCIe Data Center SSD (rev 01)
└nvme nvme0 INTEL SSDPEDMW400G4                      {CVCQ51610002400AGN}
 └nvme0n1 372.61g [259:0] Partitioned (dos)
  ├nvme0n1p1 120.00g [259:1] ext4 {eb94342f-2eea-4318-9f79-3517ae1ccaad}
  │└Mounted as /dev/nvme0n1p1 @ /
  └nvme0n1p2 16.00g [259:2] swap {7480b481-814b-4a09-851c-facfe01500ab}
   └dm-0 16.00g [253:0] swap {87872cce-8f64-4e57-b247-7c7307b70f4e}
PCI [ahci] 00:17.0 SATA controller: Intel Corporation Q170/Q150/B150/H170/H110/Z170/CM236 Chipset SATA Controller [AHCI Mode] (rev 31)
├scsi 0:0:0:0 ATA      WDC WD100EFAX-68 {JEGK2KAN}
│└sda 9.10t [8:0] None
│ ├dm-1 9.10t [253:1] MD raid6 (5/8) (w/ dm-6,dm-4,dm-2,dm-7,dm-5,dm-3) in_sync 'rack-server-1:0' {c520f082-6505-5fda-a0fe-c928f0e73897}
│ │└md0 54.57t [9:0] MD v1.2 raid6 (8) clean DEGRADED, 512k Chunk {c520f082:65055fda:a0fec928:f0e73897}
│ │ │                Empty/Unknown
│ │ └dm-15 54.57t [253:15] ext4 'storage' {345ec7b8-b523-45d3-8c2e-35cda1ab62c1}
│ │  └Mounted as /dev/mapper/joined @ /mnt/1
│ └dm-8 9.10t [253:8] MD raid6 (5/8) (w/ dm-10,dm-13,dm-11,dm-9,dm-14,dm-12) in_sync 'rack-server-1:1' {295f6051-64a1-46d2-159a-da73db3423ab}
│  └md1 54.57t [9:1] MD v1.2 raid6 (8) clean DEGRADED, 512k Chunk {295f6051:64a146d2:159ada73:db3423ab}
│   │                ext4 'storage' {345ec7b8-b523-45d3-8c2e-35cda1ab62c1}
│   └dm-15 54.57t [253:15] ext4 'storage' {345ec7b8-b523-45d3-8c2e-35cda1ab62c1}
├scsi 1:0:0:0 ATA      WDC WD100EFAX-68 {1SG7363Z}
│└sdb 9.10t [8:16] None
│ ├dm-2 9.10t [253:2] MD raid6 (6/8) (w/ dm-1,dm-6,dm-4,dm-7,dm-5,dm-3) in_sync 'rack-server-1:0' {c520f082-6505-5fda-a0fe-c928f0e73897}
│ │└md0 54.57t [9:0] MD v1.2 raid6 (8) clean DEGRADED, 512k Chunk {c520f082:65055fda:a0fec928:f0e73897}
│ │                  Empty/Unknown
│ └dm-9 9.10t [253:9] MD raid6 (6/8) (w/ dm-10,dm-8,dm-13,dm-11,dm-14,dm-12) in_sync 'rack-server-1:1' {295f6051-64a1-46d2-159a-da73db3423ab}
│  └md1 54.57t [9:1] MD v1.2 raid6 (8) clean DEGRADED, 512k Chunk {295f6051:64a146d2:159ada73:db3423ab}
│                    ext4 'storage' {345ec7b8-b523-45d3-8c2e-35cda1ab62c1}
├scsi 2:0:0:0 ATA      WDC WD100EFAX-68 {2TKYUB2D}
│└sdc 9.10t [8:32] None
│ ├dm-3 9.10t [253:3] MD raid6 (0/8) (w/ dm-1,dm-6,dm-4,dm-2,dm-7,dm-5) in_sync 'rack-server-1:0' {c520f082-6505-5fda-a0fe-c928f0e73897}
│ │└md0 54.57t [9:0] MD v1.2 raid6 (8) clean DEGRADED, 512k Chunk {c520f082:65055fda:a0fec928:f0e73897}
│ │                  Empty/Unknown
│ └dm-10 9.10t [253:10] MD raid6 (0/8) (w/ dm-8,dm-13,dm-11,dm-9,dm-14,dm-12) in_sync 'rack-server-1:1' {295f6051-64a1-46d2-159a-da73db3423ab}
│  └md1 54.57t [9:1] MD v1.2 raid6 (8) clean DEGRADED, 512k Chunk {295f6051:64a146d2:159ada73:db3423ab}
│                    ext4 'storage' {345ec7b8-b523-45d3-8c2e-35cda1ab62c1}
├scsi 3:0:0:0 ATA      WDC WD100EFAX-68 {JEJRAT3N}
│└sdd 9.10t [8:48] None
│ ├dm-4 9.10t [253:4] MD raid6 (1/8) (w/ dm-1,dm-6,dm-2,dm-7,dm-5,dm-3) in_sync 'rack-server-1:0' {c520f082-6505-5fda-a0fe-c928f0e73897}
│ │└md0 54.57t [9:0] MD v1.2 raid6 (8) clean DEGRADED, 512k Chunk {c520f082:65055fda:a0fec928:f0e73897}
│ │                  Empty/Unknown
│ └dm-11 9.10t [253:11] MD raid6 (1/8) (w/ dm-10,dm-8,dm-13,dm-9,dm-14,dm-12) in_sync 'rack-server-1:1' {295f6051-64a1-46d2-159a-da73db3423ab}
│  └md1 54.57t [9:1] MD v1.2 raid6 (8) clean DEGRADED, 512k Chunk {295f6051:64a146d2:159ada73:db3423ab}
│                    ext4 'storage' {345ec7b8-b523-45d3-8c2e-35cda1ab62c1}
├scsi 4:0:0:0 ATA      WDC WD100EFAX-68 {2YJB2MHD}
│└sde 9.10t [8:64] None
│ ├dm-5 9.10t [253:5] MD raid6 (4/8) (w/ dm-1,dm-6,dm-4,dm-2,dm-7,dm-3) in_sync 'rack-server-1:0' {c520f082-6505-5fda-a0fe-c928f0e73897}
│ │└md0 54.57t [9:0] MD v1.2 raid6 (8) clean DEGRADED, 512k Chunk {c520f082:65055fda:a0fec928:f0e73897}
│ │                  Empty/Unknown
│ └dm-12 9.10t [253:12] MD raid6 (4/8) (w/ dm-10,dm-8,dm-13,dm-11,dm-9,dm-14) in_sync 'rack-server-1:1' {295f6051-64a1-46d2-159a-da73db3423ab}
│  └md1 54.57t [9:1] MD v1.2 raid6 (8) clean DEGRADED, 512k Chunk {295f6051:64a146d2:159ada73:db3423ab}
│                    ext4 'storage' {345ec7b8-b523-45d3-8c2e-35cda1ab62c1}
├scsi 5:0:0:0 ATA      WDC WD100EFAX-68 {JEJW1TLN}
│└sdf 9.10t [8:80] None
│ ├dm-6 9.10t [253:6] MD raid6 (2/8) (w/ dm-1,dm-4,dm-2,dm-7,dm-5,dm-3) in_sync 'rack-server-1:0' {c520f082-6505-5fda-a0fe-c928f0e73897}
│ │└md0 54.57t [9:0] MD v1.2 raid6 (8) clean DEGRADED, 512k Chunk {c520f082:65055fda:a0fec928:f0e73897}
│ │                  Empty/Unknown
│ └dm-13 9.10t [253:13] MD raid6 (2/8) (w/ dm-10,dm-8,dm-11,dm-9,dm-14,dm-12) in_sync 'rack-server-1:1' {295f6051-64a1-46d2-159a-da73db3423ab}
│  └md1 54.57t [9:1] MD v1.2 raid6 (8) clean DEGRADED, 512k Chunk {295f6051:64a146d2:159ada73:db3423ab}
│                    ext4 'storage' {345ec7b8-b523-45d3-8c2e-35cda1ab62c1}
├scsi 6:0:0:0 ATA      WDC WD100EFAX-68 {JEHRV47N}
│└sdg 9.10t [8:96] ext4 {e3a28a0b-46c9-4cf4-8bfa-0688dde1bf8d}
│ └Mounted as /dev/sdg @ /mnt/1
└scsi 7:0:0:0 ATA      WDC WD100EFAX-68 {2TK3JVUD}
 └sdh 9.10t [8:112] None
  ├dm-7 9.10t [253:7] MD raid6 (3/8) (w/ dm-1,dm-6,dm-4,dm-2,dm-5,dm-3) in_sync 'rack-server-1:0' {c520f082-6505-5fda-a0fe-c928f0e73897}
  │└md0 54.57t [9:0] MD v1.2 raid6 (8) clean DEGRADED, 512k Chunk {c520f082:65055fda:a0fec928:f0e73897}
  │                  Empty/Unknown
  └dm-14 9.10t [253:14] MD raid6 (3/8) (w/ dm-10,dm-8,dm-13,dm-11,dm-9,dm-12) in_sync 'rack-server-1:1' {295f6051-64a1-46d2-159a-da73db3423ab}
   └md1 54.57t [9:1] MD v1.2 raid6 (8) clean DEGRADED, 512k Chunk {295f6051:64a146d2:159ada73:db3423ab}
                     ext4 'storage' {345ec7b8-b523-45d3-8c2e-35cda1ab62c1}
USB [usb-storage] Bus 001 Device 003: ID 0781:5567 SanDisk Corp. Cruzer Blade {2005224340054080F2CD}
└scsi 8:0:0:0 SanDisk  Cruzer Blade     {2005224340054080F2CD}
 └sdi 3.73g [8:128] Partitioned (dos) 'Kali_Live' {2018-04-12-11-04-09-00}
  ├sdi1 863.97m [8:129] iso9660 'Kali_Live' {2018-04-12-11-04-09-00}
  ├sdi2 704.00k [8:130] vfat {7D9D-6DD1}
  └sdi3 2.88g [8:131] ext3 'persistence' {c02d7a36-8272-4d19-8751-cd5a3f57cef2}
Other Block Devices
├loop0 9.10t [7:0] DM_snapshot_cow
│└dm-1 9.10t [253:1] MD raid6 (5/8) (w/ dm-6,dm-4,dm-2,dm-7,dm-5,dm-3) in_sync 'rack-server-1:0' {c520f082-6505-5fda-a0fe-c928f0e73897}
├loop1 9.10t [7:1] Empty/Unknown
│└dm-2 9.10t [253:2] MD raid6 (6/8) (w/ dm-1,dm-6,dm-4,dm-7,dm-5,dm-3) in_sync 'rack-server-1:0' {c520f082-6505-5fda-a0fe-c928f0e73897}
├loop2 9.10t [7:2] Empty/Unknown
│└dm-3 9.10t [253:3] MD raid6 (0/8) (w/ dm-1,dm-6,dm-4,dm-2,dm-7,dm-5) in_sync 'rack-server-1:0' {c520f082-6505-5fda-a0fe-c928f0e73897}
├loop3 9.10t [7:3] Empty/Unknown
│└dm-4 9.10t [253:4] MD raid6 (1/8) (w/ dm-1,dm-6,dm-2,dm-7,dm-5,dm-3) in_sync 'rack-server-1:0' {c520f082-6505-5fda-a0fe-c928f0e73897}
├loop4 9.10t [7:4] Empty/Unknown
│└dm-5 9.10t [253:5] MD raid6 (4/8) (w/ dm-1,dm-6,dm-4,dm-2,dm-7,dm-3) in_sync 'rack-server-1:0' {c520f082-6505-5fda-a0fe-c928f0e73897}
├loop5 9.10t [7:5] Empty/Unknown
│└dm-6 9.10t [253:6] MD raid6 (2/8) (w/ dm-1,dm-4,dm-2,dm-7,dm-5,dm-3) in_sync 'rack-server-1:0' {c520f082-6505-5fda-a0fe-c928f0e73897}
├loop6 9.10t [7:6] Empty/Unknown
│└dm-7 9.10t [253:7] MD raid6 (3/8) (w/ dm-1,dm-6,dm-4,dm-2,dm-5,dm-3) in_sync 'rack-server-1:0' {c520f082-6505-5fda-a0fe-c928f0e73897}
├loop7 9.10t [7:7] Empty/Unknown
│└dm-8 9.10t [253:8] MD raid6 (5/8) (w/ dm-10,dm-13,dm-11,dm-9,dm-14,dm-12) in_sync 'rack-server-1:1' {295f6051-64a1-46d2-159a-da73db3423ab}
├loop8 9.10t [7:8] Empty/Unknown
│└dm-9 9.10t [253:9] MD raid6 (6/8) (w/ dm-10,dm-8,dm-13,dm-11,dm-14,dm-12) in_sync 'rack-server-1:1' {295f6051-64a1-46d2-159a-da73db3423ab}
├loop9 9.10t [7:9] Empty/Unknown
│└dm-10 9.10t [253:10] MD raid6 (0/8) (w/ dm-8,dm-13,dm-11,dm-9,dm-14,dm-12) in_sync 'rack-server-1:1' {295f6051-64a1-46d2-159a-da73db3423ab}
├loop10 9.10t [7:10] Empty/Unknown
│└dm-11 9.10t [253:11] MD raid6 (1/8) (w/ dm-10,dm-8,dm-13,dm-9,dm-14,dm-12) in_sync 'rack-server-1:1' {295f6051-64a1-46d2-159a-da73db3423ab}
├loop11 9.10t [7:11] Empty/Unknown
│└dm-12 9.10t [253:12] MD raid6 (4/8) (w/ dm-10,dm-8,dm-13,dm-11,dm-9,dm-14) in_sync 'rack-server-1:1' {295f6051-64a1-46d2-159a-da73db3423ab}
├loop12 9.10t [7:12] Empty/Unknown
│└dm-13 9.10t [253:13] MD raid6 (2/8) (w/ dm-10,dm-8,dm-11,dm-9,dm-14,dm-12) in_sync 'rack-server-1:1' {295f6051-64a1-46d2-159a-da73db3423ab}
├loop13 9.10t [7:13] Empty/Unknown
│└dm-14 9.10t [253:14] MD raid6 (3/8) (w/ dm-10,dm-8,dm-13,dm-11,dm-9,dm-12) in_sync 'rack-server-1:1' {295f6051-64a1-46d2-159a-da73db3423ab}
└loop14 0.00k [7:14] Empty/Unknown

(when system was stalled)

$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md0 : active raid6 sdd[8] sdh[14] sdc[11] sdb[9] sdf[10] sdi[7] sdg[12] sde[13]
      58597880832 blocks super 1.2 level 6, 512k chunk, algorithm 18 [8/7] [UUUUUUU_]
      [===========>.........]  reshape = 59.3% (5794184856/9766313472) finish=168083.4min speed=393K/sec
      bitmap: 26/37 pages [104KB], 131072KB chunk

unused devices: <none>

(right now)

$ cat /proc/mdstat 
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md1 : active raid6 dm-9[6] dm-8[5] dm-12[4] dm-14[3] dm-13[2] dm-11[1] dm-10[0]
      58597880832 blocks super 1.2 level 6, 512k chunk, algorithm 2 [8/7] [UUUUUUU_]
      bitmap: 11/73 pages [44KB], 65536KB chunk

md0 : active raid6 dm-2[6] dm-1[5] dm-5[4] dm-7[3] dm-6[2] dm-4[1] dm-3[0]
      58597880832 blocks super 1.2 level 6, 512k chunk, algorithm 18 [8/7] [UUUUUUU_]
      bitmap: 7/73 pages [28KB], 65536KB chunk

unused devices: <none>

Best regards
Patrik Dahlström
