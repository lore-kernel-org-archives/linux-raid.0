Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6FBCC433F5
	for <linux-raid@archiver.kernel.org>; Mon, 28 Feb 2022 15:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbiB1P3O (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 28 Feb 2022 10:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiB1P3N (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 28 Feb 2022 10:29:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CB66C73
        for <linux-raid@vger.kernel.org>; Mon, 28 Feb 2022 07:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646062113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cIhIuCXA5nHQcj3iuQ7d3wLvIh4aLmKasZbjBffXX1M=;
        b=guoHe8+qcEgA+WlhkepSp3cdfppm0uO39diMBLgLxTprqUwiOkrDJFqEd0fkNbN9WfdQj2
        3qQLBzjpUw8U/tSjplva/CfY7hQGg/TPMJrvhiUH0v8N+ZMqgi2P/aQOHU0Ktyfywg5dy6
        k12mVqcGBV0J/BFEf8eAdAlBsui5SKk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-JGCLJXpWP_iMzOhmaMNhLA-1; Mon, 28 Feb 2022 10:28:31 -0500
X-MC-Unique: JGCLJXpWP_iMzOhmaMNhLA-1
Received: by mail-ed1-f70.google.com with SMTP id h17-20020a05640250d100b004133863d836so6102567edb.0
        for <linux-raid@vger.kernel.org>; Mon, 28 Feb 2022 07:28:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cIhIuCXA5nHQcj3iuQ7d3wLvIh4aLmKasZbjBffXX1M=;
        b=V2SGF9GaiaXuFcu02lhAzYo2tHKIcB67i6XS4c04YZkzjiXoWAbltgCiPndgClMYm5
         dvV8LmE8UZ0NNtqUUEPZqQUKdE/ZVgS6rTAMqFg0fH2dS3dxNSdtckCtTNYVzTqhrtsN
         I3njPzBzKQOqlKEHkaVRmwEZWhUOCqSQWvK6rdzih/m7JYSmkBSPi45Vji2iX+TiLhFa
         e/lRQArnxU8rY3fK5XREQSmiYk1xGhj7vCMPJ1BmWxTrSgs7GVfufrqQcmQSSzZAbnEG
         3M/eOHkcdG9L4UsrdyyfhegAJiNqJP9cZzBcTAfT36KxwyUbLy7CMxgaai2JAVdXk31T
         s0cg==
X-Gm-Message-State: AOAM533DPzkp8icWANBMZ9VG1pRlhjseYA5iboN+r0UPtkcvQQqHwFfH
        IxcVo8OKxUZkrJnthV0rZu9c/wJAaXE0L8s7RywMPx0d1gT4avuJPCMGXdykJCq+F9Stf7VpLQ1
        6Rr+D5bjyFKug7Y7XFuUTK0dVe/qGDBkJ3Pv94w==
X-Received: by 2002:a17:906:d8ae:b0:6b7:98d6:6139 with SMTP id qc14-20020a170906d8ae00b006b798d66139mr15344573ejb.498.1646062110229;
        Mon, 28 Feb 2022 07:28:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzi6AoC4Wa6NMHF5VBraWZzx2BgqXD8BBFD94CoVcQSm377R4m3mssv0I9Wp/N4IjeCmZFKtb8I3djS4TgOEJE=
X-Received: by 2002:a17:906:d8ae:b0:6b7:98d6:6139 with SMTP id
 qc14-20020a170906d8ae00b006b798d66139mr15344546ejb.498.1646062109886; Mon, 28
 Feb 2022 07:28:29 -0800 (PST)
MIME-Version: 1.0
References: <20220216205914.7575-1-mwilck@suse.com> <164504936873.10228.7361167610237544463@noble.neil.brown.name>
 <e8720e3f8734cbad1af34d5e54afc47ba3ef1b8f.camel@suse.com> <20220217130934.lh2b33255kyx2pax@alatyr-rpi.brq.redhat.com>
In-Reply-To: <20220217130934.lh2b33255kyx2pax@alatyr-rpi.brq.redhat.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 28 Feb 2022 23:28:19 +0800
Message-ID: <CALTww2-_rJDyVh2GLehJ8Yg9LOy4MnkvDeJnF2uunaOy6ONu7g@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH] udev-md-raid-assembly.rules: skip if DM_UDEV_DISABLE_OTHER_RULES_FLAG
To:     Peter Rajnoha <prajnoha@redhat.com>
Cc:     Martin Wilck <mwilck@suse.com>, Jes Sorensen <jsorensen@fb.com>,
        lvm-devel@redhat.com, linux-raid <linux-raid@vger.kernel.org>,
        Coly Li <colyli@suse.com>, dm-devel@redhat.com,
        Heming Zhao <heming.zhao@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Feb 17, 2022 at 9:10 PM Peter Rajnoha <prajnoha@redhat.com> wrote:
>
> On Thu 17 Feb 2022 11:58, Martin Wilck wrote:
> > On Thu, 2022-02-17 at 09:09 +1100, NeilBrown wrote:
> > > On Thu, 17 Feb 2022, mwilck@suse.com wrote:
> > > > From: Martin Wilck <mwilck@suse.com>
> > > >
> > > > device-mapper sets the flag DM_UDEV_DISABLE_OTHER_RULES_FLAG to 1
> > > > for
> > > > devices which are unusable. They may be no set up yet, suspended,
> > > > or
> > > > otherwise unusable (e.g. multipath maps without usable path). This
> > > > flag does not necessarily imply SYSTEMD_READY=0 and must therefore
> > > > be tested separately.
> > >
> > > I really don't like this - looks like a hack.  A Kludge.
> >
> > These are strong words. You didn't go into detail, so I'm assuming that
> > your reasoning is that DM_UDEV_DISABLE_OTHER_RULES_FLAG is an internal
> > flag of the device-mapper subsystem. Still, you can see that is's used
> > both internally by dm, and by other subsystems:
> >
> > https://github.com/lvmteam/lvm2/blob/8dccc2314e2482370bc6e5cf007eb210994abdef/udev/13-dm-disk.rules.in#L15
> > https://github.com/g2p/bcache-tools/blob/a73679b22c333763597d39c72112ef5a53f55419/69-bcache.rules#L6
> > https://github.com/opensvc/multipath-tools/blob/d9d7ae9e2125116b465b4ff4d98ce65fe0eac3cc/kpartx/kpartx.rules#L10
> >
>
> The flags that DM use for udev were introduced before systemd project
> even existed. We needed to introduce the DM_UDEV_DISABLE_OTHER_RULES_FLAG
> to have a possibility for all the "other" (non-dm) udev rules to check
> for if there's another subsystem stacking its own devices on top of DM ones.
>
> The flag is used to communicate the other rules a condition when a DM
> device underneath is either not yet set up completely or it's not ready
> to be read/scanned for a reason (e.g. the device is suspended, not yet
> loaded with a table...).
>
> The reason we needed to introduce such a flag is simple - there's
> limited amount of event types and DM devices are not ready on the usual
> ADD event. It's after the CHANGE event that originates from the DM
> device having a table loaded and resumed. At the same time, a CHANGE
> event can be generated for various different reasons. So checking a
> single flag that we set based in out own udev rules based on our best
> knowledge and let other other rules to check for this single flag
> seemed to be the best option to solve this.
>
> > Would you call these others "hacks", too?
> >
> > > Can you provide a reference to a detailed discussion that explains
> > > why
> > > SYSTEMD_READY=0 cannot be used?
> >
> > The main reason is that SYSTEMD_READY=0 is set too late, in 99-systemd-
> > rules, and only on "add" events:
> > https://github.com/systemd/systemd/blob/bfae960e53f6986f1c4d234ea82681d0acad57df/rules.d/99-systemd.rules.in#L18
> >
> > I guess the device-mapper rules themselves could be setting
> > SYSTEMD_READY="0". @Peter Rajnoha, do you want to comment on that? My
> > concern wrt such a change would be possible side effects. Setting
> > SYSTEMD_READY=0 on "change" events could actually be wrong, see below.
> >
>
> First of all, as already mentioned, DM udev rules with all the flags
> pre-date the systemd project itself.
>
> When systemd was introduced, we communicated the flag use with systemd
> right away and so this line was added to 99-systemd.rules:
>
>   SUBSYSTEM=="block", ACTION=="add", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}=="1", ENV{SYSTEMD_READY}="0"
>
> At that early time, the SYSTEMD_READY flag was used solely for systemd
> purpose of setting its own device units properly. Just later, other subsystems
> started (mis)using this flag for notifying about device readiness and so
> the very original intention of the SYSTEMD_READY flag has diverted this
> way a little bit.
>
> Last but not the least, systemd is just one of the init systems/service
> managers around so it's not any standard for block devices to set the
> SYSTEMD_READY flag to notify about device readiness. Yes, it's true
> that systemd is widespread now, but still not a single standard...
>
> > I the case I was observing, there was a multipath device without valid
> > paths, which had switched to queueing mode [*]. If this happens for
> > whatever reason (and it could be something else, like a suspended DM
> > device), IO on such a device hangs. IO that may hang must not be
> > attempted from an udev rule. Therefore it makes sense that layers
> > stacked on top of DM try to avoid it, and checking udev properties set
> > by DM is a reasonable way to do that.
> >
> > The core of the problem is that there is no well-defined "API"
> > specifying how different udev rule sets can communicate, iow which udev
> > properties are well-defined enough to be consumed outside of the
> > subsystem that defines them. SYSTEMD_READY is about the only "global"
> > property. IMO it's somewhat overloaded: The actual semantics of
> > SYSTEMD_READY=0 is "systemd shouldn't activate the associated device
> > unit". Various udev rule sets use it with similar but not 100%
> > identical semantics like "don't touch this" or "don't probe this".
> >
>
> Exactly!
>
> The SID - Storage Instantiation Daemon, which is still in development,
> is trying to cover exactly this part, among other things.
>
> > In the case I was looking at, the device had already been activated by
> > systemd. Later, the device had lost all active paths and thus became
> > unusable. We can't easily set SYSTEMD_READY=0 on such a device. Doing
> > so would actually be dangerous, because systemd might remove the
> > device. Moreover, while processing the udev rule, we just don't know if
> > the problem is temporary or permanent.
> >
> > Other properties, like those set by the DM subsystem, are less well-
> > defined. There's no official spec defining their names and semantics,
> > and there are multiple flags which aren't easly differentiated
> > (DM_UDEV_DISABLE_DISK_RULES_FLAG, DM_UDEV_DISABLE_OTHER_RULES_FLAG,
> > DM_NOSCAN, DM_SUSPENDED, MPATH_DEVICE_READY). OTOH, most of these flags
> > have been around for many years without changing, and thus have
> > acquired the status of a semi-official API, which is actually used in
> > other rule sets. In particular DM_UDEV_DISABLE_OTHER_RULES_FLAG has a
> > few users, see above. I believe this is for good reason, and therefore
> > I don't consider my patch a "hack".
> >
>
> Maybe we (DM) should have documented this better, more clearly, but the
> DM_UDEV_DISABLE_OTHER_RULES_FLAG is really designed to be checked by
> "other" foreign subsystems to notify them whether they can process their
> udev rules on such a DM device.
>
> Full documentation for the generic DM udev flags is here:
>
> https://sourceware.org/git/?p=lvm2.git;a=blob;f=libdm/libdevmapper.h;=e9412da7d33fc7534cd1eccd88c21b75c6c221b1;hb=HEAD#l3644
>
> In summary, the meaning of the flags:
>
>   DM_UDEV_DISABLE_DISK_RULES_FLAG is controlling 13-dm-disk.rules (where
> blkid is called for DM devices and /dev/disk/by-* symlinks are set)
>
>   DM_UDEV_DISABLE_DM_RULES_FLAG is controlling 10-dm.rules
>
>   DM_UDEV_DISABLE_SUBSYSTEM_RULES_FLAG is controlling DM subsystem (LVM,
> multipath, crypt, ...)
>
>   DM_NOSCAN is just a helper DM-internal flag in udev to help inside
> DM's own rules and/or its subsystem rules
>
>   DM_SUSPENDED is something that is set and can be checked, but foreign
> (non-DM) udev rules don't need to bother about this at all. DM udev
> rules already set DM_UDEV_DISABLE_OTHER_RULES_FLAG to notify other rules
> if the DM device becomes unreadable.
>
>   DM_NAME, DM_UUID - normally, other rules don't need to bother about
> DM name or UUID - they're set mainly to hook custom permission rules on
> (for which DM has a template 12-dm-permissions.rules).
>
> So the only flag a non-DM rule should be concerned about is exactly the
> single DM_UDEV_DISABLE_OTHER_RULES_FLAG. That's its exact purpose it
> was designed for within DM block devices and uevent processing.
>
> Definitely not a hack!
>
> (I'm just a bit surprised that we haven't sent a patch to MD yet.
> Wasn't there a check for this flag anytime before? I thought all
> major block subsystems have already been covered.)
>

Hi Peter

In rhel, we have a rhel only udev rule that checks
DM_UDEV_DISABLE_OTHER_RULES_FLAG. Maybe it's the reason why you don't
notice this. Besides DM_UDEV_DISABLE_OTHER_RULES_FLAG, it still checks
other flags.

# Next make sure that this isn't a dm device we should skip for some reason
ENV{DM_UDEV_RULES_VSN}!="?*", GOTO="dm_change_end"
ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}=="1", GOTO="dm_change_end"
ENV{DM_SUSPENDED}=="1", GOTO="dm_change_end"
KERNEL=="dm-*", SUBSYSTEM=="block", ENV{ID_FS_TYPE}=="linux_raid_member", \
        ACTION=="change", RUN+="/sbin/mdadm -I $env{DEVNAME}"
LABEL="dm_change_end"

In 10-dm.rules, if DM_SUSPENDED is 1, it sets
DM_UDEV_DISABLE_OTHER_RULES_FLAG to 1. So we don't need the check of
DM_SUSPENDED. But how DM_UDEV_RULES_VSN? Do we need to check it?

Best Regards
Xiao

