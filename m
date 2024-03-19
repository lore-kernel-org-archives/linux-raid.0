Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4C625605
	for <linux-raid@vger.kernel.org>; Tue, 19 Mar 2024 17:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710869772; cv=none; b=C8R0AWGQh82CJClWplRskKfz0gy+IivspsePwjBN0lS4NfOxbdudM3MtNeG9FSo57sniYOyUKu14M7IoAb7MHlcgLTrApnTIBURu4mVH5hu0BhLKRAhKaV/wcF1BcI4M78bdHbLhixdMANvD59XIbbB7fSQbGn29ro363hF6VUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710869772; c=relaxed/simple;
	bh=hdB+3FuqSuS7PNqq/EekJOO0V2sW38OjoWreqeHNEuA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VuCLM40jMKejF0sQvUM0xSjOgGxXJs5cUkOxj6Xhd+i+5CpkRf+9B/0rl+7uTXtr+pSuDemEuH8fMOrQJYno8yE22QD7WVi9eWGvub3RjLJwcEmMeZHmm00GAjaFZwsBNjEl7hREOfuWkL/BS7K8DXjsjWA6IoV+F7WU7IRyW84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XrOsXtA9; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XrOsXtA9"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7cc01644f51so156922439f.2
        for <linux-raid@vger.kernel.org>; Tue, 19 Mar 2024 10:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710869770; x=1711474570; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hdB+3FuqSuS7PNqq/EekJOO0V2sW38OjoWreqeHNEuA=;
        b=XrOsXtA9M6HTwZ+QL6dNjilGaniqQS7mGSAlcGyYcmAPXuLkaZQ6jn/+Yj0vAyAr0E
         3Uy9xRibytZyLg/fT2JeBI4BCk8CkVqrIMAwhjmBtj48Y2PVGqEtHeib7X8uxfX+uyKC
         nEG+oZiz46eZv87QynKyG6zc0W/jI5Uj2paNQ4hDsF3nA1EC95nT9YTgXu3SvASpgvki
         GNQdvcNCaU2qUMDlBrqpi29MsrV1XhT3SkNSgS/uJiKM2h656GQSL9WVfYwcJ6Mi7+6A
         8fP4oesExGKjdJW/Yue2vXg6BgQvc5roOg8fAorGxXfkHwMZIly34rSJF6uxZGV2t24o
         8g3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710869770; x=1711474570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hdB+3FuqSuS7PNqq/EekJOO0V2sW38OjoWreqeHNEuA=;
        b=AdezwT9EwVFezcAcyYXT8G60HNJV4WFhoWNUZ8dLhHu4y75ZPBKBmOvrWhtyZ9gDc2
         njBbEL4uVghEk2QsJPb/1eJAK9dDO6jv65nniVcEw7pqK8Kd77t67S8S9PKSm+gDpjt6
         st9pbaL/ETCrSCB/C8PXRcI5fjDN4SbkYHXyM5Zs35sb1BsphrcGv0EKfLVvdBlbKcWk
         FL/uCkzTPFYFOQD++M1N8uofzUEkuooA1Eg0rzgfeBgI55DEhZqGLXML0wy2tB5j8Ela
         2URQXPK3GSIYm5FvaLDDd47fdzzEAv4Fv0Nojd9e++iYD+6HVrwlLATRvoeofPwLWo0P
         YXfQ==
X-Gm-Message-State: AOJu0Yybi5O0OZwLk0X3n06pT97EYISjxxOTW4nkeElKSWfWN50+upWO
	sHamCEOEb/6hyPx29dOvIm6uOvkZHdPbcoWqnb8pkWVpwrY/iMMdrl+rYStSQTtSztu6AznlpiJ
	joVLgv/dHx3szhlEcEsqD6EPuvLnSi1CH
X-Google-Smtp-Source: AGHT+IHCC/dFlK1k5czv7qa76xNLrd5Xi2vQYkNJ6KV2pMBxkePZZUqaNA8zjVA6bOGWQNQ8mNLofWNFaSPv1gpGAoM=
X-Received: by 2002:a05:6602:2577:b0:7cc:dcc:499d with SMTP id
 dj23-20020a056602257700b007cc0dcc499dmr3493096iob.18.1710869770329; Tue, 19
 Mar 2024 10:36:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a0b4ad1c053bd2be00a962ff769955ac6c3da6cd.camel@reinelt.co.at>
 <abae1cb3-2ab1-d6cb-5c31-3714f81ef930@huaweicloud.com> <d26f7e96192abbbebd39448afe9a45e2fdd63d21.camel@reinelt.co.at>
 <ae0328a65c8a8df66dee1779036a941d2efd8902.camel@reinelt.co.at>
In-Reply-To: <ae0328a65c8a8df66dee1779036a941d2efd8902.camel@reinelt.co.at>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Tue, 19 Mar 2024 12:35:59 -0500
Message-ID: <CAAMCDecDjUyLJi7QP9cmxOQfnsJdzbYDv70Ed0uB8uuf2Ry6-Q@mail.gmail.com>
Subject: Re: heavy IO on nearly idle RAID1
To: Michael Reinelt <michael@reinelt.co.at>
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

It is possible that for UAS the counters are purely wrong and that no
IO is really happening.

I have seen the perf counters be wrong in a number of ways for a
number of devices and often no one notices that the counters are
wrong.

And since the counters being wrong does not really affect it working
or not this is often missed.

If it is a spinning disk you might try listening to it and see if it
is really doing something.

On Tue, Mar 19, 2024 at 9:09=E2=80=AFAM Michael Reinelt <michael@reinelt.co=
.at> wrote:
>
> I think I found at least a workaround: the strange behaviour disappears i=
mmediately, if I disable
> UAS, and use usb-storage for the externel USB drive.
>
> options usb-storage quirks=3D04e8:4001:u
>
> I am sure that UAS has been used with kernel 6.1, too, where it did not c=
ause any issues...
>
> Ideas what is going wrong in kernel 6.6? I'd like to re-enable UAS, becau=
se UAS is about 200 MB/sec
> faster than usb-storage
>
>
> regards, Michael
>
> --
> Michael Reinelt <michael@reinelt.co.at>
> Ringsiedlung 75
> A-8111 Gratwein-Stra=C3=9Fengel
> +43 676 3079941
>
