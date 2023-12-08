Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22164C6F;
	Fri,  8 Dec 2023 05:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N8tLFs81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F38AC433C8;
	Fri,  8 Dec 2023 05:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702013610;
	bh=57Iuychu+Y6HJndFxVGj0xwfUq2O94hJGtPFq6Hs3bE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=N8tLFs818LJj90WRN8s0XJpAyMFajluMii8/dZUCGN26Sp99+yFxIluN2oqv5k1Fo
	 0zK5XjSQFFhqDiI3yabEQaA0LC0bLYo4i5k+kPQknF+u2HeVSC3IbX4OdIKw+sn4OU
	 eKX6+D6u+Bp5/p3tnBRM8NIHK0G0J5CmqKDlGQMOUMixsn/595AzvSSBDMVwBj+r4A
	 QLfUgtZbDpzG8vPUfCEPJ+hEnmM6Wb3l5Xa8/2kXrWQYzLNnbDL/Epcdcyc5OakQgS
	 id9PK+dBcukWAPJP8WLmG0F50J3sErIQQTyaMPVcpMjkws/pKM90WXMmpBqqMPvada
	 YY4i+LlElWWDg==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-50be03cc8a3so2090305e87.1;
        Thu, 07 Dec 2023 21:33:30 -0800 (PST)
X-Gm-Message-State: AOJu0YxC7vgwggckZWPC56gyuPTxQdk6shoKUrjONZ4KV2i4/g66+EP+
	WFeaLzMsekthuRUWIdcbghZ3VSWqSfCz4XmmMjg=
X-Google-Smtp-Source: AGHT+IGrWYKEARpYyha5a0BZLMItMM50RLahl12IkQVgDAvW13+O6qc+CP0Wak/gkrsYjmUNkbytn6ssAaOvZubz3jo=
X-Received: by 2002:a05:6512:12c2:b0:50c:1bc5:6a65 with SMTP id
 p2-20020a05651212c200b0050c1bc56a65mr1563713lfg.53.1702013608490; Thu, 07 Dec
 2023 21:33:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <03dd7de1cecdb7084814f2fab300c9bc716aff3e.1701632867.git.christophe.jaillet@wanadoo.fr>
 <202312041419.81EF03F7B7@keescook>
In-Reply-To: <202312041419.81EF03F7B7@keescook>
From: Song Liu <song@kernel.org>
Date: Thu, 7 Dec 2023 21:33:17 -0800
X-Gmail-Original-Message-ID: <CAPhsuW43g-M+xvzD0N1JsJ_zGnvZQOw2Bi1TEqoHKanPnvMHLQ@mail.gmail.com>
Message-ID: <CAPhsuW43g-M+xvzD0N1JsJ_zGnvZQOw2Bi1TEqoHKanPnvMHLQ@mail.gmail.com>
Subject: Re: [PATCH] md/md-multipath: Convert "struct mpconf" to flexible array
To: Kees Cook <keescook@chromium.org>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-kernel@vger.kernel.org, 
	kernel-janitors@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 4, 2023 at 2:20=E2=80=AFPM Kees Cook <keescook@chromium.org> wr=
ote:
>
> On Sun, Dec 03, 2023 at 08:48:06PM +0100, Christophe JAILLET wrote:
> > The 'multipaths' field of 'struct mpconf' can be declared as a flexible
> > array.
> >
> > The advantages are:
> >    - 1 less indirection when accessing to the 'multipaths' array
> >    - save 1 pointer in the structure
> >    - improve memory usage
> >    - give the opportunity to use __counted_by() for additional safety
> >
> > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>
> This looks like a really nice conversion. I haven't run-tested this, but
> it reads correct to me.

Agreed this is a good optimization. However, since MD_MULTIPATH is
already marked as deprecated. I don't think we should ship further
changes to it.

Thanks,
Song
