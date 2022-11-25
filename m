Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C89CC4332F
	for <linux-raid@archiver.kernel.org>; Sat, 26 Nov 2022 19:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiKZTSz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 26 Nov 2022 14:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiKZTSv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 26 Nov 2022 14:18:51 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EE1F584
        for <linux-raid@vger.kernel.org>; Sat, 26 Nov 2022 11:18:49 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1oya1K-000Bjf-8X;
        Fri, 25 Nov 2022 14:49:38 +0000
Message-ID: <f58964da-4ded-61a8-bd6a-e2391557b38a@youngman.org.uk>
Date:   Fri, 25 Nov 2022 14:49:38 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: how do i fix these RAID5 arrays?
Content-Language: en-GB
To:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <20221124211019.GE19721@jpo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 24/11/2022 21:10, David T-G wrote:
> I don't want to try BtrFS.  That's another area where I have no experience,
> but from what I've seen and read I really don't want to go there yet.

Btrfs ...

It's a good idea, and provided you don't do anything esoteric it's been 
solid for years.

It used to have a terrible reputation for surviving a disk full - at a 
guess it needs some disk space to shuffle its btree to recover space - 
and a disk-full situation borked the garbage collection.

Raid-1 (mirroring) by default only mirrors the directories, the data 
isn't mirrored so you can easily still lose that ... (they call that 
user misconfiguration, I call it developer arrogance ...)

Parity raid is still borken...

At the end of the day, if you want to protect your data, DON'T rely on 
the filesystem. There are far too many cases where the developers have 
made decisions that protect the file system (and hence computer uptime) 
at the expense of the data IN the filesystem. I don't give a monkeys if 
the filesystem protects itself to enable a crashed computer to reboot 
ten seconds faster, if the consequence of that change is my computer is 
out of action for a day while I have to restore a backup to re-instate 
the integrity of my data !!!

Cheers,
Wol
