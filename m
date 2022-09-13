Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 656BDC54EE9
	for <linux-raid@archiver.kernel.org>; Tue, 13 Sep 2022 18:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbiIMSXT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Sep 2022 14:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiIMSW7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 13 Sep 2022 14:22:59 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4217F5A8B2
        for <linux-raid@vger.kernel.org>; Tue, 13 Sep 2022 10:39:47 -0700 (PDT)
Received: from host86-157-192-122.range86-157.btcentralplus.com ([86.157.192.122] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1oY9sv-0000k2-9A;
        Tue, 13 Sep 2022 18:39:46 +0100
Message-ID: <15fabdc2-b5d1-785d-b082-765d0650f475@youngman.org.uk>
Date:   Tue, 13 Sep 2022 18:39:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: change UUID of RAID devcies
Content-Language: en-GB
To:     Reindl Harald <h.reindl@thelounge.net>,
        Pascal Hambourg <pascal@plouf.fr.eu.org>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <2341a2a9-b86e-f0e5-784a-05dbd474dec5@thelounge.net>
 <729bdc01-b0ae-887a-6d2a-5135d287636c@youngman.org.uk>
 <05a1161b-d798-c68f-d37c-a9fc373c6e73@thelounge.net>
 <0023fefe-aad1-e692-48dd-e354497f6e41@plouf.fr.eu.org>
 <1fb05e0f-34b7-3ec4-bc00-ec540e592f19@thelounge.net>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <1fb05e0f-34b7-3ec4-bc00-ec540e592f19@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 13/09/2022 12:12, Reindl Harald wrote:
> 
> "For example, you cannot create 3TB or 4TB partition size (RAID based) 
> using the fdisk command. It will not allow you to create a partition 
> that is greater than 2TB" makes me nervous
> 
> how to get a > 3 TB partition for /dev/md2
> 
> --------------------
> 
> and finally how would the command look for "Then with just two drives 
> you change the raid to raid-1"?
> 
> the first two drives are ordered to start with 1 out of 4 machines ASAP 
> given that the machine in front of me is running since 2011/06 365/24......

Dare I suggest you read the raid wiki site?

In particular
https://raid.wiki.kernel.org/index.php/Setting_up_a_(new)_system
https://raid.wiki.kernel.org/index.php/Converting_an_existing_system

Also a very good read ...
https://raid.wiki.kernel.org/index.php/System2020
Which is the system I'm typing this on.

These pages don't all jibe with what I remember writing, but read them 
carefully, make sure you understand what is going on, and more 
importantly WHY, and you should be good to go.

And when you're wondering how to go from the 4-drive raid-10 to the 
2-drive raid-1, you should be able to just fail/remove the two small 
drives and everything will migrate to your two new big drives, and then 
it's just whatever the command is to convert between raid levels. The 
drives will already be in a raid-1 layout, so converting from 10 to 1 
will just be a change of metadata.

Cheers,
Wol
