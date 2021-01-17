Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E7CC433DB
	for <linux-raid@archiver.kernel.org>; Sun, 17 Jan 2021 22:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C0032076E
	for <linux-raid@archiver.kernel.org>; Sun, 17 Jan 2021 22:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbhAQWjL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 17 Jan 2021 17:39:11 -0500
Received: from li1843-175.members.linode.com ([172.104.24.175]:59256 "EHLO
        mail.stoffel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729422AbhAQWjK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 17 Jan 2021 17:39:10 -0500
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id E8558216E7;
        Sun, 17 Jan 2021 17:38:28 -0500 (EST)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id 7A10AA6B76; Sun, 17 Jan 2021 17:38:28 -0500 (EST)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <24580.48228.432544.10328@quad.stoffel.home>
Date:   Sun, 17 Jan 2021 17:38:28 -0500
From:   "John Stoffel" <john@stoffel.org>
To:     " " <Cedric.dewijs@eclipso.eu>
Cc:     <linux-raid@vger.kernel.org>
Subject: Re: What is the best way to combine 4 HDD's and 2 SSD's into a single
        filesystem?
In-Reply-To: <950d061954e1f779739c9c5777b94ade@mail.eclipso.de>
References: <950d061954e1f779739c9c5777b94ade@mail.eclipso.de>
X-Mailer: VM 8.2.0b under 26.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>>   <" <Cedric.dewijs@eclipso.eu>> writes:

> ­I have 4 slow, loud, big, power hungry and old hard drives, and 2 SSD's. I'm trying to come up with a way to combine them into a system that has the following characteristics:
> A) The hard drives stop spinning 5 minutes after they have been used.
> B) The SSD's are used for read and write caching. Writes to the system are absorbed by the SSD's. Only when the ssd's are full of dirty data, then the hard drives are woken up. (This means the SSD's contain dirty data for potentially a long time.)
> C) When data is requested that's not present on the SSD's (a read cache miss), then the hard drive which has that data is woken up.
> D) When a hard drive is woken up as a result of a read cache miss, then the SSD's write out the dirty data to that drive.
> E) If one drive fails, or starts to produce random data, the system must return the correct data to the user.

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
> Btrfs in raid 1 is able to handle a failing hard drive, both when it failed completely, and when it corrupts data.
> Bcache is capable of using an ssd to cache the read and the write requests from btrfs. 
> The not-so-good:
> Bcache can only use one SSD, so using bcache is only possible as read cache in order to achieve characteristic E, but this prevents characteristic B to be achieved.
> I can't get bcache to read-ahead the data that is adjacent to the data that has just been accessed.

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

> This requires more SSD's and more (SATA) ports than I have.  I can't
> get bcache to read-ahead the data that is adjacent to the data that
> has just been accessed.

Why don't you just partition your SSD(s) into 4 partitions and use
each partition as a cache for a seperate HDD?  The SSDs have more than
enough IOPs to handle the load.  But!  I would mirror a pair of SSDs
and mirror pairs of disks for even more redundancy and reliability
here.


> Third idea is to use mdadm to create a raid 0 array out of the 2
> SSD's to create a fault tolerant write cache:

No, RAID1 (mirror) not a RAID 0 stripe across two SSDs.

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
> This setup is capable of achieving all characteristics I'm after. It can handle abrupt failure of a single drive.
> The not-so-good:
> When one of the SSD's start to produce random data, mdadm is not able to know what SSD produces correct data, and data is lost. (both copies of the data btrfs is trying to write to underlying storage are on the 2 SSD's.

> Fourth idea is to use dm-cache. Dm-cache can only cache one backing device, and it has no way to use 2 cache devices. 
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

Remember, a single SSD can handle loads more IOPs than all four of
your drives, so partitioning your SSDS might be an answer to your
solutions.

