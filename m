Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC03C6FD1F
	for <linux-raid@archiver.kernel.org>; Sun, 19 Mar 2023 14:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjCSOen (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Mar 2023 10:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjCSOel (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Mar 2023 10:34:41 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03097DB6
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 07:34:39 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id bp22so310479oib.6
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 07:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vastdata.com; s=google; t=1679236479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GirUUxQOPPxnU7Cs9/BvDg4VtDV++YTTuxckXbwaeAw=;
        b=NG87OEHgj6TftrlSU6kU1qKPhfVAHpwbKwSIFyTZgU3M9x64kV/VFeqRGa6e6Iq50v
         jKjz71jwTjIuQA7s7/RbzAOpzyTTXkPui+teyyMMLr7MlSnpOKA0MP8kDvmW0uL7ylnV
         5JRhY69sXOKrsvfNtxWRX7IKINiGaMHMFAjZbAg6mjFrP4dVx+Rbyv81VyP+IDS+dqo7
         5i8PWG11wY6oq3/qr/PaMxfonIIGZj1erohRWC+ZLJb6vGXXTxx/dtHDGZPyKgcCJHeD
         OeL9YBvcCC0FMZi2uRz9RRLSvi6NCt0N/fZrwaMt1o7tkK47tPJGDSj1bFKDpe4Tn6Oc
         WAwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679236479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GirUUxQOPPxnU7Cs9/BvDg4VtDV++YTTuxckXbwaeAw=;
        b=Xmy/ge4H4JpR0hBFsItHSPWtqz169/LKRnDD+x08e4GcLoy3GbdK/kLokSZLfrRnXz
         hjUbbCkfIREtgrfNk305MczLOedZCk7xdTto94JhJ4M4Qf7hkM4tvzcs7r+PNeKZUk2/
         JD5J3YCoFDHdwVe5NZElchzrVGKte5HngAAKQZ5uxrKoHymysAwPr25S/bB08ZImYLPj
         T3erBTqSH9Yo/vkWWas1ncYagPeOslnPuBzylpaGz09Cq4gV3IsO/6foXkNux3RTPGCD
         wIhMyU2Vt9IO27bzyEIRXeKWBON7MVYf4bKFvFvqmrEg59QKbTJ1IWckqCp9KYp6GAYo
         3xpw==
X-Gm-Message-State: AO0yUKXmandC1Xc0Whihfjmcr2LAA407JSLRSLVqUh6BTesVqL+Fl6Jk
        ntmjo32G+G92WuMmXZxUB3Fk3IR5RXTaqyyUBa06dZ3EVBNp6PMa
X-Google-Smtp-Source: AK7set+/zzcC5+SNDETAao0Hg0nZMXHw5EagI4k5utH1yS7aSmG2jIlKwTvBlchDk5KLTv56QZ5LD8rINBWCZA7/g0Q=
X-Received: by 2002:aca:f09:0:b0:384:1832:233b with SMTP id
 9-20020aca0f09000000b003841832233bmr4952810oip.2.1679236478535; Sun, 19 Mar
 2023 07:34:38 -0700 (PDT)
MIME-Version: 1.0
References: <CALM_6_s7=eyDWFkirzg6ifqeeeF6-bnZD8n7=3=V+fm_qc34AQ@mail.gmail.com>
 <25620.54403.944889.209021@quad.stoffel.home> <CAHh8SWHbryBgTBz=5KDsmkHEb8MZGw9EAVyLuDg0Uo7pcrBsGw@mail.gmail.com>
 <c0e76e25-8f5a-af1d-cb47-e772ec458176@demonlair.co.uk> <CAHh8SWFzXx4f-vzOsuPVZAaNMH_RKufHB99B=vMFYZc+s9=msg@mail.gmail.com>
 <c9a0489a-32a7-1fa2-cca5-3c2f03106593@demonlair.co.uk>
In-Reply-To: <c9a0489a-32a7-1fa2-cca5-3c2f03106593@demonlair.co.uk>
From:   Asaf Levy <asaf@vastdata.com>
Date:   Sun, 19 Mar 2023 16:34:27 +0200
Message-ID: <CAHh8SWEaROSqU_O6mckVoisviZepqkBheK5wurmqve5GJrRfcw@mail.gmail.com>
Subject: Re: Question about potential data consistency issues when writes
 failed in mdadm raid1
To:     Geoff Back <geoff@demonlair.co.uk>
Cc:     John Stoffel <john@stoffel.org>,
        Ronnie Lazar <ronnie.lazar@vastdata.com>,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I understand.
As you said I meant consistent under the definition that data must
never go back in time regardless of the failure type.

Thanks,
Asaf

On Sun, Mar 19, 2023 at 2:45=E2=80=AFPM Geoff Back <geoff@demonlair.co.uk> =
wrote:
>
> Hi Asaf,
>
> All disk subsystems are inherently consistent in the normal meaning of
> the term under normal circumstances.
>
> An application that requires your specific definition of consistency
> across catastrophic failure cases in the disk subsystem needs to use an
> application-appropriate method of ensuring writes are flushed before
> reading.  Writing with O_DIRECT is one method and depending on the
> application's exact requirements may be sufficient on its own.  In other
> application domains, flushing and some form of out-of-band signalling or
> locking is better.  It really depends on the application.
>
> Regards,
>
> Geoff.
>
> Geoff Back
> What if we're all just characters in someone's nightmares?
>
> On 19/03/2023 11:31, Asaf Levy wrote:
> > Thank you for the clarification.
> >
> > To make sure I fully understand.
> > An application that requires consistency should use O_DIRECT and
> > enforce an R/W lock on top of the mirrored device?
> >
> > Asaf
> >
> > On Sun, Mar 19, 2023 at 11:55=E2=80=AFAM Geoff Back <geoff@demonlair.co=
.uk> wrote:
> >> Hi Asaf,
> >>
> >> Yes, in principle there are all sorts of cases where you can perform a
> >> read of newly written data that is not yet on the underlying disk and
> >> hence the possibility of reading the old data following recovery from =
an
> >> intervening catastrophic event (such as a crash).  This is a fundament=
al
> >> characteristic of write caching and applies with any storage device an=
d
> >> any write operation where something crashes before the write is comple=
te
> >> - you can get this with a single disk or SSD without having RAID in th=
e
> >> mix at all.
> >>
> >> The correct and only way to guarantee that you can never have your
> >> "consistency issue" is to flush the write through to the underlying
> >> devices before reading.  If you explicitly flush the write operation
> >> (which will block until all writes are complete on A, B, M) and the
> >> flush completes successfully, then all reads will be of the new data a=
nd
> >> there is no consistency issue.
> >>
> >> Your scenario describes a concern for the higher level code, not in th=
e
> >> storage system.  If your application needs to be absolutely certain th=
at
> >> even after a crash you cannot end up reading old data having previousl=
y
> >> read new data then it is the responsibility of the application to flus=
h
> >> the writes to the storage before executing the read.  You would also
> >> need to ensure that the application cannot read from the data between
> >> write and flush; there's several different ways to achieve that
> >> (O_DIRECT may be helpful).  Alternatively, you might want to look at
> >> using something other than the disk for your data interchange between
> >> processes.
> >>
> >> Regards,
> >>
> >> Geoff.
> >>
> >> Geoff Back
> >> What if we're all just characters in someone's nightmares?
> >>
> >> On 19/03/2023 09:13, Asaf Levy wrote:
> >>> Hi John,
> >>>
> >>> Thank you for your quick response, I'll try to elaborate further.
> >>> What we are trying to understand is if there is a potential race
> >>> between reads and writes when mirroring 2 devices.
> >>> This is unrelated to the fact that the write was not acked.
> >>>
> >>> The scenario is: let's assume we have a reader R and a writer W and 2
> >>> MD devices A and B. A and B are managed under a device M which is
> >>> configured to use A and B as mirrors (RAID 1). Currently, we have som=
e
> >>> data on A and B, let's call it V1.
> >>>
> >>> W issues a write (V2) to the managed device M
> >>> The driver sends the write both to A and B at the same time.
> >>> The write to device A (V2) completes
> >>> R issues a read to M which directs it to A and returns the result (V2=
).
> >>> Now the driver and device A fail at the same time before the write
> >>> ever gets to device B.
> >>>
> >>> When the driver recovers all it is left with is device B so future
> >>> reads will return older data (V1) than the data that was returned to
> >>> R.
> >>>
> >>> Thanks,
> >>> Asaf
> >>>
> >>> On Fri, Mar 17, 2023 at 10:58=E2=80=AFPM John Stoffel <john@stoffel.o=
rg> wrote:
> >>>>>>>>> "Ronnie" =3D=3D Ronnie Lazar <ronnie.lazar@vastdata.com> writes=
:
> >>>>> I'm trying to understand how mdadm protects against inconsistent da=
ta
> >>>>> read in the face of failures that occur while writing to a device t=
hat
> >>>>> has raid1.
> >>>> You need to give a better test case, with examples.
> >>>>
> >>>>> Here is the scenario: I have set up raid1 that has 2 mirrors. First
> >>>>> one is on local storage and the second is on remote storage.  The
> >>>>> remote storage mirror is configured with write-mostly.
> >>>> Configuration details?  And what is the remote device?
> >>>>
> >>>>> We have parallel jobs: 1 writing to an area on the device and the
> >>>>> other reading from that area.
> >>>> So you create /dev/md9 and are writing/reading from it, then the
> >>>> system crashes and you lose the local half of the mirror, right?
> >>>>
> >>>>> The write operation writes the data to the first mirror, and at tha=
t
> >>>>> point the read operation reads the new data from the first mirror.
> >>>> So how is your write succeeding if it's not written to both halves o=
f
> >>>> the MD device?  You need to give more details and maybe even some
> >>>> example code showing what you're doing here.
> >>>>
> >>>>> Now, before data has been written to the second (remote) mirror a
> >>>>> failure has occurred which caused the first machine to fail, When
> >>>>> the machine comes up, the data is recovered from the second, remote=
,
> >>>>> mirror.
> >>>> Ah... some more details.  It sounds like you have a system A which i=
s
> >>>> writing to a SITE local remote device as well as a REMOTE site devic=
e
> >>>> in the MD mirror, is this correct?
> >>>>
> >>>> Are these iSCSI devices?  FibreChannel?  NBD devices?  More details
> >>>> please.
> >>>>
> >>>>> Now when reading from this area, the users will receive the older
> >>>>> value, even though, in the first read they got the newer value that
> >>>>> was written.
> >>>>> Does mdadm protect against this inconsistency?
> >>>> It shouldn't be returning success on the write until both sides of t=
he
> >>>> mirror are updated.  But we can't really tell until you give more
> >>>> details and an example.
> >>>>
> >>>> I assume you're not building a RAID1 device and then writing to the
> >>>> individual devices behind it's back or something silly like that,
> >>>> right?
> >>>>
> >>>> John
> >>>>
>
