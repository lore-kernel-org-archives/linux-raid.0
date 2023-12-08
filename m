Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="J/8eZJQr"
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2E811D
	for <linux-raid@vger.kernel.org>; Fri,  8 Dec 2023 09:27:57 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1d05199f34dso18231285ad.3
        for <linux-raid@vger.kernel.org>; Fri, 08 Dec 2023 09:27:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1702056477; x=1702661277; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Hg6fUEZXStGBp771sMyuxFL70vLJ5BeYI/ptmqsolcE=;
        b=J/8eZJQrQDM9h9GBp+AfyI/b1z5mDYebqC3SXKnipDtex0OzNu0uKwiv/Z8BSQVsNd
         a+ZlnbvYo9jqDhuYJQj22iUTpJzsF9UR+iMBNinz8hEtqGOlGREc5YhW5lfGzzc3OWnC
         xrIJofD9kwr5NSIdzsKD/dicz3JqaQ28UehDg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702056477; x=1702661277;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hg6fUEZXStGBp771sMyuxFL70vLJ5BeYI/ptmqsolcE=;
        b=xTKBxSDzVLdNAF2Dtb5P64FNvWMJA2kNe4mcOywFpBVna1EFAWpq+oilw5Wcm2kki1
         OdXhZhQTYBOfwmz/v5jUZpxYKXtvKfkhsS3qdWQsmukvwT1AUze5okBQahCkQARK+ee3
         5GPvxAms95bsJaZlyi7OxDo8zpbSp1rJdeqfX/xzy2gvBoJyutS8nJ5MxW2pfx3rAzLX
         xP0oGWvmNbXCyMoRxfpO/+xtvH9hnL4moI7Ln+ErEOxfbwh+DoZRGc8yV4F8Zc3zQ62w
         HA47GeL5ZSawayFDqIj3LB6plToFV+RRpa2Exkby9brzMisRstnZavO6EoZ4Um3xP7y1
         xv1A==
X-Gm-Message-State: AOJu0Yw3M2mhnJFmCNEwjhmViTolnK/V7sm7+Q6VaTVqt8rEWxAqDwUp
	59pUwJKplg3aqvf1GJlA5YJkcw==
X-Google-Smtp-Source: AGHT+IHVTw89wrkKxW6H+y85uDNqkr3bSCVArfzo6yB6zlvvZsJ6ez9TxBemFCSY+J8FoNDku+7DiA==
X-Received: by 2002:a17:902:6848:b0:1d0:8383:742d with SMTP id f8-20020a170902684800b001d08383742dmr364617pln.37.1702056477358;
        Fri, 08 Dec 2023 09:27:57 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902ee4c00b001d0c134dc2dsm1955222plo.77.2023.12.08.09.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Dec 2023 09:27:56 -0800 (PST)
Date: Fri, 8 Dec 2023 09:27:56 -0800
From: Kees Cook <keescook@chromium.org>
To: Song Liu <song@kernel.org>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] md/md-multipath: Convert "struct mpconf" to flexible
 array
Message-ID: <202312080926.FBF7A2DDD2@keescook>
References: <03dd7de1cecdb7084814f2fab300c9bc716aff3e.1701632867.git.christophe.jaillet@wanadoo.fr>
 <202312041419.81EF03F7B7@keescook>
 <CAPhsuW43g-M+xvzD0N1JsJ_zGnvZQOw2Bi1TEqoHKanPnvMHLQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW43g-M+xvzD0N1JsJ_zGnvZQOw2Bi1TEqoHKanPnvMHLQ@mail.gmail.com>

On Thu, Dec 07, 2023 at 09:33:17PM -0800, Song Liu wrote:
> On Mon, Dec 4, 2023 at 2:20 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Sun, Dec 03, 2023 at 08:48:06PM +0100, Christophe JAILLET wrote:
> > > The 'multipaths' field of 'struct mpconf' can be declared as a flexible
> > > array.
> > >
> > > The advantages are:
> > >    - 1 less indirection when accessing to the 'multipaths' array
> > >    - save 1 pointer in the structure
> > >    - improve memory usage
> > >    - give the opportunity to use __counted_by() for additional safety
> > >
> > > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> >
> > This looks like a really nice conversion. I haven't run-tested this, but
> > it reads correct to me.
> 
> Agreed this is a good optimization. However, since MD_MULTIPATH is
> already marked as deprecated. I don't think we should ship further
> changes to it.

Hm, that seems like a weird catch-22 to me. I would say we should
continue to improve any code in the kernel that people spend time to
work on, or we should remove that code entirely. Should MD_MULTIPATH be
removed? How long has it been deprecated? (We just had an LTS release,
so doing removal now is a good time...)

-- 
Kees Cook
