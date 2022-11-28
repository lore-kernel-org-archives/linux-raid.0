Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED31EC4321E
	for <linux-raid@archiver.kernel.org>; Mon, 28 Nov 2022 23:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbiK1Xfa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 28 Nov 2022 18:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiK1Xf2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 28 Nov 2022 18:35:28 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D1632B8E
        for <linux-raid@vger.kernel.org>; Mon, 28 Nov 2022 15:35:27 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id o1so7505019pfp.12
        for <linux-raid@vger.kernel.org>; Mon, 28 Nov 2022 15:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PocaQB0xkui7lorI5JZxZZ97MzIzYaOLlbqwBPPYBMw=;
        b=FH+lBZroqShqr2cz8+PHTa4gMQy9ejdoxb4sn24HT4FCihLsNQ6D00pPRicjqhjAE+
         3skTvszva9n3kOCi+kDXyAgVLys6Bb8YSUVs3jHxiDnElYtxBTqy3o/HlF5/NkxSiNJD
         XM4pu32IUNevH5ANXRYV19O/DbI26H4ewPU2yU1TGMaGjZIrjJYZenQUmDdv5/bz3dAu
         kK566xHRFZDAEpPwwKDa0jLIj331qYykwSy4hF3udB0XhSIKqzbGNj52BLHNG+DbOQXb
         8C9mgypGFlKGcOP41WhkZgVyLSCIAZTZMd0XrJHFB2kXiRLE7ahYd3u5orhMxFw9tToH
         qj1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PocaQB0xkui7lorI5JZxZZ97MzIzYaOLlbqwBPPYBMw=;
        b=kO57KOsak+h13bTUPqO3rLpI4CEUi/KvD8WunSXqL/mFF2o+g+3eIM82rcFRIj9z7X
         5TyeVlztm8EIPlkPVYN/ZQcGvFJgz2NOp3vCvt8NoAGQXTB+694zUfHPRAHtQSKFefn/
         Is5oykMcXOcX8q+E5AZPVNED8Eh1pxpfZpPNf+D5I2pDxGs8tIKhIPXy4G3MUYvtMl08
         DS2kxOJ2EHN7+WIXIBRJ9JwE80C5d1yFL4z62nxJh3e3TvgVY6LaqpArYr0v4A4wP3ML
         LkuyjIBVfXdk4f5i7kGehTh9zD7aJESD9hpjWxAtfQwVuBrET0aLCm1Y18brEO+lGW+L
         Texg==
X-Gm-Message-State: ANoB5plF0Rfa8xCvIYTzgsJ5E3DrJZEfnheO12F268pBv7pyT7FCpsmY
        b+ejSrlpp4nXtOEamwI7/PkQwEhjFNs0U1wIxEguAzwE
X-Google-Smtp-Source: AA0mqf5FMuJTKRNC7WoMYApkwPBb3CgAaJQPTwbEv4ZdY990MLNWHNrIAIQAm5qTpQxJ8ec2bSxOIBtrwG/iIngAWLQ=
X-Received: by 2002:aa7:8d5a:0:b0:562:7f16:7407 with SMTP id
 s26-20020aa78d5a000000b005627f167407mr56838216pfe.15.1669678526776; Mon, 28
 Nov 2022 15:35:26 -0800 (PST)
MIME-Version: 1.0
References: <CAA0v=OA8LS0s7G8CHK_0oL=nh49_H4G26-r85GgZLOAtbb3WOg@mail.gmail.com>
In-Reply-To: <CAA0v=OA8LS0s7G8CHK_0oL=nh49_H4G26-r85GgZLOAtbb3WOg@mail.gmail.com>
From:   Samuel Lopes <samuelblopes@gmail.com>
Date:   Mon, 28 Nov 2022 23:33:31 +0000
Message-ID: <CAA0v=OANGnih6sxB6TTdynA0BbSOhyaMpfvW2O1KSSTws76AtQ@mail.gmail.com>
Subject: Fwd: Recover RAID5
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello everyone,

Before anything else let me apologize for my bad english.

Here is my problem:

I was planning to replace all disks on a 6 drive raid5 array for
bigger ones and then grow it. So I fail/removed the first drive,
replaced it and let the array rebuild. In that process another drive
had problems and got kicked off the array leaving me with 4 working
drives and 2 spares (the new one and the one that was kicked).
After reboot I did a smart test on the kicked drive that showed no
errors (at least for now).
Nevertheless, after trying to assemble the array again those 2 drives
were always marked as spare, even if I fail/re-add/assemble force
them.

And here is where I probably made a great mistake. I tried to create
the array again using the same parameters and drive order but I'm
unable to mount the filesystem.

I have a saved output of --detail and I have the boot logs to check
the correct drive order:

Old --detail output:

           Version : 1.2
     Creation Time : Fri Mar 23 14:09:57 2018
        Raid Level : raid5
        Array Size : 48831518720 (45.48 TiB 50.00 TB)
     Used Dev Size : 9766303744 (9.10 TiB 10.00 TB)
      Raid Devices : 6
     Total Devices : 5
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Wed Jul 20 11:14:14 2022
             State : clean, degraded
    Active Devices : 5
   Working Devices : 5
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : bitmap

              Name : home:4  (local to host home)
              UUID : 2942a897:e0fb246c:a4a823fd:e0a6f0af
            Events : 633890

    Number   Major   Minor   RaidDevice State
       0       8       97        0      active sync   /dev/sdg1
       1       8      113        1      active sync   /dev/sdh1
       2       8      193        2      active sync   /dev/sdm1
       7       8      209        3      active sync   /dev/sdn1
       -       0        0        4      removed
       6       8      225        5      active sync   /dev/sdo1

The drive names are different now but I checked the serial numbers
from the boot log to make sure it was the correct order:

Nov 21 09:10:52 [localhost] kernel: [    2.108665] md/raid:md4: device
sdg1 operational as raid disk 0
Nov 21 09:10:52 [localhost] kernel: [    2.108670] md/raid:md4: device
sdn1 operational as raid disk 3
Nov 21 09:10:52 [localhost] kernel: [    2.108671] md/raid:md4: device
sdm1 operational as raid disk 2
Nov 21 09:10:52 [localhost] kernel: [    2.108673] md/raid:md4: device
sdo1 operational as raid disk 5
Nov 21 09:10:52 [localhost] kernel: [    2.108674] md/raid:md4: device
sdi1 operational as raid disk 1
Nov 21 09:10:52 [localhost] kernel: [    2.108675] md/raid:md4: device
sdp1 operational as raid disk 4

Then I run:

mdadm -v --create /dev/md5 --level=5 --chunk=512K --metadata=1.2
--layout=left-symmetric --data-offset=262144s --raid-devices=6
/dev/sdn1 /dev/sdj1 /dev/sdl1 /dev/sdm1 /dev/sdo1 /dev/sdr1
--assume-clean

I'm not sure about the data-offset but that value makes the array size
match the old --detail output. New --detail output:

           Version : 1.2
     Creation Time : Mon Nov 28 15:07:36 2022
        Raid Level : raid5
        Array Size : 48831518720 (45.48 TiB 50.00 TB)
     Used Dev Size : 9766303744 (9.10 TiB 10.00 TB)
      Raid Devices : 6
     Total Devices : 6
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Mon Nov 28 15:07:36 2022
             State : clean
    Active Devices : 6
   Working Devices : 6
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : bitmap

              Name : home:5  (local to host home)
              UUID : 5da28055:2d1ca246:98a0aa83:eba65394
            Events : 1

    Number   Major   Minor   RaidDevice State
       0       8      209        0      active sync   /dev/sdn1
       1       8      145        1      active sync   /dev/sdj1
       2       8      177        2      active sync   /dev/sdl1
       3       8      193        3      active sync   /dev/sdm1
       4       8      225        4      active sync   /dev/sdo1
       5      65       17        5      active sync   /dev/sdr1

But I'm unable to mount:

sudo mount -v -o ro /dev/md5 /media/test
mount: /media/test: wrong fs type, bad option, bad superblock on
/dev/md5, missing codepage or helper program, or other error.
       dmesg(1) may have more information after failed mount system call.

No info at all in dmesg.

I also tried recreating the array with the old drive that I replaced
and a missing member instead of the kicked drive with same output.

I'm pretty lost here so I would welcome any help at all.

Linux home 6.0.0-2-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.0.3-1
(2022-10-21) x86_64 GNU/Linux
mdadm - v4.2 - 2021-12-30 - Debian 4.2-4+b1

Thank you in advance,
Samuel
