Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF11DC07E99
	for <linux-raid@archiver.kernel.org>; Fri,  9 Jul 2021 06:13:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B05B361279
	for <linux-raid@archiver.kernel.org>; Fri,  9 Jul 2021 06:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhGIGQO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 9 Jul 2021 02:16:14 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33356 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhGIGQO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 9 Jul 2021 02:16:14 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8EFD721AB0;
        Fri,  9 Jul 2021 06:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625811210; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5vGunTupXTFZVDHosH7IbXx2aQukctaVEaCMnI04usk=;
        b=k0y6vKV4SdtifpAZx1uzyORuw+f1hfucE/i6Oo1ITrOt4RcQKnRf5dIjonvxECCLUDMllV
        pJfUw8z40NVQEe5C8Ll+eY1YBrxZO4EwscGlpQuJaOE6Ml6TUmseejXRmsfsbJl418oH6s
        gmO0NpVk4prc+jkgQRLi/NbYmY+LOmM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625811210;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5vGunTupXTFZVDHosH7IbXx2aQukctaVEaCMnI04usk=;
        b=OFz6wvA4vMadPbjIq2LJjxtxVm4YM4QsQMKiuOTuVSljYN3SrNgzYZtT2oQmTU6tkvX5G3
        Z9xLrOuR3mRH0EAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4BCDC13B2B;
        Fri,  9 Jul 2021 06:13:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4kdtOwjp52D6OAAAMHmgww
        (envelope-from <neilb@suse.de>); Fri, 09 Jul 2021 06:13:28 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "BW" <m40636067@gmail.com>
Cc:     "Fine Fan" <ffan@redhat.com>, linux-raid@vger.kernel.org
Subject: Re: --detail --export doesn't show all properties
In-reply-to: <CADcL3SDik3whZoqk16r_HeK0_JU1RvUgekYPjwTpO4NN+DkBAg@mail.gmail.com>
References: <CADcL3SDfzw+PZHWabN0mrHFuyt1gVtD6Owf_bNpFT=xV-JrVVA@mail.gmail.com>,
 <CAOaDVC6yNDOVAvMu4gBuc+sTH50UrXD3z4sODa1NtFsV9SEZ9Q@mail.gmail.com>,
 <CADcL3SBwbiZJgXVOOTqV2UPqTg=eJwG=ZDCwgzTd9Ez8FH5D6w@mail.gmail.com>,
 <162569672750.31036.1684525188878933981@noble.neil.brown.name>,
 <CADcL3SAWbA8C5c41MeuBczatmikUu0NMPY+1jjoy54AyObJVJA@mail.gmail.com>,
 <162578835845.31036.9861674953440872046@noble.neil.brown.name>,
 <CADcL3SDik3whZoqk16r_HeK0_JU1RvUgekYPjwTpO4NN+DkBAg@mail.gmail.com>
Date:   Fri, 09 Jul 2021 16:13:25 +1000
Message-id: <162581120598.31036.6598299608450900729@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 09 Jul 2021, BW wrote:
> It was a 4-drive RAID5 array missing one drive completely.

That shouldn't result in the array not assembling....  though I guess
that depends on how it was assembled.
Do you know how it was assembled?

> 
> But I expected is was an easy thing to fix as "mdadm --detail
> /dev/md1xxx" will show the details fine (out of the same information
> in memory). But if it's not, maybe just make a note about it and move
> on with more important things. I wouldn't be surprised if I'm the only
> one ever needing this feature. And I already implemented a work-around
> in my storage-management-system be getting the RAID level etc. from
> /proc/mdstat first. A pain to serialize of course but it works now.

It probably is easy to fix, once it is understood.  I want to understand
it.  I need to be able to reproduce it.

NeilBrown



> 
> On Fri, Jul 9, 2021 at 1:52 AM NeilBrown <neilb@suse.de> wrote:
> >
> > On Thu, 08 Jul 2021, BW wrote:
> > > 1: Just because the array is inactive doesn't mean the information is
> > > not valuable, actually it's even more,  as your most likely needs your
> > > attention
> > > 2: The information is available and is printed when not doing --export
> >
> > Ahh... I missed that.  My memory is that when the array is inactive, the
> > md driver really don't know anything about the array.  It doesn't find
> > out until it reads the metadata, and it does that as it activates the
> > array.
> > But looking at your sample output I see does, as you say, give a raid
> > level for an inactive array.
> >
> > But looking at the code, it should do exactly the same thing for
> > --export, and --brief, and normal.
> > It determines the raid level:
> >
> >         if (inactive && info)
> >                 str = map_num(pers, info->array.level);
> >         else
> >                 str = map_num(pers, array.level);
> >
> > and then report 'str' in all 3 cases (possibly substituting "-unknown-"
> > or "container" for NULL) providing that array.raid_disks is non-zero -
> > which it is in your example.
> > So I cannot see how you would get the results that you report.
> >
> > Do you know how you got the array in this inactive state? I could then
> > experiment and see if I can reproduce your result.
> >
> > NeilBrown
> 
> 
