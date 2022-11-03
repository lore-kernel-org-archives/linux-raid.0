Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD94C433FE
	for <linux-raid@archiver.kernel.org>; Thu,  3 Nov 2022 02:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiKCC4e (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Nov 2022 22:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiKCC41 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Nov 2022 22:56:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9322111C24
        for <linux-raid@vger.kernel.org>; Wed,  2 Nov 2022 19:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667444103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5zyjl1/Az4cjueiclTlyNHpic+UVxLY5HMkl3WcABaI=;
        b=EYC/SZHguYCWPGC0ezwtcaJTbWszYPjnq7X0lcGRvUpOVCEchl5TAW5kHkhfn16zKSwbod
        j6krD+Fy2FUV8DJ0HAoqLgf02iAjlZpCaTyhaLuk6WEa+R68tc77yDIZDBPoFoCxV41vjr
        +kunz2HqVQ9zCkcT/XF3XJZW/gkwhu4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-496-zdroqmjoPtmFoNkuo8DMoQ-1; Wed, 02 Nov 2022 22:55:02 -0400
X-MC-Unique: zdroqmjoPtmFoNkuo8DMoQ-1
Received: by mail-pl1-f198.google.com with SMTP id e13-20020a17090301cd00b001871e6f8714so520654plh.14
        for <linux-raid@vger.kernel.org>; Wed, 02 Nov 2022 19:55:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5zyjl1/Az4cjueiclTlyNHpic+UVxLY5HMkl3WcABaI=;
        b=TqRnGR/UKInnsIJFgYEYs4oOC4q3ayyWAW1KldMQntkj9OKBQcrixEwCu2m5KfuFM3
         1NIaBVnOccZ+9hBOt2sIP/CtpLYuZ3bGE65D/0dc/Jqwx+QmMpBBIXJKC7Zq+8RHpOLI
         mn14LpIIW7EStx1eSDn8V49NzgG1l/2UhwEi1umNa/1v4Thzx2nXxwC2175t4M6XnA6N
         B9m92/N0fWYwdWStnLEaZolNC9eNB/RvrtgyjpMOowH+5u59zYwvq+ul34wfooUd0M3D
         ZfRkuMPIjbFJbFKgnU6qms5Kwn223SJ79egbZvvh/C1eZeBdyzf30h0s1DwtV9jNO438
         xT6g==
X-Gm-Message-State: ACrzQf1DEOvr/xlSgnfA2tR3xxuWY0iEJuoEM/L6X4F3IvXfNal/c8S6
        8my08SIQmJeuliXJO2eRljFWItZTPFIoQq+YbzCt+YH1A60xLRQvUbPwWDg1UXQCFGNnJszjeEY
        he66Dip5fdznhkvEkiPdIrA6GRLcIoeABWxm23Q==
X-Received: by 2002:a17:902:e5d1:b0:187:3593:a86f with SMTP id u17-20020a170902e5d100b001873593a86fmr12714045plf.15.1667444100828;
        Wed, 02 Nov 2022 19:55:00 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6LdBxEdReWpRU375dn7R7bM55PRRXdkNnFr9LvY0yMc3hXLxSN6DFHSM/OIUGs+swoc6FUGvhs4E8Y0DffIvY=
X-Received: by 2002:a17:902:e5d1:b0:187:3593:a86f with SMTP id
 u17-20020a170902e5d100b001873593a86fmr12714019plf.15.1667444100491; Wed, 02
 Nov 2022 19:55:00 -0700 (PDT)
MIME-Version: 1.0
References: <984d4620-e53f-0d1f-c61a-0485ea79e3f6@rechte.fr>
In-Reply-To: <984d4620-e53f-0d1f-c61a-0485ea79e3f6@rechte.fr>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 3 Nov 2022 10:54:49 +0800
Message-ID: <CALTww2-dKxDzTo6svQm+8wyo5UiY6v+amjoKjbhHQ4dVvDO67w@mail.gmail.com>
Subject: Re: mdadm udev rule does not start mdmonitor systemd unit.
To:     =?UTF-8?B?TWFyYyBSZWNodMOp?= <marc4@rechte.fr>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Nov 1, 2022 at 8:27 PM Marc Recht=C3=A9 <marc4@rechte.fr> wrote:
>
> Hello,
>
> I have a udev rule and a md127 device with the properties as following.
>
> The mdmonitor service is not started (no trace in systemd journal).
> However I can manually start the service.
>
> I just noticed that SYSTEMD_READY porperty is 0 which could explain this
> behaviour (according to man systemd.device) ?

Hi Marc

For raid device, SYSTEMD_READY will be 1 when the change event happens.
And for lvm volume, SYSTEMD_READY will be 1 when the add event happens.
So you need to notice about his in your udev rule.

>
> I don't know how to further debug.

You can add systemd.log_level=3Ddebug udev.log-priority=3Ddebug to your boo=
t conf
file. For example,
/boot/loader/entries/xxx-4.18.0-416.el8.x86_64.conf. My environment
is rhel. Maybe it's different on your system.

Then you can add some printf logs into your udev rule. I did in this
way, something
like this:

ENV{SYSTEMD_READY}=3D=3D"0", GOTO=3D"test_end"
SUBSYSTEM=3D=3D"block", ACTION=3D=3D"add", RUN{program}+=3D"/usr/bin/echo
mdadm-test-add-SYSTEMD_READY"
SUBSYSTEM=3D=3D"block", ACTION=3D=3D"change", RUN{program}+=3D"/usr/bin/ech=
o
mdadm-test-change-SYSTEMD_READY"

You can check the logs by journalctl command. So you can know which
rule runs in your udev rule.

Regards
Xiao
>
> Thanks
>
> # udevadm info --query=3Dproperty --name=3D/dev/md127
>
> DEVPATH=3D/devices/virtual/block/md127
> DEVNAME=3D/dev/md127
> DEVTYPE=3Ddisk
> DISKSEQ=3D6
> MAJOR=3D9
> MINOR=3D127
> SUBSYSTEM=3Dblock
> USEC_INITIALIZED=3D5129215
> ID_IGNORE_DISKSEQ=3D1
> MD_LEVEL=3Draid1
> MD_DEVICES=3D2
> MD_METADATA=3D1.2
> MD_UUID=3D800ee577:652e6fdc:79f6768e:dea2f7ea
> MD_DEVNAME=3DSysRAID1Array1
> MD_NAME=3Dlinux2:SysRAID1Array1
> ID_FS_UUID=3Dx94VGG-7hfP-rn1c-MR53-q6to-QPZR-73eAdq
> ID_FS_UUID_ENC=3Dx94VGG-7hfP-rn1c-MR53-q6to-QPZR-73eAdq
> ID_FS_VERSION=3DLVM2 001
> ID_FS_TYPE=3DLVM2_member
> ID_FS_USAGE=3Draid
> SYSTEMD_WANTS=3Dmdmonitor.service
> SYSTEMD_READY=3D0
> UDISKS_MD_LEVEL=3Draid1
> UDISKS_MD_DEVICES=3D2
> UDISKS_MD_METADATA=3D1.2
> UDISKS_MD_UUID=3D800ee577:652e6fdc:79f6768e:dea2f7ea
> UDISKS_MD_DEVNAME=3DSysRAID1Array1
> UDISKS_MD_NAME=3Dlinux2:SysRAID1Array1
> UDISKS_MD_DEVICE_dev_nvme0n1p2_ROLE=3D0
> UDISKS_MD_DEVICE_dev_nvme0n1p2_DEV=3D/dev/nvme0n1p2
> UDISKS_MD_DEVICE_dev_nvme1n1p2_ROLE=3D1
> UDISKS_MD_DEVICE_dev_nvme1n1p2_DEV=3D/dev/nvme1n1p2
> DEVLINKS=3D/dev/md/SysRAID1Array1
> /dev/disk/by-id/md-name-linux2:SysRAID1Array1
> /dev/disk/by-id/lvm-pv-uuid-x94VGG-7hfP-rn1c-MR53-q6to-QPZR-73eAdq
> /dev/disk/by-id/md-uuid-800ee577:652e6fdc:79f6768e:dea2f7ea
> TAGS=3D:systemd:
> CURRENT_TAGS=3D:systemd:
>
> # cat /usr/lib/udev/rules.d/63-md-raid-arrays.rules
> # do not edit this file, it will be overwritten on update
>
> SUBSYSTEM!=3D"block", GOTO=3D"md_end"
>
> # handle md arrays
> ACTION!=3D"add|change", GOTO=3D"md_end"
> KERNEL!=3D"md*", GOTO=3D"md_end"
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
> ENV{DEVTYPE}=3D=3D"disk", ENV{MD_DEVNAME}=3D=3D"?*", SYMLINK+=3D"md/$env{=
MD_DEVNAME}"
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

