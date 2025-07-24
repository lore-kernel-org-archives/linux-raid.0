Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39EF237186
	for <linux-raid@vger.kernel.org>; Thu, 24 Jul 2025 09:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753350241; cv=none; b=rq3QQoxtDoy+PcgFg7d48zKxHDLbz83XUclQZLIXpIyJl+chfOek4i/b5czUK6crjjskgT7ZQ0rCN6w/UOvPaet5bvxCPQah1l/hJidzeV/IqEkOe489ROkOdRtAcOXNw+LeWkJd04C+YSpAE0OlOo7OoscQz+NRVzjyNLNE3JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753350241; c=relaxed/simple;
	bh=1RsW6TkQHbPLtqeFzWRPPpTD1CLBeW1m9UMNqDJ4yFA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QMaknStB0BrhUjY7G+pLgj8CXk79Ab/ltIZ6CsrctEufqkzTIOydo4d/1tL8RNk7J3T+BYrsLYM3HT3uSEtnLd1rmPxGblB4xnxFlKUdeVuoRzsAJDMgXDWCZBeNyyhtgTZQpeMZyjSMjkLLWx+JFOgpN6P/2j2T6Vkn3yhxn6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LZBdwaST; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LZBdwaST"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753350237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4uVu8UqJY2rILvYiLxcmHt2uP5c2QlGcySH4tysmwV8=;
	b=LZBdwaSTTJ1aegeGZm6YYt5Zy1AM4SN7ZLun3iAvWyMTTNuMHwoC68CsRiAHlrj8ECMQYx
	zzFfoTVncIdFQtUNMUaTRJ8lUlS446fcmIfBT+wu4G35n6bzmx+WRaGfkl+IhcHJWLSTHw
	4OxY6fxLzKXxAE1/oyR7beVPauHRlgc=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-PE0B3tMHPS2n01wNfEiYbA-1; Thu, 24 Jul 2025 05:43:53 -0400
X-MC-Unique: PE0B3tMHPS2n01wNfEiYbA-1
X-Mimecast-MFC-AGG-ID: PE0B3tMHPS2n01wNfEiYbA_1753350232
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-553cff91724so439989e87.2
        for <linux-raid@vger.kernel.org>; Thu, 24 Jul 2025 02:43:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753350232; x=1753955032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4uVu8UqJY2rILvYiLxcmHt2uP5c2QlGcySH4tysmwV8=;
        b=HuqSfa0AMbuME855t9cKtpJhanJLwZREzLwATpTUAT25Sf7ezhSysFn9aCpU4y8btN
         VjtY1BEVS8x53LaNPHWTecDrJKIUD9p+L4GEYZ8w6oe48fFZeL9vjSjQZoJnS00qvQae
         DhMD/lOeLWNqGyXilKroOl/aCj79Qap0/D8cL3lVNjCoigy9Gt335uuGGtijIMVt3g9a
         9FTVeGjYOK7Q6TnEFY5tFbG4iCSs3HAM+40Ej33+2N+XFyVce4LwgiNC1Tp3e+j6PbQ+
         ZShCHGD1g/7zkUVmi4vFT9xbPQJh2MtmtMfLZ/C0xlHvWOIMdlEsbzMx90jEgrqHMFUX
         D9Qw==
X-Forwarded-Encrypted: i=1; AJvYcCVVuv14bBuM+vLdXqDN+7CpEJVRLki4vViR2gSikECNqc+7jRPYjgkMQu6Tel65zz3UhBYesyYlpyR5@vger.kernel.org
X-Gm-Message-State: AOJu0YwDN/uFj1QzcpunIlBPj1ON+HI1f2mCm+QF7Hye9TLHX3HEy+Fk
	a+JpRZOnfgMifIcFk2QNx8rLXICGERQnIUYhX1URSg/hwmCuBEUftcgV/JDvEPCTuFHppJ9UjAv
	Rc3N+t6NBEELg9BbV7LwGJ1cS8AunqKkG4q4qtkpTFvIzmKtrJKeuKhQT43QX8eeQfcYdzIrEaG
	Guzjbv+neCGJjBO9bSygDPLPfVh8PqB+0RDUYCbQ==
X-Gm-Gg: ASbGncvULrV9nTlY0VoB2KMHY3j+uZJwi/Om2KAvWGg5z4va1jY9PU7hW0CUwTHS+x+
	9DCT2hflrIhHvd4hYxmNkRyVjlWcc+2NjiYkxpjJ3SU55eiY2d4AyCHlaoocUAk5x7hEW2bU9eI
	beLq5e/r0AG9rHCUCxz7PEig==
X-Received: by 2002:a05:6512:24c2:10b0:553:3892:5ecc with SMTP id 2adb3069b0e04-55a513de6d9mr1469789e87.36.1753350231660;
        Thu, 24 Jul 2025 02:43:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNxawjYjUKLHdRCl0oaMlA657BHnzVrGFgD43ZuQRZcdLd3BVs8Uc+KgukbnjyBzZ0CU7JsvInvhbJa0Eednw=
X-Received: by 2002:a05:6512:24c2:10b0:553:3892:5ecc with SMTP id
 2adb3069b0e04-55a513de6d9mr1469775e87.36.1753350231225; Thu, 24 Jul 2025
 02:43:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGVVp+X8GYS7yKkq-qxJ5hpTL=vHMBgG=wuSsNJZ0VrjQeMA6w@mail.gmail.com>
 <CALTww2-_9saPOtLC0dXUhQiK+2eV739rjwX3K3KDAz6AgbE6Ug@mail.gmail.com> <CAGVVp+XfxgMDJ=JX6nLtieyco=PajfqhoKZBb0Qrs7bndUEk_Q@mail.gmail.com>
In-Reply-To: <CAGVVp+XfxgMDJ=JX6nLtieyco=PajfqhoKZBb0Qrs7bndUEk_Q@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 24 Jul 2025 17:43:38 +0800
X-Gm-Features: Ac12FXwcVG0omWbb12mwc3CHvnCyZE2x-xhiu5sbpejBKE3eh2PymZSwJKRQ7sI
Message-ID: <CALTww2-sdV1gDGAcfPSHWJOoycb=aMrT9-XFDayNKeEaDeE7og@mail.gmail.com>
Subject: Re: [bug report] mdadm: Unable to initialize sysfs
To: Changhui Zhong <czhong@redhat.com>
Cc: Linux Block Devices <linux-block@vger.kernel.org>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Changhui

Thanks for confirming this.

md raid has a change which guarantee device node (/dev/md0) can be
removed when stopping array
9e59d609763f (md: call del_gendisk in control path)

The change is good, but this change introduces a problem as you see.
So I fixed the problem by
https://github.com/md-raid-utilities/mdadm/pull/182. Now we don't need
any change.

Regards
Xiao

On Thu, Jul 24, 2025 at 3:53=E2=80=AFPM Changhui Zhong <czhong@redhat.com> =
wrote:
>
> Hi,Xiao
>
> yes,  succeed assemble  RAID array with the latest upstream mdadm,
> # mdadm -A /dev/md0 /dev/sda /dev/sdb
> mdadm: /dev/md0 has been started with 2 drives.
> # mdadm -V
> mdadm - v4.4-55-g787cc1b6 - 2025-07-09
>
> if not install the latest upstream mdadm,
> this issue will be hit in the upstream kernel git/axboe/linux-block.git=
=EF=BC=8C
> but not triggered in git/torvalds/linux.git=EF=BC=8C
>
> is there anything that need to be fixed in git/axboe/linux-block.git?
>
> Thanks=EF=BC=8C
>
> On Thu, Jul 24, 2025 at 3:18=E2=80=AFPM Xiao Ni <xni@redhat.com> wrote:
> >
> > Hi Changhui
> >
> > I guess you need to use the latest upstream mdadm. Could you have a
> > try with https://github.com/md-raid-utilities/mdadm/
> >
> > Regards
> > Xiao
> >
> > On Thu, Jul 24, 2025 at 3:07=E2=80=AFPM Changhui Zhong <czhong@redhat.c=
om> wrote:
> > >
> > > Hello,
> > >
> > > mdadm fails to initialize the sysfs interface while attempting to
> > > assemble a RAID array,
> > > please help check and let me know if you need any info/test, thanks.
> > >
> > > repo: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-blo=
ck.git
> > > branch: for-next
> > > INFO: HEAD of cloned kernel
> > > commit a8fa1731867273dd09125fd23cc1df4c33a7dcc3
> > > Merge: b41d70c8f7bf 5ec9d26b78c4
> > > Author: Jens Axboe <axboe@kernel.dk>
> > > Date:   Tue Jul 22 19:10:37 2025 -0600
> > >
> > >     Merge branch 'for-6.17/block' into for-next
> > >
> > > reproducer:
> > > # mdadm -CR /dev/md0 -l 1 -n 2 /dev/sdb /dev/sdc -e 1.0
> > > mdadm: array /dev/md0 started.
> > > # mdadm -S /dev/md0
> > > mdadm: stopped /dev/md0
> > > # mdadm -A /dev/md0 /dev/sdb /dev/sdc
> > > mdadm: Unable to initialize sysfs
> > > # rpm -qa | grep mdadm
> > > mdadm-4.4-2.el10.x86_64
> > >
> > > and not hit this issue with upstream kernel
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> > >
> > >
> > > Best Regards,
> > > Changhui
> > >
> >
>

