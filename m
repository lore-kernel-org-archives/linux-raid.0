Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247351A0BC7
	for <linux-raid@vger.kernel.org>; Tue,  3 Sep 2024 10:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725358310; cv=none; b=QJMUoeOYG4SP6oGtnzjkOp96rQiqvjj4VkqvHpBRIkuQ86obOme8l8kPEILX4NLD2BEXkbdEBmAbzUzX3GagVpUIo5xd1TpPjltXOYvm/1KkJMBHBTmw4EmFxBN7S6cqvLRzwK91SKcI9AdJf0fIxegOqWRCuLvdV2rfzbUgFyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725358310; c=relaxed/simple;
	bh=9gSnKHJAKzvogXxkWsyQgGcaje2dc+LgOoC/RSiTzfg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l29tNV91bvQOtehPRg2fC0VqF/AAAWpwRnGen1oQBkB1TQa03i/Gn3eo27GwCmkGoJMIi3DbMgsddaqFFWELSi9dNTq+2z15uHXAMQon0YymMAxy96OeubplAlHcCvPn9r8d3lGOruuEoHrzSESqePncY8cdlEM67pPXn2tlR1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZuTY3rSZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZuTY3rSZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725358306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9gSnKHJAKzvogXxkWsyQgGcaje2dc+LgOoC/RSiTzfg=;
	b=ZuTY3rSZgE64it8Rn/Jb2IJsylWEJ5g2kICmeqN7h+xlfNDig+Y35qmsd0Ga1So0NoYlvK
	zXJIPHDwDGV2CM/GXrUU5y0N8/sqbxeNvkXmlaFBNcohCH/JjH25sIoYLmC+Im2v8g07CK
	9oGloAp37xsBHMbwnI8ObwPIKZzyILk=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-696-tBj2_tchP9q0mYYucxDGYQ-1; Tue, 03 Sep 2024 06:11:45 -0400
X-MC-Unique: tBj2_tchP9q0mYYucxDGYQ-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2d404dffd54so5534140a91.1
        for <linux-raid@vger.kernel.org>; Tue, 03 Sep 2024 03:11:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725358303; x=1725963103;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9gSnKHJAKzvogXxkWsyQgGcaje2dc+LgOoC/RSiTzfg=;
        b=pva8KnTt207+cxXttKOX1yK/62VgnhnfV3YfM+I11OiyfxrcktO/PDcHZhz3cC+P98
         aChmTaKesJQwuGOca9YsJY3filkoFfNYOag2HijtwGyL149Vb+QB8xSxaKKOUl3c82o2
         6SNIWoVnStVIofzp7RCPNlG2zFXB17S5L53hnTzDsyZDlBFbPo4nrgm6EpFmN1WXDP+M
         MB89+pE7Ce4oObO/FFBXBWINIGaxCUH2Jwk1jFYl0b7WZdfstKxzxBbMl1YuyqzQ6doa
         kDmIpEf6Cjxeed00WWBDoB9+2INb2Im5bk657E3Lm+fluazeUfhmtsvvJKlQ6xuI//1t
         M+XQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUn+b5jMs6Bj8SPn8hpt4DpqZ3x0gz6LcngNnb+9nhwLjmFVehCD05GZtAVYU1JUeDRPVQ7YXTby4z@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw43hDMb2CqEGEHCr/djbf6howPmzxnIZJdnhb2XxsHT6y4ovt
	dXOeo7mWcl40QxksoASOT9qvXStNclJjreCT6T5NyDK/g8d/K0MoWPcdf1RPTbvfO2SQozB7c/3
	orQXCCxYgkdqRsoeoOKwUX6bTgiJyOHiPkyYvdHE/Eg9KU20TA/+qRTo8AoZw8Rxz0A0ElVfJTw
	SY4svyEYqKiZhLfG1OGDr8KXXYU4WWQBLalA==
X-Received: by 2002:a17:90a:6046:b0:2d8:89ad:a67e with SMTP id 98e67ed59e1d1-2d88d667e5cmr10351147a91.1.1725358303078;
        Tue, 03 Sep 2024 03:11:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNCN1TLz3GUkWNze3xhlSYyUfYknhRcmw1Zmp5sh7Ayf9YUKmcErsOVXmJDpd+vkI4bEiPUXMD0MDK7GsipDc=
X-Received: by 2002:a17:90a:6046:b0:2d8:89ad:a67e with SMTP id
 98e67ed59e1d1-2d88d667e5cmr10351128a91.1.1725358302502; Tue, 03 Sep 2024
 03:11:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240828021150.63240-1-xni@redhat.com> <20240828021150.63240-2-xni@redhat.com>
 <20240902115013.00006343@linux.intel.com> <20240902121037.000066e9@linux.intel.com>
 <CALTww28fYqzAdmNdx9CmXWL4ozma2f1vx8oPYuDi2Ycds=S7zg@mail.gmail.com> <20240903093446.00000a94@linux.intel.com>
In-Reply-To: <20240903093446.00000a94@linux.intel.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 3 Sep 2024 18:11:29 +0800
Message-ID: <CALTww28gidoTgKO7yH=7NXZUEy2nZmhPLGrgF9UobaQdfRHd8A@mail.gmail.com>
Subject: Re: [PATCH 01/10] mdadm/Grow: Update new level when starting reshape
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: ncroxon@redhat.com, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 3, 2024 at 3:34=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Tue, 3 Sep 2024 08:34:46 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > On Mon, Sep 2, 2024 at 6:10=E2=80=AFPM Mariusz Tkaczyk
> > <mariusz.tkaczyk@linux.intel.com> wrote:
> > >
> > > On Mon, 2 Sep 2024 11:50:13 +0200
> > > Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:
> > >
> > > > Hi Xiao,
> > > > Thanks for patches.
> > > >
> > > > On Wed, 28 Aug 2024 10:11:41 +0800
> > > > Xiao Ni <xni@redhat.com> wrote:
> > > >
> > > > > Reshape needs to specify a backup file when it can't update data =
offset
> > > > > of member disks. For this situation, first, it starts reshape and=
 then
> > > > > it kicks off mdadm-grow-continue service which does backup job an=
d
> > > > > monitors the reshape process. The service is a new process, so it=
 needs
> > > > > to read superblock from member disks to get information.
> > > >
> > > > Looks like kernel is fine with reset the same level so I don't see =
a risk
> > > > in this change for other scenarios but please mention that.
> > > >
> > >
> > > Sorry, I didn't notice that it is new field. We should not update it =
if it
> > > doesn't exist. Perhaps, we should print message that kernel patch is
> > > needed?
> >
> > We can merge this patch set after the kernel patch is merged. Because
> > this change depends on the kernel change. If the kernel patch is
> > rejected, we need to find another way to fix this problem.
>
> We have to mention kernel commit in description then.
>
>
> Let say that it is merged, we should probably notify user,
> "hey your kernel is missing the kernel patch that allow this functionalit=
y to
> work reliably, issue may occur". What do you think? Is it valuable?

Hi Mariusz

It makes sense. I'll add this in V2 once kernel patch is merged.

Regards
Xiao
>
> Thanks,
> Mariusz
>

