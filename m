Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 333D5C05027
	for <linux-raid@archiver.kernel.org>; Tue, 14 Mar 2023 20:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjCNUnL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Mar 2023 16:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjCNUnJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Mar 2023 16:43:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676DAD50A
        for <linux-raid@vger.kernel.org>; Tue, 14 Mar 2023 13:43:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20FA7B81B97
        for <linux-raid@vger.kernel.org>; Tue, 14 Mar 2023 20:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71A1C433D2
        for <linux-raid@vger.kernel.org>; Tue, 14 Mar 2023 20:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678826585;
        bh=LF/BcKlq932gR/+J4nbVkPRjLBOB7F9T/8KpydMdIS4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LmfrU7snExyjSF/RDaSoEvVsoaR+9hO6Zq0kCeO2VXIrWzz4ITi7WmLd54chilSVF
         2EO6Cob8/FdPaaEIWgBq+y118iQUdJyrmth27JwmkQzZn1a6sJnnJ54Dk5YCYklSMH
         oUIHJKWkNJbmEBdGP72km/6Qpwz1rTiHv+awdoPUVwzxofdHoyR2dZ+f8Utm6PLB3L
         haWa+rf2u3s6gw4H0CTkeANkhzQbsusRdB2zkGwyLIxxxId9h3RTI1srKAaOejPkyC
         1FgB4l52r7pNMM0YDiQ369WaLI08Aj8DzA0M+XvT+sgPhQpKYQQBJJqcG+WvMVim8a
         yd3v2OMEMdm1w==
Received: by mail-lj1-f169.google.com with SMTP id t14so17327383ljd.5
        for <linux-raid@vger.kernel.org>; Tue, 14 Mar 2023 13:43:05 -0700 (PDT)
X-Gm-Message-State: AO0yUKXz/k95/qerd6LvaG42+pUbZ/fAQ+ti9boO/3c82HOnPRgJIVVk
        y+zF9vUDUuJe0uNwHK+khN/kTgpgfr5KjY6zQC0=
X-Google-Smtp-Source: AK7set/pR1GvBhoORUih3tIQer/iLPPLFUwVfSnhsSFqctW0D9zLpt+yNrP2IJtaxRQhMp/BGXIHgTXi84v4JeJhu6E=
X-Received: by 2002:a2e:8e29:0:b0:295:a64f:9d50 with SMTP id
 r9-20020a2e8e29000000b00295a64f9d50mr132842ljk.5.1678826583775; Tue, 14 Mar
 2023 13:43:03 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1678136717.git.heinzm@redhat.com> <5be00f6c-22ee-1af3-c5ed-d92863d7f442@linux.dev>
 <CAM23Vxqf-XMdoobeEyyk1MC=PzkWM=5w88jM8R-joxrrT82ukw@mail.gmail.com>
 <777de4f2-1b5d-aded-620d-4c14102a551f@linux.dev> <CAPhsuW403CvtNqALpBMi-SWOaPULybUF3xPSQa7e54+0pm74bA@mail.gmail.com>
 <CAM23Vxpzbt50iyJWQPxDnf51iO1E+cgQJnLFfKCZ3o5Xtro5aQ@mail.gmail.com>
In-Reply-To: <CAM23Vxpzbt50iyJWQPxDnf51iO1E+cgQJnLFfKCZ3o5Xtro5aQ@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 14 Mar 2023 13:42:51 -0700
X-Gmail-Original-Message-ID: <CAPhsuW50UrR7SDkfC=rj=2DrA2nX64vEnHQ7SHVo3aWgJpFPXw@mail.gmail.com>
Message-ID: <CAPhsuW50UrR7SDkfC=rj=2DrA2nX64vEnHQ7SHVo3aWgJpFPXw@mail.gmail.com>
Subject: Re: [PATCH 00/34] address various checkpatch.pl requirements
To:     Heinz Mauelshagen <heinzm@redhat.com>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        linux-raid@vger.kernel.org, ncroxon@redhat.com, xni@redhat.com,
        dkeefe@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Mar 14, 2023 at 11:03=E2=80=AFAM Heinz Mauelshagen <heinzm@redhat.c=
om> wrote:
>
> On Mon, Mar 13, 2023 at 10:21=E2=80=AFPM Song Liu <song@kernel.org> wrote=
:
>>
>> On Tue, Mar 7, 2023 at 5:37=E2=80=AFPM Guoqing Jiang <guoqing.jiang@linu=
x.dev> wrote:
>> >
>> >
>> >
>> > On 3/8/23 01:22, Heinz Mauelshagen wrote:
>> > > As the MD RAID  subsystem is in active maintenance receiving
>> > > functional enhancements still, it is
>> > > hardly old in general,
>> >
>> > I might use the inappropriate word, let's say the 'existing' code.
>> > And I am not against use checkpatch (all the new patches
>> > should be checked by it I believe).
>> >
>> > > profits from coding (style) enhancements and
>> > > adoption of current APIs.
>> >
>> > This kind of patchset can also bring troubles, eg, people works
>> > for downstream kernel need more effort to backport fix patches
>> > due to conflict, I assume stable kernel could be affected as well.
>> >
>> > A more sensible way might be fix coding style issue while the
>> > adjacent code need to be changed because of new feature or bug
>> > etc. Anyway, just my 0.02$.
>>
>> Agreed. These 1032 insertions(+) will make git-blame harder for
>> little benefit in style.
>
>
> If you reject taking style benefits, at least take deprecated function pa=
tch #30 (kmap_local_page/kunmap_local).

Could you please resend this patch alone on top of md-next?

Thanks,
Song
