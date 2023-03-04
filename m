Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83B6EC6FA8E
	for <linux-raid@archiver.kernel.org>; Sat,  4 Mar 2023 07:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjCDHzY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 4 Mar 2023 02:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCDHzX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 4 Mar 2023 02:55:23 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED4B18AAE
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 23:55:22 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 428261F8A3;
        Sat,  4 Mar 2023 07:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677916521; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p8D4n8biQulGbckft04SGMlSJwP89zJObA2T8t92i8M=;
        b=I1NEHNiI2pvosx1ZjYWFPw+738ONtUbzeZUZWXdSAnwPVzQAPL7d6S1MrjZ0XGH+z4k/My
        h0tM3Lkox2emOBPAwwNrDSPCQRpBf/qw+rxsyZloQG8iUoh/oeB2cZLkdxs9OTliug2r+F
        9pm6CBWCip6Y0odkEHBOKU+cGvBUiBs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677916521;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p8D4n8biQulGbckft04SGMlSJwP89zJObA2T8t92i8M=;
        b=H7x8A76P0Gr05FrCmYms6TocFJUiXh9si49+sV3iiNkgO0jkqf9BkGriJpgdzvfSJ2F+23
        iCqC8/N3mSVuV6DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1F70D13901;
        Sat,  4 Mar 2023 07:55:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HlVtOmj5AmQaFQAAMHmgww
        (envelope-from <hare@suse.de>); Sat, 04 Mar 2023 07:55:20 +0000
Message-ID: <d8b4cbdd-b47f-3456-232a-b784a4c7f325@suse.de>
Date:   Sat, 4 Mar 2023 08:55:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Why isn't the "Support Intel AHCI remapped NVMe devices" in
 mainline?
Content-Language: en-US
To:     Michael Fritscher <michael@fritscher.net>,
        "David F." <df7729@gmail.com>, Andrew R <junkbustr@gmail.com>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <CAGRSmLsh0aqJMuFzMMhm6fYjsCL-MNXR=t04cGj9FNvG0EENTQ@mail.gmail.com>
 <CAB-xnyD+iWsbuemirPyHqEG9DnbBb1unjj6D-21ZmBbjp9eAmA@mail.gmail.com>
 <CAGRSmLs1nVWHVEv5FXzDCbsC7otzsVr_HceXXruKDO228zM5Eg@mail.gmail.com>
 <d78d528f-d0fa-c04c-6bdd-0b48fc159671@fritscher.net>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <d78d528f-d0fa-c04c-6bdd-0b48fc159671@fritscher.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/3/23 23:39, Michael Fritscher wrote:
> Good evening,
> 
> you mean https://lkml.org/lkml/2019/6/20/27 /
> https://lore.kernel.org/linux-pci/20190620061038.GA20564@lst.de/T/ ,
> right? And yes, I have this problem as well. On a Toshiba z20t-c, and
> this device has no option to switch this off. And even if has, there is
> the problem that this device has no "normal" NVMe driver in the uefi it
> seems, so it could not boot from...
> 
As you might have glanced from the documentation, this is one of the 
really bad mess-ups.
This particular feature was one of the first attempts by Intel to get 
software RAID to work with NVMe without having to change Windows.
What they did here was to 'hide' the NVMe device behind an AHCI device, 
essentially turning the AHCI PCI device into a combo with shared 
registers and shared interrupts.
The resulting NVMe device is in violation of the spec, making it 
questionable whether we should modify our implementation for a 
non-compliant device.
To make matters worse Intel has since come up with similar (but 
different) technologies; RSTe/VMD is one of the examples.
And Windows has meanwhile learned to handle NVMe, so the entire
rationale for this piece of .... has gone.
Making it even more questionable whether we should support it.

The only way I see how we could support it would be by writing an PCI 
driver which splits the AHCI driver into two PCI virtual functions, the
first being a 'normal' AHCI' device and the other one being the NVMe.
Not sure if that's possible, though (one possible would have to ask 
Bjorn Helgaas), but that seems to be the best option.
Except from ditching the NVMe in that device, of course :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

