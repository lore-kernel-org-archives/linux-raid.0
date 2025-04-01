Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357B2EACE
	for <linux-raid@vger.kernel.org>; Tue,  1 Apr 2025 04:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743482951; cv=none; b=YuCSqfcA/BNLU8BALLvg5PfiyUeLHFSU+TMhq345upBCyJR8yaCs+6lUJZvtJ9YvhNSLegyG6UHoysL6zwZGPIBos1awbH4196Um/gpf/PMeFYnuFZkPkVNhjST2kOfbnptfdj1S7suMUcjc+oMlHKlWgHIEu7e5bLOVrot0wAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743482951; c=relaxed/simple;
	bh=SL1y5cQxbLjz9QbPjECL3URBwlFqp5IZBnZc9OXesM4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FODWWRL2iwkeNadCfMdlQ30qWXBZEcZwRCeYVOpm+ysXQBT5rgI0lL8p7l2360fdwVtUPtxvlSCRl6alu7PQyO/M4TtoyojVN5yWIPJPtsQg1ucjIFlwSz2oQUFJ55Wd1rGLzuiLWqNPob5IouudQp4GtFNCSTrtyMAKvMaKAkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P0a/DmRx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P0a/DmRx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743482947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LrpUQSY91fpAhxrli3ZlK2MR3OU0Ax5VvPymoKVClZc=;
	b=P0a/DmRxlggSdQjl43RANEoCEFUOmiWm36rwTF8J+adCtNnK6FKQqm7Z85iHuAuOKhSJIL
	vF0hXWjIf56z5HLIda0B8F9+R2EPClbQL8HAHyFxNpux2OLGaXW88dT8zYhxM4FkdZAu+E
	SYApkq6u9/5iBbSTvx8j7tI/L1d6zpA=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-ML9R3V_WPVar36u4L8lDBQ-1; Tue, 01 Apr 2025 00:49:05 -0400
X-MC-Unique: ML9R3V_WPVar36u4L8lDBQ-1
X-Mimecast-MFC-AGG-ID: ML9R3V_WPVar36u4L8lDBQ_1743482944
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-30bf6cdaf17so30829161fa.3
        for <linux-raid@vger.kernel.org>; Mon, 31 Mar 2025 21:49:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743482943; x=1744087743;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LrpUQSY91fpAhxrli3ZlK2MR3OU0Ax5VvPymoKVClZc=;
        b=kXJpe9ZqwqEMq2aTbb95ZPA2dU/rUuqaD0A7D+Y63oZIu9IeOGi7+tgET028hg1gTR
         S6lNJxrsmmtjhTzGJnKYcYK8NrydntSB0dtTyAMZDrTzc59DuVPcH7w47ULUYdgE78kD
         CiJ67VC67fnAU+/xyT0LUrj7jCh/YvR6jyPsCO4my44Q/Nb2b0mMUooncXNMYH86d287
         qUoyO4xdfZLbkxuBJh8oYcREHNItRG5DF8Zqw3A3E446xfq9Qz5EPsQTcGEnYNvsPWzX
         3GdrizybMcmXyVhEqL8im3pdW7+OOgP+3xuvQy6ZdCFnI4bW0dTBwBgzI9jGtcoNaIoo
         E82g==
X-Gm-Message-State: AOJu0YxyB9Gi2yNhRiDWIWWFuJoDqLTJDw0DODgMiONGjWeMIXOklwDe
	YCe0RCrsXlgZJ7r6vsCPrKvr5HpquhoQiXqHKbezVcj6tr7/atIzfVTbjeKRZJIqh1jSNAQoQ3u
	3egH69ZpIJHuq6FsE+xsWK1iXDPg7q8haIU6yVxqE7wFlx2ocDX/iUUDtSVV52KQhxBoX+qUoXK
	GNURsodkIFXFDJRT65PUdiAUhGl7vgvyIoXVCBE85JzeDODUY=
X-Gm-Gg: ASbGncuOHVBW8V24At2YlKM+2y4ZEU+3CsDngssT1XO+XGsJYtmdVQnXit7yy3cgsuT
	RsKImCdNic91oqt0pKUK7FsoEJsKC2JF2sRtXGerfAAwfdt4euNCe2fRAyEAEI5T4pwjfR5sopw
	==
X-Received: by 2002:a05:651c:1584:b0:30b:b956:53d4 with SMTP id 38308e7fff4ca-30de022c55dmr31616771fa.5.1743482942740;
        Mon, 31 Mar 2025 21:49:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFfhrpgyXWLQrlWmt5RXGZbpmGoA9mdZvHjoRuxdUOiZCMY3F2xPOFuLJ2JUgi9yHOSbIPytOmmyW0AtHlOKZk=
X-Received: by 2002:a05:651c:1584:b0:30b:b956:53d4 with SMTP id
 38308e7fff4ca-30de022c55dmr31616731fa.5.1743482942404; Mon, 31 Mar 2025
 21:49:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5fc88c9b-83a7-414c-82da-7cccb1f876f3@dev-mail.net>
 <CALTww2-=QABMBKatYQVJ+VSAVTXvvhn1jJFUqf8ZZZb3+nx0Mw@mail.gmail.com>
 <0d9732b1-84c5-4875-ad22-25e546584fbf@dev-mail.net> <CALTww2-V8ADxpQ0+to+gyiUO-YELNwc+Fiw0vV+E-HM32L=mng@mail.gmail.com>
 <7a13feed-09b6-49ec-8071-6df3be84abd2@dev-mail.net>
In-Reply-To: <7a13feed-09b6-49ec-8071-6df3be84abd2@dev-mail.net>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 1 Apr 2025 12:48:50 +0800
X-Gm-Features: AQ5f1Jrud6trAMky1GOBD-BMahq64EwIVfkbP-pJNLgoBeYoERzaeSUPoHRRkkQ
Message-ID: <CALTww284ysugf7dMqS6q3eSjkWSq4Upx7_u4GUzmKE9PbE1fdw@mail.gmail.com>
Subject: Re: extreme RAID10 rebuild times reported, but rebuild's progressing ?
To: pgnd@dev-mail.net
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 1, 2025 at 10:41=E2=80=AFAM pgnd <pgnd@dev-mail.net> wrote:
>
> > so everything works well now
>
> the OP question remains unanswered.  namely what the issue is re:
>
>         finish=3D3918230862.4min speed=3D0K/sec
>
> , and whether it's an indication of a functional problem with the rebuild=
, one of the mdadm util, or of config?
>

I can't give you an answer now. Because there is very little
information. But the mdadm --monitor --scan is a suspicious place. Do
you know why this command is running? I tried to start a recovery and
didn't see this command.

Thanks
Xiao

