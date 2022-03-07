Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B890AC433EF
	for <linux-raid@archiver.kernel.org>; Mon,  7 Mar 2022 14:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237594AbiCGOUL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Mar 2022 09:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbiCGOUK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Mar 2022 09:20:10 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106523A184
        for <linux-raid@vger.kernel.org>; Mon,  7 Mar 2022 06:19:16 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id kt27so32397316ejb.0
        for <linux-raid@vger.kernel.org>; Mon, 07 Mar 2022 06:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:references:from
         :in-reply-to:content-transfer-encoding;
        bh=VqMjXfW3DCCJ+9PbeG8/H+/I5ijzaS6z6cL2qigdRsU=;
        b=hoPqpDYQIaTU8qe3YtB1QI/lq4e0X2jC+SRv1ZlFZlIUMEe6P47+Zwsv6IjELrXg0A
         IRQfXLYlrnHVObZnpOpeTFt1NaDOJNx7Sp7FrrqJD94uWv34FLIh9rLdf1ph9w9VJgnN
         CM9G5P/bOueubC0yIj5ob0g1zwuGKNhuJfqv7oNFvg/mYHVg2extat04K0IpbFTYoVBJ
         vFvPXTKIMGgk96r1KQ4TIaIUmyLHFmnZn3X981sDaJ6hU6nPQLdjSBYhDK9wjlMPRDS7
         r5fF8lA5MBhYi+WaOCtje26vxJe6tbrNARPKSW1ziYjowNLoD7FVtKjNGciebqS7ruqf
         fwAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:references:from:in-reply-to:content-transfer-encoding;
        bh=VqMjXfW3DCCJ+9PbeG8/H+/I5ijzaS6z6cL2qigdRsU=;
        b=VOQb2qtcv8lE2CVZl1dy9LPDnCO3lf4tz4ifyx6Mf8g2j5cpruTke6gH3whYRF2bh0
         fOICkB/Ks1H0DPv50q2B0CHfJ/GFTiAwUxmWqUSEHgx+D/MwbRZT16+dzWW6wNdpxDjl
         8fUtGffWlEl5U/RKVd6Q9C/hVBLIcWGVu9VLFuxAuGOycWSYlTDAPzCuj6JhvIrvsiSt
         yCp6Tgkjm684ndAzdF/k7PSpQq1eQbJ8h1oZX9WP6sUW6TvNd/NBjEXytBrjbqd1RVec
         BOpOcD+ubbCSN9d02pxwwCHvz2e8wckB91YOuk7XYAsApzxyAphRgL2zkjhuMvbaTyvc
         /8Mg==
X-Gm-Message-State: AOAM532l+K7l3K0hLDQVZxEPehXo8kH/iJGM9gyrtXEP3XrkBIZC1NbW
        X38DOzxMeCaBw+o7koveVXg/mPrus4Mmhw==
X-Google-Smtp-Source: ABdhPJxkEUis4rXAJf+BSCJiuWZhmOmUMl7qHrz+OozvioJDCoLDISehGFH2AGrJ+eqixmXg5Rxomg==
X-Received: by 2002:a17:906:6d09:b0:6b9:2e0e:5bdd with SMTP id m9-20020a1709066d0900b006b92e0e5bddmr9029027ejr.246.1646662754369;
        Mon, 07 Mar 2022 06:19:14 -0800 (PST)
Received: from ?IPV6:2a02:8109:8640:217c:10b4:80ba:ac1b:b250? ([2a02:8109:8640:217c:10b4:80ba:ac1b:b250])
        by smtp.gmail.com with ESMTPSA id t19-20020a1709060c5300b006d582121f99sm4726508ejf.36.2022.03.07.06.19.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 06:19:13 -0800 (PST)
Message-ID: <335f6238-9329-7616-051f-075706ac9022@gmail.com>
Date:   Mon, 7 Mar 2022 15:19:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: striping 2x500G to mirror 1x1T
To:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <20220305044704.GB4455@justpickone.org>
From:   Natanji <natanji@gmail.com>
In-Reply-To: <20220305044704.GB4455@justpickone.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello David,
what you propose here should work, but be aware that you are essentially 
first writing all data to the 2 smaller drives and then reading from 
them only when the mirror 1 TB disk gets added. If there are bad sectors 
that only gets dicovered while reading (not writing), you might lose 
data. A much cleaner way would be to make a backup of your data disk and 
then first crate the array with all disks, then write the data back from 
your backup once the disks are in sync. You should definitely make a 
backup or you could potentially lose data when creating this array.

I don't see the benefit of striping in your setup, by the way. For the 
two smaller disks it might seem that this is beneficial for performance, 
but since every write also needs to be made on the mirror, this will 
essentially lead to your read/write head moving back and forth a lot, 
no? Because if you write four consecutive chunks C1-C4 on the striped 
side, two of these would be written to each smaller disk. And on the 1 
TB disk side this would mean writing the sectors with only one 
read/write head, each around 500GB apart from each other, and in a back 
and worth fashion (although that might be optimized by queuing). So your 
write performance could actually be *worse* than on a single drive, and 
definitely not gain the 2x speed benefit of striping. For read 
performance you might be okay, but nevertheless put unneccessary 
mechanical wear on your 1 TB drive.

[C1 C3 ....] 500GB-1      [C2 C4 ....] 500GB-2
[C1 C3 ... (500G space)  C2 C4 ....] 1TB

At least that's my understanding, someone correct me if I'm wrong and 
mdadm handles such setups more intelligently (i.e. by laying out the 
chunks completely linearly on the 1TB disk instead of 1-to-1 "mirroring" 
the chunks on the 2x500G RAID0). If you think I'm correct, then instead 
of striping I would just use linear mode on the 500GB disks to pool them 
into one large volume, and thus essentially get Raid1 speed benefits of 
double read performance compared to a single drive. This has the 
downside of putting very different wear on the two 500GB volumes, of course.

Best regards,
Natanji

Am 05.03.2022 um 05:47 schrieb David T-G:
> Hi, all --
>
> I have a 1T data drive (currently in use with data) that I'd like to
> mirror with a pair of 500G drives striped together.  I'll be mirroring
> two partitions, and I'll be striping partitions to ensure the correct
> size, and my understanding is that I'll have to create the mirror on the
> two new drives with half missing, mount it up, copy over the data, dump
> the original disk, and add it as the other half of the mirror to sync.
> If I've missed anything there, please let me know, but all of that
> matches my Googling and I don't think I have any questions.
>
> What I do wonder, and what I don't see in any searches since apparently
> nobody talks about striping up half of a mirror, is if I should do
> anything special with my two-disk RAID0 stripe.  I was gobsmacked at
> the simplicity of RAID10 on only two drives by splitting each in half
> and "flipping" one to maximize head movement performance.  Awesome! :-)
> Are there any brilliant hacks for simple striping?  If I'm just putting
> together two [not terribly large] disks, will I benefit from any other
> funny stuff, or should I just stripe together two partitions -- each
> half the size of my other drive, of course -- to make a "boring basic"
> stripe and run with that?
>
>
> TIA & HANW
>
> :-D
