Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807EF3B7AA;
	Fri,  8 Dec 2023 18:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I8hmSMa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147B8C433C7;
	Fri,  8 Dec 2023 18:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702059084;
	bh=+F+CuKHjMhjOaVmDV9U/s8l7zrO94PrksbiVe6XkcXg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=I8hmSMa+C7BeWc+f7WDx935Prfc4M1k0zk4ffWscm2PljjTOt0YXZQ4pjXhyOZL+n
	 6tMZItugZ/qeVB9J8ejMkOacIJ4C9pkdIl4+NCxC64tIjKs7WhiXuXsGVnctSrKq7y
	 4VTihcYiZQ6e8ZDoLfJIJbWZw/vrH6aKhk9IHIxZddiNAlCLQfhIYAWL+DIhxF8Cx4
	 GWN0G3tF5PuvHjfUr7bSmaAcoxCaFjgtQotOsypI6a2JCPqQVFJKJTwL9yh6lSmvNC
	 FISt9wiMGW1IqTehrbAqq6iPxMFZUrigeoB2+/eQWHnM33OXIycIcYLUGJM9AHgwyE
	 uaDSbIbhT22iA==
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-50bef9b7a67so2667226e87.1;
        Fri, 08 Dec 2023 10:11:23 -0800 (PST)
X-Gm-Message-State: AOJu0YzTtvpOekWdghHpxMcD75XJJxIWQVle6BVF3Xbik70nts38CDqE
	o97sBDjhZ7aTvERPV0cRATziKCPY/XSQwQX5Zhw=
X-Google-Smtp-Source: AGHT+IG6LJR5y7Arr5OwpIwgsyoV0O6bDJv5rQ3+/wPqJVZq1OA5HIuoJtYWlq5B7EYjpwpdlv5oQAchTUPCPjAGzKw=
X-Received: by 2002:a05:6512:488d:b0:50b:e750:dd99 with SMTP id
 eq13-20020a056512488d00b0050be750dd99mr142687lfb.38.1702059082273; Fri, 08
 Dec 2023 10:11:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <03dd7de1cecdb7084814f2fab300c9bc716aff3e.1701632867.git.christophe.jaillet@wanadoo.fr>
 <202312041419.81EF03F7B7@keescook> <CAPhsuW43g-M+xvzD0N1JsJ_zGnvZQOw2Bi1TEqoHKanPnvMHLQ@mail.gmail.com>
 <202312080926.FBF7A2DDD2@keescook>
In-Reply-To: <202312080926.FBF7A2DDD2@keescook>
From: Song Liu <song@kernel.org>
Date: Fri, 8 Dec 2023 10:11:10 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5F1aRrCRW-ad5Sq=cgxHX+QgXgYZyMX17Zj4Mj=Jnhjw@mail.gmail.com>
Message-ID: <CAPhsuW5F1aRrCRW-ad5Sq=cgxHX+QgXgYZyMX17Zj4Mj=Jnhjw@mail.gmail.com>
Subject: Re: [PATCH] md/md-multipath: Convert "struct mpconf" to flexible array
To: Kees Cook <keescook@chromium.org>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-kernel@vger.kernel.org, 
	kernel-janitors@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 8, 2023 at 9:27=E2=80=AFAM Kees Cook <keescook@chromium.org> wr=
ote:
>
> On Thu, Dec 07, 2023 at 09:33:17PM -0800, Song Liu wrote:
> > On Mon, Dec 4, 2023 at 2:20=E2=80=AFPM Kees Cook <keescook@chromium.org=
> wrote:
> > >
> > > On Sun, Dec 03, 2023 at 08:48:06PM +0100, Christophe JAILLET wrote:
> > > > The 'multipaths' field of 'struct mpconf' can be declared as a flex=
ible
> > > > array.
> > > >
> > > > The advantages are:
> > > >    - 1 less indirection when accessing to the 'multipaths' array
> > > >    - save 1 pointer in the structure
> > > >    - improve memory usage
> > > >    - give the opportunity to use __counted_by() for additional safe=
ty
> > > >
> > > > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > >
> > > This looks like a really nice conversion. I haven't run-tested this, =
but
> > > it reads correct to me.
> >
> > Agreed this is a good optimization. However, since MD_MULTIPATH is
> > already marked as deprecated. I don't think we should ship further
> > changes to it.
>
> Hm, that seems like a weird catch-22 to me. I would say we should
> continue to improve any code in the kernel that people spend time to
> work on, or we should remove that code entirely. Should MD_MULTIPATH be
> removed? How long has it been deprecated? (We just had an LTS release,
> so doing removal now is a good time...)

We marked it as deprecated about 2.5 years ago. But to be honest,
I currently don't have a plan to remove it. I guess I should start thinking
about it.

Thanks,
Song
