Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A10FC433C1
	for <linux-raid@archiver.kernel.org>; Wed, 24 Mar 2021 15:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D06AE619B8
	for <linux-raid@archiver.kernel.org>; Wed, 24 Mar 2021 15:14:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236551AbhCXPOU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Mar 2021 11:14:20 -0400
Received: from rin.romanrm.net ([51.158.148.128]:57578 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236500AbhCXPNv (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 24 Mar 2021 11:13:51 -0400
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id 7A9E76A4;
        Wed, 24 Mar 2021 15:13:47 +0000 (UTC)
Date:   Wed, 24 Mar 2021 20:13:47 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Andy Smith <andy@strugglers.net>
Cc:     linux-raid@vger.kernel.org
Subject: Re: MDRaid Rollback
Message-ID: <20210324201347.33ef3184@natsu>
In-Reply-To: <20210324144407.GL3712@bitfolk.com>
References: <CA+OzjxLW2Vw-ecs7jNELecpYxoBbK767pXEV8rFVaQp_HXfjOg@mail.gmail.com>
        <20210324144407.GL3712@bitfolk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 24 Mar 2021 14:44:07 +0000
Andy Smith <andy@strugglers.net> wrote:

> The default metadata version (1.2) is placed at the start of an
> array, so even if zeroed this will prevent the array member being
> used as the filesystem that is on top of it.
> ...
> Finally, if you are on superblock versions 1.1 or 1.2 you may be
> able to work out the offset into the device and use a loop device to
> skip that, so treating it as a normal filesystem:
> 
>     https://raid.wiki.kernel.org/index.php/RAID_superblock_formats#The_version-1_Superblock_Format

Also could delete the partition and recreate it with the new starting offset,
matching the offset for actual data. Recently I've migrated a couple of disks
off LVM in this manner.

Or if the entire disk was used as an array member, then create a brand new
partition table on it, with a single partition of the required offset.

sfdisk is helpful for dumping partitions into a text file ("-d"), which can
then be edited and restored to the device with "sfdisk /dev/disk < file".

All of this is likely more complex if you have to use GPT.

-- 
With respect,
Roman
