Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2B8C2C7
	for <linux-raid@vger.kernel.org>; Fri,  1 Mar 2024 00:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709254197; cv=none; b=PVZUNTvCMS2VoLObYBHL0sDhX/sWSLxiTa0w8Ols8rFOdbmtnvosr+EDDuxg7wqpq+pURAg41EJqBLYNe9bvZsfJkrhJlfQ2bdYoLBV9I08CWxywUmv9tgNoWnfg58NJd66oxbvWoJs5SZH+uxDg9CNmjJsBB2CGZsHSetYy2bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709254197; c=relaxed/simple;
	bh=j1ISuchHoQ7XzYupfDW3V7NGFW9lM9ffi1QF7fPlF0o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lzb0YhOB+w0bHGzTOAj8bbF0yZMMqTKz1JM+Q1cwA/Tm+MT+nAHKwnHAE00M61K9A3t++Bp+ejATzsGHUQuvs6gnGGifkJ2UJ/XlCgADPSUahLGiBsrflZxScoulJT+dHnduY/+f0gSBK3k/aH+9qnhuCvFNWzXJJJzH9Ot4qdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FDY27zxJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FDY27zxJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709254194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j1ISuchHoQ7XzYupfDW3V7NGFW9lM9ffi1QF7fPlF0o=;
	b=FDY27zxJNjGAgxv/vV9Cdv4XjpY0wktmbKXA9NSgywKOEbB7ZWWjTYpQkWQ1lUAGnvRWRe
	qwoiW95absgU4GqpBYmwJeiZLAkFIaDzR7C0w9SAg7t1dj2OkAJ2zhhiskOX1SSkIeEbef
	eVU/22sh/tzbvYZRYT0U8CGRC5TeYjo=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-YvEpe2dTNI2k7_w0s6LA-w-1; Thu, 29 Feb 2024 19:49:53 -0500
X-MC-Unique: YvEpe2dTNI2k7_w0s6LA-w-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5cf35636346so1187531a12.3
        for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 16:49:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709254192; x=1709858992;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j1ISuchHoQ7XzYupfDW3V7NGFW9lM9ffi1QF7fPlF0o=;
        b=G8EuD4BAE9vzqJrAcunOdMnN4cVl8NW3GaqLWeTPgoS73WCD6hRzLJKAID028jSMXf
         k839NnTrKNxJNDtfcDMuMwCS5AiebWsoF57eto7M6QOsFnf/in+QivdQ9c56KWDXEIfA
         yqL6bCi/kLUGzlw7UCDAoqEegCBkAdxu/X8edyhNb2RKNrbbOb2Arn+Qq2y8ZsQo1G7k
         S1CEFfAMuUDKKVwIKgKhPj41k0v1gFG9I1BPtXI2KtSG/owsHS55mFrvr85BqNHV8RdT
         ngslAW11prRTYbfIlc6a3ua4YlaEWgZr6GR5fJAb5aqUuOJKbTRP5u9PwDPR2hI4ckmq
         IY9g==
X-Forwarded-Encrypted: i=1; AJvYcCXQ63qO2mW9hNz4kKo4aaq9Ok2xR3pGWLjVMKPx+sWDCjIZmxTdLaGoNQZ9l5TygMDJl0Nn4yJkdzDg8kqEtej+RqsF+uWRIiUORQ==
X-Gm-Message-State: AOJu0YzFvUSc8kO/zo9sxzEk783Ib42JxFM+c9pEK5m4jjQFB8ZB3FAY
	TRMPS3mlMN0Me9UeH7HEfbozlA0K1eXcZR5CD5qYlGn5YRmr2xz3d8FJtINSA94mSimzMPW7zPl
	V4IyJ+NxzKcjrkHHZWRYKs2ELz2Ew/WlP2/BTSWsI45s9kYkdpW+yTEu4ni4/XTpb3qt1ycXJC1
	QVf823Ng64WIiiaZKfmVtmb10ybnk2ghVPuS0KZ++5PwH+
X-Received: by 2002:a17:90b:238d:b0:299:3e54:83f3 with SMTP id mr13-20020a17090b238d00b002993e5483f3mr251824pjb.38.1709254191886;
        Thu, 29 Feb 2024 16:49:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH0Q5dwWivL/YK2ympLjv7kcqdpTHuI6Qo84BzqY0pSsbaPaXtyr01xH2VzXo/l3dRcpXXgWfc7UDo5SHQVOqI=
X-Received: by 2002:a17:90b:238d:b0:299:3e54:83f3 with SMTP id
 mr13-20020a17090b238d00b002993e5483f3mr251814pjb.38.1709254191613; Thu, 29
 Feb 2024 16:49:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240229154941.99557-1-xni@redhat.com> <20240229154941.99557-3-xni@redhat.com>
 <CAPhsuW6j5q+kjJ9Xn0dBmb_TVZC+z8FAjExpQHWO1pCAN_fYtQ@mail.gmail.com> <CAPhsuW60wGMLeOAkOqBJTgVU8qEnQCyRB9+c-f42GHe9ynJxpw@mail.gmail.com>
In-Reply-To: <CAPhsuW60wGMLeOAkOqBJTgVU8qEnQCyRB9+c-f42GHe9ynJxpw@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 1 Mar 2024 08:49:40 +0800
Message-ID: <CALTww28-+EFDEk6EgGurvD=ET2_MBtebg1fp0pe+YPJ5kOn8Qw@mail.gmail.com>
Subject: Re: [PATCH 2/6] md: Revert "md: Make sure md_do_sync() will set MD_RECOVERY_DONE"
To: Song Liu <song@kernel.org>
Cc: yukuai1@huaweicloud.com, bmarzins@redhat.com, heinzm@redhat.com, 
	snitzer@kernel.org, ncroxon@redhat.com, linux-raid@vger.kernel.org, 
	dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 1, 2024 at 7:46=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> On Thu, Feb 29, 2024 at 2:53=E2=80=AFPM Song Liu <song@kernel.org> wrote:
> >
> > On Thu, Feb 29, 2024 at 7:50=E2=80=AFAM Xiao Ni <xni@redhat.com> wrote:
> > >
> > > This reverts commit 82ec0ae59d02e89164b24c0cc8e4e50de78b5fd6.
> > >
> > > The root cause is that MD_RECOVERY_WAIT isn't cleared when stopping r=
aid.
> > > The following patch 'Clear MD_RECOVERY_WAIT when stopping dmraid' fix=
es
> > > this problem.
> > >
> > > Signed-off-by: Xiao Ni <xni@redhat.com>
> >
> > I think we still need 82ec0ae59d02e89164b24c0cc8e4e50de78b5fd6 or some
> > variation of it. Otherwise, we may hit the following deadlock. The test=
 vm here
> > has 2 raid arrays: one raid5 with journal, and a raid1.
> >
> > I pushed other patches in the set to the md-6.9-for-hch branch for
> > further tests.
>
> Actually, it appears md-6.9-for-hch branch still has this problem. Let me=
 test
> more..
>
> Song
>

Hi Song

What are the commands you use for testing? Can you reproduce it with
the 6.6 kernel?

Regards
Xiao

