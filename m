Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95839C4332F
	for <linux-raid@archiver.kernel.org>; Fri, 25 Nov 2022 09:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiKYJ6C (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Nov 2022 04:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiKYJ5i (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 25 Nov 2022 04:57:38 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C08110FFA
        for <linux-raid@vger.kernel.org>; Fri, 25 Nov 2022 01:56:19 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1oyK5k-000BqU-Eq;
        Thu, 24 Nov 2022 21:49:08 +0000
Message-ID: <a0eae02e-8d6e-39ad-19a0-574d92891687@youngman.org.uk>
Date:   Thu, 24 Nov 2022 21:49:07 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: how do i fix these RAID5 arrays?
Content-Language: en-GB
To:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <20221123220736.GD19721@jpo> <20221124032821.628cd042@nvm>
 <CAAMCDedMhATuEPx8yFzAwxf5zS7CXFhz6702rmUCg7pXQX4qSA@mail.gmail.com>
 <20221124212007.GF19721@jpo>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <20221124212007.GF19721@jpo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 24/11/2022 21:20, David T-G wrote:
> Roger, et al --
> 
> ...and then Roger Heflin said...
> ...
> %
> %  I use LVM on a 4 section raid built very similar to his, except mine
> % is a linear lvm so no raid0 seek issues.
> 
> Got any pointers to instructions?

Dunno whether my setup would work for you, but I've raid-5'd my disks, 
then put a single lvm volume over the top, and then broken that up into 
partitions as required.

Note that I didn't raid the entire disk, I left space for swap, boot. and /.

And I always plan to expand the array by doubling the size of the disks. 
Effectively a raid-5+0 sort of thing. Add two double-size disks, raid-0 
the disks I've removed and add them, and there's probably enough space 
to resize onto those three before doubling up what's left and adding 
that back.

(Note also I've got dm-integrity in there too, but that's me.)

https://raid.wiki.kernel.org/index.php/System2020

Cheers,
Wol
