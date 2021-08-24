Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FEEC4338F
	for <linux-raid@archiver.kernel.org>; Tue, 24 Aug 2021 07:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64B7560F91
	for <linux-raid@archiver.kernel.org>; Tue, 24 Aug 2021 07:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbhHXHp7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Aug 2021 03:45:59 -0400
Received: from smtp1.servermx.com ([134.19.178.79]:57988 "EHLO
        smtp1.servermx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbhHXHp6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 24 Aug 2021 03:45:58 -0400
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2021 03:45:58 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=servermx.com; s=servermx; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:Date:From:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=S316GZth6dTRivVDE7QgxW/8U8eGuj8VZbox4YhtZtA=; b=rTYw9DLfdj449NnPHq6+Gmz4rM
        z9rV/4dQNLgfDQgnEXO6eAxelBBLfJMiWmjvWhBa8k0p/TcZX4/Y+ODZvfztx3lCVgyE4Lns0wiNm
        Zs9E0qg341fWfYaU1pREMxcncDu+Fh0RAPtZO2Q7r1qtxprCWWRoZqfOezoQCond1/Vo=;
Received: by exim4; Tue, 24 Aug 2021 09:35:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=servermx.com; s=servermx; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:Date:From:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=S316GZth6dTRivVDE7QgxW/8U8eGuj8VZbox4YhtZtA=; b=rTYw9DLfdj449NnPHq6+Gmz4rM
        z9rV/4dQNLgfDQgnEXO6eAxelBBLfJMiWmjvWhBa8k0p/TcZX4/Y+ODZvfztx3lCVgyE4Lns0wiNm
        Zs9E0qg341fWfYaU1pREMxcncDu+Fh0RAPtZO2Q7r1qtxprCWWRoZqfOezoQCond1/Vo=;
Received: by exim4; Tue, 24 Aug 2021 09:35:36 +0200
Received: from usr01 (usr01.home.robinhill.me.uk [IPv6:2a01:348:2ab::50])
        by cthulhu.home.robinhill.me.uk (Postfix) with SMTP id AC9276A01FD;
        Tue, 24 Aug 2021 08:35:32 +0100 (BST)
Received: by usr01 (sSMTP sendmail emulation); Tue, 24 Aug 2021 08:36:55 +0100
From:   hillr@robinhill.me.uk
Date:   Tue, 24 Aug 2021 08:36:55 +0100
To:     NeilBrown <neilb@suse.de>
Cc:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>,
        Nigel Croxon <ncroxon@redhat.com>, jes@trained-monkey.org,
        xni@redhat.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH V2] Fix buffer size warning for strcpy
Message-ID: <YSShlyG5hzWPkjb5@usr01.home.robinhill.me.uk>
Mail-Followup-To: NeilBrown <neilb@suse.de>,
        "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>,
        Nigel Croxon <ncroxon@redhat.com>, jes@trained-monkey.org,
        xni@redhat.com, linux-raid@vger.kernel.org
References: <20210819131017.2511208-1-ncroxon@redhat.com>
 <5d28eff3-d693-92c5-6e84-54846b36a480@linux.intel.com>
 <162975880927.9892.4170329329993823938@noble.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162975880927.9892.4170329329993823938@noble.neil.brown.name>
Feedback-ID: outgoingmessage:robin@robinhill.me.uk:ns01.servermx.com:servermx.com
X-AuthUser: bimu5pypsh
X-AuthUser: bimu5pypsh
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue Aug 24, 2021 at 08:46:49AM +1000, NeilBrown wrote:

> On Mon, 23 Aug 2021, Tkaczyk, Mariusz wrote:
> > On 19.08.2021 15:10, Nigel Croxon wrote:
> > 
> > > +	memset(ve->name, '\0', sizeof(ve->name));
> > > +	if (name) {
> > > +		int l = strlen(ve->name);
> > > +		if (l > 16)
> > > +			l = 16;
> > > +		memcpy(ve->name, name, l);
> > > +	}
> > 
> > What about:
> > if (name)
> > 	/*
> > 	 * Name might not be null terminated.
> > 	 */
> > 	strncpy(ve->name, name, sizeof(ve->name));
> 
> I really like the idea of using strncpy().  I didn't realize it would
> nul-pad to the full size, and that is exactly what we want.
> So
> 
>   strncpy(ve->name, name?:"", sizeof(ve->name));
> 
> would be a complete solution.
> 
Except that won't get rid of the buffer warning that was the point of
this patch:

buffer_size_warning: Calling "strncpy" with a maximum size
argument of 16 bytes on destination array "ve->name" of
size 16 bytes might leave the destination string unterminated.

Looking at the code, I don't think we're relying on the destination
string being null terminated anyway (if it's the full 16 bytes), so it's
not actually going to cause an issue, but we'll still be left with the
warning. Presumably using memcpy doesn't flag on this (as it then
doesn't know the value being copied is meant to be a string), which is
why that was being proposed.

Cheers.
    Robin
