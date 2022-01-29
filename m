Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB6F5C433EF
	for <linux-raid@archiver.kernel.org>; Sat, 29 Jan 2022 15:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243765AbiA2Pg1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 29 Jan 2022 10:36:27 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:47187 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235877AbiA2PgZ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 29 Jan 2022 10:36:25 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1nDpm3-0000LK-Dg; Sat, 29 Jan 2022 15:36:23 +0000
Message-ID: <c3b7a580-952f-7c7a-fddc-88ca0b5fde84@youngman.org.uk>
Date:   Sat, 29 Jan 2022 15:36:21 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: hardware recovery and RAID5 services
Content-Language: en-GB
To:     Phil Turmel <philip@turmel.org>,
        Roger Heflin <rogerheflin@gmail.com>
Cc:     David T-G <davidtg+robot@justpickone.org>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <20220121164804.GE14596@justpickone.org>
 <6cfb92e5-5845-37ff-d237-4c3d663446e3@youngman.org.uk>
 <33fb3dfd-e234-14d9-7643-3449c700a241@youngman.org.uk>
 <b052c0be-a57b-7e2f-c2ca-44a58e971e39@youngman.org.uk>
 <CAAMCDeeXT2Sy5Tczou7X6uO1yJx9TigEmJz9guwPUjT5SiEzQQ@mail.gmail.com>
 <7571b432-4b19-3de4-b04d-3a46b09b0629@turmel.org>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <7571b432-4b19-3de4-b04d-3a46b09b0629@turmel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 22/01/2022 22:23, Phil Turmel wrote:
> That said, I highly recommend copying the disk showing read errors onto 
> another disk, keeping the log of sectors replaced by zeros. Then 
> performing a file by file backup from the degraded array, using the copy 
> instead of the troubled drive.

I believe there is also a way of injecting a hardware error onto a 
drive. Unless you can take a backup of the backup :-) I wouldn't 
recommend it at the moment, but there's some ATA command or whatever 
that tells the drive to flag a sector as bad, and return a read error 
until it's over-written.

Obviously, doing that on the sectors that weren't rescued, and then 
doing a scrub, is going to recover your data if it's both possible and 
done right :-)

Cheers,
Wol
