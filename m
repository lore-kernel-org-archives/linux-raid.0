Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6593DC433B4
	for <linux-raid@archiver.kernel.org>; Thu, 29 Apr 2021 09:11:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22D6361449
	for <linux-raid@archiver.kernel.org>; Thu, 29 Apr 2021 09:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbhD2JMI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 29 Apr 2021 05:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235645AbhD2JMH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 29 Apr 2021 05:12:07 -0400
X-Greylist: delayed 370 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 29 Apr 2021 02:11:21 PDT
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC75AC06138E
        for <linux-raid@vger.kernel.org>; Thu, 29 Apr 2021 02:11:21 -0700 (PDT)
Received: from natsu (natsu2.home.romanrm.net [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id 26051684;
        Thu, 29 Apr 2021 09:05:07 +0000 (UTC)
Date:   Thu, 29 Apr 2021 14:05:06 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     d tbsky <tbskyd@gmail.com>
Cc:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: add new disk with dd
Message-ID: <20210429140506.537c3c4a@natsu>
In-Reply-To: <CAC6SzHLDYhQDtfQMYozN6EBYB=nsKvB77hmyByZNr9uTpQH+KQ@mail.gmail.com>
References: <CAC6SzHLDYhQDtfQMYozN6EBYB=nsKvB77hmyByZNr9uTpQH+KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 29 Apr 2021 16:52:21 +0800
d tbsky <tbskyd@gmail.com> wrote:

> Hi:
>    I want to replace a fault disk for software raid5. there is
> something like grub/biosgrub at the beginning of the disk, so if I can
> use command below to copy them:
> 
> "dd if=/dev/sda of=/dev/sdb bs=1M count=10"
> 
> if it is a gpt disk I can use sgdisk to copy the partition table then
> radmonize guid.

Do you use whole disks or partitions as MD members? Better use partitions. And
if so, you can simply run "wipefs -a /dev/sdb1" after your dd, to wipe all the
MD metadata that got copied.

> however dd may also copy the mdadm superblock which include internal
> bitmap(since I don't caculate correct size). I don't know if there is
> risk that mdadm will be confused with the bitmap in new disk. although
> I have tried and it seems work fine.

Without wiping the metadata, don't plug in both disks at the same time, and
don't even plug in the new disk alone. With metadata at the beginning, mdadm
might pick up the new one as a normally operating array member, whereas it
only has 10 MB of the actual data copied to it.

-- 
With respect,
Roman
