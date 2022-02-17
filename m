Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDAE0C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 17 Feb 2022 11:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239699AbiBQLAh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 17 Feb 2022 06:00:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239730AbiBQK70 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 17 Feb 2022 05:59:26 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7112A5990
        for <linux-raid@vger.kernel.org>; Thu, 17 Feb 2022 02:59:02 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 26CC91F3A2;
        Thu, 17 Feb 2022 10:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645095541; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n3dRDRWUWCyjnUMFxxsluLiF2hSdSwFGapgykNaalds=;
        b=VfWBEJ1CPDt06rxzhg8qh1KdTNeg/a0+KXSpynaZFe/4Dt7AWfwXiT77H82Tsc3cV41lFL
        31ABc4KSm64ACTSRbwUlTwJtDL4OdHb13kXJ523w/OivznS59v/VTAPykCmOfRhyYYesLE
        rnW/x8eRu1jCfzJEvJCaB0L9/8xTuIw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B533613DD8;
        Thu, 17 Feb 2022 10:59:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oxwfKnQqDmLWTgAAMHmgww
        (envelope-from <mwilck@suse.com>); Thu, 17 Feb 2022 10:59:00 +0000
Message-ID: <e8720e3f8734cbad1af34d5e54afc47ba3ef1b8f.camel@suse.com>
Subject: Re: [PATCH] udev-md-raid-assembly.rules: skip if
 DM_UDEV_DISABLE_OTHER_RULES_FLAG
From:   Martin Wilck <mwilck@suse.com>
To:     NeilBrown <neilb@suse.de>
Cc:     Jes Sorensen <jsorensen@fb.com>, linux-raid@vger.kernel.org,
        lvm-devel@redhat.com, Peter Rajnoha <prajnoha@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Heming Zhao <heming.zhao@suse.com>, Coly Li <colyli@suse.com>,
        dm-devel@redhat.com
Date:   Thu, 17 Feb 2022 11:58:55 +0100
In-Reply-To: <164504936873.10228.7361167610237544463@noble.neil.brown.name>
References: <20220216205914.7575-1-mwilck@suse.com>
         <164504936873.10228.7361167610237544463@noble.neil.brown.name>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 2022-02-17 at 09:09 +1100, NeilBrown wrote:
> On Thu, 17 Feb 2022, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > device-mapper sets the flag DM_UDEV_DISABLE_OTHER_RULES_FLAG to 1
> > for
> > devices which are unusable. They may be no set up yet, suspended,
> > or
> > otherwise unusable (e.g. multipath maps without usable path). This
> > flag does not necessarily imply SYSTEMD_READY=0 and must therefore
> > be tested separately.
> 
> I really don't like this - looks like a hack.  A Kludge.

These are strong words. You didn't go into detail, so I'm assuming that
your reasoning is that DM_UDEV_DISABLE_OTHER_RULES_FLAG is an internal
flag of the device-mapper subsystem. Still, you can see that is's used
both internally by dm, and by other subsystems:

https://github.com/lvmteam/lvm2/blob/8dccc2314e2482370bc6e5cf007eb210994abdef/udev/13-dm-disk.rules.in#L15
https://github.com/g2p/bcache-tools/blob/a73679b22c333763597d39c72112ef5a53f55419/69-bcache.rules#L6
https://github.com/opensvc/multipath-tools/blob/d9d7ae9e2125116b465b4ff4d98ce65fe0eac3cc/kpartx/kpartx.rules#L10

Would you call these others "hacks", too?

> Can you provide a reference to a detailed discussion that explains
> why
> SYSTEMD_READY=0 cannot be used?

The main reason is that SYSTEMD_READY=0 is set too late, in 99-systemd-
rules, and only on "add" events:
https://github.com/systemd/systemd/blob/bfae960e53f6986f1c4d234ea82681d0acad57df/rules.d/99-systemd.rules.in#L18

I guess the device-mapper rules themselves could be setting
SYSTEMD_READY="0". @Peter Rajnoha, do you want to comment on that? My
concern wrt such a change would be possible side effects. Setting
SYSTEMD_READY=0 on "change" events could actually be wrong, see below.

I the case I was observing, there was a multipath device without valid
paths, which had switched to queueing mode [*]. If this happens for
whatever reason (and it could be something else, like a suspended DM
device), IO on such a device hangs. IO that may hang must not be
attempted from an udev rule. Therefore it makes sense that layers
stacked on top of DM try to avoid it, and checking udev properties set
by DM is a reasonable way to do that.

The core of the problem is that there is no well-defined "API"
specifying how different udev rule sets can communicate, iow which udev
properties are well-defined enough to be consumed outside of the
subsystem that defines them. SYSTEMD_READY is about the only "global"
property. IMO it's somewhat overloaded: The actual semantics of
SYSTEMD_READY=0 is "systemd shouldn't activate the associated device
unit". Various udev rule sets use it with similar but not 100%
identical semantics like "don't touch this" or "don't probe this". 

In the case I was looking at, the device had already been activated by
systemd. Later, the device had lost all active paths and thus became
unusable. We can't easily set SYSTEMD_READY=0 on such a device. Doing
so would actually be dangerous, because systemd might remove the
device. Moreover, while processing the udev rule, we just don't know if
the problem is temporary or permanent. 

Other properties, like those set by the DM subsystem, are less well-
defined. There's no official spec defining their names and semantics,
and there are multiple flags which aren't easly differentiated
(DM_UDEV_DISABLE_DISK_RULES_FLAG, DM_UDEV_DISABLE_OTHER_RULES_FLAG,
DM_NOSCAN, DM_SUSPENDED, MPATH_DEVICE_READY). OTOH, most of these flags
have been around for many years without changing, and thus have
acquired the status of a semi-official API, which is actually used in
other rule sets. In particular DM_UDEV_DISABLE_OTHER_RULES_FLAG has a
few users, see above. I believe this is for good reason, and therefore
I don't consider my patch a "hack".

Regards
Martin

[*] How that came to pass is subtle by itself, and admittedly not fully
understood.

