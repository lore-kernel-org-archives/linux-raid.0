Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48C3EC4743D
	for <linux-raid@archiver.kernel.org>; Wed,  9 Jun 2021 02:41:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D7C76023D
	for <linux-raid@archiver.kernel.org>; Wed,  9 Jun 2021 02:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235395AbhFICn2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Jun 2021 22:43:28 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:36598 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbhFICn2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Jun 2021 22:43:28 -0400
Received: by mail-pj1-f51.google.com with SMTP id d5-20020a17090ab305b02901675357c371so518254pjr.1;
        Tue, 08 Jun 2021 19:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=OJBnSZyyN/TSkxF4mL7VTmvijhvvcetVLxVOTBkXuFw=;
        b=irTROfY8vBMeABz5qvVQPRPtz9hpBfdenrmVDOo613z9qBTUNRidLXPusVUEumKDve
         oHXhTu1vNW4IFlN0QA/NuUwvapl2Rl0Hi7qgTd/duoEa0A1vNSIATLvdYZHNg8A5U40J
         /jfpMYC2R7H7lFhorfmYaADR1fGp1eVPnpwa/EsjD0lvzw4Zz7ldYe+XpOo96toASqBj
         Xk3NGtNIQZhJ5wUbS6Ab+YM8Xe0dVJzLrfW8PerSdPHgMyWjpSCskrTLbeGDLO/Fu/lM
         Dj+6m4L4AQIkGtbx+a8REH0uE/w9Lfz1LOj5aZb/67z8AvV8ZIFCi6zgDyohuzJNyEpk
         v0MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=OJBnSZyyN/TSkxF4mL7VTmvijhvvcetVLxVOTBkXuFw=;
        b=CYF31ANPHXgd52b7pJAlcqD9urCzHqxSdJrn+ftB6h7zdUY9F5RJb2TRj4h200/KT+
         rD3dmURLCSCS9tvc/CvvrvPDtfD026gcS2gwZ9+DyP+oV7ue6XogGqN2LHSwA3lD6bTV
         PAyrHnABpUw5xJ34xkL4YknkEAhsY5p8QJx2M+wrWEF/mE04eRsdYDGZVdjcszdTDYNX
         zDzNSaCPlybcxC/yNcyKuYkMqRgOBVIpj3q9gEeajcMwxP0kYNU4HzGkvTwiFlPC5x8v
         2Qodv2iLf3j1MYu3PyxohKopl/mHrj0hTqM1OK0oCikk+8AYyJ52O7xlMDjiVuB+tWZg
         2eQQ==
X-Gm-Message-State: AOAM532c0ujziVM18Wpfe4pJ23F5k19lJk0lu46y6Vg68sjtgGKPdXRE
        IFohDv02ORMUNE5DgyR/fBA=
X-Google-Smtp-Source: ABdhPJyqymsv3JZ+XoEL7RK+Ex6Sknom2ovU6f8KGlJklEntXaO8P0YqxDQjna7rNDNPXKLPcRCAiA==
X-Received: by 2002:a17:90a:8b0d:: with SMTP id y13mr9772120pjn.88.1623206434039;
        Tue, 08 Jun 2021 19:40:34 -0700 (PDT)
Received: from [10.7.3.1] ([133.130.111.179])
        by smtp.gmail.com with ESMTPSA id fs10sm3469217pjb.31.2021.06.08.19.40.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jun 2021 19:40:33 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.6\))
Subject: Re: [Bug Report] Discard bios cannot be correctly merged in blk-mq
From:   Wang Shanker <shankerwangmiao@gmail.com>
In-Reply-To: <YMAOO3XjOUl2IG+4@T590>
Date:   Wed, 9 Jun 2021 10:40:27 +0800
Cc:     linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        Xiao Ni <xni@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1C6DB607-B7BE-4257-8384-427BB490C9C0@gmail.com>
References: <85F98DA6-FB28-4C1F-A47D-C410A7C22A3D@gmail.com>
 <YL4Z/QJCKc0NCV5L@T590> <C866C380-7A71-4722-957F-2CE65BDACF26@gmail.com>
 <YMAOO3XjOUl2IG+4@T590>
To:     Ming Lei <ming.lei@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.6)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


> 2021=E5=B9=B406=E6=9C=8809=E6=97=A5 08:41=EF=BC=8CMing Lei =
<ming.lei@redhat.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Tue, Jun 08, 2021 at 11:49:04PM +0800, Wang Shanker wrote:
>>=20
>>=20
>> Actually, what are received by the nvme controller are discard =
requests
>> with 128 segments of 4k, instead of one segment of 512k.
>=20
> Right, I am just wondering if this way makes a difference wrt. single
> range/segment discard request from device viewpoint, but anyway it is
> better to send less segment.
It would be meaningful if more than queue_max_discard_segments() bio's
are sent and merged into big segments.=20
>=20
>>=20
>>>=20
>>>>=20
>>>> Similarly, the problem with scsi devices can be emulated using the =
following=20
>>>> options for qemu:
>>>>=20
>>>>       -device virtio-scsi,id=3Dscsi \
>>>>       -device =
scsi-hd,drive=3Dnvme1,bus=3Dscsi.0,logical_block_size=3D4096,discard_granu=
larity=3D2097152,physical_block_size=3D4096,serial=3DNVME1 \
>>>>       -device =
scsi-hd,drive=3Dnvme2,bus=3Dscsi.0,logical_block_size=3D4096,discard_granu=
larity=3D2097152,physical_block_size=3D4096,serial=3DNVME2 \
>>>>       -device =
scsi-hd,drive=3Dnvme3,bus=3Dscsi.0,logical_block_size=3D4096,discard_granu=
larity=3D2097152,physical_block_size=3D4096,serial=3DNVME3 \
>>>>       -trace scsi_disk_emulate_command_UNMAP,file=3Dscsitrace.log
>>>>=20
>>>>=20
>>>> Despite the discovery, I cannot come up with a proper fix of this =
issue due
>>>> to my lack of familiarity of the block subsystem. I expect your =
kind feedback
>>>> on this. Thanks in advance.
>>>=20
>>> In the above setting and raid456 test, I observe that =
rq->nr_phys_segments can
>>> reach 128, but queue_max_discard_segments() reports 256. So discard
>>> request size can be 512KB, which is the max size when you run 1MB =
discard on
>>> raid456. However, if the discard length on raid456 is increased, the
>>> current way will become inefficient.
>>=20
>> Exactly.=20
>>=20
>> I suggest that bio's can be merged and be calculated as one segment =
if they are
>> contiguous and contain no data.
>=20
> Fine.
>=20
>>=20
>> And I also discovered later that, even normal long write requests, =
e.g.
>> a 10m write, will be split into 4k bio's. The maximum number of bio's =
which can=20
>> be merged into one request is limited by queue_max_segments, =
regardless
>> of whether those bio's are contiguous. In my test environment, for =
scsi devices,
>> queue_max_segments can be 254, which means about 1m size of requests. =
For nvme
>> devices(e.g. Intel DC P4610), queue_max_segments is only 33 since =
their mdts is 5,
>> which results in only 132k of requests.=20
>=20
> Here what matters is queue_max_discard_segments().
Here I was considering normal write/read bio's, since I first took it =
for granted
that normal write/read IOs would be optimal in raid456, and finally =
discovered
that those 4k IOs can only be merged into not-so-big requests.
>=20
>>=20
>> So, I would also suggest that raid456 should be improved to issue =
bigger bio's to
>> underlying drives.
>=20
> Right, that should be root solution.
>=20
> Cc Xiao, I remembered that he worked on this area.

Many thanks for looking into this issue.

Cheers,

Miao Wang=
