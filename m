Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="lf0Tbx4p"
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438611713
	for <linux-raid@vger.kernel.org>; Mon,  4 Dec 2023 14:20:06 -0800 (PST)
Received: by mail-oo1-xc2e.google.com with SMTP id 006d021491bc7-58d5979c676so3240474eaf.1
        for <linux-raid@vger.kernel.org>; Mon, 04 Dec 2023 14:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1701728405; x=1702333205; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c+WzlKb2MQSHfnGqBE/e5O7OA37FmS5jYCRCA/LLsH0=;
        b=lf0Tbx4pZSpplXVE+zqYxKYOIwCE2xAIUgcZiK3fCq6WNOA8asMjsl+yN0MHxt2eDn
         rbaiZLPUY41HHiP3/HfHTDEMuBNSsqFAfOwLCszTWL335Aat5ZHiNUr8kTLUlWLeMVgK
         Ko4WxPKFTphxd51BX4j69weJgwWn21SSL2GP0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701728405; x=1702333205;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c+WzlKb2MQSHfnGqBE/e5O7OA37FmS5jYCRCA/LLsH0=;
        b=Jzl6XQl7MM3QYhbG7PS5/9s48uCEn1fBOtC6cUEQCTLZyFn+Jn7iLlS/zWRRa8ZTD0
         GqDmlcBjYdWJX0Us4HDviVYE25qrSvgBv/DLjiXR8vqUy5AylzcPWWQpI9NsGT+VWGlR
         yQetMeSRPcOUeRexxtp2y3I374H135pxvm6WnUmxA8JMdLWJCm0ZsxGQ4duT8f9aNSwL
         ZA7pG8+9JUZyZHIV2qpRfGypFo8L4C/2VBOqFdVkTXNyZVQvU1sUaaGaHnRC6zY9TYJ0
         5M3iEeqEFRcpShznjYnPs1UZKBUcMFF/MaPZwFif1kLn+wDkzt8sVAQeivzBob3shjtf
         Ta0w==
X-Gm-Message-State: AOJu0Yz1TnrpT9Bj38Nio6aWMYKXm4kbNFG5QUccM/dAwcz45O+l5CNp
	LfYfIYsSOhkv/48rqtPo0OuIIw==
X-Google-Smtp-Source: AGHT+IGC7BzaBQCIfZe1vXo4mx3JRiDIzetuPnC9oVZ29pkisPeQ4hM13pxSUb9WDQN6k46hgaEL7w==
X-Received: by 2002:a05:6358:9106:b0:170:302b:545f with SMTP id q6-20020a056358910600b00170302b545fmr2543842rwq.56.1701728405319;
        Mon, 04 Dec 2023 14:20:05 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id ey5-20020a056a0038c500b006cde75646d3sm4718759pfb.179.2023.12.04.14.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 14:20:04 -0800 (PST)
Date: Mon, 4 Dec 2023 14:20:04 -0800
From: Kees Cook <keescook@chromium.org>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Song Liu <song@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] md/md-multipath: Convert "struct mpconf" to flexible
 array
Message-ID: <202312041419.81EF03F7B7@keescook>
References: <03dd7de1cecdb7084814f2fab300c9bc716aff3e.1701632867.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03dd7de1cecdb7084814f2fab300c9bc716aff3e.1701632867.git.christophe.jaillet@wanadoo.fr>

On Sun, Dec 03, 2023 at 08:48:06PM +0100, Christophe JAILLET wrote:
> The 'multipaths' field of 'struct mpconf' can be declared as a flexible
> array.
> 
> The advantages are:
>    - 1 less indirection when accessing to the 'multipaths' array
>    - save 1 pointer in the structure
>    - improve memory usage
>    - give the opportunity to use __counted_by() for additional safety
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

This looks like a really nice conversion. I haven't run-tested this, but
it reads correct to me.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
