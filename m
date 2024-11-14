Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD991FAC40
	for <linux-raid@vger.kernel.org>; Thu, 14 Nov 2024 12:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731588877; cv=none; b=cNyMMTFHEo8PK9HABJmTWG3OBlYwUKla44Wa+e5vpL7bbT52MUEvZqUiS3/w3V4/rL79nNZ99X5O5NkCHCVWY9ILW24AG0qTG7Yw/aWbH1C37/zUhI3+BUNind5GBu7KnWm6XmZUNyBl2opM1857PCynrp7zLemvhNSKm7JG/8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731588877; c=relaxed/simple;
	bh=nwg7bOzpiJ59znEn9jOmH7iVb/nkveDkp2lPdI7Foao=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mpokkuqr5NY7DcJ4y983jKDxULjbs5qXeMbOdVK1Mv3RcHznhC7++Xa4bbLKepK7fAxsYHsc1JrGoZlJzgc6yIxRkvKkvlqMNSx8YOZwu5sq44kaD+EL0c2gJoni9oQOOpm1ldKzHUlMxXpTSbxgXquWa//xrkg/n29XLIjZAXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=YVdkfefD; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="YVdkfefD"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5c94c0bf354so77981a12.1
        for <linux-raid@vger.kernel.org>; Thu, 14 Nov 2024 04:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1731588873; x=1732193673; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oLO5MOFbDKX/JRBEDlQ9968ZUw6CoMmaw3WCv5/Ymwg=;
        b=YVdkfefD4FfSpXl4JPgOE5HVRY9d7UJWZlDyiry7O6L3rt9UIyWS+2JUp1INar8t5y
         zYowhUPJNj0mXaKhhrrvc68juKHEVCjT14cm6rYEWp96X66CGPJUiwuLxJKdnyLuH8KA
         rEQG+cdI7Dr8FgLh4qzik2oKoroFN0IohmJtBMdBNdg2uHrOCiudPuV7hMFuRJgehQE7
         g5ZBpCG7GydSHH/T1rpTMSs2gbyADDt85l778hE3HhiiKPvMXNRRSbCHqY1IpQRYfhlr
         2bvEJB/WG196Z13+e4MSdDRetFEP0GmHIZvN4Y6Tt7CHVU/eVWtBzuWlF7P2BHm6t8EC
         evlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731588873; x=1732193673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oLO5MOFbDKX/JRBEDlQ9968ZUw6CoMmaw3WCv5/Ymwg=;
        b=ZhSXAVqcuTmS6Kx/GcZso8UwCS8nn9a2yRvx9GLXqsmBqppXKapVr52nGi93pf87k4
         qB7P2GBlp3UIoN49WaIi9Hluqf49P0Yq3PAcx04Vmwywz7JOIJ4faxIRw3n3xBpLu8Ow
         ExWQFRw62V/vgCplGOEjdnK2QMDM/ovzrhm4oEBx5DyIsLj0QMwns+2CKF8mVsYo0lLe
         6R95sBboZRs0AE9JmI5zVef1mc9ZOCuNi1pkcACURrX3R6nf3GM43RR1W8oh/nAhLoUK
         N9JZ4pGJGvrByJre4yjjBcpBcS2iaNfL7ZBAI4lBNCCd9MJh+we8/Eonh5oShXj2bVbj
         P6Rw==
X-Forwarded-Encrypted: i=1; AJvYcCUVXRm5Az7K7Km4Ci0eRoapFw9BNCf6/P2HMO0BusONjFkVKbjZkQnJBE+eTPFQ0pY/ZOqbKuQ8WroP@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3tnUoKGh3eUUfR01uLqhsl3MhJPbCjNDi4d0Gi/E1OC3n6el4
	c1Q8EG3eJAaeAtMbzwRXZW78GV9Yj8/EQ+hHL73qqsYx6lXxdEX/OIQMLqU74Ig0Z41q3KckOVT
	XaNTortgcO3fKc0dmQ0XprdhXfL6yY7TYzcHNdA==
X-Google-Smtp-Source: AGHT+IHYKKzc3dMtaCp8Lgj4q8vp9BU1WJGvZJ3AMA6Se33dwjmxYU21TjZXi8hK2/IIT7zBJYmRoycaJnz0kVl7E1c=
X-Received: by 2002:a05:6402:5213:b0:5ce:fa24:fbaf with SMTP id
 4fb4d7f45d1cf-5cf0a45c722mr7749999a12.9.1731588873093; Thu, 14 Nov 2024
 04:54:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com>
 <CALtW_ahYbP71XPM=ZGoqyBd14wVAtUyGGgXK0gxk52KjJZUk4A@mail.gmail.com>
 <CAJpMwyjG61FjozvbG1oSej2ytRxnRpj3ga=V7zTLrjXKeDYZ_Q@mail.gmail.com>
 <4a914bc9-0d4e-e7c8-bed8-7b781f585587@huaweicloud.com> <CALTww297-iYB1m2Y0_ceHn1Y43nB-RZdw67QSm6zWZ3hGEtkig@mail.gmail.com>
 <CAJpMwyiR3B0ismDXXyqS-HSzyiiVDj7YYE85m91oDvB9apnB6g@mail.gmail.com>
 <8f7173c6-8847-129c-c5ed-27eb3b8a8458@huaweicloud.com> <CAJpMwyjPcLQ=HF5EOXgQFOy=bGHLDWZQJ5CwUV0UHMnyeSPM_g@mail.gmail.com>
 <fb9db285-dff0-681c-1dcf-7f01350ccb48@huaweicloud.com> <CAJpMwyi8v2LvdVG2nJ-aJOHDpw79tcwGfPbgV--4xH67NC2B3Q@mail.gmail.com>
 <3fbe69c8-375c-c397-d40d-bc26d4aeda1a@huaweicloud.com> <CAMGffEnSJ9KMtB8O4x7Mzyvt4X53CHDMHi9WArGecjOhjh2dTg@mail.gmail.com>
 <6691be8d-994f-b219-213d-26557c258559@huaweicloud.com>
In-Reply-To: <6691be8d-994f-b219-213d-26557c258559@huaweicloud.com>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Thu, 14 Nov 2024 13:54:22 +0100
Message-ID: <CAMGffE=BmZJB2orbrP6SiL=vSPz8E0JZT6OeFb7tNONCBepUEQ@mail.gmail.com>
Subject: Re: Experiencing md raid5 hang and CPU lockup on kernel v6.11
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Haris Iqbal <haris.iqbal@ionos.com>, Xiao Ni <xni@redhat.com>, 
	=?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>, 
	linux-raid@vger.kernel.org, 
	=?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>, 
	"yangerkun@huawei.com" <yangerkun@huawei.com>, David Jeffery <djeffery@redhat.com>, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 14, 2024 at 1:19=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/11/14 18:27, Jinpu Wang =E5=86=99=E9=81=93:
> > Do you want us to try the following change on top of the md/md-6.13
> > branch without Xiao's patch and your fixup alone, or combine them all
> > together?
>
> Combine them please, sorry that I forgot to mention it.
>
> And for md/md-6.13 there will be conflicts. So try v6.11 is better I
> think.
Thanks for clarification.
I have to chery-pick the following 3 commits to apply clean on v6.11.5

6f039cc42f21 md/raid5: rename wait_for_overlap to wait_for_reshape
0e4aac736666 md/raid5: only add to wq if reshape is in progress
e6a03207b925 md/raid5: use wait_on_bit() for R5_Overlap

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2868e2e20dea..6df5e9e65494 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5867,17 +5867,6 @@ static int add_all_stripe_bios(struct r5conf *conf,
                        wait_on_bit(&dev->flags, R5_Overlap,
TASK_UNINTERRUPTIBLE);
                        return 0;
                }
-       }
-
-       for (dd_idx =3D 0; dd_idx < sh->disks; dd_idx++) {
-               struct r5dev *dev =3D &sh->dev[dd_idx];
-
-               if (dd_idx =3D=3D sh->pd_idx || dd_idx =3D=3D sh->qd_idx)
-                       continue;
-
-               if (dev->sector < ctx->first_sector ||
-                   dev->sector >=3D ctx->last_sector)
-                       continue;

                __add_stripe_bio(sh, bi, dd_idx, forwrite, previous);
                clear_bit((dev->sector - ctx->first_sector) >>

Will report back the result.

>
> >
> > BTW: we hit similar hung since kernel 4.19.
>
> Good to know, I think Xiao's patch alone is fine for 4.19, the
> BUG_ON() probabaly won't be triggered.

Thx!
>
> Thanks,
> Kuai
>
>
