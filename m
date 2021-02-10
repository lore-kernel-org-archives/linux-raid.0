Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70E3C433DB
	for <linux-raid@archiver.kernel.org>; Wed, 10 Feb 2021 22:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A6FF64E77
	for <linux-raid@archiver.kernel.org>; Wed, 10 Feb 2021 22:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbhBJWLH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 10 Feb 2021 17:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbhBJWLA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 10 Feb 2021 17:11:00 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42352C061788
        for <linux-raid@vger.kernel.org>; Wed, 10 Feb 2021 14:10:19 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id f2so4930936ljp.11
        for <linux-raid@vger.kernel.org>; Wed, 10 Feb 2021 14:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=powerlamerz-org.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=XC1bn73a7+ZKz/zjZNWgaJulbx1PEvHX/LrnDuWXJPQ=;
        b=KytToGD5kfhnZwB0dMTTVbQGZL96jseXInkvlV2VqejWazDaoOFJ609arL4eNoAjAL
         hsctsfe8eKjJ+nimsMQuFR4zUR83Y+NAXqQRO5wSatA0NAhazNGbhLBA2xkl2ZGVoVM2
         /2E0wEReCgoXS3N5VlDJWYT10mFpKkhmom4UYFdWV6sLigya5MJnLzheQLOhExHi0gte
         FtQroKSRqT3DkaDAZ/TcKP6zMgakx5TKwpcLR674M0fFvG5ThBZb8V1suh2Q24cJKd1u
         f9wCTWl/2P7R2AV5E9UZlzpeG9Gxnp72tMRi+UiBO9L8XZ7J1o4htYt9q74ur46hhVuN
         W6Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XC1bn73a7+ZKz/zjZNWgaJulbx1PEvHX/LrnDuWXJPQ=;
        b=lxsJk6D2PFTLdBT3+EEiQUq5nhor8zY/gaM/Z5SS3QUJpGVOcOK6pOf/wKjDHKN/2W
         eXagbWmrZA1Df60uN/RfGL0hDfyPlzhsiInRr1Xlxbeh5tjSY7e2hZIndTzMVqBHpQ1q
         hFZX5N8pxxJE7tIzFwhYM6NU/uYC1GVATCYIeMN/f6iWvEAzi8D/h+0dctQAgJDaMHFK
         boib+qsN8pRwV6kaIugE0EVitH3WNQmUOEIcZsZu9quM2y2kcG2KvYPTaM9nXWSqulv0
         cBinA/dA8TCyJ1aZswzT7ru5UwZcWwRryNRcxsY9h3TVRoURbq7D2DrNX4k8RtF5Oicw
         PFZw==
X-Gm-Message-State: AOAM532OCyCKJNZY9v5fUo2JC0H+ksSx8xabbPyTCXGh5VAOynDdw2IE
        3zIAkOhkwog/KNjbQy40hlGEXRjzTgh315e31NA=
X-Google-Smtp-Source: ABdhPJwlokZo9HBCH8667kBs3C0LcijZ4GtJQ9QXMsG8LlQ2uIQRChayjpjK/+Ce/FHC/Fxr07JASA==
X-Received: by 2002:a2e:b01a:: with SMTP id y26mr3137448ljk.442.1612995017569;
        Wed, 10 Feb 2021 14:10:17 -0800 (PST)
Received: from [192.168.77.73] ([212.85.71.156])
        by smtp.gmail.com with ESMTPSA id u20sm680193ljo.6.2021.02.10.14.10.17
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 14:10:17 -0800 (PST)
Subject: Re: I trashed my superblocks after reshape from raid5 to raid6
 stalled - need help recovering
From:   =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>
To:     linux-raid@vger.kernel.org
References: <1e6c1c18-38c3-3419-505c-b310e9f55dd6@powerlamerz.org>
Message-ID: <0d0eb6c1-39db-1258-4b81-cac8e7f5c78d@powerlamerz.org>
Date:   Wed, 10 Feb 2021 23:10:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1e6c1c18-38c3-3419-505c-b310e9f55dd6@powerlamerz.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/29/21 1:37 AM, Patrik Dahlström wrote:
> Hello,
> 
> Logs and disk information is located at the end of this email. Please
> note that I also have a USB stick plugged into this computer that
> sometimes comes up as sda and sometimes sdi, which means that some of
> the collected data might be off-by-one (sda -> sdb, etc.).
> 
> I will try to be as thorough as possible to explain what has happened
> and don't waste your time. The short version first:
> 
> * Start reshape of raid5 with 7 disks to raid6 with 8 disks
> * Reshape stalls
> * Panic
> * Fail to create overlays
> * Become overconfident
> * Overwrite superblock (wrongly) without overlays
> * Realize mistake
> * Stop
> * Get overlays working
> * Much hard thinking and experimenting with device mapper
> * Successfully mount raid volume by combining 2 overlay sets
> * Need help restoring array
> 
> If this is enough information, please skip to "Where I am now" below.
> For details on what I've written to my superblock, see "Frakking up".
> 
> Long version
> ============
> This story begins with a perfectly healthy raid5 array with 7 x 10 TB
> drives. Well, mostly healthy. I had started to see these lines pop up
> in my syslog:
> 
> Jan 21 18:01:06 rack-server-1 smartd[1586]: Device: /dev/sdb [SAT], 16 Currently unreadable (pending) sectors
> 
> Because of this, I started to become paranoid that I would loose data
> when replacing the bad drive. I decided I should add another 10 TB to
> the array and convert to raid6. These are the commands I used to kick
> off that conversion:
> 
> (mdadm 4.1 and Linux 4.15.0-132-generic)
> 
> $ sudo mdadm --add /dev/md0 /dev/sdg
> $ sudo mdadm --grow /dev/md0 --level=6 --raid-disk=8
> 
> This kicked off the reshape process successfully. A few days later, I
> started to notice I/O issues. More precisely: timeouts. It looks like
> the reshape process had stalled and any kind of I/O to the raid mount
> mount point would also stall, until some timeout error occurred. This
> was most likely caused by BBL, but I didn't know that at the time. At
> this point these messages started to show up in my kernel log:
> 
> Jan 20 21:55:06 rack-server-1 kernel: INFO: task md0_reshape:29278 blocked for more than 120 seconds.
> Jan 20 21:55:06 rack-server-1 kernel:       Tainted: G           OE    4.15.0-132-generic #136-Ubuntu
> Jan 20 21:55:06 rack-server-1 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Jan 20 21:55:06 rack-server-1 kernel: md0_reshape     D    0 29278      2 0x80000000
> Jan 20 21:55:06 rack-server-1 kernel: Call Trace:
> Jan 20 21:55:06 rack-server-1 kernel:  __schedule+0x24e/0x880
> Jan 20 21:55:06 rack-server-1 kernel:  schedule+0x2c/0x80
> Jan 20 21:55:06 rack-server-1 kernel:  md_do_sync+0xdf1/0xfa0
> Jan 20 21:55:06 rack-server-1 kernel:  ? wait_woken+0x80/0x80
> Jan 20 21:55:06 rack-server-1 kernel:  ? __switch_to_asm+0x35/0x70
> Jan 20 21:55:06 rack-server-1 kernel:  md_thread+0x129/0x170
> Jan 20 21:55:06 rack-server-1 kernel:  ? md_seq_next+0x90/0x90
> Jan 20 21:55:06 rack-server-1 kernel:  ? md_thread+0x129/0x170
> Jan 20 21:55:06 rack-server-1 kernel:  kthread+0x121/0x140
> Jan 20 21:55:06 rack-server-1 kernel:  ? find_pers+0x70/0x70
> Jan 20 21:55:06 rack-server-1 kernel:  ? kthread_create_worker_on_cpu+0x70/0x70
> Jan 20 21:55:06 rack-server-1 kernel:  ret_from_fork+0x35/0x40
> 
> Other tasks or user processes also started to become blocked. Almost
> anything I did would become blocked because it would access this mount
> point and stall. If I rebooted the server, it would stall during boot,
> when assembling the raid.
> 
> By removing all the drives, I was able to at least boot the server. I
> decided to update to Ubuntu 20.04 and try again - no dice. I still got
> blocked. I did notice that the reshape progressed a little bit every
> time I booted.
> 
> I figured I would revert the reshape and start from scratch and I found
> out that there is something called "--assemble --update=revert-reshape":
> 
> (mdadm v4.1 and Linux-5.4.0-64-generic, USB stick is sda)
> 
> $ sudo mdadm --detail /dev/md0
> /dev/md0:         
>            Version : 1.2
>      Creation Time : Sat Apr 29 16:21:11 2017
>         Raid Level : raid6
>         Array Size : 58597880832 (55883.29 GiB 60004.23 GB)
>      Used Dev Size : 9766313472 (9313.88 GiB 10000.70 GB)
>       Raid Devices : 8
>      Total Devices : 8
>        Persistence : Superblock is persistent
> 
>      Intent Bitmap : Internal
> 
>        Update Time : Thu Jan 21 20:32:24 2021
>              State : clean, degraded, reshaping 
>     Active Devices : 7
>    Working Devices : 8
>     Failed Devices : 0
>      Spare Devices : 1
> 
>             Layout : left-symmetric-6
>         Chunk Size : 512K
> 
> Consistency Policy : bitmap
> 
>     Reshape Status : 59% complete
>         New Layout : left-symmetric
> 
>               Name : rack-server-1:1  (local to host rack-server-1)
>               UUID : 7f289c7a:570e2f7e:2ac6f909:03b3970f
>             Events : 728221
> 
>     Number   Major   Minor   RaidDevice State
>        8       8       48        0      active sync   /dev/sdd
>       13       8       64        1      active sync   /dev/sde
>       12       8       96        2      active sync   /dev/sdg
>        7       8      128        3      active sync   /dev/sdi
>       10       8       80        4      active sync   /dev/sdf
>        9       8       16        5      active sync   /dev/sdb
>       11       8       32        6      active sync   /dev/sdc
>       14       8      112        7      spare rebuilding   /dev/sdh
> $ sudo mdadm --stop /dev/md0
> $ sudo mdadm --assemble --update=revert-reshape /dev/md0
> 
> This did not do what I expected. Unfortunately, I forgot to save the
> output of "mdadm --detail /dev/md0" after the last command, but if I
> remember correctly it marked all my drives, except sdh, as faulty. I
> expected it to start going backwards in the reshape progress.
> 
> At this point, I saved away the output of these commands:
> 
> (mdadm v4.1 and Linux-5.4.0-64-generic, USB stick is sda)
> 
> $ sudo mdadm --examine /dev/sdb
> $ sudo mdadm --examine /dev/sdc
> $ sudo mdadm --examine /dev/sdd
> $ sudo mdadm --examine /dev/sde
> $ sudo mdadm --examine /dev/sdf
> $ sudo mdadm --examine /dev/sdg
> $ sudo mdadm --examine /dev/sdh
> $ sudo mdadm --examine /dev/sdg
> $ sudo mdadm --examine /dev/sdh
> $ sudo mdadm --examine /dev/sdi
> 
> (output located at the end)
> 
> Fail to create overlays
> =======================
> I realized that I needed to start using overlays unless I mess up even
> more. However, that was easier said than done. No matter what I did, I
> always got this error as a result of "dmsetup create":
> 
> Jan 21 21:19:10 rack-server-1 kernel: device-mapper: table: 253:1: snapshot: Cannot get origin device
> Jan 21 21:19:10 rack-server-1 kernel: device-mapper: ioctl: error adding target to table
> 
> Frakking up
> ===========
> Now, what would be the sane thing to do when you can't create overlays?
> 
> Stop. Ask for help.
> 
> If this was a test on how I perform under pressure, I failed. After all,
> this wasn't my first time recovering from a failed reshape. Just search
> the mailing list for my name. I was confident in my abilities, and flew
> straight into the sun:
> 
> (mdadm v4.1 and Linux-5.4.0-64-generic, USB stick is sdi)
> 
> $ sudo mdadm --create --level=6 --raid-devices=8 --size=4883156736 /dev/md0 /dev/sdc /dev/sdd /dev/sdf /dev/sdh /dev/sde /dev/sda /dev/sdb missing
> 
> Notice the lack of "--assume-clean" and the wrong "--size" parameter,
> not to mention the missing "--data-offset" since it was "non-default".
> 
> This kicked off a rebuild of disk sdb (the last non-missing device).
> Fortunately, I realized my mistake within a few seconds - 39 seconds in
> fact, if my command history can be trusted - and stopped the array.
> 
> What follows is a series of more attempts at re-creating the superblock
> with different parameters to "mdadm --create --assume-clean". The last
> one (I think) being:
> 
> (mdadm v4.1 and Linux-5.4.0-64-generic, USB stick is sdi)
> 
> $ sudo mdadm --create --assume-clean --level=6 --raid-devices=8 --size=9766313472 --data-offset=61440 /dev/md0 /dev/sdc /dev/sdd /dev/sdf /dev/sdh /dev/sde /dev/sda /dev/sdb missing
> 
> Running "fsck.ext4 -n /dev/md0" on this array would at least start.
> However, it would eventually reach a point where it would start spewing
> a ton of errors. My guess is that it reaches the point where the array
> has not yet been reshaped.
> 
> Getting overlays to work again
> ==============================
> 
> Although my command history has no memory of it, "journalctl" tell me
> that I rebooted my server one more time after I failed to create
> overlays. After that, the "overlay_create" and "overlay_remove"
> functions just worked. Every. <censored>. Time.
> 
> Once overlays were working, I got to work at thinking hard and
> experimenting. Some experiments quickly grew the overlay files
> and my storage space for them were only ~80 GB. I decided to
> scrap the newly added disk and re-use it as storage space for
> overlay files. In hindsight, I realize that I could have used
> the other 10 TB drive I had laying on the shelf below...
> 
> Where I am now
> ==============
> 
> I am able to mount my raid volume by creating 2 separate sets of overlay
> files, create an array on each set, and then use device mapper in linear
> mode to "stitch together" the 2 arrays at the exact reshape position:
> 
> (mdadm v4.1 and Linux-5.4.0-64-generic)
> 
> $ sudo mdadm --create --assume-clean --level=6 --raid-devices=8 --size=9766313472 --layout=left-symmetric --data-offset=61440 /dev/md0 /dev/dm-3 /dev/dm-4 /dev/dm-6 /dev/dm-7 /dev/dm-5 /dev/dm-1 /dev/dm-2 missing
> $ sudo mdadm --create --assume-clean --level=6 --raid-devices=8 --size=9766313472 --layout=left-symmetric-6 --data-offset=123392 /dev/md1 /dev/dm-10 /dev/dm-11 /dev/dm-13 /dev/dm-14 /dev/dm-12 /dev/dm-8 /dev/dm-9 missing
> $ echo "0 69529589760 linear /dev/md0 0
> 69529589760 47666171904 linear /dev/md1 69529589760" | sudo dmsetup create joined
> $ sudo mount -o ro /dev/dm-15 /storage
> 
> The numbers are taken from the "mdadm -E <dev>" commands I ran earlier,
> only recalculated to fit the expected unit. The last drive in the array
> has been re-purposed as overlay storage.
> 
> What now?
> =========
> 
> This is where I need some more help:
> * How can I resume the reshape or otherwise fix my array?
> * Is resuming a reshape something that would be a useful feature?
>   If so, I could look into adding support for it. Maybe used like this?
> 
>   # mdadm --create --assume-clean /dev/md0 <array definition>
>   # mdadm --manage /dev/md0 --grow --reshape-pos=<number> <grow params>
> 
> * Does wiping or overwriting the superblock also clear the BBL?
> * Is there any information missing?

Update! I've fully recovered from my mishaps and successfully reshaped
my array from raid5 to raid6!

I modified mdadm so that I could set the proper bits and values in the
superblocks when creating my array. These were my final commands to get
my array running again:

$ sudo ./mdadm --create --assume-clean --level=6 --raid-devices=8 --data-offset=61440 --layout=left-symmetric --size=9766313472 --reshape-position=34764794880 --new-data-offset=246784 --new-layout=left-symmetric-6 /dev/md0 /dev/sdc /dev/sdd /dev/sdf /dev/sdh /dev/sde /dev/sda /dev/sdb missing
$ sudo mdadm --stop /dev/md0
$ sudo ./mdadm --assemble --update="revert-reshape" /dev/md0 /dev/sdc /dev/sdd /dev/sdf /dev/sdh /dev/sde /dev/sda /dev/sdb
$ sudo mount -o ro /dev/md0 /storage

This resumed my array reshape from raid5 to raid6. Once that had
completed, I added the final 8th disk and let it rebuild. The added
flags are "--reshape-position", "--new-data-offset", and "--new-layout".

Are these flags something that would be considered useful for mdadm?
If so, I could clean up the patches a bit and post them.

// Patrik
