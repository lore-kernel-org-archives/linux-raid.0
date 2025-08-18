Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E7D286D50
	for <linux-raid@vger.kernel.org>; Mon, 18 Aug 2025 09:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755509601; cv=none; b=oMT+aCKkphvBbBiXs7MrF89lYguVNfEOBCNQf1oyMR3WcR+5I02aFpDGkVFg4rhDTyeBFqDQgKJCf2DmlpAbcoNCE4tDjjCNo/Y3IGfwGSN4Ljjp84BY0E4TITxfbb1zezoxYJ3OF5nU+5YwZ1KweDJgUDDJuowC4eSrsoc2fGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755509601; c=relaxed/simple;
	bh=uSLvRTu4hGR1au8Vdf0mxF1w61739uuAIZBq39PdzcE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IGTdQW3G5V8yZQ6iapgfqmwylwfPVOT9vCKnbhMK8Lblj5sU9FmlHC94iTNEVK12vdMPJDczTdo0c8m4WCvjnKk/MjYg+Ifs8Mdel2MTQRTkulcGDx6X6B8RALT3eWQCz8XWKHVELfEM17E2Q95k7SvUVUte7ARHc2LuZN72KwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nrsAAiYN; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nrsAAiYN"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e934c8f9751so918869276.2
        for <linux-raid@vger.kernel.org>; Mon, 18 Aug 2025 02:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755509597; x=1756114397; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0eHSFHZrKP4jaobZBRQX8mr++BZnfo6OLyOCfPO2sJY=;
        b=nrsAAiYNfKkVswmk1/vk3VtdDi0c/EO4wxeDJltoinj7ZzoEYY7CcAzcBuNsRoV5Bz
         kvgwV+5JAP8R1lnEZWfQsubFpNlhEZI+2ZKq1QBbkrBiMLtL6JLaAAqR7b/Qsg75HpGG
         ZwVjb+CHXZH0k2f+QgxOO5mbav0JK2tNWrHz1iID3HuUxioMZl6yUIk7TuQwVDHEYoJ2
         fknLiQpG1KFrOcSorDkc6JYxnwZkm7OCEekF1tjaYQ/ZaqSZL9pS0wMI70i3VljW7nMM
         qA4aSHfBANSHyHLLv7vBCTKUxOsPLuFS1ZmBR9AiVJ2WrjOYaY73uSXTkXwKJ6xTJfnX
         A0Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755509597; x=1756114397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0eHSFHZrKP4jaobZBRQX8mr++BZnfo6OLyOCfPO2sJY=;
        b=KRC9d/M/VIPfmXcdkHnuSJ6YBfjBDFvtEoM9A8izyJe9QT4tb1QcflE20NTw/IR6Tl
         zeCAAGbtjCp/wYHu1Q2SLWeKczhtrkX8yRSezP1A5a8RfwCkZh7DklfBiRl8VTU4GoUl
         t3f8ET60KMmEGABkL7MCxbP/WFOtXTz+DOFMgQIWWiGT98Mv64vP0FckCCqYfAg8+sMJ
         Ll52w5pOKjIpkNmro1Z8okrKGcrgxZSfdM216Iy4KsCGwi/WUTI6Ej+pQzAwSCGfIhcC
         ltpLe+tKY1OKigZ86zTsrHNCsHfcX6RqnubUuZojwYBqpYnTOM+M2lvRDoW+Udyyv2e4
         N+eg==
X-Forwarded-Encrypted: i=1; AJvYcCX94tZg7AJby8yf4yaOkSfPHx2iZ1fnP7AhYPKWZHVRVHbsQbZj24P7eSbkpO9fcKEy2t1OYTFe1J0V@vger.kernel.org
X-Gm-Message-State: AOJu0YwF9hJZRp88kBP9EgzdD7SIfdAe81jYoryvSg1M2sLiEoe35LRB
	CzS+iCsOOOYU/yFVcY5v1CyUFN03M4fDhRTOP+Djqqe73zY+sUd0s8+v43hXBoYXp7bd8eHe5sW
	l+tujgK9mAb9eqKLjHvc5FtvieY4FLXs=
X-Gm-Gg: ASbGncsgS8LKzEm3pGREq2TIsePq0SCQWjyB/D5buPojoBNI5jgVy4+va678VfXXj8H
	dttcBVgCeYtoinJc406WWLUMAjJaKAkmXcI4tFyUzRjEC3sDbSMirBuVKvxjg55l8pIa16/ylZ8
	NIAWLC62VhbxuW03QalTNd/3fzcqbCpJDtJef4LR4qFmdeJiIlr4mYccCw1BvWmpJb2zVrsK/AJ
	6Q8pO4fSkxGlpqhppE0DXock+Alal68IZBOhEp2dwVrbu32Ch8=
X-Google-Smtp-Source: AGHT+IEPB8o9xAcZz4tY+f/8HHja8PvD6Ylq4PQFffTV1PzmHUy+YabDvdMswMApIWGCfCP52N2KUGZFy4Z5SrUVKRI=
X-Received: by 2002:a05:6902:3308:b0:e93:3d4b:40d2 with SMTP id
 3f1490d57ef6-e933d4b420amr8635894276.15.1755509596679; Mon, 18 Aug 2025
 02:33:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250813032929.54978-1-xni@redhat.com> <e193fc4b-994f-8261-a7de-8fd8008a9bae@huaweicloud.com>
In-Reply-To: <e193fc4b-994f-8261-a7de-8fd8008a9bae@huaweicloud.com>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Mon, 18 Aug 2025 10:33:05 +0100
X-Gm-Features: Ac12FXzXPYET-TuNGRFoCy65NLkS-A4BYyyg4GgcwnbCwg9681e2_LxOgVkjFoY
Message-ID: <CAMw=ZnR0HyaeG279BZybnJ9zYD5LbnjKS=U4Gc0w5bBs=i38BA@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] md: add legacy_async_del_gendisk mode
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org, mpatocka@redhat.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Aug 2025 at 01:54, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>
>
> =E5=9C=A8 2025/08/13 11:29, Xiao Ni =E5=86=99=E9=81=93:
> > commit 9e59d609763f ("md: call del_gendisk in control path") changes th=
e
> > async way to sync way of calling del_gendisk. But it breaks mdadm
> > --assemble command. The assemble command runs like this:
> > 1. create the array
> > 2. stop the array
> > 3. access the sysfs files after stopping
> >
> > The sync way calls del_gendisk in step 2, so all sysfs files are remove=
d.
> > Now to avoid breaking mdadm assemble command, this patch adds the param=
eter
> > legacy_async_del_gendisk that can be used to choose which way. The defa=
ult
> > is async way. In future, we plan to change default to sync way in kerne=
l
> > 7.0. Then users need to upgrade to mdadm 4.5+ which removes step 2.
> >
> > Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> > Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> > Closes: https://lore.kernel.org/linux-raid/CAMw=3DZnQ=3DET2St-+hnhsuq34=
rRPnebqcXqP1QqaHW5Bh4aaaZ4g@mail.gmail.com/T/#t
> > Suggested-and-reviewed-by: Yu Kuai <yukuai3@huawei.com>
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> > v2: minor changes on format and log content
> > v3: changes in commit message and log content
> > v4: choose to change to sync way as default first in commit message
> >   drivers/md/md.c | 56 ++++++++++++++++++++++++++++++++++++------------=
-
> >   1 file changed, 42 insertions(+), 14 deletions(-)
> >
>
> Aplied to md-6.17
> Thanks

Hi,

I noticed this bugfix is not in 6.17~rc2 released yesterday, will it
be in rc3? Thanks
