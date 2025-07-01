Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D467195808
	for <linux-raid@vger.kernel.org>; Tue,  1 Jul 2025 01:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751334971; cv=none; b=mifob+EnBE0ErUNZJ2PaKIpi9zbGhCroL7fNKXFq+06hdnxffGw5s8IObVBf26hiXm2Bl3bUYbSRfgzDbry/hg4lVlmJklTUBoTzU6JTUe8Yl3VfypAcjLNftW1Om9EQvp59OHKgpRdEL9/6BAnGkeSmkkXl2ArnZagKBxtaimk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751334971; c=relaxed/simple;
	bh=BKCjC1wcxq+ruQYP0HnjaqNKa6+Bww9fcMDo319KwuU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QB17yfnGfsguF7Tu9AjQ0ce6INrCZpITS/9ErFs/+OAjNN4PiZ5p2OH5olSX8CU2uEM/LHXX6eZ2sHSmk4UAcECbGo6y0Et3uJ3HUe5QDmrsDCi210J5jYJ629LDASy80oJg8zyq6YPXVRos9TSG8oCIIIm2LE/kBbdu+lg2zMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iu0OyqS8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iu0OyqS8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751334969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BKCjC1wcxq+ruQYP0HnjaqNKa6+Bww9fcMDo319KwuU=;
	b=iu0OyqS84uprAolKPN8OnhidZS+ix5rUyRwVkS1h8rgDTLFnUejESuL21ByNlbMi3q6tMx
	WAbU/wNz9W8sbSiC5vVuU8VBdEAjAjz9izI0wRqDNn5ntGcxjPjBMIi+E3G4WAOH6d8VCT
	UJmliubEkNwNEKzQCILiuhvniA2RF3M=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-4ZwSpKZcMaa-6YXxMoaWAg-1; Mon, 30 Jun 2025 21:56:07 -0400
X-MC-Unique: 4ZwSpKZcMaa-6YXxMoaWAg-1
X-Mimecast-MFC-AGG-ID: 4ZwSpKZcMaa-6YXxMoaWAg_1751334966
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5561bcb924bso927893e87.0
        for <linux-raid@vger.kernel.org>; Mon, 30 Jun 2025 18:56:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751334965; x=1751939765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BKCjC1wcxq+ruQYP0HnjaqNKa6+Bww9fcMDo319KwuU=;
        b=fwAyBxvVP+zLwX7SWGiF6DEYYzEuCcOgm4Krex+RvuJEAKh5Cn2Vs7ltkzUf0dC7EA
         B+aKzbnroSFzrD02hb0ifRf6Xbwhgxa2EeYPtnjn1aSB9rmOBPdcbINBuqrvg7SJDBAE
         1+5aHQ0fM6z4HqqGfdPnM+TxC2eR87onR022aLJQtQcCVp1cAhqHEp7V9BwR2tGlqa3i
         xooTJBJwG+hVj4oFGkaCf+XXzfheOCcX0rVs1DjNR2i/18kZ9X3y7XcxgwlocrXLYE6a
         TX9e5IzF7y7+153K9Kol0CTPiRQx4d9/lJQC0uQCC3qGZLIYzRrsU6llEuCsWHwWXymc
         nXXA==
X-Forwarded-Encrypted: i=1; AJvYcCVDU7CKBRn4NM8sDrGmq8VGMJNKUVus/P/99M7lbXSvhEWfvT1Y3wdSVWkN5CIO2Dy7Yn8+eljGjbEg@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+uEBaO8qUBkyT3AjWHSSAp/quTDJoqBCIXX/Oeq0YM8UexgrD
	PSlL32twaXVmQYtABL3MQar7VZEJUMa6CZ+Q50eu3q3WS2C6+KcuJgOqXSP6gtYpR9cm4q9rfGq
	udfGG1Yutyr7WcettSATx+G/y+xnfqohbM9zN21LMq9yAX41tbJYlGaaaxuJBxQW940antUCLfE
	jEUCshtfoDTZlh8WTZUNVcot7TMPDyaMUpf+kSjQ==
X-Gm-Gg: ASbGncubYloZQZt6zAXbDJlYb6V6B3Di2XWpo+4rvjNcQml9v3TvJg9i0/5bT3OdC+i
	/BNjAkWuud7a6GWekHzwzgW7KnrUNsoae04DE6ZIDj+SYcvUFfMm2olrNR77Fn4/azS71hP+PLf
	q6qt9P
X-Received: by 2002:a05:6512:3d8b:b0:553:24b7:2f6f with SMTP id 2adb3069b0e04-5550b9fe64fmr5227934e87.51.1751334965394;
        Mon, 30 Jun 2025 18:56:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7Budh15ok7JsD4i5ULcZsYI+7J+vAHSbtXuHaBQBrwXBh5fG1UdBQuF4qCwZ7I5m5+Og+vztxbGILDmoT2go=
X-Received: by 2002:a05:6512:3d8b:b0:553:24b7:2f6f with SMTP id
 2adb3069b0e04-5550b9fe64fmr5227924e87.51.1751334964935; Mon, 30 Jun 2025
 18:56:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-17-yukuai1@huaweicloud.com> <c76f44c0-fc61-41da-a16b-5a3510141487@redhat.com>
 <cf6d7be1-af73-216c-b2ab-b34a8890450d@huaweicloud.com> <CALTww2-RT64+twHo3=Djpuj81jArmePQShGynDrRtYab3c1i2w@mail.gmail.com>
 <93166d88-710f-c416-b009-5d57f870b152@huaweicloud.com>
In-Reply-To: <93166d88-710f-c416-b009-5d57f870b152@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 1 Jul 2025 09:55:53 +0800
X-Gm-Features: Ac12FXyW-h6l8Fg8AHEM1TSseRMnZ0yZiVlfpW7m1kKgq5HblPmqF_NKBPkZTXk
Message-ID: <CALTww2820X=HU3Zuu+z19oCaPL+oQ4bMNostoAgfDk1-3nB3aQ@mail.gmail.com>
Subject: Re: [PATCH 16/23] md/md-llbitmap: implement bit state machine
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, colyli@kernel.org, song@kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com, johnny.chenyi@huawei.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2025 at 7:05=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2025/06/30 16:25, Xiao Ni =E5=86=99=E9=81=93:
> > On Mon, Jun 30, 2025 at 10:25=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.c=
om> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2025/06/30 10:14, Xiao Ni =E5=86=99=E9=81=93:
> >>> For reload action, it runs continue here.
> >>
> >> No one can concurent with reload.
> >>
> >>>
> >>> And doesn't it need a lock when reading the state?
> >>
> >> Notice that from IO path, all concurrent context are doing the same
> >> thing, it doesn't matter if old state or new state are read. If old
> >> state is read, it will write new state in memory again; if new state i=
s
> >> read, it just do nothing.
> >
> > Hi Kuai
> >
> > This is the last place that I don't understand well. Is it the reason
> > that it only changes one byte at a time and the system can guarantee
> > the atomic when updating one byte?
> >
> > If so, it only needs to concern the old and new data you mentioned
> > above. For example:
> > raid1 is created without --assume-clean, so all bits are BitUnwritten.
> > And a write bio comes, the bit changes to dirty. Then a discard is
> > submitted in another cpu context and it reads the old status
> > unwritten. From the status change table, the discard doesn't do
> > anything. In fact, discard should update dirty to unwritten. Can such
> > a case happen?
>
> This can happen for raw disk, however, if there are filesystem, discard
> and write can never race. And for raw disk, if user really issue write
> and discard concurrently, the result really is uncertain, and it's fine
> the bit result in dirty or unwritten.

Hi Kuai

If there is a filesystem and the write io returns. The discard must
see the memory changes without any memory barrier apis?

Regards
Xiao
>
> Thanks,
> Kuai
>
> >
> > Regards
> > Xiao
> >>
> >> Thanks,
> >> Kuai
> >>
> >
> >
> > .
> >
>

