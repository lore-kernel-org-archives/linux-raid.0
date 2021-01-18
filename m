Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D1EC433E0
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jan 2021 02:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AB60224DF
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jan 2021 02:00:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730458AbhARCAe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 17 Jan 2021 21:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730086AbhARCAc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 17 Jan 2021 21:00:32 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB76C061573
        for <linux-raid@vger.kernel.org>; Sun, 17 Jan 2021 17:59:52 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id w5so14927937wrm.11
        for <linux-raid@vger.kernel.org>; Sun, 17 Jan 2021 17:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=b806g5xMihW6/4sUYoUmpHBvei0OwfoM0MPzarGBnR8=;
        b=jGYE1R7157gXufep1f8G5fda7jQV8TjCddVAfl0+M875CVvHaj812h3VvdgLHZWj/T
         j9QAt05UctQroCJ4TZm1FL7cZIDiWrhx3dLJs9VEW4Mu5fJIFY2Qkilh07FA0jEXaNSY
         XTcMaAkbfuS7Ee+n8xK/y9q8x9zSxSEscdedHZo8wPcEfPohi/9rOoT9U5QVQ+7w08W4
         zDp6FZH2xRyol+VXUgMh85sLBb2VJlA9VPyfwkQ22+vFSn5VJF05yIWFd52swwiMndhs
         3beQ9bg0OjQP61wJ+Sngga6rJy9P/fWcwLvT+coIpD4/k57GL1nH2qWoERDZCNO5H33a
         J2dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=b806g5xMihW6/4sUYoUmpHBvei0OwfoM0MPzarGBnR8=;
        b=XFuo25byREA7T7sV+gXGVlCaFtBD3nWYrnAnWCAhxi76TMRCqh+RYjm1QVCDsPs5Dz
         MEMTJMwVFAZEyu9So9G4/iVw8R+o8tKjMyLPMbV6FKG1zwNeySYCm2ejbuVQwBxsefJF
         Zic0qMPyxzRMvUthIhtB1bQOBe6SzP/NZOJuksRhCZPabJjiT8Jia4GmmkKw18hwYhtf
         R+x9gIBczJUh1ki40Fg38TDNAjPqVxitpEha6wpqIU+Ul9qyTL0lN9ODGXpQRpWsGPuW
         OHpvXt4ypt4AGOhEEtVL8y+cQshYNRNDqsiVlk/Y5GyRFmUlPGe8RYh23l1AJ5sfnpoj
         k9iA==
X-Gm-Message-State: AOAM532ge71gVHjuzpjhxsMlH77tnZFvD3nxWIa0LEQYO7Rxjz1oOr4j
        Jr2yeXTYtXnF2UXoMeH9kJOqESNQXgBmDRufqaPTbA==
X-Google-Smtp-Source: ABdhPJyl2LK0abqaNU/MhlL/U4WHxD8taycv9w6WatUVnV3EYXHAFkhrqGHqrzmBnKB0M76KHUz/BD1rSsJkEW4Emk0=
X-Received: by 2002:adf:a201:: with SMTP id p1mr23481963wra.65.1610935189506;
 Sun, 17 Jan 2021 17:59:49 -0800 (PST)
MIME-Version: 1.0
References: <950d061954e1f779739c9c5777b94ade@mail.eclipso.de>
In-Reply-To: <950d061954e1f779739c9c5777b94ade@mail.eclipso.de>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 17 Jan 2021 18:59:33 -0700
Message-ID: <CAJCQCtTT+_2F2EFUz=juOn2YG+ZOu2gmNx1Qwu2wp6273T9DNA@mail.gmail.com>
Subject: Re: What is the best way to combine 4 HDD's and 2 SSD's into a single filesystem?
To:     Cedric.dewijs@eclipso.eu
Cc:     Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Jan 17, 2021 at 1:43 PM <Cedric.dewijs@eclipso.eu> wrote:
>
> =C2=ADI have 4 slow, loud, big, power hungry and old hard drives, and 2 S=
SD's. I'm trying to come up with a way to combine them into a system that h=
as the following characteristics:
>
> A) The hard drives stop spinning 5 minutes after they have been used.
> B) The SSD's are used for read and write caching. Writes to the system ar=
e absorbed by the SSD's. Only when the ssd's are full of dirty data, then t=
he hard drives are woken up. (This means the SSD's contain dirty data for p=
otentially a long time.)
> C) When data is requested that's not present on the SSD's (a read cache m=
iss), then the hard drive which has that data is woken up.
> D) When a hard drive is woken up as a result of a read cache miss, then t=
he SSD's write out the dirty data to that drive.
> E) If one drive fails, or starts to produce random data, the system must =
return the correct data to the user.
>
> First idea is to use this stack of bcache and btrfs:
> +--------------------------------------------+--------------+
> |               btrfs raid 1 (2 copies) /mnt                |
> +--------------+--------------+--------------+--------------+
> | /dev/bcache0 | /dev/bcache1 | /dev/bcache2 |/dev/bcache3  |
> +--------------+--------------+--------------+--------------+
> |                       Cache (SSD)                         |
> |                       /dev/sda4                           |
> +--------------+--------------+--------------+--------------+
> | Data HDD     | Data HDD     | Data HDD     |Data HDD      |
> | /dev/sda8    | /dev/sda9    | /dev/sda10   |/dev/sda11    |
> +--------------+--------------+--------------+--------------+
> The good:
> Btrfs in raid 1 is able to handle a failing hard drive, both when it fail=
ed completely, and when it corrupts data.
> Bcache is capable of using an ssd to cache the read and the write request=
s from btrfs.
> The not-so-good:
> Bcache can only use one SSD, so using bcache is only possible as read cac=
he in order to achieve characteristic E, but this prevents characteristic B=
 to be achieved.
> I can't get bcache to read-ahead the data that is adjacent to the data th=
at has just been accessed.
>
> Second idea is to use a SSD in front of each hard drive:
> +-----------------------------------------------------------+
> |                btrfs raid 1 (2 copies) /mnt               |
> +--------------+--------------+--------------+--------------+
> | /dev/bcache0 | /dev/bcache1 | /dev/bcache2 | /dev/bcache3 |
> +--------------+--------------+--------------+--------------+
> | Cache SSD    |  Cache SSD   |  Cache SSD   |   Cache SSD  |
> | /dev/sda5    | /dev/sda6    | /dev/sda7    | /dev/sda8    |
> +--------------+--------------+--------------+--------------+
> | Data         | Data         | Data         | Data         |
> | /dev/sda9    | /dev/sda10   | /dev/sda11   |/dev/sda12    |
> +--------------+--------------+--------------+--------------+
> The good:
> This setup achieves all characteristics I'm after
> The not-so-good:
> This requires more SSD's and more (SATA) ports than I have.
> I can't get bcache to read-ahead the data that is adjacent to the data th=
at has just been accessed.
>
> Third idea is to use mdadm to create a raid 0 array out of the 2 SSD's to=
 create a fault tolerant write cache:
> +-----------------------------------------------------------+
> |                 btrfs raid 1 (2 copies) /mnt              |
> +--------------+--------------+--------------+--------------+
> | /dev/bcache0 | /dev/bcache1 | /dev/bcache2 |/dev/bcache3  |
> +--------------+--------------+--------------+--------------+
> |                      bcache Cache                         |
> |                         /dev/md0                          |
> +-----------------------------------------------------------+
> |               mdadm raid 0 array /dev/md0                 |
> |             SSD /dev/sda4 and SSD /dev/sda5               |
> +--------------+--------------+--------------+--------------+
> | Data         | Data         | Data         | Data         |
> | /dev/sda9    | /dev/sda10   | /dev/sda11   |/dev/sda12    |
> +--------------+--------------+--------------+--------------+
> The good:
> This setup is capable of achieving all characteristics I'm after. It can =
handle abrupt failure of a single drive.
> The not-so-good:
> When one of the SSD's start to produce random data, mdadm is not able to =
know what SSD produces correct data, and data is lost. (both copies of the =
data btrfs is trying to write to underlying storage are on the 2 SSD's.
>
> Fourth idea is to use dm-cache. Dm-cache can only cache one backing devic=
e, and it has no way to use 2 cache devices.
> +-----------------------------------------------------------+
> |                btrfs raid 1 (2 copies) /mnt               |
> +--------------+--------------+--------------+--------------+
> | /dev/bcache0 | /dev/bcache1 | /dev/bcache2 | /dev/bcache3 |
> +--------------+--------------+--------------+--------------+
> | Cache SSD    |  Cache SSD   |  Cache SSD   |   Cache SSD  |
> | /dev/sda5    | /dev/sda6    | /dev/sda7    | /dev/sda8    |
> +--------------+--------------+--------------+--------------+
> | Data         | Data         | Data         | Data         |
> | /dev/sda9    | /dev/sda10   | /dev/sda11   |/dev/sda12    |
> +--------------+--------------+--------------+--------------+
> The good:
> This setup is capable of achieving all characteristics I'm after.
> The not-so-good:
> This requires more SSD's and more (SATA) ports than I have.
>
> What options do I have to create the desired setup?
> Is it feasible to add a checksum to mdadm, much like btrfs has, so it can=
 tell what drive (if any) has returned the correct data?
>
> Is this the correct mailing list to ask these questions?
>
> ---
>
> Take your mailboxes with you. Free, fast and secure Mail &amp; Cloud: htt=
ps://www.eclipso.eu - Time to change!
>


I think all the options are complicated, and lack sufficient hardware
isolation to withstand SSD failure.

I think all the options are complicated in a recovery/restore context.
I think you're better off with two separate storage setups, this
isolates problems and makes recovery much simpler and more robust.

A

HDD1+SSD1=3D>
                            Btrfs raid1 profile for metadata, raid0 or
raid1 profile for data depending on your risk tolerance
HDD2+SSD2=3D>

B

HDD3+HDD4=3D> Btrfs raid1 profile for metadata and data.


Setup btrbk to take snapshots and use btrfs send/receive to cheaply
replicate A to B. Configure a scheduled scrub of A and B once a month.

Assuming A has more storage capacity than B, you can have important vs
throwaway subvolumes. Important is backed up, and throwaway isn't.

If A has problems and can't be repaired, just blow it away and
recreate it from scratch, then restore from the latest snapshot on B.

Still another variation would be to skip the cache, and setup a
separate file system on the SSDs.

--=20
Chris Murphy
