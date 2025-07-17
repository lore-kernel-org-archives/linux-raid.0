Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5EC7E9;
	Thu, 17 Jul 2025 03:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752722258; cv=none; b=TDu+OxtPnzubwxydQEvpvHP7L4WchE8X2bWPchKRH7jhsGdnU8ThlFEYmCdV+0jlcOj7yQj51yDaECRZ0sJkPWMRlHulAjkNP9nRVF4Wf7hGIpgMRjx+X0+ekJujSL36MVWkuLqfSemZEMf+/ePmONp2CJ8c+BuWoYjSRuexMbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752722258; c=relaxed/simple;
	bh=WusgH3dhrq8o8RZGjanwI00GxPk73ywG8x/Q2OsBZPE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sPDZaifRh9YzPJkGiWtkkC64a3kUd6QAIolsnPpRXlAbeB1PTvFmmRay1dpd43/R5Yf2HZVjI31uBgMOwaq1eyK6CpqXgHotpHa8WNQ9NwP2I7IdtlnUMYgVvJ4xGkIJhZiVNUv3HY6XMW9suXx1QfYWPWZeyJmEF6aC482LWGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BlwXPpP1; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BlwXPpP1"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-61390809a36so144421eaf.1;
        Wed, 16 Jul 2025 20:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752722256; x=1753327056; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Y81AqTyJAgC90px8z1GDMnTxobUHSoeR1l3JmPgATFQ=;
        b=BlwXPpP1GjKDqYQ14emNHnmbAWs/Fk4JyxoOalDEK8YPJWJA+CQsE21XMU2wb8TOl2
         8+/6wNP/gcRYZ1F41be/3/SY8ZdYHNQnWHBxK3jogMI6JmWjGlStH9+JnqUx7GyrvWJy
         h89z6ew35tEyWuUVN12rKRXG1ej7klYX2Pjhp/6SeYwZSAvL4TJJzJ3aDWvgUOcBDrIW
         Fccu8xLkaFgg68/S7TG5bpvIdGzhTojRDWTVij6aUwYpcAgw4qD2rc58e+tbQ5oEWKn0
         Eg+Xu5mcJluuoR/KBNDH1h4cSZVY01xczE0f6fPj5wfZQigziWSaXrda7xzpyi8pIB+X
         Gsfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752722256; x=1753327056;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y81AqTyJAgC90px8z1GDMnTxobUHSoeR1l3JmPgATFQ=;
        b=Z79tmJIJLmSBLaRfDRRvyVCwDiS/iVav3WN4IVXus8LXVlSn2V+/59XNvq9rmFcTKp
         BkJMaU+bbPeo3eRbZSIfdjKDcw1MtaWaV6cD1BIB1OJ2YW2NB+nrF6mVPA05LKbTzp0m
         EQFbgFy4iZPNyWeR6WzBaNS6/+yyomIeBsHopk02+uhEHE2NLTfsJwCD5fWxTSKD9aOk
         CrlCo93mjpADfs4tT3ym2Kedq+0xAiJkhYp2kuKdqnbM2/Ob53xUk3eFjFWJd+7bOZsn
         QAPUGb2lJrAU1nTb8gEjM9We0z0fMoa3k+YQFdHcRmoJxR66VdMhojMx2PZiz8tO82hA
         +jZg==
X-Forwarded-Encrypted: i=1; AJvYcCU4siW8fIfZ//pv++Ln5UZr0pxs8GR03Rdc+NCFyTnR8CV6glwlWPhSos4AkiPA3v6EEONfdrYHN0xHfQ==@vger.kernel.org, AJvYcCVq4iJbitt4MgCpBM9qidFd+hwOv1n0sCBN83M0fzIbICgZjI8qjwi9fViRH1Stc23wjHwMYRvrEIA4pok=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywoz5yFsF+khuXRTgI9H9RDKhcFQETaM1YhgcXzW3GNYx8BzFtH
	FjaVMbcFGfNG2CM0HLh/NN8deTus/D+EfqIeXj5qjIbQk0b8070ZT51ye26wyxl34bmcG23dhxp
	u7xIU/c85e6ywc8tHI8blHjjEgQcHGhw=
X-Gm-Gg: ASbGncsaNG/NZceTmOh7NX9TAEahLpy8ja0/zBZrAxnWhtxp2dFcRiluDnSCRyRlinS
	Ku3JDlNiimMWErzbudpX+frp/IyyVvX1dcO3XdMNpJAOXtOe2MV3Jsl4ZPckGo/+TppinNp12QW
	WvgSgdWJtLBlTnRVEOSmNc7RHMgErc0//+PEI1TWKC8mTd6ZLtq39hgbpd4yMpDWdDBGFIONllt
	q2IuCIu62WHynO1Whgh4w/bIb6eVazRdHU9V6E=
X-Google-Smtp-Source: AGHT+IEtivipB9g5w338UTRAKjaClj6lUtcIUZrPdJL7TzeqNtyLNmcxsaTO5OsL1EPNBz4plqK1kSPLlVSgIdEoJBw=
X-Received: by 2002:a05:6820:2d0c:b0:611:4701:bcd2 with SMTP id
 006d021491bc7-6159fee52d9mr3917716eaf.6.1752722255686; Wed, 16 Jul 2025
 20:17:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250711100930.3398336-1-zhangchunyan@iscas.ac.cn>
 <20250711100930.3398336-4-zhangchunyan@iscas.ac.cn> <69e3f295-3b43-4a13-bb84-3f9a89171331@ghiti.fr>
In-Reply-To: <69e3f295-3b43-4a13-bb84-3f9a89171331@ghiti.fr>
From: Chunyan Zhang <zhang.lyra@gmail.com>
Date: Thu, 17 Jul 2025 11:16:59 +0800
X-Gm-Features: Ac12FXzbOyvDEa_I8t7LghI6yF9EP3lV6Llna9xJ2JKwX9MGZBvjrNJNq1DOr7g
Message-ID: <CAAfSe-vMGzJOwnTyo-O6WKZmHLY=FMBEVde6h=j52W+cSOwSaw@mail.gmail.com>
Subject: Re: [PATCH V2 3/5] raid6: riscv: Add a compiler error
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Chunyan Zhang <zhangchunyan@iscas.ac.cn>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Charlie Jenkins <charlie@rivosinc.com>, Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
	linux-riscv@lists.infradead.org, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Alex,

On Wed, 16 Jul 2025 at 21:43, Alexandre Ghiti <alex@ghiti.fr> wrote:
>
> First, the patch title should be something like:

Yeah, I've also recognized the phrase is not right when rereading
after the patch was sent.

>
> "raid6: riscv: Prevent compiler with vector support to build already
> vectorized code"
>
> Or something similar.
>
> On 7/11/25 12:09, Chunyan Zhang wrote:
> > The code like "u8 **dptr = (u8 **)ptrs" just won't work when built with
>
>
> Why wouldn't this code ^ work?

I actually didn't quite get this compiler issue ^_^||

>
> I guess preventing the compiler to vectorize the code is to avoid the
> inline assembly code to break what the compiler could have vectorized no?
>

This states the issue clearly, I will cook a new patchset.

Thanks for the review,
Chunyan

>
> > a compiler that can use vector instructions. So add an error for that.
> >
> > Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> > ---
> >   lib/raid6/rvv.c | 4 ++++
> >   1 file changed, 4 insertions(+)
> >
> > diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
> > index 89da5fc247aa..015f3ee4da25 100644
> > --- a/lib/raid6/rvv.c
> > +++ b/lib/raid6/rvv.c
> > @@ -20,6 +20,10 @@ static int rvv_has_vector(void)
> >       return has_vector();
> >   }
> >
> > +#ifdef __riscv_vector
> > +#error "This code must be built without compiler support for vector"
> > +#endif
> > +
> >   static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
> >   {
> >       u8 **dptr = (u8 **)ptrs;
