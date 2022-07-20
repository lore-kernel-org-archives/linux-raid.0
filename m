Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 138A9C43334
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jul 2022 18:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiGTSc1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jul 2022 14:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiGTSc0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Jul 2022 14:32:26 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4E611163
        for <linux-raid@vger.kernel.org>; Wed, 20 Jul 2022 11:32:24 -0700 (PDT)
Received: from host86-158-105-35.range86-158.btcentralplus.com ([86.158.105.35] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1oEEUg-0008qI-4p;
        Wed, 20 Jul 2022 19:32:22 +0100
Message-ID: <2a0119a2-814f-d61b-cf82-b446c453e6dc@youngman.org.uk>
Date:   Wed, 20 Jul 2022 19:32:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: 5.18: likely useless very preliminary bug report: mdadm raid-6
 boot-time assembly failure
Content-Language: en-GB
To:     Nix <nix@esperi.org.uk>
Cc:     linux-raid@vger.kernel.org
References: <87o7xmsjcv.fsf@esperi.org.uk>
 <d28a695e-1958-d438-b43d-65470c1bbe7a@youngman.org.uk>
 <87bktjpyna.fsf@esperi.org.uk>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <87bktjpyna.fsf@esperi.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 20/07/2022 16:55, Nix wrote:
> [    9.833720] md: md126 stopped.
> [    9.847327] md/raid:md126: device sda4 operational as raid disk 0
> [    9.857837] md/raid:md126: device sdf4 operational as raid disk 4
> [    9.868167] md/raid:md126: device sdd4 operational as raid disk 3
> [    9.878245] md/raid:md126: device sdc4 operational as raid disk 2
> [    9.887941] md/raid:md126: device sdb4 operational as raid disk 1
> [    9.897551] md/raid:md126: raid level 6 active with 5 out of 5 devices, algorithm 2
> [    9.925899] md126: detected capacity change from 0 to 14520041472

Hmm.

Most of that looks perfectly normal to me. The only oddity, to my eyes, 
is that md126 is stopped before the disks become operational. That could 
be perfectly okay, it could be down to a bug, whatever whatever.

The capacity change thing scares some people but that's a a normal part 
of an array coming up ...

Cheers,
Wol
