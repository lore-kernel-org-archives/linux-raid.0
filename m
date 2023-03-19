Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 822EEC7618A
	for <linux-raid@archiver.kernel.org>; Sun, 19 Mar 2023 09:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjCSJNa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Mar 2023 05:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjCSJN1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Mar 2023 05:13:27 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C1321295
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 02:13:24 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-1755e639b65so10248743fac.3
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 02:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vastdata.com; s=google; t=1679217204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HynfHlm6izuEFrLyV6lTh720fjmwhwHHpUVj+4NJSsI=;
        b=CkJSbesfRro4jKheAqnQwdY0Ys+beUtAKl+bUAyHcZQFWdI1JyWs9mVwi5QHmgxXvA
         O/01V25U4Aq+AsMlpkTv1/h00pXMCIKvyo5GFoU69t3Bp7vcxjFpoeKXwoZBhu3mLvBw
         XCW3iXnanZmEDfcMz2TakCI2dBWZwvXDc4+IzYfW8gUszJ3ZC3eFumvmnWxYZ9HZZSrw
         xiHxN3flaetyHsDDeQoZDe/Xwa+12HecpFK7IubnpjxcWpBzkH7jzQ3ei9zfuVAMAB0x
         uutISWIx62b8yIL5RaqhQZXu9wpGRCZBgZjuNjGYp4FpP9jatYXsLOeWv2uCsGJjj83K
         DCRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679217204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HynfHlm6izuEFrLyV6lTh720fjmwhwHHpUVj+4NJSsI=;
        b=J9zth6Z90mLFqeRtmd2OLn4zCHFX1a0Cs2VtyNCURsgzUbiPc/ekF5kB4Az8WcSWnw
         lslK/jqkbDA9xnYUpFyWa6Pd2rz1mxN8rixUqKM2REuqh/F2ly4iQ97rffmPo156hEm0
         NFW6LFBlycdjImYFdmFNYb6TJBI5+7Mg8BU7Or0eU+W9o5lJ8t+OE9T9eC3zQNcAsGEv
         x2TagoMWSgPdbOxMMSlUXOvVU2pe4cIQfk2vxgUWFvNSUnc+yObwuCzvDndD05LHXjit
         5y30JdDO4TNjj3Yaw7fGuQ8bW6a2VcNEzQnOeKo5i3fg//6OWPLickWZHCvGKFDkgiBg
         Drpg==
X-Gm-Message-State: AO0yUKWPOneq0fAK+7namvrs5JlfkOuAj8uXNr7cM7RUmazH/dvmOkPI
        H85caShuVlNPy9zc0f2iV433nViGlc3fdjkItvhFJqCUYCrp3lSA+8U=
X-Google-Smtp-Source: AK7set9GA8YBDMwt9cb7x39JyR0Jr5XvjKcpghptUgfTc97mALbFx40A88dMekiKy4xwp44ELJ16uGbUjKAc4VJFpZw=
X-Received: by 2002:a05:6871:4912:b0:17b:f094:5478 with SMTP id
 tw18-20020a056871491200b0017bf0945478mr1300618oab.2.1679217203738; Sun, 19
 Mar 2023 02:13:23 -0700 (PDT)
MIME-Version: 1.0
References: <CALM_6_s7=eyDWFkirzg6ifqeeeF6-bnZD8n7=3=V+fm_qc34AQ@mail.gmail.com>
 <25620.54403.944889.209021@quad.stoffel.home>
In-Reply-To: <25620.54403.944889.209021@quad.stoffel.home>
From:   Asaf Levy <asaf@vastdata.com>
Date:   Sun, 19 Mar 2023 11:13:12 +0200
Message-ID: <CAHh8SWHbryBgTBz=5KDsmkHEb8MZGw9EAVyLuDg0Uo7pcrBsGw@mail.gmail.com>
Subject: Re: Question about potential data consistency issues when writes
 failed in mdadm raid1
To:     John Stoffel <john@stoffel.org>
Cc:     Ronnie Lazar <ronnie.lazar@vastdata.com>,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi John,

Thank you for your quick response, I'll try to elaborate further.
What we are trying to understand is if there is a potential race
between reads and writes when mirroring 2 devices.
This is unrelated to the fact that the write was not acked.

The scenario is: let's assume we have a reader R and a writer W and 2
MD devices A and B. A and B are managed under a device M which is
configured to use A and B as mirrors (RAID 1). Currently, we have some
data on A and B, let's call it V1.

W issues a write (V2) to the managed device M
The driver sends the write both to A and B at the same time.
The write to device A (V2) completes
R issues a read to M which directs it to A and returns the result (V2).
Now the driver and device A fail at the same time before the write
ever gets to device B.

When the driver recovers all it is left with is device B so future
reads will return older data (V1) than the data that was returned to
R.

Thanks,
Asaf

On Fri, Mar 17, 2023 at 10:58=E2=80=AFPM John Stoffel <john@stoffel.org> wr=
ote:
>
> >>>>> "Ronnie" =3D=3D Ronnie Lazar <ronnie.lazar@vastdata.com> writes:
>
> > I'm trying to understand how mdadm protects against inconsistent data
> > read in the face of failures that occur while writing to a device that
> > has raid1.
>
> You need to give a better test case, with examples.
>
> > Here is the scenario: I have set up raid1 that has 2 mirrors. First
> > one is on local storage and the second is on remote storage.  The
> > remote storage mirror is configured with write-mostly.
>
> Configuration details?  And what is the remote device?
>
> > We have parallel jobs: 1 writing to an area on the device and the
> > other reading from that area.
>
> So you create /dev/md9 and are writing/reading from it, then the
> system crashes and you lose the local half of the mirror, right?
>
> > The write operation writes the data to the first mirror, and at that
> > point the read operation reads the new data from the first mirror.
>
> So how is your write succeeding if it's not written to both halves of
> the MD device?  You need to give more details and maybe even some
> example code showing what you're doing here.
>
> > Now, before data has been written to the second (remote) mirror a
> > failure has occurred which caused the first machine to fail, When
> > the machine comes up, the data is recovered from the second, remote,
> > mirror.
>
> Ah... some more details.  It sounds like you have a system A which is
> writing to a SITE local remote device as well as a REMOTE site device
> in the MD mirror, is this correct?
>
> Are these iSCSI devices?  FibreChannel?  NBD devices?  More details
> please.
>
> > Now when reading from this area, the users will receive the older
> > value, even though, in the first read they got the newer value that
> > was written.
>
> > Does mdadm protect against this inconsistency?
>
> It shouldn't be returning success on the write until both sides of the
> mirror are updated.  But we can't really tell until you give more
> details and an example.
>
> I assume you're not building a RAID1 device and then writing to the
> individual devices behind it's back or something silly like that,
> right?
>
> John
>
