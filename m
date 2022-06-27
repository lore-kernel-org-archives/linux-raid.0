Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA83BC43334
	for <linux-raid@archiver.kernel.org>; Mon, 27 Jun 2022 15:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237637AbiF0PKv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 27 Jun 2022 11:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235052AbiF0PKu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 27 Jun 2022 11:10:50 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF379D12E
        for <linux-raid@vger.kernel.org>; Mon, 27 Jun 2022 08:10:48 -0700 (PDT)
Received: from host86-158-155-35.range86-158.btcentralplus.com ([86.158.155.35] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1o5qNy-00022t-4s;
        Mon, 27 Jun 2022 16:10:46 +0100
Message-ID: <d058da47-528e-f9af-dbb1-5941eef72b56@youngman.org.uk>
Date:   Mon, 27 Jun 2022 16:10:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: what's wrong with RAID-10? (was "Re: moving a working array")
Content-Language: en-GB
To:     David T-G <davidtg-robot@justpickone.org>,
        Linux-RAID <linux-raid@vger.kernel.org>
References: <CAPpdf595_7eW8amX8eueMxgjaWvLW-hWHh1SHHaGAt8YyP7yDw@mail.gmail.com>
 <7683b644cf076f8db06d60fdd3e4f88424f35bd2.camel@gmail.com>
 <92378403-adf6-dedb-828c-81b331c1d8c1@youngman.org.uk>
 <20220627104109.GJ18273@justpickone.org>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <20220627104109.GJ18273@justpickone.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 27/06/2022 11:41, David T-G wrote:
> Wol, et al --
> 
> ...and then Wols Lists said...
> %
> % On 24/06/2022 15:09, Wilson Jonathan wrote:
> % > On Fri, 2022-06-24 at 08:38 -0500, o1bigtenor wrote:
> % > >
> % > > I have a working (no issues) raid-10 array in one box.
> %
> % Bummer. It's a raid-10. A raid-1 would have been easier.
> [snip]
> 
> This tripped me.  I presumed that the reason for -10, not least because
> he also said "these 4 drives", was because the array space is bigger than
> just one hard drive size, ie 6T on 4ea 3T drives.  How would RAID-1 work
> for that storage?  And why would it be easier than RAID-10?
> 
Just that raid-1 would have been a simple case of two drives, each a 
backup of the other. Keep one safe, put the other in the new system.

With raid-10, it's much more complicated - you can't just do that :-(

Cheers,
Wol
