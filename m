Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 326A4C433DB
	for <linux-raid@archiver.kernel.org>; Wed,  3 Feb 2021 06:08:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD63E64DF4
	for <linux-raid@archiver.kernel.org>; Wed,  3 Feb 2021 06:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbhBCGIj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 3 Feb 2021 01:08:39 -0500
Received: from mail-40140.protonmail.ch ([185.70.40.140]:19696 "EHLO
        mail-40140.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbhBCGIi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 3 Feb 2021 01:08:38 -0500
Date:   Wed, 03 Feb 2021 06:07:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1612332472;
        bh=h0TD2elYV+UOb4YFu/GA3YVcgXd+M9EjEeq3X16+X/Q=;
        h=Date:To:From:Reply-To:Subject:From;
        b=WH6PQfGSgZfwQQKyAQUYIOHlJaoKon3/UHIVSe7Yma878uotzQU7HNDHFP+SR32sa
         afZxKdb4P/XBL06j4MMW/+sHrJKHV7CVXNFewiA3eHqzKcAtmlJC6fN3SZxc/iaoio
         7B1wDjAyZKNWhSAfyBU0C+sW/hqQ41g2fpxD4SYI=
To:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
From:   importantdata <importantdata@protonmail.com>
Reply-To: importantdata <importantdata@protonmail.com>
Subject: Re: [solved] 3 drive RAID5 with 1 bad drive, 1 drive active but not clean and a single clean drive
Message-ID: <1xVN7rJL7OEF2ZKf4PrEYr8js-QWLWTpjtyYFFo9a67zcH7AhHdQbmfimfB0hSGWYa2YP9DgJYdfd-GzYE_p__TXZU9HZkvkF-YWRCkAExs=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org




Sent with ProtonMail Secure Email.

=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Original Me=
ssage =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90
On Tuesday, February 2, 2021 10:04 PM, importantdata <importantdata@protonm=
ail.com> wrote:

> Hello,
>
> So, I have a bad situation. I run a raid5 array with 3 drives, I noticed =
one had fallen out of the array. I need to setup better monitoring, it turn=
s out this was quite some time ago (back in Nov!). This leaves two drives a=
nd puts me into a bit of a scare. So I decide to move the important data of=
f to a different array. I created a dir in /mnt made a new LVM partition fo=
rmatted it as EXT4 and started syncing stuff over... Kinda forgot to actual=
ly mount it though so all that data was syncing right back into the bad arr=
ay (woops!). Server died this morning, I assume the extra stress may have d=
one something with the drives, or perhaps it filled up root and panicked. I=
n either case I could not boot. Setup a fresh OS on my other raid array and=
 got some tools installed and now I am working on trying to assemble the ba=
d raid array enough to pull out my data. My data is contained within an LVM=
 within the raid array.
>
> I have attached the examine and mdadm of the drives, as you can see ddd h=
as a really old update time. This drive was having lots of i/o errors. So I=
 want to use sde and sdf to assemble a read-only array, assemble the LVM, m=
ount then copy my important data off. They are 185 events different so I as=
sume there will be some slight data corruption. But I am hoping its mostly =
fine and likely part of my bad rsync.
>
> So unfortunately I don't know what mdadm version was used to make this ar=
ray or the OS version as that's all stuck on the dead array. Here is what I=
 am running on my new install I am using to try and recover the data:
> Linux 4.19.0-13-amd64 #1 SMP Debian 4.19.160-2 (2020-11-28) x86_64 GNU/Li=
nux
> mdadm - v4.1 - 2018-10-01
>
> The initial -D looked like this:
>
>     root@kglhost-1:~# mdadm -D /dev/md1
>     /dev/md1:
>                Version : 1.2
>             Raid Level : raid0
>          Total Devices : 3
>            Persistence : Superblock is persistent
>
>                  State : inactive
>        Working Devices : 3
>
>                   Name : blah:1
>                   UUID : fba7c062:e352fa39:fdc09bf9:e21c4617
>                 Events : 18094545
>
>         Number   Major   Minor   RaidDevice
>
>            -       8       82        -        /dev/sdf2
>            -       8       66        -        /dev/sde2
>            -       8       50        -        /dev/sdd2
>
>
> I tried to run the array but that failed:
>
>     # mdadm -o -R  /dev/md1
>     mdadm: failed to start array /dev/md/1: Input/output error
>
>
> In dmesg it says
>
>     [Tue Feb  2 21:14:42 2021] md: kicking non-fresh sdd2 from array!
>     [Tue Feb  2 21:14:42 2021] md: kicking non-fresh sdf2 from array!
>     [Tue Feb  2 21:14:42 2021] md/raid:md1: device sde2 operational as ra=
id disk 1
>     [Tue Feb  2 21:14:42 2021] md/raid:md1: not enough operational device=
s (2/3 failed)
>     [Tue Feb  2 21:14:42 2021] md/raid:md1: failed to run raid set.
>     [Tue Feb  2 21:14:42 2021] md: pers->run() failed ...
>
>
>
> That made the array look like so:
>
>     # mdadm -D /dev/md1
>     /dev/md1:
>                Version : 1.2
>          Creation Time : Thu Jul 30 21:34:20 2015
>             Raid Level : raid5
>          Used Dev Size : 489615360 (466.93 GiB 501.37 GB)
>           Raid Devices : 3
>          Total Devices : 1
>            Persistence : Superblock is persistent
>
>            Update Time : Tue Feb  2 13:55:02 2021
>                  State : active, FAILED, Not Started
>         Active Devices : 1
>        Working Devices : 1
>         Failed Devices : 0
>          Spare Devices : 0
>
>                 Layout : left-symmetric
>             Chunk Size : 512K
>
>     Consistency Policy : unknown
>
>                   Name : blah:1
>                   UUID : fba7c062:e352fa39:fdc09bf9:e21c4617
>                 Events : 18094730
>
>         Number   Major   Minor   RaidDevice State
>            -       0        0        0      removed
>            -       0        0        1      removed
>            -       0        0        2      removed
>
>            -       8       66        1      sync   /dev/sde2
>
>
> I was hoping that assume-clean might be helpful, but seems I can't assemb=
le with that option
>
>     # mdadm --assemble --assume-clean -o  /dev/md1 /dev/sde /dev/sdf
>     mdadm: :option --assume-clean not valid in assemble mode
>
>
> So I tried a more normal assemble but it does not have enough drives to s=
tart the array:
>
>     # mdadm --assemble -o  /dev/md1 /dev/sde2 /dev/sdf2
>     mdadm: /dev/md1 assembled from 1 drive - not enough to start the arra=
y.
>
>
> mdstat looked like this awhile ago:
>
>     Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] =
[raid4] [raid10]
>     md1 : inactive sdf2[2](S) sde2[1](S)
>           979230720 blocks super 1.2
>
>     md2 : active raid5 sdb1[1] sda1[0] sdc1[2]
>           3906764800 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3=
/3] [UUU]
>           bitmap: 1/15 pages [4KB], 65536KB chunk
>
>     md0 : active raid1 sde1[4]
>           242624 blocks super 1.0 [3/1] [_U_]
>
>     unused devices: <none>
>
>
>
> Now it looks like so
>
>     Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] =
[raid4] [raid10]
>     md1 : inactive sdf2[2](S) sde2[1](S)
>           979230720 blocks super 1.2
>
>     md2 : active raid5 sdb1[1] sda1[0] sdc1[2]
>           3906764800 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3=
/3] [UUU]
>           bitmap: 0/15 pages [0KB], 65536KB chunk
>
>     md0 : active raid1 sde1[4]
>           242624 blocks super 1.0 [3/1] [_U_]
>
>     unused devices: <none>
>
>
>
> I am really concerned about --force... andhttps://raid.wiki.kernel.org/in=
dex.php/Linux_Raid#When_Things_Go_Wrogn does nothing to alleviate those fea=
rs.
>
> Anyone have suggestions on what to do next?
> Thanks!

Hello again,

So it looks like I fixed my situation.


I decided to go for the overlay option in:
https://raid.wiki.kernel.org/index.php/Recovering_a_damaged_RAID

I initially went past that because it looked too complex.  The parallel com=
mand makes everything look really difficult.  I try not to run commands unl=
ess I understand what they are doing.  So I spend a few minutes playing wit=
h parallel and learning how it works and what underlying commands are being=
 executed.  Once I figured that out I went ahead with the process.  It migh=
t be a good idea to list the actual commands needed broken down so people a=
re not scared away by that section.

Once the overlays were in place I ended up with an issue

The array looked like this:

```
# mdadm -D /dev/md1
/dev/md1:
           Version : 1.2
        Raid Level : raid0
     Total Devices : 2
       Persistence : Superblock is persistent

             State : inactive
   Working Devices : 2

              Name : blah:1
              UUID : fba7c062:e352fa39:fdc09bf9:e21c4617
            Events : 18094730

    Number   Major   Minor   RaidDevice

       -     253        3        -        /dev/dm-3
       -     253        4        -        /dev/dm-4
```

So I tried to assemble

```
# mdadm --assemble --force /dev/md1
mdadm: Merging with already-assembled /dev/md/1
mdadm: forcing event count in /dev/dm-4(2) from 18094545 upto 18094730
mdadm: clearing FAULTY flag for device 0 in /dev/md/1 for /dev/dm-4
mdadm: Marking array /dev/md/1 as 'clean'
mdadm: failed to RUN_ARRAY /dev/md/1: Input/output error
```

I was really worried but stopped md1 and tried again and it worked!

```
# mdadm --assemble --force /dev/md1 $OVERLAYS
mdadm: /dev/md1 has been started with 2 drives (out of 3).
```

LVM detected the partitions right away and I was able to mount them without=
 issue.  I have pulled the important bits off and its still going fine so I=
 am pulling less critical but very very nice to have data off as well.

So a success story for MDADM, recovery with little to no data loss.

