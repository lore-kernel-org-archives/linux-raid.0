Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD171A9F99
	for <linux-raid@vger.kernel.org>; Tue, 12 Aug 2025 07:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754984431; cv=none; b=OZKUwemZNc95Po643XDoEOilmlFro0VPPCqQvjm30zBu3IHsBNZKM7yo+3YD96Vc3lgEUegSqVWpE1pQEIPW64KPR/mh5E7QUWd1ECsv9vcwO92W8Ub5hWn6vrA3tw3Ho5W00/QNxqTjTqKjXPHc+SndIsEBVBAAL0vw3Cw9VoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754984431; c=relaxed/simple;
	bh=BxBy2FvXKxB6jqStrH2LVVMkBcBJbyuwZAt7rSJBYVc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JuS0SI3RW1Lp02LFnjNHhOpGZQNAG7EEwi0RFOiBzYZw/YFiQLtz56eo8pYDDlHltDCJ1CYVQEcgH3EwThmz2v9/PW+dtl82BCYTe6fnymf+x+WJfkca65yPsK8kedIq4yyAuvaoeLnu0ReNaTa/4HNg4WhtoJEsylwYgiwQ2VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IhMGhEe/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IhMGhEe/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754984428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BxBy2FvXKxB6jqStrH2LVVMkBcBJbyuwZAt7rSJBYVc=;
	b=IhMGhEe/dttwj3ITyjJXetof8TUZsXkQS31cqucTFPhRHS8OSqnmR2Uj/KxHoEpctptb97
	ZVreX17aJqLnyAzv+Az8MmOEMr246TwB2CdOW4/HO4RMsucu6VkQ80cQHSJ46aV24kH4bB
	sGX5sautd73gkhOq2QbdS1OcChjvaUo=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-n_9FtgZyPu6E3lACKCodyQ-1; Tue, 12 Aug 2025 03:40:27 -0400
X-MC-Unique: n_9FtgZyPu6E3lACKCodyQ-1
X-Mimecast-MFC-AGG-ID: n_9FtgZyPu6E3lACKCodyQ_1754984426
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-55b91d6fecbso3503611e87.0
        for <linux-raid@vger.kernel.org>; Tue, 12 Aug 2025 00:40:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754984426; x=1755589226;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BxBy2FvXKxB6jqStrH2LVVMkBcBJbyuwZAt7rSJBYVc=;
        b=j+ymfI3S3pY+8iV/okVj+G4tcGjtupMxD80nUD3ribkZeRyad0ZWWi72JPplXrVSR/
         O0Z77Bu+1qtYomlPlgyzNbpKW9cyCxD20SpxbXw1EPPhZSCfTEKSul8FrRQmLRwFXu65
         AYhCqeE8R7mVmmmrDsjUOw775a23BrTkcWWI8qhVy5aY/S05qY2YXZXI94sTYTb0+2qh
         F6HTvYEifmjqcslME6Os9/uokK6qs5JRLAGfzBd5jZ2liAutG31HGDM1JPZM6zThTBmc
         /quawDaMHtEHI0t+/IBrat3cEO383hWrGCir09mSb6lT9UOSG+IHVj5EuIYvXZt0gLdy
         PnUA==
X-Forwarded-Encrypted: i=1; AJvYcCVArCCPtN/Sn0B5Ies8nV+vVolGoOltUvZdVr9UdkAb0ZYSLVBxbQpm3X6D8Zg8rImDGfvKNle7/GRZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7MNFJT3EA0q9B8Jfomo+N9J+GyJrCKJSWpb00w24gi982aZGx
	YCkyTRygV05i0uw9JXAKaEVOoJ+Qua5usLykkslQ6mzHqzL+t6gaAwtVsVnpvue7b1EbdC+3yNf
	p61wEQz77hrP1r85sIBsm4HojxWwv6F5IRPSlRBGAMEvb40oeIRjOhp1ivvNcWXzBhlMy+KzEUm
	H2JvQHeVUFKHLTp2I9/CteEAWnDrj9C9YWrlE7Aw==
X-Gm-Gg: ASbGncvVHL2t13iJJotYh5BG9/A+8EW+V//mpdW7/mkaOGWRwA/1Kfox0KcYDYQv83v
	rgOV7jXT9+Ah1hbNHbfcLU2w7SeB668uiTNXBRAnh41z+tapdCaoLW3P7acK2ZG42h+i1dCls8b
	LjVxT3RuofZtrIuUvGyTDksw==
X-Received: by 2002:ac2:568e:0:b0:55c:c937:111d with SMTP id 2adb3069b0e04-55cc93714c5mr2643572e87.13.1754984425690;
        Tue, 12 Aug 2025 00:40:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG35tnLtJR2rqaWUxBtH9f82lvMFluyrwzdR5TOKjBviYAVpnea1G87sauL2GR4dWq+NvTr0MFGEB4LIeOixOY=
X-Received: by 2002:ac2:568e:0:b0:55c:c937:111d with SMTP id
 2adb3069b0e04-55cc93714c5mr2643560e87.13.1754984425085; Tue, 12 Aug 2025
 00:40:25 -0700 (PDT)
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
 <CAMw=ZnS+2oqGZ31wkMEFheXi_8xk1hSM1tnW=wh_wc98TGDrXw@mail.gmail.com>
In-Reply-To: <CAMw=ZnS+2oqGZ31wkMEFheXi_8xk1hSM1tnW=wh_wc98TGDrXw@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 12 Aug 2025 15:40:13 +0800
X-Gm-Features: Ac12FXzjkFeLffltiZv6ydrsJB3Kt2fyoma0L1pPq_XjVT3PZ_q718IKVN3L1mw
Message-ID: <CALTww2_ot_qAGwnfQDfRSj6qtaAME1ZA27XgtL_L3pfT_WoWRw@mail.gmail.com>
Subject: Re: md regression caused by commit 9e59d609763f70a992a8f3808dabcce60f14eb5c
To: Luca Boccassi <luca.boccassi@gmail.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Mikulas Patocka <mpatocka@redhat.com>, 
	Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, vkuznets@redhat.com, 
	yuwatana@redhat.com, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 12, 2025 at 2:32=E2=80=AFAM Luca Boccassi <luca.boccassi@gmail.=
com> wrote:
>
> On Fri, 8 Aug 2025 at 09:07, Luca Boccassi <luca.boccassi@gmail.com> wrot=
e:
> >
> > On Fri, 8 Aug 2025 at 07:40, Yu Kuai <yukuai1@huaweicloud.com> wrote:
> > > =E5=9C=A8 2025/08/08 13:28, Xiao Ni =E5=86=99=E9=81=93:
> > > > I know it's not good to break mdadm by a kernel change. But sometim=
es
> > > > it needs userspace tool and kernel work together to fix a problem,
> > > > right?
> > > > Sorry for bringing the problem, and thanks for the suggestions. Any
> > > > more good suggestions?
> > > >
> > >
> > > Idealy, we should fix mdadm first, then after a release, fix kernel.
> > > Sadly the transition stage is missing now. :(
> > >
> > > If we want to just avoid this problem in kernel, what I can think of =
is
> > > adding a switch and mark it deprecated for now. And in new mdadm
> > > releases enable that switch, and after sometime, remove mdadm legacy
> > > code to stop array, and finally remove the deprecated switch in kerne=
l
> > > then everyone will be happy :)
> >
> > Hi,
> >
> > As long as the change makes the current default behaviour backward
> > compatible, and the switch is used by mdadm to opt-in the new,
> > incompatible behaviour, then yes that sounds like a good solution,
> > thank you.
>
> Hi,
>
> Any update? RC1 was released with this regression. Any ETA on the fix?
> If it won't be ready soon, would it be possible to revert the change
> for now, until the fix is ready? Thanks!
>

Hi

I took two days for a regression test and sent the patch to the mail
list just now.

Regards
Xiao

