Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F6F14659D
	for <linux-raid@vger.kernel.org>; Thu, 23 Jan 2025 16:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737651411; cv=none; b=fgn3h2PUwEaRN704YrYAQk/VXxMw8Q6D+UPA7c4lgTFNtdHrfqmOaNlw7KdVCIyWR7gcIc8Ng0X/Vsu9wvm1s+AbKS8C3WJXUcWvsGfLe8+nwEvNSg5evetw19Xks89g90UNUnQJ5q9OBq9rADW5BRA+mOKgNoWBjSH/cFzR+6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737651411; c=relaxed/simple;
	bh=Mtgdc91dbaPUjQfbkgSlq1jI3t3MXpwjz85aFwsx9Xk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nvGk4c2iWqod8VRt6P+U0Qy73LaLE0YawNTZ8m3Hp9Eg/xOmffuHFhpibACXBx53w58NV2LPJQcEudahm0wbocW1SwvSDumnmpVWDE2thiLMKabnLeDdmgnUrtLwHGUxWJL9E8qOZE0Y9q7ge6/hHcFhCULx5OfafqU5qDf95DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UIKEK4XQ; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UIKEK4XQ"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e580d6211c8so1942745276.1
        for <linux-raid@vger.kernel.org>; Thu, 23 Jan 2025 08:56:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737651408; x=1738256208; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sgN0rwVNLpp/OEJLdwsCxwYpidw8Q8ju1c5DSy1Bq84=;
        b=UIKEK4XQUnY+NGiwg8AkTFg2xURsKcEEBie98pIktsqcGzlU9cxm+G40IrRPvPPtMA
         TXMUPZGaImYl5K4cnph5TNwQNdSMQe+My1Nx+WZFdzglDrH9iON1PyDjp89zGzsdzbWY
         Q1Hkj9gCRiihAoHv3S4wIqIPnXzHkrRdmNy//2H2KpJpdkYTwZGKgIh+HRUkqWdV8PfM
         yyxcbpf7FcHR7sxB+twYSHjdtIMdXKQoL6iXPSUfzFVf8vsdvTeSwOrXRsSyaVKi8Q1W
         teyuRkjCy26DYCAAC8Iw0GE8x8v4ZrnLEXDAjLKZ9G5WlZAUy4RTAkLQ6av9LmAZ/Prt
         NeGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737651408; x=1738256208;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sgN0rwVNLpp/OEJLdwsCxwYpidw8Q8ju1c5DSy1Bq84=;
        b=iGeOJHTZd0B4EtefLIYGqpi0QMij6Ww7oV5t0r/UZ3OI3Qf5JSscvc03dUu3iOIqtQ
         NsG9FF1cQIMg0S94PV/VhXhbt/xOilbDTXqaGGGOzHD713vtug75NEeqXgHocXEzzGqF
         bV+QuGw23KaV1kv9Ee81l6zqPut7fnracKouLrHlXekIpZLwvbAnr6JJEF9/I1L4p690
         Ycpiwxb5PH14FZBK4/YstFUAUw7zVGglNVJcrLbY3QmCYydvOAEU4KClaVUEvKL8LyZA
         tFQmGWSI+LilDiq04/cYXY12l1sMpyRNFDZHoiWBOkFEyIUUgvus+FYkevSzVL5PSbNC
         FZSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdZTgzIXM+CFfqDaMa0uZLFdcMi2K+bhM53wLY6HElAEHsT8CxtUdWqzKO1fkLbTj5D3O5PreD4Ew8@vger.kernel.org
X-Gm-Message-State: AOJu0YxmZmAqNbKkNFhrQUBzjy+59GehQRA96wgAv+rx89VI6aDrXd8W
	3CKcPrqypaVogLwDy1tFvg9mhy0RzylpnalPZbRmk1ylun6C/fUO8PBNG5X6RpWUu4t8ofc4jRi
	4DblW5mMiPwj9264iCzPuncunXv1aC3Aa
X-Gm-Gg: ASbGncthLuj5iQ9VmYAM0B1zVxZSF7QYzZBvdlF4MD6whDL0iVgCr1eEk+8dvbKWwxi
	1RZfbU/3PeMpx1+Ibws1qKxu1PBO5G6IoJ4eZFRrkvA5VRq6V0+MfNeoNwB9jABg=
X-Google-Smtp-Source: AGHT+IHKV791fOmKJU+UAsX1gP2mjtMbWGQZoxPgq/0v7yEahkkJWpyJyYjNs0vDOIcAJ1r0KHkS/c/vBw625gvYGho=
X-Received: by 2002:a05:690c:d94:b0:6ef:4fba:8151 with SMTP id
 00721157ae682-6f6eb6a1698mr221847867b3.19.1737651408496; Thu, 23 Jan 2025
 08:56:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAiJnjqFwETu8ZwE44jdNWk=UYbdoNJr0W7pjkgjkTy0ff8grA@mail.gmail.com>
 <f33df1a3-c274-4c6a-9359-b0cf0869bee2@molgen.mpg.de>
In-Reply-To: <f33df1a3-c274-4c6a-9359-b0cf0869bee2@molgen.mpg.de>
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Thu, 23 Jan 2025 18:56:37 +0200
X-Gm-Features: AWEUYZl84bzcLcua5EjIfGCNL4hNyCFy2UEFP1LshALnOCaKzSKp_ZBWxs0wjwE
Message-ID: <CAAiJnjq6Cw6WfZFKAXA=xW5RjcUb0805=6u7fzM7oyANkzoHCg@mail.gmail.com>
Subject: Re: Huge lock contention during raid5 build time
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> What Linux version do you test with?

Currently on Centos Stream 10.

[root@memverge2 ~]# uname -r
6.12.0-43.el10.x86_64

I can switch to the Rocky 9.5 if required.

> I also remember the patch *[RFC V9] md/bitmap:
> Optimize lock contention.* [1]. It=E2=80=99d be great if you could help t=
esting.

Ohh, I have thought that the patch already included in the mdadm
version (mdadm - v4.4-13-ge0df6c4c - 2025-01-17)

If the patch is not yet applied to the latest mdadm version, how
exactly to do that ?

I'm not a Linux developer, but I would be glad to test that patch.

Anyway, I believe that mdadm should be optimized for the latest PCIe
gen 5.0 NVMe SSDs.

Anton

=D1=87=D1=82, 23 =D1=8F=D0=BD=D0=B2. 2025=E2=80=AF=D0=B3. =D0=B2 16:49, Pau=
l Menzel <pmenzel@molgen.mpg.de>:
>
> Dear Anton,
>
>
> Thank you for your report.
>
> Am 23.01.25 um 14:56 schrieb Anton Gavriliuk:
>
> > I'm building mdadm raid5 (3+1), based on Intel's NVMe SSD P4600.
> >
> > Mdadm next version
> >
> > [root@memverge2 ~]# /home/anton/mdadm/mdadm --version
> > mdadm - v4.4-13-ge0df6c4c - 2025-01-17
> >
> > Maximum performance I saw ~1.4 GB/s.
> >
> > [root@memverge2 md]# cat /proc/mdstat
> > Personalities : [raid6] [raid5] [raid4]
> > md0 : active raid5 nvme0n1[4] nvme2n1[2] nvme3n1[1] nvme4n1[0]
> >        4688044032 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/=
3] [UUU_]
> >        [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>......]  recovery =
=3D 71.8% (1122726044/1562681344) finish=3D5.1min speed=3D1428101K/sec
> >        bitmap: 0/12 pages [0KB], 65536KB chunk
> >
> > Perf top shows huge spinlock contention
> >
> > Samples: 180K of event 'cycles:P', 4000 Hz, Event count (approx.):
> > 175146370188 lost: 0/0 drop: 0/0
> > Overhead  Shared Object                             Symbol
> >    38.23%  [kernel]                                  [k] native_queued_=
spin_lock_slowpath
> >     8.33%  [kernel]                                  [k] analyse_stripe
> >     6.85%  [kernel]                                  [k] ops_run_io
> >     3.95%  [kernel]                                  [k] intel_idle_irq
> >     3.41%  [kernel]                                  [k] xor_avx_4
> >     2.76%  [kernel]                                  [k] handle_stripe
> >     2.37%  [kernel]                                  [k] raid5_end_read=
_request
> >     1.97%  [kernel]                                  [k] find_get_strip=
e
> >
> > Samples: 1M of event 'cycles:P', 4000 Hz, Event count (approx.): 717038=
747938
> > native_queued_spin_lock_slowpath  /proc/kcore [Percent: local period]
> > Percent =E2=94=82       testl     %eax,%eax
> >          =E2=94=82     =E2=86=91 je        234
> >          =E2=94=82     =E2=86=91 jmp       23e
> >     0.00 =E2=94=82248:   shrl      $0x12, %ecx
> >          =E2=94=82       andl      $0x3,%eax
> >     0.00 =E2=94=82       subl      $0x1,%ecx
> >     0.00 =E2=94=82       shlq      $0x5, %rax
> >     0.00 =E2=94=82       movslq    %ecx,%rcx
> >          =E2=94=82       addq      $0x36ec0,%rax
> >     0.01 =E2=94=82       addq      -0x7b67b2a0(,%rcx,8),%rax
> >     0.02 =E2=94=82       movq      %rdx,(%rax)
> >     0.00 =E2=94=82       movl      0x8(%rdx),%eax
> >     0.00 =E2=94=82       testl     %eax,%eax
> >          =E2=94=82     =E2=86=93 jne       279
> >    62.27 =E2=94=82270:   pause
> >    17.49 =E2=94=82       movl      0x8(%rdx),%eax
> >     0.00 =E2=94=82       testl     %eax,%eax
> >     1.66 =E2=94=82     =E2=86=91 je        270
> >     0.02 =E2=94=82279:   movq      (%rdx),%rcx
> >     0.00 =E2=94=82       testq     %rcx,%rcx
> >          =E2=94=82     =E2=86=91 je        202
> >     0.02 =E2=94=82       prefetchw (%rcx)
> >          =E2=94=82     =E2=86=91 jmp       202
> >     0.00 =E2=94=82289:   movl      $0x1,%esi
> >     0.02 =E2=94=82       lock
> >          =E2=94=82       cmpxchgl  %esi,(%rbx)
> >          =E2=94=82     =E2=86=91 je        129
> >          =E2=94=82     =E2=86=91 jmp       20e
> >
> > Are there any plans to optimize spinlock contention ?
> >
> > Latest PCI 5.0 NVMe SSDs have tremendous performance characteristics,
> > but huge spinlock contention just kills that performance.
>
> What Linux version do you test with? A lot of work is going into this in
> the last two years. I also remember the patch *[RFC V9] md/bitmap:
> Optimize lock contention.* [1]. It=E2=80=99d be great if you could help t=
esting.
>
>
> Kind regards,
>
> Paul
>
>
> [1]:
> https://lore.kernel.org/linux-raid/DM6PR12MB319444916C454CDBA6FCD358D83D2=
@DM6PR12MB3194.namprd12.prod.outlook.com/
