Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2655CC07E96
	for <linux-raid@archiver.kernel.org>; Thu,  8 Jul 2021 23:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3E5E61450
	for <linux-raid@archiver.kernel.org>; Thu,  8 Jul 2021 23:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbhGHXz0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Jul 2021 19:55:26 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:47742 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhGHXz0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Jul 2021 19:55:26 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0F3EC2222A;
        Thu,  8 Jul 2021 23:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625788363; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wix4iWqwX3m8FrrdG66YOPjXkCJ9xOjOpvpDl5w6TYI=;
        b=hDppKWgnOeq4UTC9bE6CopfZuQlCCmCc2Fj0zco4VJTv5/wAbCJQgUbK0HHAP8/RZq+yQz
        SZff8wCKqFl7qdEEteH0at9P9uOBSyeDToKEXNLaOqG4GDYq8ac/lJeAKrCykUdkE7TzsU
        0zDIMtg8E1KGL5UpbKQbR2RlWfu93Es=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625788363;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wix4iWqwX3m8FrrdG66YOPjXkCJ9xOjOpvpDl5w6TYI=;
        b=yK3DnVMlQvJDopx8nW73rtb+ZsddgmWtXAwGXvBVvByKWqhRBaCMsQanuRGNDwN2ZMz/mG
        r7JAN70BrykigdAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C442A13B21;
        Thu,  8 Jul 2021 23:52:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id t0V2HcmP52A+egAAMHmgww
        (envelope-from <neilb@suse.de>); Thu, 08 Jul 2021 23:52:41 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "BW" <m40636067@gmail.com>
Cc:     "Fine Fan" <ffan@redhat.com>, linux-raid@vger.kernel.org
Subject: Re: --detail --export doesn't show all properties
In-reply-to: <CADcL3SAWbA8C5c41MeuBczatmikUu0NMPY+1jjoy54AyObJVJA@mail.gmail.com>
References: <CADcL3SDfzw+PZHWabN0mrHFuyt1gVtD6Owf_bNpFT=xV-JrVVA@mail.gmail.com>,
 <CAOaDVC6yNDOVAvMu4gBuc+sTH50UrXD3z4sODa1NtFsV9SEZ9Q@mail.gmail.com>,
 <CADcL3SBwbiZJgXVOOTqV2UPqTg=eJwG=ZDCwgzTd9Ez8FH5D6w@mail.gmail.com>,
 <162569672750.31036.1684525188878933981@noble.neil.brown.name>,
 <CADcL3SAWbA8C5c41MeuBczatmikUu0NMPY+1jjoy54AyObJVJA@mail.gmail.com>
Date:   Fri, 09 Jul 2021 09:52:38 +1000
Message-id: <162578835845.31036.9861674953440872046@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 08 Jul 2021, BW wrote:
> 1: Just because the array is inactive doesn't mean the information is
> not valuable, actually it's even more,  as your most likely needs your
> attention
> 2: The information is available and is printed when not doing --export

Ahh... I missed that.  My memory is that when the array is inactive, the
md driver really don't know anything about the array.  It doesn't find
out until it reads the metadata, and it does that as it activates the
array.
But looking at your sample output I see does, as you say, give a raid
level for an inactive array.

But looking at the code, it should do exactly the same thing for
--export, and --brief, and normal.
It determines the raid level:

        if (inactive && info)
                str = map_num(pers, info->array.level);
        else
                str = map_num(pers, array.level);

and then report 'str' in all 3 cases (possibly substituting "-unknown-"
or "container" for NULL) providing that array.raid_disks is non-zero -
which it is in your example.
So I cannot see how you would get the results that you report.

Do you know how you got the array in this inactive state? I could then
experiment and see if I can reproduce your result.

NeilBrown
