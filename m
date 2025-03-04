Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F811F4CAD
	for <linux-raid@vger.kernel.org>; Tue,  4 Mar 2025 09:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741080996; cv=none; b=okDmbvMKMMupbwaimi07Bm4CS7fDIk6uW7eTgithpzjlBwUSJ1p0nSfenbns2wDERXquyQQVxaVQfdA0WAVauCK00Ic/6MCZ1b6sm3qu4pUxOy0qtQUrtEIATRyNWyjYkQjGVTQOfQXpqT2qbxVkDhPIXKbz3EHHanOuEKwQhRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741080996; c=relaxed/simple;
	bh=XYMv+JLtHyfh/XIkbjGVaat3eYoz6ufRvAz/ebFp25k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fR5STmQGG1kZaWt4hwq/JAFGbglxhxu+vyo/wzOXHWgp7XzXkTVNIPIspaKtQ0ZVgGifXIZijgylVpfSfh0oZsOEEBD07MU0ArLv34uDqLJwJ9OSn8SGsWa5UFwxzdBECZ9EuKQ6ANzUiFG6VZ/vNieG72ce4qcBPKPdqtfcflk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gwz+n2ND; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gwz+n2ND"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741080993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h7XzQKBO7VWeu0SLMfQ8s8nXUB3W9fakhUJySnCGt58=;
	b=Gwz+n2NDAFxnd2tvJQ5lpPkO4LnCSUMmCjs4C73P2naeZIdFu4LVHylcfBOetdlYa9TXq3
	CTtAZB9mxAcWOKJn9zSWHq5Z9BfZ66OdtXZjPwVGM27lLYH5esrNekEMnx8vHn5n8HaB+B
	dx69Bz8meNTf0izoeP4gyHHijoQaDYk=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-BETYMsI1P2WfGpat_1FLVw-1; Tue, 04 Mar 2025 04:36:26 -0500
X-MC-Unique: BETYMsI1P2WfGpat_1FLVw-1
X-Mimecast-MFC-AGG-ID: BETYMsI1P2WfGpat_1FLVw_1741080985
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-549576121f0so1659257e87.2
        for <linux-raid@vger.kernel.org>; Tue, 04 Mar 2025 01:36:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741080985; x=1741685785;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h7XzQKBO7VWeu0SLMfQ8s8nXUB3W9fakhUJySnCGt58=;
        b=qLLXYhkYPtYLpfzR7zQ/bBc2HjiLKNi5Tspe/YJh4OMt60NwkoRlYFZaY8t8d312ns
         Q81BrqjC+q20EA9o+pWSlgBAxYSXzbp8zhah4O9E4nueyowPvlTdrvA7Wn0bCE/KLAXH
         A40gtfUdtWyqMS8fH91nLwqSGv5N1Bf91jNhIOKSm1P8VMwZjYOHZdgkfpisThFLmkO8
         zD6b1uVcRlLvO+mS5VtTx4h1PdcrMbKVukdrt+CX5vLKny/6PYQ3QWyB2c5ciOdBhIQE
         5MLsQ+RDRm4p4cBKoXZ9UgXKONlL4yEfJjz1ewAS9v7yAPu9QCmhNuonDPqQRFMlcAx8
         z07g==
X-Forwarded-Encrypted: i=1; AJvYcCVoFu0T+05SuUNKI6REGcfxsrdZ+KAwn+TRY0kBDIQq/B9FLyt/W8x5i3+MAmycBLMMWmlWV1K55OcB@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/r3w3LGyMtgjXRHKfFkHlWHqT3sCxankFcrLIxp3JKN7u7c2P
	o/coYhUgnghwfAe534MxffjYwnHvYuKAQX16uVIV0HffCebGVWiRqtVpqnhJUZpO9+Fi+OIcFq7
	izCo3iaCofq0nc2YejwMmYSyCZpKP/0tajTjQfsEEM3BAgppU2PytF8S1Rb0FoXkeXvMcrWwTyb
	QHtXxCzSYvmx9n59MDuQHzzpgQ7WiQsrnoig==
X-Gm-Gg: ASbGncuS1dW3USiKU1HwmpH+V3Qw2TaUllXnwhRpqwtU9Dm5gIAYnvdmbQacxE8ZhpT
	BMyboJaOlJisR+kfXgqD3RUMZ6uZxfugW604oUk3o7PvNZLGIMDihMN66mh2vM2AesvROw+DMmg
	==
X-Received: by 2002:a05:6512:e8a:b0:549:7590:ff24 with SMTP id 2adb3069b0e04-549759100a5mr896173e87.22.1741080985187;
        Tue, 04 Mar 2025 01:36:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGxgejBrB8qds8qLbaK/pbCdCNZHrxbNW9loOZnpdg40LTNctMLfQZv30FbmcJ05JSwXyXbWbmHt6BQrcpT6dU=
X-Received: by 2002:a05:6512:e8a:b0:549:7590:ff24 with SMTP id
 2adb3069b0e04-549759100a5mr896165e87.22.1741080984807; Tue, 04 Mar 2025
 01:36:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250304090950.18337-1-xni@redhat.com> <05a09a19-a37c-4da0-b773-745ce75b2444@molgen.mpg.de>
In-Reply-To: <05a09a19-a37c-4da0-b773-745ce75b2444@molgen.mpg.de>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 4 Mar 2025 17:36:13 +0800
X-Gm-Features: AQ5f1Jq5OypN-wBTL8cEB-wA-L4Yvjg6vvj8bFBYeWEYzbCtUH4oHBG00qJyPNQ
Message-ID: <CALTww28J+g4sH92i8_ju_MFDxkCocdDP7psmps1x9q5vuqaYyQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] md/raid10: Don't print warn calltrace for discard
 with REQ_NOWAIT
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: yukuai1@huaweicloud.com, song@kernel.org, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 4, 2025 at 5:14=E2=80=AFPM Paul Menzel <pmenzel@molgen.mpg.de> =
wrote:
>
> Dear Xiao,
>
>
> Thank you for your patch.
>
>
> Am 04.03.25 um 10:09 schrieb Xiao Ni:
> > There is no need to print warn call trace. And it also can confuse
>
> Why is there no need?

Hi Paul

I use raid1 as a reference, there is no warning there. And why is
there need to give warning message?

>
> > qe and mark test case failure.
>
> What is *qe*?

quality engineering team. They check the result and report error if
the dmesg has calltrace(warning/error)

Regards
Xiao

>
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   drivers/md/raid10.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > index 15b9ae5bf84d..0441691130c7 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -1631,7 +1631,7 @@ static int raid10_handle_discard(struct mddev *md=
dev, struct bio *bio)
> >       if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
> >               return -EAGAIN;
> >
> > -     if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT)) {
> > +     if (bio->bi_opf & REQ_NOWAIT) {
> >               bio_wouldblock_error(bio);
> >               return 0;
> >       }
>
>
> Kind regards,
>
> Paul
>

