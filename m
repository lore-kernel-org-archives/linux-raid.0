Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 424CCC6FD1F
	for <linux-raid@archiver.kernel.org>; Sun, 19 Mar 2023 11:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjCSLbe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Mar 2023 07:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCSLbb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Mar 2023 07:31:31 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60E3CA25
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 04:31:29 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-177b78067ffso10389755fac.7
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 04:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vastdata.com; s=google; t=1679225488;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iVERC9NOSzYckJa3BllpVUDL7mAthLCUO3p39a5S1Js=;
        b=BOC3XxmW2mq1VUUBFE2lHk8wQn3u7/WMLcO3ORlH1lgDifnmbuA135FPKOmaeCZsc5
         NmFLMaifm3jUVR4Wj2uIWBCItQ1vFmQXml448+2K8EJ3SEtlsQIM/qym8W2F/1IEBE87
         MkYpxzzGiyUeEvi9xnTM1Brt7is9b4/iMbqmRHAr+W2Za2ZjG4+BCVdenkMFwNW8SXaf
         nP+SgIkJG7coGGhyredRTcmLFrMgoD/q3x3kTjE+RBI0BWjCUWn5tQyTQH0Itqa8Szj7
         hr7Nr31AfiCXvr13vEXaNQHcPraxsyLzxS/OaWcyob5jhEO8k8QQbFguyMywooMzuUtk
         i+rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679225488;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iVERC9NOSzYckJa3BllpVUDL7mAthLCUO3p39a5S1Js=;
        b=Kxq7L81+8qdK1eNJqEUg1qFUJ0CR6ZPvIoREqFFJn3d0DcrsMwhCCevWHMm25OdJxX
         kZs2W6dHik7rPmfFYvgsfXVfSQUdMaBmomsj7SEo9VoV+s7Nr4DCPnhac5r6SkeNFAbe
         8yhCLzsQrLY2E8NqmsY9GAR7PGAegGUzLYBTw4j0g8+kYAyc2juEePncaOmuATVlPnqr
         +AkrkfpRIn1CDkGji0Dn8a2xl70L1Y8i0ISeOvkd/2tFLWm1WkdYJCvAQu5MkFC1EtJg
         WHAzZ9mUhmD+rSdCZewfHqWqIdbwx2dX2GEyeuIQtdWCVBAMIPLxjDlJiJNO82Y48UPj
         VCpw==
X-Gm-Message-State: AO0yUKUHROn72JhAshch68K/JQt8U6oC3JAoXk16MsWobDzT7QS4fJxp
        aNIL9VpUz/omISLBuRgBzIu4PnJNJJ0ISRx27Z72cA==
X-Google-Smtp-Source: AK7set9CKKqFdo5VvvDLxRXcfi2G3r1u/wixoe1UQ4ux5bjEQTsSTfPc4bw1d8Sof89l7Xwcvvej+uvY5hQ4v1PmfP8=
X-Received: by 2002:a05:6871:4091:b0:16e:8993:9d7c with SMTP id
 kz17-20020a056871409100b0016e89939d7cmr1653827oab.1.1679225488299; Sun, 19
 Mar 2023 04:31:28 -0700 (PDT)
MIME-Version: 1.0
References: <CALM_6_s7=eyDWFkirzg6ifqeeeF6-bnZD8n7=3=V+fm_qc34AQ@mail.gmail.com>
 <25620.54403.944889.209021@quad.stoffel.home> <CAHh8SWHbryBgTBz=5KDsmkHEb8MZGw9EAVyLuDg0Uo7pcrBsGw@mail.gmail.com>
 <c0e76e25-8f5a-af1d-cb47-e772ec458176@demonlair.co.uk>
In-Reply-To: <c0e76e25-8f5a-af1d-cb47-e772ec458176@demonlair.co.uk>
From:   Asaf Levy <asaf@vastdata.com>
Date:   Sun, 19 Mar 2023 13:31:17 +0200
Message-ID: <CAHh8SWFzXx4f-vzOsuPVZAaNMH_RKufHB99B=vMFYZc+s9=msg@mail.gmail.com>
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

Thank you for the clarification.

To make sure I fully understand.
An application that requires consistency should use O_DIRECT and
enforce an R/W lock on top of the mirrored device?

Asaf

On Sun, Mar 19, 2023 at 11:55=E2=80=AFAM Geoff Back <geoff@demonlair.co.uk>=
 wrote:
>
> Hi Asaf,
>
> Yes, in principle there are all sorts of cases where you can perform a
> read of newly written data that is not yet on the underlying disk and
> hence the possibility of reading the old data following recovery from an
> intervening catastrophic event (such as a crash).  This is a fundamental
> characteristic of write caching and applies with any storage device and
> any write operation where something crashes before the write is complete
> - you can get this with a single disk or SSD without having RAID in the
> mix at all.
>
> The correct and only way to guarantee that you can never have your
> "consistency issue" is to flush the write through to the underlying
> devices before reading.  If you explicitly flush the write operation
> (which will block until all writes are complete on A, B, M) and the
> flush completes successfully, then all reads will be of the new data and
> there is no consistency issue.
>
> Your scenario describes a concern for the higher level code, not in the
> storage system.  If your application needs to be absolutely certain that
> even after a crash you cannot end up reading old data having previously
> read new data then it is the responsibility of the application to flush
> the writes to the storage before executing the read.  You would also
> need to ensure that the application cannot read from the data between
> write and flush; there's several different ways to achieve that
> (O_DIRECT may be helpful).  Alternatively, you might want to look at
> using something other than the disk for your data interchange between
> processes.
>
> Regards,
>
> Geoff.
>
> Geoff Back
> What if we're all just characters in someone's nightmares?
>
> On 19/03/2023 09:13, Asaf Levy wrote:
> > Hi John,
> >
> > Thank you for your quick response, I'll try to elaborate further.
> > What we are trying to understand is if there is a potential race
> > between reads and writes when mirroring 2 devices.
> > This is unrelated to the fact that the write was not acked.
> >
> > The scenario is: let's assume we have a reader R and a writer W and 2
> > MD devices A and B. A and B are managed under a device M which is
> > configured to use A and B as mirrors (RAID 1). Currently, we have some
> > data on A and B, let's call it V1.
> >
> > W issues a write (V2) to the managed device M
> > The driver sends the write both to A and B at the same time.
> > The write to device A (V2) completes
> > R issues a read to M which directs it to A and returns the result (V2).
> > Now the driver and device A fail at the same time before the write
> > ever gets to device B.
> >
> > When the driver recovers all it is left with is device B so future
> > reads will return older data (V1) than the data that was returned to
> > R.
> >
> > Thanks,
> > Asaf
> >
> > On Fri, Mar 17, 2023 at 10:58=E2=80=AFPM John Stoffel <john@stoffel.org=
> wrote:
> >>>>>>> "Ronnie" =3D=3D Ronnie Lazar <ronnie.lazar@vastdata.com> writes:
> >>> I'm trying to understand how mdadm protects against inconsistent data
> >>> read in the face of failures that occur while writing to a device tha=
t
> >>> has raid1.
> >> You need to give a better test case, with examples.
> >>
> >>> Here is the scenario: I have set up raid1 that has 2 mirrors. First
> >>> one is on local storage and the second is on remote storage.  The
> >>> remote storage mirror is configured with write-mostly.
> >> Configuration details?  And what is the remote device?
> >>
> >>> We have parallel jobs: 1 writing to an area on the device and the
> >>> other reading from that area.
> >> So you create /dev/md9 and are writing/reading from it, then the
> >> system crashes and you lose the local half of the mirror, right?
> >>
> >>> The write operation writes the data to the first mirror, and at that
> >>> point the read operation reads the new data from the first mirror.
> >> So how is your write succeeding if it's not written to both halves of
> >> the MD device?  You need to give more details and maybe even some
> >> example code showing what you're doing here.
> >>
> >>> Now, before data has been written to the second (remote) mirror a
> >>> failure has occurred which caused the first machine to fail, When
> >>> the machine comes up, the data is recovered from the second, remote,
> >>> mirror.
> >> Ah... some more details.  It sounds like you have a system A which is
> >> writing to a SITE local remote device as well as a REMOTE site device
> >> in the MD mirror, is this correct?
> >>
> >> Are these iSCSI devices?  FibreChannel?  NBD devices?  More details
> >> please.
> >>
> >>> Now when reading from this area, the users will receive the older
> >>> value, even though, in the first read they got the newer value that
> >>> was written.
> >>> Does mdadm protect against this inconsistency?
> >> It shouldn't be returning success on the write until both sides of the
> >> mirror are updated.  But we can't really tell until you give more
> >> details and an example.
> >>
> >> I assume you're not building a RAID1 device and then writing to the
> >> individual devices behind it's back or something silly like that,
> >> right?
> >>
> >> John
> >>
>
