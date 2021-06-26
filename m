Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD08C49EA6
	for <linux-raid@archiver.kernel.org>; Sat, 26 Jun 2021 11:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5367B616ED
	for <linux-raid@archiver.kernel.org>; Sat, 26 Jun 2021 11:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbhFZLL5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 26 Jun 2021 07:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhFZLL5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 26 Jun 2021 07:11:57 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0882C061574
        for <linux-raid@vger.kernel.org>; Sat, 26 Jun 2021 04:09:34 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id b3so6091750plg.2
        for <linux-raid@vger.kernel.org>; Sat, 26 Jun 2021 04:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:references:in-reply-to:subject:date:message-id:mime-version
         :content-transfer-encoding:content-language:thread-index;
        bh=gMplGGKoCVImqPid11LDHZ7G7xflf7znmdYM1EIRnYI=;
        b=n5Gi2FrMA6tavRn0/J4JBUeOOMq4o5tXmTKKNfvriOv7xGUfmP2jqlhvn2Xm/NaX79
         36/B/TyOcTEwx2RiqeYOVDlcpiqbjM8nGOTD6xhsn9VKEci5DmzgWIaY0lQyoka0C2Jy
         3d+LmsDldfFf2ZlISBg6EYm0teeiEnf7l94HY1Z/KgK33In3RgqBRxkTRIe8qSZuEbEQ
         89htHK2Dx+e6EIi1/Oi964IdyUHpBsmpVwWcCXYkSPV3IyJ9wLTYTouOcZ5oXRfpI2Vj
         TRicPHG8Xccv7mv0mLbftme9dPCRTt2ijBEqweziUuOpARCv65fZReYue5MuZFdCBPhR
         i8sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:references:in-reply-to:subject:date
         :message-id:mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=gMplGGKoCVImqPid11LDHZ7G7xflf7znmdYM1EIRnYI=;
        b=K98vFkOwROv8APxQpGrn2Kvi6QQoOWxD/mK3a3EHh2dxnfY738cSw0576wSQoNOsty
         r9qo8z+lHdKVmjiJt6oDzyxlICIPBtM+0gYYA1BunMzS9ncmmI32cbn7RWq8nfBHGEt3
         GNj9jTV+ndxv8QRLdEbgPbrMnCg2U45nd+ZwuFrM5qRLTF357TftwQpn2wLq80p7MBy+
         SzNAe3tHPLxiRVXUcgTdBkGNRwkd3qb8KxQsL7mI+xcgHnmlfYJ5WmZpIO0xD7R7gSw7
         KlXHYqHkQAjfEYwGGadQUHV8FpvS3WE+KkiU3qukBf+4kf8+lytbdIIxmxNNQdjsWeo/
         kfEw==
X-Gm-Message-State: AOAM533/GgGOSieE/xQfX787s9X0/vob+6U/iCd+79YSoolX4VEqJCxQ
        NCvwdZkXEZpT3CVQCWVbPl+jtwulJIYgjoA0
X-Google-Smtp-Source: ABdhPJw2TJiVj5Un0seB+HX/UZYgjnZQEbA9goF8vLDYXvCz602XoJiENlzsQd6J60U1eWqZbXLFOg==
X-Received: by 2002:a17:90b:1c06:: with SMTP id oc6mr15611233pjb.112.1624705773782;
        Sat, 26 Jun 2021 04:09:33 -0700 (PDT)
Received: from EdgarII ([58.164.17.235])
        by smtp.gmail.com with ESMTPSA id g10sm7341271pji.10.2021.06.26.04.09.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Jun 2021 04:09:33 -0700 (PDT)
From:   "Jason Flood" <3mu5555@gmail.com>
To:     "'Phil Turmel'" <philip@turmel.org>, <linux-raid@vger.kernel.org>
References: <007601d769ba$ced0e870$6c72b950$@gmail.com> <6d412bf3-a7b9-1f08-2da9-96d34d8f112b@turmel.org>
In-Reply-To: <6d412bf3-a7b9-1f08-2da9-96d34d8f112b@turmel.org>
Subject: RE: 4-disk RAID6 (non-standard layout) normalise hung, now all disks spare
Date:   Sat, 26 Jun 2021 21:09:29 +1000
Message-ID: <00f101d76a7b$bdb3fc50$391bf4f0$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-au
Thread-Index: AQGNx8sXAjFFTjp8y/bre2t4Ys80RwKF0iigq6U4YWA=
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thanks for that, Phil - I think I'm starting to piece it all together =
now. I was going from a 4-disk RAID5 to 4-disk RAID6, so from my reading =
the backup file was recommended. The non-standard layout meant that the =
array had over 20TB usable, but standardising the layout reduced that to =
16TB. In that case the reshape starts at the end so the critical section =
(and so the backup file) may have been in progress at the 99% complete =
point when it failed, hence the need to specify the backup file for the =
assemble command.

I ran "sudo mdadm --assemble --verbose --force /dev/md0 /dev/sd[bcde] =
--backup-file=3D/root/raid5backup":

mdadm: looking for devices for /dev/md0
mdadm: /dev/sdb is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdc is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdd is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sde is identified as a member of /dev/md0, slot 3.
mdadm: Marking array /dev/md0 as 'clean'
mdadm: /dev/md0 has an active reshape - checking if critical section =
needs to be restored
mdadm: No backup metadata on /root/raid5backup
mdadm: added /dev/sdc to /dev/md0 as 1
mdadm: added /dev/sdd to /dev/md0 as 2
mdadm: added /dev/sde to /dev/md0 as 3
mdadm: no uptodate device for slot 4 of /dev/md0
mdadm: added /dev/sdb to /dev/md0 as 0
mdadm: Need to backup 3072K of critical section..
mdadm: /dev/md0 has been started with 4 drives (out of 5).

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
sudo mdadm --detail /dev/md0

/dev/md0:
           Version : 1.2
     Creation Time : Thu Jul 13 01:11:22 2017
        Raid Level : raid6
        Array Size : 15627793408 (14903.83 GiB 16002.86 GB)
     Used Dev Size : 7813896704 (7451.91 GiB 8001.43 GB)
      Raid Devices : 4
     Total Devices : 4
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Sat Jun 26 19:40:16 2021
             State : clean, reshaping
    Active Devices : 4
   Working Devices : 4
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric-6
        Chunk Size : 512K

Consistency Policy : bitmap

    Reshape Status : 99% complete
     Delta Devices : -1, (5->4)
        New Layout : left-symmetric

              Name : Universe:0
              UUID : 3eee8746:8a3bf425:afb9b538:daa61b29
            Events : 184255

    Number   Major   Minor   RaidDevice State
       6       8       16        0      active sync   /dev/sdb
       7       8       32        1      active sync   /dev/sdc
       5       8       48        2      active sync   /dev/sdd
       4       8       64        3      active sync   /dev/sde

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

cat /proc/mdstat

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] =
[raid4] [raid10]
md0 : active raid6 sdb[6] sde[4] sdd[5] sdc[7]
      15627793408 blocks super 1.2 level 6, 512k chunk, algorithm 18 =
[4/3] [UUUU]
      [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.]  =
reshape =3D 99.7% (7794393600/7813896704) finish=3D52211434.6min =
speed=3D0K/sec
      bitmap: 14/30 pages [56KB], 131072KB chunk
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The drive mounts and the files are all intact, but still sitting on 99% =
complete with 52 million minutes to finish and counting up. The "No =
backup metadata" made me suspicious that it is stuck because it can't =
write to /root/raid5backup (and looking at it now I should have put it =
somewhere more sensible as I'm using sudo, but I used it in the RAID5 to =
RAID6 process and it was happy). It does seem to have modified the file, =
though:

stat raid5backup

  File: raid5backup
  Size: 3149824         Blocks: 6152       IO Block: 4096   regular file
Device: 802h/2050d      Inode: 1572897     Links: 1
Access: (0600/-rw-------)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2021-06-26 19:39:16.739983712 +1000
Modify: 2021-06-26 19:40:16.778498938 +1000
Change: 2021-06-26 19:40:16.778498938 +1000
 Birth: -
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

But I believe those times are from when I first ran the assemble command =
- it's 20:30 now. I couldn't find a flag to conditionally treat the =
backup file as garbage - just the --invalid-backup "I know it's garbage" =
option. Given that the assemble isn't complaining about needing to =
restore the critical section, is my next step something like:

	sudo mdadm --assemble --verbose --force /dev/md0 /dev/sd[bcde] =
--backup-file=3Draidbackup --invalid-backup

Thanks again, Phil. I haven't been using Linux seriously for very long, =
so this has been a steep learning curve for me.

Jason
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

-----Original Message-----
From: Phil Turmel <philip@turmel.org>=20
Sent: Saturday, 26 June 2021 00:00
To: Jason Flood <3mu5555@gmail.com>; linux-raid@vger.kernel.org
Subject: Re: 4-disk RAID6 (non-standard layout) normalise hung, now all =
disks spare

Good morning Jason,

Good report.  Comments inline.

On 6/25/21 8:08 AM, Jason Flood wrote:
> I started with a 4x4TB disk RAID5 array and, over a few years changed=20
> all the drives to 8TB (WD Red - I hadn't seen the warnings before now, =

> but it looks like these ones are OK). I then successfully migrated it=20
> to RAID6, but it then had a non-standard layout, so I ran:
> 	sudo mdadm --grow /dev/md0 --raid-devices=3D4=20
> --backup-file=3D/root/raid5backup --layout=3Dnormalize

Ugh.  You don't have to use a backup file unless mdadm tells you too.=20
Now you are stuck with it.

> After a few days it reached 99% complete, but then the "hours =
remaining"
> counter started counting up. After a few days I had to power the=20
> system down before I could get a backup of the non-critical data=20
> (Couldn't get hold of enough storage quickly enough, but it wouldn't=20
> be catastrophic to lose it), and now the four drives are in standby, =
with the array thinking it is RAID0.
> Running:
> 	sudo mdadm --assemble /dev/md0 /dev/sd[bcde] responds with:
> 	mdadm: /dev/md0 assembled from 4 drives - not enough to start the=20
> array while not clean - consider --force.

You have to specify the backup file on assembly if a reshape using one =
was interrupted.

> It appears to be similar to=20
> https://marc.info/?t=3D155492912100004&r=3D1&w=3D2,
> but before trying --force I was considering using overlay files as I'm =

> not sure of the risk of damage. The set-up process that is documented =
in the "
> Recovering a damaged RAID" Wiki article is excellent, however the=20
> latter part of the process isn't clear to me. If successful, are the=20
> overlay files written to the disk like a virtual machine snapshot, or=20
> is the process stopped, the overlays removed and the process repeated, =

> knowing that it now has a low risk of damage?

Using --force is very low risk on assembly.  I would try it (without =
overlays, and with backup file specified) before you do anything else.=20
Odds of success are high.

Also try the flags to treat the backup file as garbage if its contents =
don't match what mdadm expects.

Report back here after the above.

> System details follow. Thanks for any help.

[details trimmed]

Your report of the details was excellent.  Thanks for helping us help =
you.


Phil

