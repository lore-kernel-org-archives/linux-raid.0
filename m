Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270ECC43334
	for <linux-raid@archiver.kernel.org>; Thu, 23 Jun 2022 12:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbiFWM46 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Jun 2022 08:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbiFWM45 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Jun 2022 08:56:57 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEDB4BBBA
        for <linux-raid@vger.kernel.org>; Thu, 23 Jun 2022 05:56:53 -0700 (PDT)
Received: from host86-158-155-35.range86-158.btcentralplus.com ([86.158.155.35] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1o4MOB-0006Sg-Ev;
        Thu, 23 Jun 2022 13:56:51 +0100
Message-ID: <81c50899-7edb-e629-3bbc-16cfa8f17e34@youngman.org.uk>
Date:   Thu, 23 Jun 2022 13:56:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: a new install - - - putting the system on raid
Content-Language: en-GB
To:     o1bigtenor <o1bigtenor@gmail.com>,
        Linux-RAID <linux-raid@vger.kernel.org>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 23/06/2022 13:11, o1bigtenor wrote:
> Greetings
> 
> https://raid.wiki.kernel.org/index.php/SATA_RAID_Boot_Recipe
> 
> Found the above recipe - - - the preface there is that this is
> an existing system.
> 
> I am wanting to have all of /efi/boot, /, swap, /tmp, /var, /usr and
> /usr/local on one raid-1 array and a second array for /home - - -
> on a new install.

/efi/boot (a) must be fat32, and (b) must be a "top level" partition. 
Okay, that's not totally true, but near enough, and scuppers your plan 
straight off ...

swap - why mirror it? If you set the fstab priorities to the same value, 
you get a striped raid-0 for free.

/tmp - is usually tmpfs nowadays, if you need disk backing, just make 
sure you've got a big-enough swap (tmpfs defaults to half ram, make it 
bigger and let it swap).
> 
> I have tried the following:
> 
> 1. make large partition on each drive
> 2. set up raid array (2 separate arrays)
> 3. unable to place partitions on arrays

Should be able to, but as above for your first array it won't actually 
work ...
> 
> 1. set up the same partitions on each set of drives
>      (did allocate unused space between each partition)
> 2. was only allowed one partition from each drive for the array
> 
> Neither option seems able to give me what I want.
> (More security - - - less likely to lose both drives (2 M2s and 2 SSDs).)
> 
> Is my only option to set up the arrays and then use LVM2 on top?
> (One more point of failure so would rather not.)

Well. I'm using lvm, it's normal practice, but again won't work for your 
first array ...
> 
> Is there another option somewhat like the method outlined above - - -
> recipe is some over 10 years old - - - or is this the only way to do things?

/boot/efi on its own partition

swap - its own partition

/tmp - tmpfs

/ (including /var and /usr) on one array

/home on the other array
> 
> Please advise.
> 
I've not done it, it's on my list of things to try, but you could put 
/boot/efi on v1.0 superblock raid-1 array and format it fat32. Make sure 
you know what you're doing!

That basically leaves swap and /tmp as your only unprotected partitions, 
neither of which is expected to survive any computer problems intact 
anyway (swap depends on your current session, and/tmp is *defined* as 
volatile and lost on shutdown.

My setup only has the one (raid-5) array for all my "real" partitions, 
and I've got lvm to give me / and /home (and others). It also gives me 
some degree of backup capability, as I just take snapshots. Running 
gentoo, that gives me security when I update the system every weekend :-)

https://raid.wiki.kernel.org/index.php/System2020

Cheers,
Wol
