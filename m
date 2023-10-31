Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCDF8C4332F
	for <linux-raid@archiver.kernel.org>; Tue, 31 Oct 2023 14:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343911AbjJaOTi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 Oct 2023 10:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjJaOTh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 Oct 2023 10:19:37 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FCCB7
        for <linux-raid@vger.kernel.org>; Tue, 31 Oct 2023 07:19:35 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-7a692658181so186689039f.1
        for <linux-raid@vger.kernel.org>; Tue, 31 Oct 2023 07:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698761975; x=1699366775; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4tvCBPtB+l6E35c4OmMLI8E+4KoFHBLr1m/DHtYuM0k=;
        b=GkGpQz/DNtjid38/dAHZUdM4m4YSYn3R0IPGHShxwZR6Fu480pxqYugMjzOC3cMmEA
         Y5NpuSGRQD59iqZj/SLy5/MpCHApLrx43bMbvFH6K/Qa5j8URC209Q4abXoaeowWDZmR
         nsju9pQhLxypO+j45tJZOR2EDTW2zxW5Oknhs7kkCF85N0e0CNdZDQw/LgSHOtPH+Gaj
         qyg7RCpn2H7CrgWkZ2zEnRjKSoJ/L/3POb4GvV1AwO5N2a66E+19c766cMEiKkNF+U1+
         f6hr0eT5VKOeCk5F2DSqZXCPGcmKzHEN5gHU4piV4jl68/MgJJZvhFdsLtLVdeSpXCa9
         CTtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698761975; x=1699366775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4tvCBPtB+l6E35c4OmMLI8E+4KoFHBLr1m/DHtYuM0k=;
        b=JSTQ97P2qPto4Aq/6Lms64/zCBHl5Qf+VFGOkwwKVcL590gFz1BGTHR5kFSQuMBcpK
         J436e4530R0A8xhyaf70cBv2S29wkhlp2Z7qmEVMu2UVuCd4zVJzrvT9tCeKP8nVlpOx
         RRSRBxWyjV2k+6t+tqklA3nzXg9kbcrCUOw+SEX45coUqcK1ARLrCcxKw9LS2N6t9IQG
         Px+kHPWf7n69+4ePmCFp89tjA+lOh/+8UeQ4VIcTJfAlZqX1Z7r5nQUpWiXr783YP+rx
         bA61W63lxBEga/edY9eILyyemBalPyE0mz/5JC49csfd7GRtDD83r39tb6xYkLBMoZ1z
         5zaQ==
X-Gm-Message-State: AOJu0YyNxTkl1T7LgP5un3JjdhpYh/iKK/5Ngpg6HtQCXC1z/Mbr36UV
        IQD5DD1eqCLbT6Mo4OOrIyYwzExoA92G74ycgQWXgkAtUNg=
X-Google-Smtp-Source: AGHT+IGGAvlKhDZkPVy8XgMnl5IySHbOOWLgobx9a79kY1npA90rwx4RL41T4/4tMhp0woFiAk2uwEcueB+o1n+2eME=
X-Received: by 2002:a6b:7f48:0:b0:7a6:a3b1:b45c with SMTP id
 m8-20020a6b7f48000000b007a6a3b1b45cmr14016766ioq.14.1698761974961; Tue, 31
 Oct 2023 07:19:34 -0700 (PDT)
MIME-Version: 1.0
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
 <ZUByq7Wg-KFcXctW@fisica.ufpr.br> <577244fc-f43a-4e1f-bf34-d1c194fd90b4@eyal.emu.id.au>
 <ZUD1axirvgJVdG2-@fisica.ufpr.br>
In-Reply-To: <ZUD1axirvgJVdG2-@fisica.ufpr.br>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Tue, 31 Oct 2023 09:19:24 -0500
Message-ID: <CAAMCDed1HMxPzRoikxM9L-zi8m4FvGWDg=jXL=NevZ+tkwiogA@mail.gmail.com>
Subject: Re: problem with recovered array
To:     Carlos Carvalho <carlos@fisica.ufpr.br>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If it is a spinning disk there is a limit to the total amount of
updates(iops) read or write that can be done per second.

In Raid5/6 a small read is 1 small read, but a small write requires
several disks to get read and/or written to complete that single
write, when a disk is failed, a read that would have had its data on
the missing disk needs to read all other disks to recalculate the
missing data.

If your array was already busy, the extra reads and recalculates could
push your array over its ability to do io limit.

I set these 2 parms to limit the total amount of dirty cache and this
appears to make the system more responsive.

[root@bm-server ~]# sysctl -a | grep -i dirty | grep -i bytes
vm.dirty_background_bytes =3D 3000000
vm.dirty_bytes =3D 5000000

The issue being that once you hit dirty_bytes all writes stop until
you get the cache cleared back to dirty_background_bytes, and the
greater the difference between the 2 the longer the freeze time is.

Note that by default most distributions don't use the _bytes they use
dirty_ratio/dirty_background_ratio that is a % of memory and can cause
the write freeze to last for a significant amount of time since a
single % is quite large if you have a lot of ram.

You might also want to look at the io for the sd* devices under the md
device as that would show what MD is doing under the covers to make
the io happen (sar and/or iostat).

On Tue, Oct 31, 2023 at 7:39=E2=80=AFAM Carlos Carvalho <carlos@fisica.ufpr=
.br> wrote:
>
> eyal@eyal.emu.id.au (eyal@eyal.emu.id.au) wrote on Tue, Oct 31, 2023 at 0=
6:29:14AM -03:
> > More evidence that the problem relates to the cache not flushed to disk=
.
>
> Yes.
>
> > It seems that the array is slow to sync files somehow. Mythtv has no pr=
oblems because it write
> > only a few large files. rsync copies a very large number of small files=
 which somehow triggers
> > the problem.
>
> Mee too. Writing few files works fine, the problem happens when many file=
s need
> flushing. That's why expanding the kernel tree blocks the machine. After =
many
> hours it either crashes or I have to do a hard reboot because all service
> stops.
>
> It also happens with 6.1 but 6.5 is a lot more susceptible. Further, the =
longer
> the uptime the more prone to deadlock the machine becomes...
