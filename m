Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E18CC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 22:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240840AbhLJWin (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Dec 2021 17:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236537AbhLJWim (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 10 Dec 2021 17:38:42 -0500
X-Greylist: delayed 588 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 10 Dec 2021 14:35:06 PST
Received: from box.sotapeli.fi (sotapeli.fi [IPv6:2001:41d0:302:2200::1c0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5B1C061746
        for <linux-raid@vger.kernel.org>; Fri, 10 Dec 2021 14:35:06 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id ACD1E7E726
        for <linux-raid@vger.kernel.org>; Fri, 10 Dec 2021 23:25:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sotapeli.fi; s=dkim;
        t=1639175115; h=from:subject:date:message-id:to:mime-version:content-type:
         content-transfer-encoding; bh=hR/mh2/21CMtWbl6afLxw0+qpjxPWDxKT8ceLTGC4g4=;
        b=bVgTX/eyJtvmBgGfJoe47vpzND0QZLdMF7LobgARWfoH/eEyzbz44cpHRJct+wMd1xAHTq
        zcbN/MXaHvBrtsZzIvsLjPx3IMOuRF+A6AiyxH+c1gyBkkhBPhvBL0UaSBRhZT3YT/cZfD
        ZR0yFcJoyF3cleNGGuzRZ1oeopRQjhS9f72RhKDT0hfcosd2M0UFyTObyDU65uAM8mIN/a
        96QmfY5bCfAHrrqlHdGyvBN8TGuTNPoTtt4jkXQNKjzu7K2WcIGTlvk0Rv+RDsBQ3iymXM
        sO7jXdIY6GZZDs4I+Wy49JxqDF5MclTrRu6A5GC43gabmRrpqoRPe5FJRrzX3A==
Message-ID: <e349ad6a-f5f7-df22-9753-bca4605e561d@sotapeli.fi>
Date:   Sat, 11 Dec 2021 00:25:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
To:     linux-raid@vger.kernel.org
From:   Jani Partanen <jiipee@sotapeli.fi>
Subject: Strange behavior when I grow raid0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

I recently migrated from btrfs raid-5 to md raid-5 and because I didn't 
have enough drives to go directly md raid-5, I basicly did this:
- 2 disks raid-0
- added 3rd disk with grow when I had moved data, still raid-0
- added 4th disk with grow when I had moved more data, still raid-0
- added 5th disk with grow and converted to raid-5

Everything went fine other than I could not add internal bitmap because 
array was created as raid-0 originally but thats not an issue, I'll 
store bitmap to my /boot, it's raid-1 on SSD and ext4.

Today I noticed that my array parity layout is parity-last and I started 
to wonder why is that, then I did remember that there was some strange 
things happening when I did add 4th drive and I made testing and was 
able to replicate what happened.

[root@nas ~]# mdadm -C /dev/md/testraid -l 0 -n 2 -N testraid 
/dev/loop21 /dev/loop22
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md/testraid started.


[root@nas ~]# mdadm -D /dev/md/testraid
/dev/md/testraid:
            Version : 1.2
      Creation Time : Fri Dec 10 22:52:01 2021
         Raid Level : raid0
         Array Size : 98304 (96.00 MiB 100.66 MB)
       Raid Devices : 2
      Total Devices : 2
        Persistence : Superblock is persistent

        Update Time : Fri Dec 10 22:52:01 2021
              State : clean
     Active Devices : 2
    Working Devices : 2
     Failed Devices : 0
      Spare Devices : 0

             Layout : -unknown-
         Chunk Size : 512K

Consistency Policy : none

               Name : nas:testraid  (local to host nas)
               UUID : b6e0c60a:da4c6fb1:9dc5ff07:adeda371
             Events : 0

     Number   Major   Minor   RaidDevice State
        0       7       21        0      active sync   /dev/loop21
        1       7       22        1      active sync   /dev/loop22


[root@nas ~]# mdadm --grow /dev/md/testraid -n 3 -l 0 --add /dev/loop23
mdadm: level of /dev/md/testraid changed to raid4
mdadm: added /dev/loop23


[root@nas ~]# mdadm -D /dev/md/testraid
/dev/md/testraid:
            Version : 1.2
      Creation Time : Fri Dec 10 22:52:01 2021
         Raid Level : raid0
         Array Size : 147456 (144.00 MiB 150.99 MB)
       Raid Devices : 3
      Total Devices : 3
        Persistence : Superblock is persistent

        Update Time : Fri Dec 10 22:53:33 2021
              State : clean
     Active Devices : 3
    Working Devices : 3
     Failed Devices : 0
      Spare Devices : 0

         Chunk Size : 512K

Consistency Policy : none

               Name : nas:testraid  (local to host nas)
               UUID : b6e0c60a:da4c6fb1:9dc5ff07:adeda371
             Events : 18

     Number   Major   Minor   RaidDevice State
        0       7       21        0      active sync   /dev/loop21
        1       7       22        1      active sync   /dev/loop22
        3       7       23        2      active sync   /dev/loop23


[root@nas ~]# mdadm --grow /dev/md/testraid -n 4 -l 0 --add /dev/loop24
mdadm: level of /dev/md/testraid changed to raid4
mdadm: added /dev/loop24
mdadm: Need to backup 6144K of critical section..


[root@nas ~]# mdadm -D /dev/md/testraid
/dev/md/testraid:
            Version : 1.2
      Creation Time : Fri Dec 10 22:52:01 2021
         Raid Level : raid4
         Array Size : 196608 (192.00 MiB 201.33 MB)
      Used Dev Size : 49152 (48.00 MiB 50.33 MB)
       Raid Devices : 5
      Total Devices : 4
        Persistence : Superblock is persistent

        Update Time : Fri Dec 10 22:59:56 2021
              State : clean, degraded
     Active Devices : 4
    Working Devices : 4
     Failed Devices : 0
      Spare Devices : 0

         Chunk Size : 512K

Consistency Policy : resync

               Name : nas:testraid  (local to host nas)
               UUID : b6e0c60a:da4c6fb1:9dc5ff07:adeda371
             Events : 39

     Number   Major   Minor   RaidDevice State
        0       7       21        0      active sync   /dev/loop21
        1       7       22        1      active sync   /dev/loop22
        3       7       23        2      active sync   /dev/loop23
        4       7       24        3      active sync   /dev/loop24
        -       0        0        4      removed


[root@nas ~]# mdadm --grow /dev/md/testraid -n 5 -l 5 --add /dev/loop25
mdadm: level of /dev/md/testraid changed to raid5
mdadm: added /dev/loop25


[root@nas ~]# mdadm -D /dev/md/testraid
/dev/md/testraid:
            Version : 1.2
      Creation Time : Fri Dec 10 22:52:01 2021
         Raid Level : raid5
         Array Size : 196608 (192.00 MiB 201.33 MB)
      Used Dev Size : 49152 (48.00 MiB 50.33 MB)
       Raid Devices : 5
      Total Devices : 5
        Persistence : Superblock is persistent

        Update Time : Fri Dec 10 23:00:39 2021
              State : clean
     Active Devices : 5
    Working Devices : 5
     Failed Devices : 0
      Spare Devices : 0

             Layout : parity-last
         Chunk Size : 512K

Consistency Policy : resync

               Name : nas:testraid  (local to host nas)
               UUID : b6e0c60a:da4c6fb1:9dc5ff07:adeda371
             Events : 59

     Number   Major   Minor   RaidDevice State
        0       7       21        0      active sync   /dev/loop21
        1       7       22        1      active sync   /dev/loop22
        3       7       23        2      active sync   /dev/loop23
        4       7       24        3      active sync   /dev/loop24
        5       7       25        4      active sync   /dev/loop25


Notice how array stay at raid4 degraded after I add 4th drive. Why is 
this happening? It doesn't happen when I added 3rd drive, it did reshape 
it through raid-4 but when it was finished it returned raid-0.

I also did another test where I made extra step after adding 4th disk:

[root@nas ~]# mdadm --grow /dev/md/testraid -n 4 -l 0
mdadm: level of /dev/md/testraid changed to raid0
[root@nas ~]# cat /proc/mdstat
Personalities : [raid1] [raid0] [linear] [raid6] [raid5] [raid4]
md118 : active raid0 loop24[4] loop23[3] loop22[1] loop21[0]
       196608 blocks super 1.2 512k chunks


And when I did add 5th drive and converted array to raid-5, it correctly 
defaults layout to left-symmetric.

Is this some sort of bug or working as intented? Also why is this "Need 
to backup 6144K of critical section.." happening when I add 4th disk but 
not when I add 3rd disk?


distro: Fedora 35
kernel:  5.15.6
mdadm:  v4.2-rc2


// JiiPee
