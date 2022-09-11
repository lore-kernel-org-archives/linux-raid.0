Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6497C6FA83
	for <linux-raid@archiver.kernel.org>; Sun, 11 Sep 2022 10:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiIKKIm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 11 Sep 2022 06:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiIKKIl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 11 Sep 2022 06:08:41 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC932BB02
        for <linux-raid@vger.kernel.org>; Sun, 11 Sep 2022 03:08:39 -0700 (PDT)
Received: from host86-157-192-122.range86-157.btcentralplus.com ([86.157.192.122] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1oXJtF-0006UD-52;
        Sun, 11 Sep 2022 11:08:37 +0100
Message-ID: <73143dc1-e259-9dd1-d146-81d6c576b5d4@youngman.org.uk>
Date:   Sun, 11 Sep 2022 11:08:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: 3 way mirror
Content-Language: en-GB
To:     Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <CAJH6TXj0y_bfJ1q50S7xnTyz_4BSrgNboim9e+zK1nKZX9MR3g@mail.gmail.com>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <CAJH6TXj0y_bfJ1q50S7xnTyz_4BSrgNboim9e+zK1nKZX9MR3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/09/2022 10:08, Gandalf Corvotempesta wrote:
> let's assume a 3 way mirror (raid1 with 3 disks)
> One disk got a bad sector detrcted by smartd
> what happens trying to read or write to that sector?

I'm guessing when linux goes to read the data, the read will fail.
> 
> is md smart enough to read from the other 2 disks and serve consistant data?

Very much so, PROVIDED linux returns a read error for the disk.
> 
> in other words, can i delay the disk replacement for a couple of days
> (i've ordered the disk today, will came tuesday) ?

What sort of error? A new disk *may* be overkill ...


Firstly, this is a disk level problem. The whole point of raid is to 
protect your data from disk level problems :-)

Secondly, this is a disk level problem. The dodgy sector might not even 
be in use, so there's no data there to lose.

Thirdly, this is a disk level problem. It may be a simple case of the 
disk needs to rewrite the data and relocate the sector and everything 
will be hunky-dory again. BUT IT CAN'T DO THAT UNTIL LINUX GIVES IT NEW 
FRESH DATA.

So you need to quiesce the disk (basically, shut down as many processes 
as you can, maybe do this overnight), and run a scrub. That will tell 
you if linux/mdraid thinks there's a problem.

Then re-run smartd and see if it's fixed the problem.

Then look at the smartd output and ask yourself "do I really need a new 
disk?". I wouldn't send the new one back. Depending on how well you are 
off for disk space and SATA ports, now you've got the new disk, if the 
old one is still good I'd go for a 3-disk raid-5 plus spare. That's my 
current setup.

Cheers,
Wol
