Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B54D7C77B61
	for <linux-raid@archiver.kernel.org>; Mon, 24 Apr 2023 07:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbjDXHli (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Apr 2023 03:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbjDXHlg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Apr 2023 03:41:36 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA44E5E
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 00:41:35 -0700 (PDT)
Received: from host86-156-145-149.range86-156.btcentralplus.com ([86.156.145.149] helo=[192.168.1.99])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pqqpJ-0006Py-C3;
        Mon, 24 Apr 2023 08:41:33 +0100
Message-ID: <bf2f7cb0-c0ae-540d-4231-a3ec9e52da3e@youngman.org.uk>
Date:   Mon, 24 Apr 2023 08:41:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Raid5 to raid6 grow interrupted, mdadm hangs on assemble command
To:     Jove <jovetoo@gmail.com>, linux-raid@vger.kernel.org
References: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
Content-Language: en-GB
Cc:     Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 23/04/2023 20:09, Jove wrote:
> # mdadm --version
> mdadm - v4.2 - 2021-12-30 - 8
> 
> # mdadm -D /dev/md0
> /dev/md0:
>             Version : 1.2
>       Creation Time : Sat Oct 21 01:57:20 2017
>          Raid Level : raid6
>          Array Size : 7813771264 (7.28 TiB 8.00 TB)
>       Used Dev Size : 3906885632 (3.64 TiB 4.00 TB)
>        Raid Devices : 4
>       Total Devices : 5
>         Persistence : Superblock is persistent
> 
>       Intent Bitmap : Internal
> 
>         Update Time : Sun Apr 23 10:32:01 2023
>               State : clean, degraded
>      Active Devices : 3
>     Working Devices : 5
>      Failed Devices : 0
>       Spare Devices : 2
> 
>              Layout : left-symmetric-6
>          Chunk Size : 512K
> 
> Consistency Policy : bitmap
> 
>          New Layout : left-symmetric
> 
>                Name : atom:0  (local to host atom)
>                UUID : 8c56384e:ba1a3cec:aaf34c17:d0cd9318
>              Events : 669453
> 
>      Number   Major   Minor   RaidDevice State
>         0       8       33        0      active sync   /dev/sdc1
>         1       8       97        1      active sync   /dev/sdg1
>         3       8       49        2      active sync   /dev/sdd1
>         5       8       80        3      spare rebuilding   /dev/sdf
> 
>         4       8       64        -      spare   /dev/sde

This bit looks good. You have three active drives, so I'm HOPEFUL your 
data hasn't actually been damaged.

I've cc'd two people more experienced than me who I hope can help.

Cheers,
Wol
