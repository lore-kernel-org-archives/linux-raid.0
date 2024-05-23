Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CB98485
	for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 02:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716429943; cv=none; b=OJuhY4XUTO31M4bZwhefqEYKtHwgRwZqX3wlE1r3XmizVTmuGZcOzWRZ5klESbqGlyE0K5HdZONa2fpwG+ho7RSaGMRfCFBfedMb4KJr+VOx2ruwXxh1p5pP8tIbtHHcpOMrlH5oEnJRvNk6mrMRtUkah9jyJVr4OGUajN6XJEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716429943; c=relaxed/simple;
	bh=lOtx+bOTmv8eb2khOqsYrx95NcQGvCTBUNhhaZ5widQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oN9C7sKhAx+/cQinlfT4wABWHBMgn9p+wbgQ714I174Sqk/MTou0dNGFdzS0vG382uDEtShHcCjTemCnDoRErblri3i2/lVFtNnDMRjZF/8389VCjZIpT+X5sqTdcHmRIGRTJrOo8hwmDf/o6ZNS1aHrgcJskshRV25PlO+/lYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BhMT9zDc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BhMT9zDc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716429940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OOh37Kgyx+lj0cR1zfj8fG/cMR0SSz3EQ1/fQJ9zVPs=;
	b=BhMT9zDcca8M5XhwesWRjuiit4bb2mABdPv5nli6551FgxVTa0UOa6sbaq5UIu7MRnjjPa
	pdo01USwXKkQNaM/9jDq8LTLC2aiQJnV9fegao8d6AUUPTBZ/yqL79wSkzIWdDfuhhh5Gp
	cYeKCPkQ7c+uULZH5CEPBs6e/Gnx2Tk=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-IAMwOXdANvGGQjcL2KoHtA-1; Wed, 22 May 2024 22:05:39 -0400
X-MC-Unique: IAMwOXdANvGGQjcL2KoHtA-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-67b44c5a0e7so351502a12.3
        for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 19:05:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716429938; x=1717034738;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OOh37Kgyx+lj0cR1zfj8fG/cMR0SSz3EQ1/fQJ9zVPs=;
        b=LZPzDVTWdBXt8vjqBRUHyzmTNL6GZCEwMryBr33tes7MBBCn0Ji6SKcJi2FGcqTBab
         EcwrtkdXTIyaWp8fYekTB9D1FQ3RvxMMyr15tODigoi0R+CKUmKPiZX/jRr8Vp1HXsQx
         LI7MEME2gsEVkmlDqpR3JQ6mKjUu7n4WUzs/WqRt5+M/mc12ICF8ZYr4znemg4lZy/wO
         xbm7Rh9yuw2x50SInBBkR8l0potdX0R93kDzq5VOOLMwK+qhfO70pVolzggX1PrZ7lZZ
         G5X+7pNDYFTu/UDKH9Aq5V5IBc6nErvLYfIFmRWsZES7Hf619K09KyQH8mI809W3y64f
         BVpA==
X-Gm-Message-State: AOJu0Yy5beiUPooMPzFVvt0Y0Ptqv2lKMH6Q0qczyGXWS9/NHe6OMsRt
	XZPsRzCuCm3u8gWLZrhez7R0Hblrc+dkwYrD6LO60fCulr0ynleKH8aQzpjnZi3SbBs3QKpPKFd
	dt2IzXOijmAGgt15HyOu6gNLTRMZvlFYtVVkOMhql0FaWgi969ZpByifgQ0i+KaZwI1nqC4QDm/
	OqBs5Gj+1f59l8OpxQuxf/UePWdoEjQ9H2bA==
X-Received: by 2002:a05:6a20:a110:b0:1af:ccfd:529d with SMTP id adf61e73a8af0-1b1f89f4897mr4105905637.27.1716429937864;
        Wed, 22 May 2024 19:05:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEdrI6wDjG/tz4ucpoIDqpNIgoWeeTcJWJt/RL1TCfnnIOBfl8j5uJ58pEzwTpsSe2187v1oITYo4Dc7vWJ1YQ=
X-Received: by 2002:a05:6a20:a110:b0:1af:ccfd:529d with SMTP id
 adf61e73a8af0-1b1f89f4897mr4105885637.27.1716429937421; Wed, 22 May 2024
 19:05:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALTww28qp4d=mvdXvLqHPTrt0FAJihdMOQMrAyL44urstSdznQ@mail.gmail.com>
 <25ea3a8d-6331-476c-8fb4-8932185b3113@deltatee.com> <CALTww2-Rm=ORd0QtuWru6qz8VaTY3D-EnjJVQ48uf8gPTSG6Uw@mail.gmail.com>
 <5c0a5fdc-a86c-424d-9f8e-ee881baf82be@deltatee.com>
In-Reply-To: <5c0a5fdc-a86c-424d-9f8e-ee881baf82be@deltatee.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 23 May 2024 10:05:26 +0800
Message-ID: <CALTww2_WnuQkMH4KeSvJNMJiiQtbP6NNA4SNt2BJPNriHcHZfQ@mail.gmail.com>
Subject: Re: mdadm/Create wait_for_zero_forks is stuck
To: Logan Gunthorpe <logang@deltatee.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 23, 2024 at 12:33=E2=80=AFAM Logan Gunthorpe <logang@deltatee.c=
om> wrote:
>
>
>
> On 2024-05-22 02:46, Xiao Ni wrote:
> > Hi Logan
> >
> > Thanks for your suggestion. I tried to create signalfd before fork()
> > but it still can't work. And I call sleep(2) before child exits, the
> > problem still can happen sometimes. This is what I tried. If you have
> > time to have a look, it's great. It's not a hurry thing.
>
> Can you send sample prints from this patch? I'm very surprised that with
> the delay on the child processes it can still happen.

There are three changes:
1. initialize signalfd before fork
2. Block SIGCHLD before fork
3. sleep 2 seconds before child exists
4. break when receiving SIGINT signal

>
> What do you do to make it happen? How frequently does it occur?

mdadm -Ss
i=3D0

while [ 1 ]; do
  /usr/sbin/mdadm -CfR /dev/md0 -l 5 -n3 /dev/loop0 /dev/loop1
/dev/loop2 --write-zeroes --auto=3Dyes -v
  mdadm --wait /dev/md0
  mdadm -Ss
  sleep 1
  i=3D$((i+1))
  echo $i
done

It's easy to reproduce in my environment. The loop device is 20MB
which is the device size during regression tests.

>
>
> > @@ -185,17 +186,6 @@ static int wait_for_zero_forks(int *zero_pids, int=
 count)
> >         if (!wait_count)
> >                 return 0;
> >
> > -       sigemptyset(&sigset);
> > -       sigaddset(&sigset, SIGINT);
> > -       sigaddset(&sigset, SIGCHLD);
> > -       sigprocmask(SIG_BLOCK, &sigset, NULL);
> > -
> > -       sfd =3D signalfd(-1, &sigset, 0);
> > -       if (sfd < 0) {
> > -               pr_err("Unable to create signalfd: %s\n", strerror(errn=
o));
> > -               return 1;
> > -       }
>
> Strictly speaking, I don't think it's necessary to move the signalfd
> initialization. Blocking the signals should be enough, then any signals
> can be retrieved at a later time with signalfd. Though, I don't think it
> should hurt to do it this way.

I did a test in a simple c program.

part0: block SIGCHLD and SIGINT
part1: fork 3 child process. It doesn't do anything in the child
process and exits.
part2: read from sfd to check SIGCHLD
part-initsfd: sleep 2 seconds and sfd=3Dsignalfd

If I put part-initsfd between part1 and part2, it can happen the same
thing. part2 only sees one SIGCHLD and it's stuck. If part-initsfd is
before part1, it works well. The father process can see the 3 SIGCHLD
signals. So it's the reason it init sfd before fork in my patch.

Best Regards
Xiao

>
> Logan
>

