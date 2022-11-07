Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60447C433FE
	for <linux-raid@archiver.kernel.org>; Mon,  7 Nov 2022 08:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbiKGIbS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Nov 2022 03:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbiKGIbQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Nov 2022 03:31:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDB714002
        for <linux-raid@vger.kernel.org>; Mon,  7 Nov 2022 00:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667809820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WZllEzv+Hu79VMl7fHKclTU2o+Qx3nHEZb0Wf2eOwu0=;
        b=P3Zt/LxDV+nNLbwyEtbbMHaqSYmecoLu3McOzF4rAF9rUc5XLQldzjIxemJxk/pOfCVvG7
        8oce85FFC//YluNpMDZQO80slsAm+KN6NnkiiI1GAwipoIokVMc9Yn+iuoMYYuVF2vN77N
        A40bh5YMFh7GR3zVM6Ei69b5GG8U0W4=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-177-DjaeDtmcP9qCPSHeW5dtHg-1; Mon, 07 Nov 2022 03:30:18 -0500
X-MC-Unique: DjaeDtmcP9qCPSHeW5dtHg-1
Received: by mail-pg1-f197.google.com with SMTP id k16-20020a635a50000000b0042986056df6so5862210pgm.2
        for <linux-raid@vger.kernel.org>; Mon, 07 Nov 2022 00:30:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WZllEzv+Hu79VMl7fHKclTU2o+Qx3nHEZb0Wf2eOwu0=;
        b=UmdDh9hg3jI8s7jM9Dod6z5eLCuPEan4/zXPgpY/x4GGe4Sp6OaBMLllqn0sCWTNgk
         HDTdHO4pzTZ+iItJVmNz+tfVORVFXtcusjaA9sFSge6t0OPX1/V7DmeLvRH3SnoLK50m
         j2JVloeShA0px629zvdxhiWrWNCAeWBUY4UrfzmoHDAEc/LG/MNy+UrOoCCsn9UMimxO
         UKYa10Y/y6cgX19wlgq+r8BIt6gMjGLWd2ArU3y95uQEFD4RW1YyJWlR9d81zkc1x1sP
         Am9pqVYjD8wsAVfOJmubgeUTSi07HDFralPopuc/VGyqsxCOXEUufWXAwo765ph4G4wy
         V04w==
X-Gm-Message-State: ACrzQf0jJPk8bMmDYSC+uo9XiCZIbPPI7nng3ptH5EusXvMg39xGJ5km
        imuTciULuroMm8B4jxNYmAgukyGjodryn5IqfxyAyUgUmWiUgp0Z+IenER5dw/PCzGI+tkkHbUW
        mhsBaVw9OUxHHJeTDYKdK8uqzUkzt3cEjOR+hCA==
X-Received: by 2002:a17:902:da82:b0:186:ee5a:47c7 with SMTP id j2-20020a170902da8200b00186ee5a47c7mr49916190plx.82.1667809817489;
        Mon, 07 Nov 2022 00:30:17 -0800 (PST)
X-Google-Smtp-Source: AMsMyM576wzhtOJyEds25Duk0Bn02vLfiQDo/XlW0npbxYayKLmkaTqFXyRAXOk8CwE2hVjAqesGJMOlLCmG00uMLVk=
X-Received: by 2002:a17:902:da82:b0:186:ee5a:47c7 with SMTP id
 j2-20020a170902da8200b00186ee5a47c7mr49916174plx.82.1667809817133; Mon, 07
 Nov 2022 00:30:17 -0800 (PST)
MIME-Version: 1.0
References: <984d4620-e53f-0d1f-c61a-0485ea79e3f6@rechte.fr>
 <CALTww2-dKxDzTo6svQm+8wyo5UiY6v+amjoKjbhHQ4dVvDO67w@mail.gmail.com> <3466aa97-597e-0c8e-42df-eaf2e947348f@rechte.fr>
In-Reply-To: <3466aa97-597e-0c8e-42df-eaf2e947348f@rechte.fr>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 7 Nov 2022 16:30:05 +0800
Message-ID: <CALTww2_ug4Je4niEhqOHa6AS5cETRAK_qTJz+D6pP1Yr9ZjEBA@mail.gmail.com>
Subject: Re: mdadm udev rule does not start mdmonitor systemd unit.
To:     =?UTF-8?B?TWFyYyBSZWNodMOp?= <marc4@rechte.fr>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Nov 6, 2022 at 4:51 PM Marc Recht=C3=A9 <marc4@rechte.fr> wrote:
>
> Le 03/11/2022 =C3=A0 03:54, Xiao Ni a =C3=A9crit :
> > On Tue, Nov 1, 2022 at 8:27 PM Marc Recht=C3=A9 <marc4@rechte.fr> wrote=
:
> >> Hello,
> >>
> >> I have a udev rule and a md127 device with the properties as following=
.
> >>
> >> The mdmonitor service is not started (no trace in systemd journal).
> >> However I can manually start the service.
> >>
> >> I just noticed that SYSTEMD_READY porperty is 0 which could explain th=
is
> >> behaviour (according to man systemd.device) ?
> > Hi Marc
> >
> > For raid device, SYSTEMD_READY will be 1 when the change event happens.
> > And for lvm volume, SYSTEMD_READY will be 1 when the add event happens.
> > So you need to notice about his in your udev rule.
> >
> >> I don't know how to further debug.
> > You can add systemd.log_level=3Ddebug udev.log-priority=3Ddebug to your=
 boot conf
> > file. For example,
> > /boot/loader/entries/xxx-4.18.0-416.el8.x86_64.conf. My environment
> > is rhel. Maybe it's different on your system.
> >
> > Then you can add some printf logs into your udev rule. I did in this
> > way, something
> > like this:
> >
> > ENV{SYSTEMD_READY}=3D=3D"0", GOTO=3D"test_end"
> > SUBSYSTEM=3D=3D"block", ACTION=3D=3D"add", RUN{program}+=3D"/usr/bin/ec=
ho
> > mdadm-test-add-SYSTEMD_READY"
> > SUBSYSTEM=3D=3D"block", ACTION=3D=3D"change", RUN{program}+=3D"/usr/bin=
/echo
> > mdadm-test-change-SYSTEMD_READY"
> >
> > You can check the logs by journalctl command. So you can know which
> > rule runs in your udev rule.
> >
> > Regards
> > Xiao
> >> Thanks
> >>
> >> # udevadm info --query=3Dproperty --name=3D/dev/md127
> >>
> >> DEVPATH=3D/devices/virtual/block/md127
> >> DEVNAME=3D/dev/md127
> >> DEVTYPE=3Ddisk
> >> DISKSEQ=3D6
> >> MAJOR=3D9
> >> MINOR=3D127
> >> SUBSYSTEM=3Dblock
> >> USEC_INITIALIZED=3D5129215
> >> ID_IGNORE_DISKSEQ=3D1
> >> MD_LEVEL=3Draid1
> >> MD_DEVICES=3D2
> >> MD_METADATA=3D1.2
> >> MD_UUID=3D800ee577:652e6fdc:79f6768e:dea2f7ea
> >> MD_DEVNAME=3DSysRAID1Array1
> >> MD_NAME=3Dlinux2:SysRAID1Array1
> >> ID_FS_UUID=3Dx94VGG-7hfP-rn1c-MR53-q6to-QPZR-73eAdq
> >> ID_FS_UUID_ENC=3Dx94VGG-7hfP-rn1c-MR53-q6to-QPZR-73eAdq
> >> ID_FS_VERSION=3DLVM2 001
> >> ID_FS_TYPE=3DLVM2_member
> >> ID_FS_USAGE=3Draid
> >> SYSTEMD_WANTS=3Dmdmonitor.service
> >> SYSTEMD_READY=3D0
> >> UDISKS_MD_LEVEL=3Draid1
> >> UDISKS_MD_DEVICES=3D2
> >> UDISKS_MD_METADATA=3D1.2
> >> UDISKS_MD_UUID=3D800ee577:652e6fdc:79f6768e:dea2f7ea
> >> UDISKS_MD_DEVNAME=3DSysRAID1Array1
> >> UDISKS_MD_NAME=3Dlinux2:SysRAID1Array1
> >> UDISKS_MD_DEVICE_dev_nvme0n1p2_ROLE=3D0
> >> UDISKS_MD_DEVICE_dev_nvme0n1p2_DEV=3D/dev/nvme0n1p2
> >> UDISKS_MD_DEVICE_dev_nvme1n1p2_ROLE=3D1
> >> UDISKS_MD_DEVICE_dev_nvme1n1p2_DEV=3D/dev/nvme1n1p2
> >> DEVLINKS=3D/dev/md/SysRAID1Array1
> >> /dev/disk/by-id/md-name-linux2:SysRAID1Array1
> >> /dev/disk/by-id/lvm-pv-uuid-x94VGG-7hfP-rn1c-MR53-q6to-QPZR-73eAdq
> >> /dev/disk/by-id/md-uuid-800ee577:652e6fdc:79f6768e:dea2f7ea
> >> TAGS=3D:systemd:
> >> CURRENT_TAGS=3D:systemd:
> >>
> >> # cat /usr/lib/udev/rules.d/63-md-raid-arrays.rules
> >> # do not edit this file, it will be overwritten on update
> >>
> >> SUBSYSTEM!=3D"block", GOTO=3D"md_end"
> >>
> >> # handle md arrays
> >> ACTION!=3D"add|change", GOTO=3D"md_end"
> >> KERNEL!=3D"md*", GOTO=3D"md_end"
> >>
> >> # partitions have no md/{array_state,metadata_version}, but should not
> >> # for that reason be ignored.
> >> ENV{DEVTYPE}=3D=3D"partition", GOTO=3D"md_ignore_state"
> >>
> >> # container devices have a metadata version of e.g. 'external:ddf' and
> >> # never leave state 'inactive'
> >> ATTR{md/metadata_version}=3D=3D"external:[A-Za-z]*",
> >> ATTR{md/array_state}=3D=3D"inactive", GOTO=3D"md_ignore_state"
> >> TEST!=3D"md/array_state", ENV{SYSTEMD_READY}=3D"0", GOTO=3D"md_end"
> >> ATTR{md/array_state}=3D=3D"clear*|inactive", ENV{SYSTEMD_READY}=3D"0",
> >> GOTO=3D"md_end"
> >> ATTR{md/sync_action}=3D=3D"reshape", ENV{RESHAPE_ACTIVE}=3D"yes"
> >> LABEL=3D"md_ignore_state"
> >>
> >> IMPORT{program}=3D"/usr/bin/mdadm --detail --no-devices --export $devn=
ode"
> >> ENV{DEVTYPE}=3D=3D"disk", ENV{MD_NAME}=3D=3D"?*",
> >> SYMLINK+=3D"disk/by-id/md-name-$env{MD_NAME}",
> >> OPTIONS+=3D"string_escape=3Dreplace"
> >> ENV{DEVTYPE}=3D=3D"disk", ENV{MD_UUID}=3D=3D"?*",
> >> SYMLINK+=3D"disk/by-id/md-uuid-$env{MD_UUID}"
> >> ENV{DEVTYPE}=3D=3D"disk", ENV{MD_DEVNAME}=3D=3D"?*", SYMLINK+=3D"md/$e=
nv{MD_DEVNAME}"
> >> ENV{DEVTYPE}=3D=3D"partition", ENV{MD_NAME}=3D=3D"?*",
> >> SYMLINK+=3D"disk/by-id/md-name-$env{MD_NAME}-part%n",
> >> OPTIONS+=3D"string_escape=3Dreplace"
> >> ENV{DEVTYPE}=3D=3D"partition", ENV{MD_UUID}=3D=3D"?*",
> >> SYMLINK+=3D"disk/by-id/md-uuid-$env{MD_UUID}-part%n"
> >> ENV{DEVTYPE}=3D=3D"partition", ENV{MD_DEVNAME}=3D=3D"*[^0-9]",
> >> SYMLINK+=3D"md/$env{MD_DEVNAME}%n"
> >> ENV{DEVTYPE}=3D=3D"partition", ENV{MD_DEVNAME}=3D=3D"*[0-9]",
> >> SYMLINK+=3D"md/$env{MD_DEVNAME}p%n"
> >>
> >> IMPORT{builtin}=3D"blkid"
> >> OPTIONS+=3D"link_priority=3D100"
> >> OPTIONS+=3D"watch"
> >> ENV{ID_FS_USAGE}=3D=3D"filesystem|other|crypto", ENV{ID_FS_UUID_ENC}=
=3D=3D"?*",
> >> SYMLINK+=3D"disk/by-uuid/$env{ID_FS_UUID_ENC}"
> >> ENV{ID_FS_USAGE}=3D=3D"filesystem|other", ENV{ID_PART_ENTRY_UUID}=3D=
=3D"?*",
> >> SYMLINK+=3D"disk/by-partuuid/$env{ID_PART_ENTRY_UUID}"
> >> ENV{ID_FS_USAGE}=3D=3D"filesystem|other", ENV{ID_FS_LABEL_ENC}=3D=3D"?=
*",
> >> SYMLINK+=3D"disk/by-label/$env{ID_FS_LABEL_ENC}"
> >>
> >> ENV{MD_LEVEL}=3D=3D"raid[1-9]*", ENV{SYSTEMD_WANTS}+=3D"mdmonitor.serv=
ice"
> >>
> >> # Tell systemd to run mdmon for our container, if we need it.
> >> ENV{MD_LEVEL}=3D=3D"raid[1-9]*", ENV{MD_CONTAINER}=3D=3D"?*",
> >> PROGRAM=3D"/usr/bin/readlink $env{MD_CONTAINER}", ENV{MD_MON_THIS}=3D"=
%c"
> >> ENV{MD_MON_THIS}=3D=3D"?*", PROGRAM=3D"/usr/bin/basename $env{MD_MON_T=
HIS}",
> >> ENV{SYSTEMD_WANTS}+=3D"mdmon@%c.service"
> >> ENV{RESHAPE_ACTIVE}=3D=3D"yes", PROGRAM=3D"/usr/bin/basename
> >> $env{MD_MON_THIS}", ENV{SYSTEMD_WANTS}+=3D"mdadm-grow-continue@%c.serv=
ice"
> >>
> >> LABEL=3D"md_end"
> >>
> >>
> Hello Xiao,
>
> Thanks for the tips.
>
> It appears that SYSTEMD_READY =3D=3D 1 when entering the add/change event=
,
> but it seems it is reset to 0 while processing the rules.
>
> Following is modified rule with debug info. Relevant journal entries:
>
> md127: '/usr/bin/echo mdadm-test-add-SYSTEMD_READY'(out)
> 'mdadm-test-add-SYSTEMD_READY'

You see the log in your test. From the following udev rule, it only can han=
dle
add/change events. And SYSTEMD_READY is 1, it doesn't go to the md_test
label. And the log appears. So it doesn't reset to 0, right?

Regards
Xiao

>
> ...
>
> md127: '/usr/bin/udevadm info --query=3Dproperty --name=3D/dev/md127'(out=
)
> 'SYSTEMD_READY=3D0'
>
>
> $ cat 63-md-raid-arrays.rules
>
> # do not edit this file, it will be overwritten on update
>
> SUBSYSTEM!=3D"block", GOTO=3D"md_end"
>
> # handle md arrays
> ACTION!=3D"add|change", GOTO=3D"md_end"
> KERNEL!=3D"md*", GOTO=3D"md_end"
>
> ENV{SYSTEMD_READY}=3D=3D"0", GOTO=3D"md_test"
> RUN{program}+=3D"/usr/bin/echo mdadm-test-add-SYSTEMD_READY"
> LABEL=3D"md_test"
>
>
> # partitions have no md/{array_state,metadata_version}, but should not
> # for that reason be ignored.
> ENV{DEVTYPE}=3D=3D"partition", GOTO=3D"md_ignore_state"
>
> # container devices have a metadata version of e.g. 'external:ddf' and
> # never leave state 'inactive'
> ATTR{md/metadata_version}=3D=3D"external:[A-Za-z]*",
> ATTR{md/array_state}=3D=3D"inactive", GOTO=3D"md_ignore_state"
> TEST!=3D"md/array_state", ENV{SYSTEMD_READY}=3D"0", GOTO=3D"md_end"
> ATTR{md/array_state}=3D=3D"clear*|inactive", ENV{SYSTEMD_READY}=3D"0",
> GOTO=3D"md_end"
> ATTR{md/sync_action}=3D=3D"reshape", ENV{RESHAPE_ACTIVE}=3D"yes"
> LABEL=3D"md_ignore_state"
>
> IMPORT{program}=3D"/usr/bin/mdadm --detail --no-devices --export $devnode=
"
> ENV{DEVTYPE}=3D=3D"disk", ENV{MD_NAME}=3D=3D"?*",
> SYMLINK+=3D"disk/by-id/md-name-$env{MD_NAME}",
> OPTIONS+=3D"string_escape=3Dreplace"
> ENV{DEVTYPE}=3D=3D"disk", ENV{MD_UUID}=3D=3D"?*",
> SYMLINK+=3D"disk/by-id/md-uuid-$env{MD_UUID}"
> ENV{DEVTYPE}=3D=3D"disk", ENV{MD_DEVNAME}=3D=3D"?*", TAG+=3D"systemd",
> SYMLINK+=3D"md/$env{MD_DEVNAME}"
> ENV{DEVTYPE}=3D=3D"partition", ENV{MD_NAME}=3D=3D"?*",
> SYMLINK+=3D"disk/by-id/md-name-$env{MD_NAME}-part%n",
> OPTIONS+=3D"string_escape=3Dreplace"
> ENV{DEVTYPE}=3D=3D"partition", ENV{MD_UUID}=3D=3D"?*",
> SYMLINK+=3D"disk/by-id/md-uuid-$env{MD_UUID}-part%n"
> ENV{DEVTYPE}=3D=3D"partition", ENV{MD_DEVNAME}=3D=3D"*[^0-9]",
> SYMLINK+=3D"md/$env{MD_DEVNAME}%n"
> ENV{DEVTYPE}=3D=3D"partition", ENV{MD_DEVNAME}=3D=3D"*[0-9]",
> SYMLINK+=3D"md/$env{MD_DEVNAME}p%n"
>
>
> IMPORT{builtin}=3D"blkid"
> OPTIONS+=3D"link_priority=3D100"
> OPTIONS+=3D"watch"
> ENV{ID_FS_USAGE}=3D=3D"filesystem|other|crypto", ENV{ID_FS_UUID_ENC}=3D=
=3D"?*",
> SYMLINK+=3D"disk/by-uuid/$env{ID_FS_UUID_ENC}"
> ENV{ID_FS_USAGE}=3D=3D"filesystem|other", ENV{ID_PART_ENTRY_UUID}=3D=3D"?=
*",
> SYMLINK+=3D"disk/by-partuuid/$env{ID_PART_ENTRY_UUID}"
> ENV{ID_FS_USAGE}=3D=3D"filesystem|other", ENV{ID_FS_LABEL_ENC}=3D=3D"?*",
> SYMLINK+=3D"disk/by-label/$env{ID_FS_LABEL_ENC}"
>
> ENV{MD_LEVEL}=3D=3D"raid[1-9]*", ENV{SYSTEMD_WANTS}+=3D"mdmonitor.service=
"
> ENV{MD_LEVEL}=3D=3D"raid[1-9]*", ENV{SYSTEMD_WANTS}+=3D"hello.service"
>
> #RUN{program}+=3D"/usr/bin/echo SYSTEMD_READY =3D $env(SYSTEMD_READY)"
> RUN{program}+=3D"/usr/bin/udevadm info --query=3Dproperty --name=3D/dev/m=
d127"
>
> # Tell systemd to run mdmon for our container, if we need it.
> ENV{MD_LEVEL}=3D=3D"raid[1-9]*", ENV{MD_CONTAINER}=3D=3D"?*",
> PROGRAM=3D"/usr/bin/readlink $env{MD_CONTAINER}", ENV{MD_MON_THIS}=3D"%c"
> ENV{MD_MON_THIS}=3D=3D"?*", PROGRAM=3D"/usr/bin/basename $env{MD_MON_THIS=
}",
> ENV{SYSTEMD_WANTS}+=3D"mdmon@%c.service"
> ENV{RESHAPE_ACTIVE}=3D=3D"yes", PROGRAM=3D"/usr/bin/basename
> $env{MD_MON_THIS}", ENV{SYSTEMD_WANTS}+=3D"mdadm-grow-continue@%c.service=
"
>
> LABEL=3D"md_end"
>
>
>

