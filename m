Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CEC0C433E0
	for <linux-raid@archiver.kernel.org>; Mon,  8 Mar 2021 16:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A9326521F
	for <linux-raid@archiver.kernel.org>; Mon,  8 Mar 2021 16:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhCHQn1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 Mar 2021 11:43:27 -0500
Received: from vps.thesusis.net ([34.202.238.73]:56926 "EHLO vps.thesusis.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229463AbhCHQnR (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 8 Mar 2021 11:43:17 -0500
Received: from localhost (localhost [127.0.0.1])
        by vps.thesusis.net (Postfix) with ESMTP id 0432A25474
        for <linux-raid@vger.kernel.org>; Mon,  8 Mar 2021 11:43:17 -0500 (EST)
Received: from vps.thesusis.net ([IPv6:::1])
        by localhost (vps.thesusis.net [IPv6:::1]) (amavisd-new, port 10024)
        with ESMTP id VW03yKNpiT-2 for <linux-raid@vger.kernel.org>;
        Mon,  8 Mar 2021 11:43:16 -0500 (EST)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 96F312546D; Mon,  8 Mar 2021 11:43:16 -0500 (EST)
References: <87tuq7g5rp.fsf@vps.thesusis.net>
User-agent: mu4e 1.5.7; emacs 26.3
From:   Phillip Susi <phill@thesusis.net>
To:     linux-raid@vger.kernel.org
Subject: Re: Raid10 reshape bug
Date:   Mon, 08 Mar 2021 11:39:40 -0500
In-reply-to: <87tuq7g5rp.fsf@vps.thesusis.net>
Message-ID: <87ft158ul7.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


So it turns out all you have to do to trigger a bug is:

mdadm --create -l raid10 -n 2 /dev/md1 /dev/loop0 missing
mdadm -G /dev/md1 -p o2

After changing the layout to offset, attemting to mkfs.ext4 on the raid
device results in errors and this in dmesg:

[1467312.410811] md: md1: reshape done.
[1467386.790079] handle_bad_sector: 446 callbacks suppressed
[1467386.790083] attempt to access beyond end of device
                 dm-3: rw=0, want=2127992, limit=2097152
[1467386.790096] attempt to access beyond end of device
                 dm-3: rw=0, want=2127992, limit=2097152
[1467386.790099] buffer_io_error: 2062 callbacks suppressed
[1467386.790101] Buffer I/O error on dev md1, logical block 4238, async page read
[1467386.793270] attempt to access beyond end of device
                 dm-3: rw=0, want=2127992, limit=2097152
[1467386.793277] Buffer I/O error on dev md1, logical block 4238, async page read
[1467394.422528] attempt to access beyond end of device
                 dm-3: rw=0, want=4187016, limit=2097152
[1467394.422541] attempt to access beyond end of device
                 dm-3: rw=0, want=4187016, limit=2097152
[1467394.422545] Buffer I/O error on dev md1, logical block 261616, async page read

/dev/md1:
           Version : 1.2
     Creation Time : Mon Mar  8 11:21:23 2021
        Raid Level : raid10
        Array Size : 1046528 (1022.00 MiB 1071.64 MB)
     Used Dev Size : 1046528 (1022.00 MiB 1071.64 MB)
      Raid Devices : 2
     Total Devices : 1
       Persistence : Superblock is persistent

       Update Time : Mon Mar  8 11:24:10 2021
             State : clean, degraded
    Active Devices : 1
   Working Devices : 1
    Failed Devices : 0
     Spare Devices : 0

            Layout : offset=2
        Chunk Size : 512K

Consistency Policy : resync

              Name : hyper1:1  (local to host hyper1)
              UUID : 69618fc3:c6abd8de:8458d647:1c242e1a
            Events : 3409

    Number   Major   Minor   RaidDevice State
       0     253        3        0      active sync   /dev/dm-3
       -       0        0        1      removed

/dev/hyper1/leg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 69618fc3:c6abd8de:8458d647:1c242e1a
           Name : hyper1:1  (local to host hyper1)
  Creation Time : Mon Mar  8 11:21:23 2021
     Raid Level : raid10
   Raid Devices : 2

 Avail Dev Size : 2095104 (1023.00 MiB 1072.69 MB)
     Array Size : 1046528 (1022.00 MiB 1071.64 MB)
  Used Dev Size : 2093056 (1022.00 MiB 1071.64 MB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=2048 sectors
          State : clean
    Device UUID : 476f8e72:76084630:c33c16e4:7c987659

    Update Time : Mon Mar  8 11:24:10 2021
  Bad Block Log : 512 entries available at offset 16 sectors
       Checksum : e5995957 - correct
         Events : 3409

         Layout : offset=2
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : A. ('A' == active, '.' == missing, 'R' == replacing)


Phillip Susi writes:

> In the process of upgrading a xen server I broke the previous raid1 and
> used the removed disk to create a new raid10 to prepare the new install.
> I think initially I created it in the default near configuration, so I
> reshaped it to offset with 1M chunk size.  I got the domUs up and
> running again and was pretty happy with the result, so I blew away the
> old system disk and added that disk to the new array and allowed it to
> sync.  Then I thought that the 1M chunk size was hurting performance, so
> I requested a reshape to a 256k chunk size with mdadm -G /dev/md0 -c
> 256.  It looked like it was proceeding fine so I went home for the
> night.
>
> When I came in this morming, mdadm -D showed that the reshape was
> complete, but I started getting ELF errors and such running various
> programs and I started to get a feeling that something had gone horribly
> wrong.  At one point I was trying to run blockdev --getsz and isntead
> the system somehow ran findmnt.  mdadm -E showed that there was a very
> large unused section of the disk both before and after.  This is
> probably because I had used -s to restrict the used size of the device
> to be only 256g instead of the full 2tb so it wouldn't take so long to
> resync, and since there was plenty of unused space, md decided to just
> write back the new layout stripes in unused space further down the disk.
> At this point I rebooted and grub could not recognize the filesystem.  I
> booted other media and tried an e2fsck but it had so many complaints,
> one of which being that the root directory was not, in fact, a directory
> so it deleted it that I just gave up and started reinstalling and
> restoring the domU from backup.
>
> Clearly somehow the reshape process did NOT write the data back to the
> disk in the correct place.  This was using debian testing with linux
> 5.10.0 and mdadm v4.1.
>
> I will try to reproduce it in a vm at some point.

