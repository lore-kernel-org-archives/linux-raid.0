Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CAFC433EF
	for <linux-raid@archiver.kernel.org>; Fri, 21 Jan 2022 19:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbiAUTbE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Jan 2022 14:31:04 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:47581 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232207AbiAUTbE (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 21 Jan 2022 14:31:04 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1nAzck-0009ug-5M;
        Fri, 21 Jan 2022 19:31:03 +0000
Message-ID: <6cfb92e5-5845-37ff-d237-4c3d663446e3@youngman.org.uk>
Date:   Fri, 21 Jan 2022 19:31:02 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: hardware recovery and RAID5 services
Content-Language: en-GB
To:     David T-G <davidtg+robot@justpickone.org>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <20220121164804.GE14596@justpickone.org>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <20220121164804.GE14596@justpickone.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 21/01/2022 16:48, David T-G wrote:
> Has anyone worked with any recovery companies in the US?  One of the 4T
> devices failed, possibly just because of motor issues, and one is
> throwing read errors, while two are just fine.  This would probably be
> easy for the right folks to fix, of course at some cost; the question is
> are there any folks that you might recommend and how much is that cost.

I've heard assorted stories about sticking drives in the freezer to help 
them recover, and have personal experience of being given a drive that 
has "failed" and I've managed to recover. Firstly, do you have a new 4TB 
drive to recover to? My worry is trying to copy the drive with read 
errors may lead to even more trouble. I'd try and recover it with 
ddrescue, and see how much it can get back.

Secondly, I'm sure I've dealt with these people in the past, although I 
can't vouch for them ...

https://www.vogon-computer-evidence.com/our-story/

I didn't use them for recovering damaged kit, we just had a bunch of 
9-track backups, but no 9-track drive, so they dumped them to CD for us. 
 From a business p-o-v it wasn't expensive ... see if they've got an 
operation near you. Describe your problem in as much detail as you can, 
and see if they'll give you an estimate ...

Cheers,
Wol
