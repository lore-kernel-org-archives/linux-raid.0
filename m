Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B579FC6FD1F
	for <linux-raid@archiver.kernel.org>; Sun, 19 Mar 2023 22:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjCSWGF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Mar 2023 18:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjCSWGE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Mar 2023 18:06:04 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A62E4
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 15:06:02 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1C61621B47;
        Sun, 19 Mar 2023 22:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679263560; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3+Pr7veiLqInyjkMeBPNeLnIToaPNTyarZNUtX3lKPU=;
        b=rQGC5PC4OCn+/rpH8E6L3gQ6SQHdOILyGtF+CFRjTY1YZz0PJ4ECs8I740/V7jirWUxVQz
        zA1C1omiyzSLE/murD3XUc3xvsY/ffMhWKclC29KKCaAxb8eRfyRo/rm8s9l/NOhMuYrEr
        we/F3DQ/NDwmNPKazputH6oNUnlIRjY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679263560;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3+Pr7veiLqInyjkMeBPNeLnIToaPNTyarZNUtX3lKPU=;
        b=q969iNmNHitw23UbipzNwDQfnrCnFhhKIKs4vxtW8IQli2DJs/3w61yzAtt6jMwaOUPrIc
        811g5JX+0haKZaDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3AE42133E6;
        Sun, 19 Mar 2023 22:05:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ywgoN0WHF2RPZQAAMHmgww
        (envelope-from <neilb@suse.de>); Sun, 19 Mar 2023 22:05:57 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Jes Sorensen" <jes@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org, "Martin Wilck" <martin.wilck@suse.com>,
        "Mariusz Tkaczyk" <mariusz.tkaczyk@intel.com>,
        "Paul Menzel" <pmenzel@molgen.mpg.de>
Subject: Re: [PATCH 2/6] Improvements for IMSM_NO_PLATFORM testing.
In-reply-to: <e2256aca-b2a1-344c-8dc4-f00d849530eb@trained-monkey.org>
References: <167867886675.11443.523512156999408649.stgit@noble.brown>,
 <167867897868.11443.7240557073570592164.stgit@noble.brown>,
 <e2256aca-b2a1-344c-8dc4-f00d849530eb@trained-monkey.org>
Date:   Mon, 20 Mar 2023 09:05:54 +1100
Message-id: <167926355421.8008.15837133562162816477@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 20 Mar 2023, Jes Sorensen wrote:
> On 3/12/23 23:42, NeilBrown wrote:
> > Factor out IMSM_NO_PLATFORM testing into a single function that caches
> > the result.
> > 
> > Allow mdmon to explicitly set the result to "1" so that we don't need
> > the ENV var in the unit file
> > 
> > Check if the kernel command line contains "mdadm.imsm.test=1" and in
> > that case assert NO_PLATFORM.  This simplifies testing in a virtual
> > machine.
> > 
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > ---
> >  mdadm.h                |    2 ++
> >  mdmon.c                |    6 ++++++
> >  super-intel.c          |   43 ++++++++++++++++++++++++++++++++++++++++---
> >  systemd/mdmon@.service |    3 ---
> >  4 files changed, 48 insertions(+), 6 deletions(-)
> 
> Hi Neil
> 
> > diff --git a/super-intel.c b/super-intel.c
> > index e155a8ae99cb..a514dea6f95c 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -629,6 +629,43 @@ static const char *_sys_dev_type[] = {
> >  	[SYS_DEV_VMD] = "VMD"
> >  };
> >  
> > +static int no_platform = -1;
> > +
> > +static int check_no_platform(void)
> > +{
> > +	static const char search[] = "mdadm.imsm.test=1";
> > +	int fd;
> > +	char buf[1024];
> 
> This isn't safe, /proc/cmdline can be longer than 1024 characters.

Why not safe?  I agree that /proc/cmdline can be longer than 1024 but the
only only considers the first 1023 at most, and does so safely.

What would you prefer?  Should I use conf_line() to read the line and
split it into words for us?

Thanks,
NeilBrown


> 
> Cheers,
> Jes
> 
> 

