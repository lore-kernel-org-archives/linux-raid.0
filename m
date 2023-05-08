Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C437C77B7F
	for <linux-raid@archiver.kernel.org>; Mon,  8 May 2023 21:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbjEHVEM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 May 2023 17:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjEHVEK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 May 2023 17:04:10 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7826E9B
        for <linux-raid@vger.kernel.org>; Mon,  8 May 2023 14:04:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 139B11F8B0;
        Mon,  8 May 2023 21:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1683579848; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MrdIC4RG/LpoA6oaLjkfOvjuiWCdF8Kpx3vInfv5WmI=;
        b=AZ9pKM3GfbzipAwS/kGsG/ktE+Qm+vHoMWm8SgtaNH84JFm/UETVB/q66NbvZrmWVaOtoO
        K9IMgznq1vyOKU5v7CjXrI1Cd+UF/pQRCNh7uU24iwyXdqzp4aO+n+V8KAMMtnnaW0rpVx
        LyWCO52mjGdjCcQQNw7dqOqeX5k00Aw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1683579848;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MrdIC4RG/LpoA6oaLjkfOvjuiWCdF8Kpx3vInfv5WmI=;
        b=NqzmOmENdU5e5VH96ThNqHglb7TViaeIn9oc44XX//upWJLUvXJhmNGFQZdTW0x3gmr5OW
        ECQFZfgJnKy9XHAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DF13A1346B;
        Mon,  8 May 2023 21:04:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id F42DJcZjWWThPAAAMHmgww
        (envelope-from <neilb@suse.de>); Mon, 08 May 2023 21:04:06 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Jes Sorensen" <jes@trained-monkey.org>
Cc:     "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
        "Mariusz Tkaczyk" <mariusz.tkaczyk@linux.intel.com>
Subject: Re: mdadm minimum kernel version requirements?
In-reply-to: <9bfd76c4-3775-4ba6-10c3-ac32b5389f63@trained-monkey.org>
References: <e8ed86bb-4162-7d8e-ece9-eb75e045bcc5@trained-monkey.org>,
 <168116364433.24821.9557577764628245206@noble.neil.brown.name>,
 <9bfd76c4-3775-4ba6-10c3-ac32b5389f63@trained-monkey.org>
Date:   Tue, 09 May 2023 07:04:03 +1000
Message-id: <168357984365.26026.8909042734026812929@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 09 May 2023, Jes Sorensen wrote:
> On 4/10/23 17:54, NeilBrown wrote:
> > On Tue, 11 Apr 2023, Jes Sorensen wrote:
> >> Hi,
> >>
> >> I bumped the minimum kernel version required for mdadm to 2.6.32.
> >>
> >> Should we drop support for anything prior to 3.10 at this point, since
> >> RHEL7 is 3.10 based and SLES12 seems to be 3.12 based.
> >>
> >> Thoughts?
> > 
> > When you talk about changing the required kernel version, I would find
> > it helpful if you at least mention what actual kernel features you now
> > want to depend on - at least the more significant ones.
> > 
> > Aside from features, I'd rather think about how old the kernel is.
> > 2.6.32 is over 13 years old.
> > 3.10 is very nearly 10 years old.
> > If there is something significant that landed in 3.10 that we want to
> > depend on, then requiring that seems perfectly reasonable.
> > 
> > I think the oldest SLE kernel that you might care about would be 4.12
> > (SLE12-SP5 - nearly 6 years old).  Anyone using an older SLE release
> > values stability over new functionality and is not going to be trialling
> > a new mdadm.
> 
> Hi Neil,
> 
> I guess my mindset is more that I don't expect RHEL/SLES grade distros
> to fully upgrade mdadm, but I do see them backporting changes occasionally.
> 
> I was mostly basing my question on what I see us testing for in the
> actual code. Dropping support for anything prior to SLES 12 (4.12) and
> RHEL 8 (kernel 4.18) seems fair.

So where you say "dropping support" you don't actually mean removing any
code, but only that you will document somewhere that no effort will be
made support, or test against, earlier kernels. Is that correct?
Sounds reasonable to me.

NeilBrown
