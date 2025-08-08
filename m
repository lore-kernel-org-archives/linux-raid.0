Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D4B274FC6
	for <linux-raid@vger.kernel.org>; Fri,  8 Aug 2025 12:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754656508; cv=none; b=DSgiv55p388HWT7VT44VqwHkrMoJPpfLChrnvt77Bx7b4fPXG1yg8bOIR9dRu4RcO+OUqVFzA1NVLzM8gwJYB/dB9FLUgILSnAxxmMi4xvZjk9ASAmtk6Tayj84n2sGKPNno8/yjK5noXSSEpYbGvBsTXBzQAGyECx5wVln+O10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754656508; c=relaxed/simple;
	bh=6lTY8pfsj/ETOtoANZODXe+lpBDK3HnBm0J81VwhSi4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=uTM7XicDwevK+D0V8yPYU8d99UkUZMd9+ReoDXCm9tK8+Q+9lRGE55QdLoNur46XUqS6G3kkSEU6/Co8QyG95G3w+22r4x2oNyz4s7/zYrr3hUT2nN+bdi6Xg2w7LkmdBcejq4Htt7f5jarV88toATfNsoJYdbzQxTH2D5gIjQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BVClxfb8; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BVClxfb8"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-31f3fe66ebaso2661949a91.0
        for <linux-raid@vger.kernel.org>; Fri, 08 Aug 2025 05:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754656507; x=1755261307; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qOWvwCPMn+7JzbpWV3+p+HWjsF9sBQQvzMYHeT5u1fs=;
        b=BVClxfb8nZ399jZ5uHeDiPijz/usgYrVKlrbfRYYLnazi0y/Ue90YKwmPp8gCW9Pwz
         WhDgX77gu8/WX46ndNdDsNW/5EY+MeSsZYN1sszfEhQhoMQLMLk8o8wBX8YHV+gjA7aJ
         3ck/P0AE9WkMJCVWD9oWXXbmGrQd+K/4KF8VpmZnjXbKaySxnEtSv55cbfgwNn0Pv9aP
         55SvE6I52bxTdW2CGw5FA1f9qAk0FILjeZ+/2Qxyv2OyCzdxFXUo6V2Wt/sgtrlpzRne
         bXWEM5dn+8bir3d6Mrcm3QuVA0IczYeWjRd/ktWGbcYo9PcNPwHVawdbr7J39F9fakgJ
         NgUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754656507; x=1755261307;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qOWvwCPMn+7JzbpWV3+p+HWjsF9sBQQvzMYHeT5u1fs=;
        b=XFoHkXOQxAbHobjDFlnUUW8TF59aOeklBEjInULeeg6bpHeVhQbXKNPu9aPtKxzqzZ
         IsoSfi4ej/R1tjtReA3VqqwfVxyW2bITDU2DKPnfal5qfCVkOFN1rYl9TbrIljB4c4FJ
         1yUCZSJgGdxGK8d202HaY6GYQVhD1/rq4AV/lwvaK5xoYkLyptrnGQ0iZFmZcVE+E16X
         txxI5kPXmmYcDi+rFfMb09pGh744B3S8P39G9adeCpZ4SGZc2u+4+jwy8igYcXtftND0
         wmkRGUJ9BJ9TAsj7SFcNJpojw0IjCubipOV33qUxO5NlJ6V83jsvo59VAXoHGRAdZcDt
         zb0g==
X-Forwarded-Encrypted: i=1; AJvYcCXTKXhpVZiuTsVnsAbajOI4WcFqw/u+ZFjmRfRN9sMKoYiZuerLfpWMuG04bh10ou6g6PiwQAbsqfkh@vger.kernel.org
X-Gm-Message-State: AOJu0Ywxz1GMPYt1K5VmuMIjrCHjhVIYV94u35S377YpJ9gpWICSMz1i
	gcUL2U9e2R7MCb6Tig3U7eEkWcif9UlWernJBm3y2p4EEuqqyeFAuFMKeB/Lk2Zhupd2Bu1nXYo
	WONBd9G5khROF5bsRJ4nJ7haIEJzjDesfV19E
X-Gm-Gg: ASbGncu07VnGjkSu+KL8zhkssmS/Wv+FeKPhby6+X5p2692MCB01UYXbQjPlDdwH8q1
	3zOIZu7hzorWaXwHY24ysRdKhr8F73Y0iB5FJ89YBwJ23VFW/bIrXkV86r5951Nc9EBKwIrfidB
	exCqY5iFdrQJUkVVCep8iEP0mu5s2LUxw5tDyk5LrPwcmlGuUe10h+MNu3QnLh+Pmg903Y35pVC
	6YnjsEfN3L1jiHpOvPp
X-Google-Smtp-Source: AGHT+IFj8TrMhv8vig8/34oGYaNstam56u46MmUIp8TE9uohp9S8/qusZRO1xXQM16uZBJbyHXPc2X217yIJgEDtR+4=
X-Received: by 2002:a17:90b:3c04:b0:31f:14b:f397 with SMTP id
 98e67ed59e1d1-32184377ae6mr4639544a91.1.1754656506683; Fri, 08 Aug 2025
 05:35:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAD8sxFKbdvqruUGv-mr=AOCTyf_s778dqMMdDdNi9nTdgR5F+Q@mail.gmail.com>
 <740d9d0a-1ffb-dd78-598f-1e86953888d5@huaweicloud.com>
In-Reply-To: <740d9d0a-1ffb-dd78-598f-1e86953888d5@huaweicloud.com>
From: chen cheng <chenchneg33@gmail.com>
Date: Fri, 8 Aug 2025 20:34:54 +0800
X-Gm-Features: Ac12FXzVEmYWw-VsyFlq0qOJD_zyvfklUOaAl9Fm-CbAg7vRaQscMGoiYN_RwqY
Message-ID: <CAD8sxFLfC8ieLr03kR8=GBBctY06HF-GSYu=WCN9r4jrMyK6+w@mail.gmail.com>
Subject: Re: md: In raid1_write_request(), when WriteErrorSeen and first_bad
 <= r1_bio->sector , why max_sectors is updated?
To: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Copied, thanks for the advice

Yu Kuai <yukuai1@huaweicloud.com> =E4=BA=8E2025=E5=B9=B48=E6=9C=888=E6=97=
=A5=E5=91=A8=E4=BA=94 09:27=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi,
>
> =E5=9C=A8 2025/08/07 20:57, chen cheng =E5=86=99=E9=81=93:
> > if (test_bit(WriteErrorSeen, &rdev->flags)) {
> >          ...
> >          if (is_bad && first_bad <=3D r1_bio->sector) {
> >                  bad_sectors -=3D (r1_bio->sector - first_bad);
> >                  if (bad_sectors < max_sectors)
> >                          max_sectors =3D bad_sectors;
> >                  rdev_dec_pending(rdev, mddev);
> >                  continue;
> >          }
> >
> >          ...
> > }
> >
> >
> > When the condition "is_bad && first_bad <=3D r1_bio->sector" is true,
> > this rdev device will be skipped and will no participate in io, so I
> > think the following code snippet is unnecessary:
> >
> > bad_sectors -=3D (r1_bio->sector - first_bad);
> > if (bad_sectors < max_sectors)
> >      max_sectors =3D bad_sectors;
> >
> > So I am confused why we need to update max_sectors in this case?
> >
> > .
> >
>
> Becase other good rdevs still have to hanlde this IO, and this IO must
> to be splited to bypass badblock regions.
>
> However, please notice maillist is exclusively for active kernel
> development like patch submit and review, bug reports and discussion.
> It is encouraged to discuss if you understand implemantaion details and
> figure out something is wrong or can be improved, but it is not
> appropriate for implementation specific question like this.
>
> Thanks,
> Kuai
>
