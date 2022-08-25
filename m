Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83FE6C04AA5
	for <linux-raid@archiver.kernel.org>; Thu, 25 Aug 2022 00:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiHYAYd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Aug 2022 20:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiHYAYc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Aug 2022 20:24:32 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084B0876BE
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 17:24:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A48E55C189;
        Thu, 25 Aug 2022 00:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661387069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CeC3X/o7wTxi+LSNVQUmdXtd821IQ6vgaLTvqgnG91A=;
        b=SREctSeU+IZ30MCjMYfkzAPeOPv7Hcg6pB0hzVS7MWBO4MzPUl8nd/p+s6WOCCspKeQzAm
        e75ozHf7SLNJZSCrMBitk+3gVzCxw/16Jl7qre9cSJOdneWMAe6Ad0fcbJa2tG5fBvK6Rk
        HomWn7tQJDBHt6bNm2xFuQu8FYQHqKE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661387069;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CeC3X/o7wTxi+LSNVQUmdXtd821IQ6vgaLTvqgnG91A=;
        b=SYs8xGLuElqxyBZs3xvmmL7kiKLhQDhWax1fM8tpj6gupnIr8KxSKl4HZdydV9u/KFX8Pd
        wJxhNOvSge4cXIDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 49D7E13A47;
        Thu, 25 Aug 2022 00:24:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IVIpAjzBBmMUUAAAMHmgww
        (envelope-from <neilb@suse.de>); Thu, 25 Aug 2022 00:24:28 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Jes Sorensen" <jes@trained-monkey.org>
Cc:     "Mariusz Tkaczyk" <mariusz.tkaczyk@linux.intel.com>,
        "Paul Menzel" <pmenzel@molgen.mpg.de>, linux-raid@vger.kernel.org
Subject: Re: [PATCH mdadm v2] super1: report truncated device
In-reply-to: <1c04ce1c-cf02-2891-cb88-c5f91a80f620@trained-monkey.org>
References: <165758762945.25184.10396277655117806996@noble.neil.brown.name>,
 <cff69e79-d681-c9d6-c719-8b10999a558a@molgen.mpg.de>,
 <165768409124.25184.3270769367375387242@noble.neil.brown.name>,
 <20220721101907.00002fee@linux.intel.com>,
 <165855103166.25184.12700264207415054726@noble.neil.brown.name>,
 <20220725094238.000014f0@linux.intel.com>,
 <1c04ce1c-cf02-2891-cb88-c5f91a80f620@trained-monkey.org>
Date:   Thu, 25 Aug 2022 10:24:21 +1000
Message-id: <166138706173.27490.18440987438153337183@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 25 Aug 2022, Jes Sorensen wrote:
> On 7/25/22 03:42, Mariusz Tkaczyk wrote:
> > On Sat, 23 Jul 2022 14:37:11 +1000
> > "NeilBrown" <neilb@suse.de> wrote:
> >=20
> >> On Thu, 21 Jul 2022, Mariusz Tkaczyk wrote:
> >>> Hi Neil,
> >>>
> >>> On Wed, 13 Jul 2022 13:48:11 +1000
> >>> "NeilBrown" <neilb@suse.de> wrote:
> ....
> >>> why not just:
> >>> if (__le64_to_cpu(super->data_offset) + __le64_to_cpu(super->data_size)=
 >
> >>> dsize) from my understanding, only this check matters. =20
> >>
> >> It seemed safest to test both.  I don't remember the difference between
> >> ->size and ->data_size.  In getinfo_super1() we have =20
> >>
> >> 	if (info->array.level <=3D 0)
> >> 		data_size =3D __le64_to_cpu(sb->data_size);
> >> 	else
> >> 		data_size =3D __le64_to_cpu(sb->size);
> >>
> >> which suggests that either could be relevant.
> >> I guess ->size should always be less than ->data_size.  But
> >> load_super1() doesn't check that, so it isn't safe to assume it.
> >=20
> > Honestly, I don't understand why but I didn't realize that you are checki=
ng two
> > different fields (size and data_size). I focused on understanding what is=
 going
> > on  here, and didn't catch difference in variables (because data_offset a=
nd
> > data_size have similar prefix).
> > For me, something like:
> >=20
> > unsigned long long _size;
> > if (st->minor_version >=3D 1 && st->ignore_hw_compat =3D=3D 0)
> >     _size=3D __le64_to_cpu(super->size);
> > else
> >     _size=3D __le64_to_cpu(super->data_size);
> >=20
> > if (__le64_to_cpu(super->data_offset) + _size > dsize)
> > {....}
> >=20
> > is more readable because I don't need to analyze complex if to get the
> > difference. Also, I removed doubled __le64_to_cpu(super->data_offset).
> > Could you refactor this part?
>=20
> What is the consensus on this discussion? I see Coly pulled this into
> his tree, but I don't see Mariusz's last concern being addressed.

I don't think we reached a consensus.  I probably got distracted.
I don't like that suggestion from Mariusz as it makes assumptions that I
didn't want to make.  I think it is safest to always test dsize against
bother ->size and ->data_size without baking in assumptions about when
either is meaningful.

NeilBrown
