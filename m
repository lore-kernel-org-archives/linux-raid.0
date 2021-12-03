Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E9CEC433EF
	for <linux-raid@archiver.kernel.org>; Fri,  3 Dec 2021 18:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238512AbhLCSeL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Dec 2021 13:34:11 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59531 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231857AbhLCSeL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Dec 2021 13:34:11 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C13835C044D
        for <linux-raid@vger.kernel.org>; Fri,  3 Dec 2021 13:30:46 -0500 (EST)
Received: from imap47 ([10.202.2.97])
  by compute6.internal (MEProxy); Fri, 03 Dec 2021 13:30:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
        mime-version:message-id:in-reply-to:references:date:from:to
        :subject:content-type; s=fm1; bh=hg4OahYr0Ft4WPN+eBw/cGDrUC37eJy
        lGoL926GDLyk=; b=Vdq4MVLQ9h4C5XN+8M9y9RtsaTNuyIhY5brnsha25Q/B/Of
        A52GKKx5unqOYkUsekVb8K5jCkifb1gLDme7v8bAjSoY8cR97MTm5WDdS/Vj9Igd
        UpzkkPNkwhZoQepBBqh/UwGRbtjekezku+xpTQ21aacdiLcsDTpTJOQFQiZEwhbi
        k8O23Nwlk4ep0VGUWbgr9hqbbotTmoMAm7KCd+VcoHVQ9wj6G2jTUe8wgqMtwRYZ
        drci9LKrxMEFkIhDNiqaWVH9N26IxFFuQcuMmihC8oIp3KCrybiWkK/R1yMpFoaQ
        Os5PBHKEJrpHcW8Z2bGaAE+30o440w8TCrX/ugg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hg4Oah
        Yr0Ft4WPN+eBw/cGDrUC37eJylGoL926GDLyk=; b=AznFNdPosIZ+gh3b7FrZPW
        /oMea7aX3tdka4jrnL+pe+G76znixI+LTKTHfpWE/23G3ct925lxlhy7CALFdUCj
        kDMsPu5NZdP2+ss/pOmRRDOhYmhLWt6ZR8a5Cy9KY3N1w/xsPnsm5Aw9CFBIueyW
        iPzHiE/jQQ2Q0eg8TxkJZ2gWnIXeoYHU2PaqjEDLMvtjeM5KtJ44/PG/F6jgGgWP
        S9Q5ulIiuHxs69W4r5Xe/TpER+0aVAJHysJVWKIqlBO8LPiZRq0XLQ4z8TCv65sN
        KgT2VFuMHmq6iRF4Xl6b3/EGfWqiaCkot/8u9HEwTrwHpVpCHf/BJuIkEyr1wDMg
        ==
X-ME-Sender: <xms:VmKqYe5ogHRtafjym0UClFZAlOla04H3bIVLRhBuEEXDRD_i03WYyw>
    <xme:VmKqYX6dUGAF4a8ZErHNA82rw_LiSspCultEnVMkHaR7MjWOashAhtSUxrNAeMMAh
    FHPF_k2vz4W31d2>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrieejgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefofgggkfgjfhffhffvufgtsehttd
    ertderredtnecuhfhrohhmpehlihhsthihsehfrghsthhmrghilhdrfhhmnecuggftrfgr
    thhtvghrnhepgfevjeevhfefvefhfeeiieehkeduvdfgudduhfehudetheelffffgfffgf
    duiefgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    lhhishhthiesfhgrshhtmhgrihhlrdhfmh
X-ME-Proxy: <xmx:VmKqYdeaWtuFEVZOJ9UR_PNM91u4T2bxpyC1VsRmVedVCnD9es06dA>
    <xmx:VmKqYbKDyEHPuM0Ll_vrJNaJQweRU1e5ULOxGknxI6DpjpHdyOGMJw>
    <xmx:VmKqYSLDDSncwtARbUL4C39GW_nRicG6ujaYcljHZ-1fA75MaQBcWQ>
    <xmx:VmKqYXXDb06O6kZJL1I-SeMccKQi-bPy8AAZ_LVgWKCobEdxcGWMpg>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 89C9827407E5; Fri,  3 Dec 2021 13:30:46 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-4458-g51a91c06b2-fm-20211130.004-g51a91c06
Mime-Version: 1.0
Message-Id: <0b869e69-56ae-4eea-8951-bb3b6c5770dd@www.fastmail.com>
In-Reply-To: <0b763738-8c4a-f960-7e3e-6c94a04ac519@eyal.emu.id.au>
References: <7be1c467-c2c2-5f90-dc1c-f1c443954f03@mattyo.net>
 <0b763738-8c4a-f960-7e3e-6c94a04ac519@eyal.emu.id.au>
Date:   Fri, 03 Dec 2021 13:30:16 -0500
From:   listy@fastmail.fm
To:     linux-raid@vger.kernel.org
Subject: Re: Help ironing out persistent mismatches on raid6
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Dec 2, 2021, at 18:33, Eyal Lebedinsky wrote:
> I use debugfs to do this. Knowing each fs block range (lo hi) 
> calculated from the raid mismatch notice:
>
> I first identify the relevant blocks in each reported range with
> 	debugfs -R "testb $lo $((hi-lo))" $device
> then locate the associated inodes with
> 	debugfs -R "icheck $list" $device
> and finally discover files in these locations with
> 	debugfs -R "ncheck $inode" $device


Thank you very much... this is exactly what I was looking for and it worked brilliantly. For posterity,  here's a summary of the process in my case.  First I converted the md sector numbers to ext4 block numbers:
2742891144 * 512 / 4096 + 0 =  342861393 
And md also told me the mismatches basically covered 5 4KiB contiguous blocks.  So...
 
   debugfs -R "testb 342861393 5" /dev/md1

told me all 5 blocks were in use.  Then using all 5 block numbers...

   debugfs -R "icheck 342861393 342861394 342861395 342861396 342861397" /dev/md1

gave me a single inode number. Then...

   debugfs -R "ncheck 299893552" /dev/md1

gave me the filename (e.g.)  /videos/00001.MTS         Then...

cp -a /videos/00001.MTS   /tmp  && rm /videos/00001.MTS ;  debugfs -R "testb 342861393 5" /dev/md1

resulted in those same 5 blocks now *not* being in use.    Then

   echo 2742891144 > /sys/block/md1/md/sync_min
   echo 2743074816 > /sys/block/md1/md/sync_max   # rounded up to next 512KiB chunk
   echo repair > /sys/block/md1/md/sync_action
   cat /sys/block/md1/md/sync_completed
   # only took a couple seconds
   echo idle > /sys/block/md1/md/sync_action
   mv /tmp/00001.MTS  /videos

I was surprised that while I was hitting those sectors, md did not report the mismatches.  And I worried that maybe I calculated the wrong blocks.  But then I did a check of the entire array overnight, and there were no mismatches reported, for the first time in a year or two of weeks.  So I guess it worked.  I actully am still a bit confused on when md components are dealing in bytes, sectors or chunks, but in this case it worked out.

Anyway, thank you, Eyal!!

-Matt
