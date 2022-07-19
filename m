Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A346C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 09:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236959AbiGSJRN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 05:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbiGSJRM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 05:17:12 -0400
Received: from box.sotapeli.fi (sotapeli.fi [37.59.98.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD942220C3
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 02:17:10 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 07E9E8358C;
        Tue, 19 Jul 2022 11:17:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sotapeli.fi; s=dkim;
        t=1658222227; h=from:subject:date:message-id:to:mime-version:content-type:
         content-transfer-encoding:in-reply-to:references;
        bh=sqDIWDH7NzKvAOS6v1TMwfvR+dADBtb5sUYL5smPFMM=;
        b=QdPj/m7DoJzKuF2T7mt1CwcNqPvRDRr9KwnfL5OLeJhRvcesqY957I3avnprpu/gY4Ts38
        S9qBPXA0Y3TrOaGfVJ+9iS6qFynA3M8bIN8tMBbtWymfx4ZuKHBnzPIa1D6KuVXXYR6FbX
        4X2E1Gf3q6yXrLcIQ0CA49dFtmVwZx98L1zM4/j1/zerJb5NUl2AlxiksiHJMJUMaB4yLj
        OtTpeyDqEgpvNwugntKHRNJbQNlhVk+PLKXdHTIBs452w49hkUEOuizfvG6lSlmS9XcC6E
        t8N1JmS0im7dxzMQo7aVHnmI2ZmdHT70/PIma4NMYYl9ry8uIJTK7qeyFvx64g==
Message-ID: <8ac1185f-1522-6343-c6c4-19bd307858f4@sotapeli.fi>
Date:   Tue, 19 Jul 2022 12:17:03 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: 5.18: likely useless very preliminary bug report: mdadm raid-6
 boot-time assembly failure
To:     Wols Lists <antlists@youngman.org.uk>, Nix <nix@esperi.org.uk>,
        linux-raid@vger.kernel.org
References: <87o7xmsjcv.fsf@esperi.org.uk>
 <d28a695e-1958-d438-b43d-65470c1bbe7a@youngman.org.uk>
From:   Jani Partanen <jiipee@sotapeli.fi>
In-Reply-To: <d28a695e-1958-d438-b43d-65470c1bbe7a@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Sorry to jump in but could you suggest something what is quite much 
default programs, not something that works only debian or something..
lsdrv on Fedora 36 spit this:
  ./lsdrv
   File "/root/lsdrv/./lsdrv", line 323
     os.mkdir('/dev/block', 0755)
                            ^
SyntaxError: leading zeros in decimal integer literals are not 
permitted; use an 0o prefix for octal integers



Wols Lists kirjoitti 18/07/2022 klo 16.17:
> On 18/07/2022 13:20, Nix wrote:
>> So I have a pair of RAID-6 mdraid arrays on this machine (one of which
>> has a bcache layered on top of it, with an LVM VG stretched across
>> both). Kernel 5.16 + mdadm 4.0 (I know, it's old) works fine, but I just
>> rebooted into 5.18.12 and it failed to assemble. mdadm didn't display
>> anything useful: an mdadm --assemble --scan --auto=md --freeze-reshape
>> simply didn't find anything to assemble, and after that nothing else was
>> going to work. But rebooting into 5.16 worked fine, so everything was
>> (thank goodness) actually still there.
>
> Everything should still be there ... and the difference between mdadm 
> 4.0 and 4.2 isn't that much I don't think ... a few bugfixes here and 
> there ...
>
> When you reboot into the new kernel, try lsdrv
>
> https://raid.wiki.kernel.org/index.php/Asking_for_help#lsdrv
>
> I don't know the current state of play with regard to Python versions 
> there ... last I knew I had to explicitly get it to invoke 2.7 ...
>
> But I've not seen any reports of problems elsewhere, so this is either 
> new or unique to you I would think ...
>
> Cheers,
> Wol

