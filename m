Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC1D0C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 13:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbiGRNRi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 09:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbiGRNRf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 09:17:35 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32E727B0E
        for <linux-raid@vger.kernel.org>; Mon, 18 Jul 2022 06:17:33 -0700 (PDT)
Received: from host86-158-105-35.range86-158.btcentralplus.com ([86.158.105.35] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1oDQct-00092C-Dg;
        Mon, 18 Jul 2022 14:17:31 +0100
Message-ID: <d28a695e-1958-d438-b43d-65470c1bbe7a@youngman.org.uk>
Date:   Mon, 18 Jul 2022 14:17:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: 5.18: likely useless very preliminary bug report: mdadm raid-6
 boot-time assembly failure
Content-Language: en-GB
To:     Nix <nix@esperi.org.uk>, linux-raid@vger.kernel.org
References: <87o7xmsjcv.fsf@esperi.org.uk>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <87o7xmsjcv.fsf@esperi.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 18/07/2022 13:20, Nix wrote:
> So I have a pair of RAID-6 mdraid arrays on this machine (one of which
> has a bcache layered on top of it, with an LVM VG stretched across
> both). Kernel 5.16 + mdadm 4.0 (I know, it's old) works fine, but I just
> rebooted into 5.18.12 and it failed to assemble. mdadm didn't display
> anything useful: an mdadm --assemble --scan --auto=md --freeze-reshape
> simply didn't find anything to assemble, and after that nothing else was
> going to work. But rebooting into 5.16 worked fine, so everything was
> (thank goodness) actually still there.

Everything should still be there ... and the difference between mdadm 
4.0 and 4.2 isn't that much I don't think ... a few bugfixes here and 
there ...

When you reboot into the new kernel, try lsdrv

https://raid.wiki.kernel.org/index.php/Asking_for_help#lsdrv

I don't know the current state of play with regard to Python versions 
there ... last I knew I had to explicitly get it to invoke 2.7 ...

But I've not seen any reports of problems elsewhere, so this is either 
new or unique to you I would think ...

Cheers,
Wol
