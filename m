Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB702DAFB9
	for <linux-raid@vger.kernel.org>; Tue, 12 Aug 2025 08:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754988622; cv=none; b=JgO762bS4UMEr6SsOz3YUerpCxIGoYb2YrkEuaR2c+Mr12EOLUDgUg30CcqmAjDr7rDLmPv9Vas1rpGayv/aHdqX6rwNo9Mhpsrax/xKHEhHfa+EoChLZynBNPjXGcL8C75x3QKMOqRI5Iky6PfECN0BuRtsxUrG+lcIPNIrdgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754988622; c=relaxed/simple;
	bh=K6NRFxO1IfXa8fexs0oRFsGFxaMGo/oO1tFRPKUaYN4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FohShlSK/ueHjq/SSPRn2S9qGnnnXmk3O0U72aUwVFioOVIdz9o3bD12XgOvUi99YEDGMNCskFpIFYFzvd5rhD44PEqPMgUko2jG7sQmbWo+nGcJT/mJG6cWtJVxu5zXGHGCkI7XfMp378l9kmfWJwbTfsWD/QMdBeVPWittrHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cWwadyIO; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cWwadyIO"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-717b580ff2aso51342837b3.0
        for <linux-raid@vger.kernel.org>; Tue, 12 Aug 2025 01:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754988617; x=1755593417; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K6NRFxO1IfXa8fexs0oRFsGFxaMGo/oO1tFRPKUaYN4=;
        b=cWwadyIOpic0H76A+LMurBbFU9/DhmjdYRjXd1vRhFs5y2iICOxvHn4VPJEpSZx8Co
         NW5Rzu2IwyiX/QmFHbhV3/b14DA8UXjfojBthBKiVcz6z77nYeLAsIM+X+ILPmHtU/30
         yRN5ScR4lSmiKjk8YxKHnvmk3ia9N2n3/CRgcY6TcpR+qGFXPZwtUx6Mife36+Efm+jn
         pQQxN3jaHLQhD42Uk8l48qcv2gApfKSu3zJKn6klA5zvb3EE50bUQcFDRWjO0h1eQisl
         l/eHpmkug93hlM9g/BqUbrTB3guOZhg7nG7+BVQ0oCLSf2DsanVmTu1WlQr1W1B92cl9
         zHJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754988617; x=1755593417;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K6NRFxO1IfXa8fexs0oRFsGFxaMGo/oO1tFRPKUaYN4=;
        b=XlQGSwBU8sWATPO6EXVyMDpL6fQYLX+oABac2DIRKlNw8bMlMcck8+lZ5fU1CQpFQL
         YmkNJiRe1FkZI1OuGXl3XdaYJ4Oqr2wtRYiRIERmmk+CVnDQ2Pc9UdoM7+tY7hRPdFZ0
         WjiClkrW2RCdh0xa66xcyBc8x6tKi+Awjx4RqJTUyhS+y29Daiud0ssjcGHg02pp35gX
         JS7VvNN0H8RCWH8b/rJsK1dYPOKfs7tY7cHu2baYjxjpGvrhj6IqcPeFtMzCATo+ETw6
         PmvIaX4B2++5k05l2mIbDIf9tnL6S0wfcrGFAtkOPODTUiUoPY2RUmG4o93glhjHmBHq
         DUiA==
X-Forwarded-Encrypted: i=1; AJvYcCXrTiMb/xMsO+2aHQDn9LWq8C52oR3Ph7q/J8mFMFOnaaHJHFhjMBbgrmLjk3X/2LXq2xCfEV4pXIjn@vger.kernel.org
X-Gm-Message-State: AOJu0YyLOS/S+hV448/MXDqrIHgsm/PGXRT5LFPU+uSwvlGdfh4vktZ8
	svVnXbgougN5sdaAVB3geTebQK7jsKgYasdlbH7QruBXOenMZasFoWGNknhosxzbDdYXM6BBQk8
	uB+ghAysaKq9bxMOTLjuSb4HJzEvNDzo=
X-Gm-Gg: ASbGncuty8g/MFv/XJyHmVfgzA1a8QJqBeHJaMJ9NyBMkcm/NNSChojOKunAtmtYNf7
	m7aTgK8jeIONii6voXDA+kemYFmzT8CWd7ZmqZ6yDXdwAv+nJV7K96zeWBam+qJEJ8A/k5JaoG8
	UF1u94gAMa4oPxSf4hJ12+bzIFYEpqE8tYIvq1bF91LXGI/iCbz6uuFdNNbFZjyGWje73riAjyX
	u5CNqvUX/n9zkGfLgqseYZiDCktcFMDY04Bg5xyZ3laSw5Q7WAl
X-Google-Smtp-Source: AGHT+IEpExo4eIzC2P1cwfN9bTC575LMbso8PLcBeweTySnWRR1KohZv86gc0ZDnyCacMSgEvRvMS6/B8PGqy8MW8po=
X-Received: by 2002:a05:690c:46c9:b0:71b:6c7b:c802 with SMTP id
 00721157ae682-71c42964ab1mr40266657b3.6.1754988617279; Tue, 12 Aug 2025
 01:50:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <f654db67-a5a5-114b-09b8-00db303daab7@redhat.com>
 <CALTww28TpRRTzjqsOXGoUrLHEk=ca85zRcDanGqgTyytA-34ow@mail.gmail.com>
 <CAMw=ZnTosW4OecBCFdVNqiw9VjSL6msUx6yYBE=9vsEn7JeKqA@mail.gmail.com>
 <8c1bf191-a741-cd7a-29dc-babf24a13777@redhat.com> <CALTww28y-cuJMAGfWjgVdjhkFB8w-z7SR48nNvdRHM01L0TGow@mail.gmail.com>
 <81648e41-fe3e-1be8-2e0e-f1f5c39564cf@huaweicloud.com> <CAMw=ZnQ=ET2St-+hnhsuq34rRPnebqcXqP1QqaHW5Bh4aaaZ4g@mail.gmail.com>
 <CAMw=ZnS+2oqGZ31wkMEFheXi_8xk1hSM1tnW=wh_wc98TGDrXw@mail.gmail.com> <CALTww2_ot_qAGwnfQDfRSj6qtaAME1ZA27XgtL_L3pfT_WoWRw@mail.gmail.com>
In-Reply-To: <CALTww2_ot_qAGwnfQDfRSj6qtaAME1ZA27XgtL_L3pfT_WoWRw@mail.gmail.com>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Tue, 12 Aug 2025 09:50:06 +0100
X-Gm-Features: Ac12FXzyPhYbqe3eraO6dzPqWDLCtBsARxcAoJliyXDzUe1Ixxvmjvg5lBUanS4
Message-ID: <CAMw=ZnQ_Ba-hJ0rzxZfU2dERk6E1Vhw5T5CVNT_KZ9qW9P2_nQ@mail.gmail.com>
Subject: Re: md regression caused by commit 9e59d609763f70a992a8f3808dabcce60f14eb5c
To: Xiao Ni <xni@redhat.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Mikulas Patocka <mpatocka@redhat.com>, 
	Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, vkuznets@redhat.com, 
	yuwatana@redhat.com, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Aug 2025 at 08:40, Xiao Ni <xni@redhat.com> wrote:
>
> On Tue, Aug 12, 2025 at 2:32=E2=80=AFAM Luca Boccassi <luca.boccassi@gmai=
l.com> wrote:
> >
> > On Fri, 8 Aug 2025 at 09:07, Luca Boccassi <luca.boccassi@gmail.com> wr=
ote:
> > >
> > > On Fri, 8 Aug 2025 at 07:40, Yu Kuai <yukuai1@huaweicloud.com> wrote:
> > > > =E5=9C=A8 2025/08/08 13:28, Xiao Ni =E5=86=99=E9=81=93:
> > > > > I know it's not good to break mdadm by a kernel change. But somet=
imes
> > > > > it needs userspace tool and kernel work together to fix a problem=
,
> > > > > right?
> > > > > Sorry for bringing the problem, and thanks for the suggestions. A=
ny
> > > > > more good suggestions?
> > > > >
> > > >
> > > > Idealy, we should fix mdadm first, then after a release, fix kernel=
.
> > > > Sadly the transition stage is missing now. :(
> > > >
> > > > If we want to just avoid this problem in kernel, what I can think o=
f is
> > > > adding a switch and mark it deprecated for now. And in new mdadm
> > > > releases enable that switch, and after sometime, remove mdadm legac=
y
> > > > code to stop array, and finally remove the deprecated switch in ker=
nel
> > > > then everyone will be happy :)
> > >
> > > Hi,
> > >
> > > As long as the change makes the current default behaviour backward
> > > compatible, and the switch is used by mdadm to opt-in the new,
> > > incompatible behaviour, then yes that sounds like a good solution,
> > > thank you.
> >
> > Hi,
> >
> > Any update? RC1 was released with this regression. Any ETA on the fix?
> > If it won't be ready soon, would it be possible to revert the change
> > for now, until the fix is ready? Thanks!
> >
>
> Hi
>
> I took two days for a regression test and sent the patch to the mail
> list just now.

That's great news, thank you!
