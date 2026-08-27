Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3228319AD90
	for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 07:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787815314; cv=none; b=KgsyljOARKy/O/dBa5n3/hfrryIfmenShenCnhNrXaxBXwkxgNHGHiw+2HN+/eHn7O6fpRVHhrC57vLNTAzYvLanZisZevaPr9NmngVn+2tCfUAIayEU20I4/OXn6hFL/vTUb+YFJWUnB7yA57JF2SG2SuuOBflfX7myMfMDgF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787815314; c=relaxed/simple;
	bh=QN4LLJKILJcpX1pZV2MhOQxGl4YiamTZyX0WyUCUqng=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mgK/pV0ZwqPsMQmZn4XvJ7BoQXKQIz5YVKVTnzIwo7o+NOqYmsxs/RUv4jQ0AWtvnUAp5yeJD6KRWWHotSgz6leQrpBVO/rAVBRWASgQcTKRVmi5vYSYB2s+s2ANq3osZ9qcQNUp9WED7JyTXmwMD9BsUgXxHdDTHiLiTGyV8qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-97bf910aa70so495306241.2
        for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 00:21:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787815312; x=1788420112;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=D8yjs5lhxn9uGJPZAn9jjZ+Jj2fso4i8f+hR78O5TqU=;
        b=NWrkgRO/OeQ2kIZ1HH8OE8fYc11IcN9TZ0MXLyLjENT6h2JpVPPGa06OHA/mEjzaQE
         Bll5JMvtGXLm12nzyysqd68RKhHBORpy+7NJl0fP2GU8F6AFQsHq1mIAPc6Sf6joSxvh
         zJGBVzE+utFTB4q5cHPeCUsPporKcK32M5sy/Y9G6tR9rv6JGFeez6KwhQV+hQpID+Wi
         goWlGK4Ovw+T1284p/rMH4A0RjiDqqD/AwYqUO2Ed/qPefov6/47cUrQ4wGFhqOyaRRH
         OXsab/pMExRemsGaMpFHWkZSBtwNnuCiJ+nP4E79QylmEoa1hBjjrFzQY7DwC5ReNjXa
         frIQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr264JkKlhYzY5ZoyLPOWzPUvQ6qai7cOvXwd43+wmKIK958B1EnZekPQreZLNDJW3rOEiuxSg9LqwJ@vger.kernel.org
X-Gm-Message-State: AFuF++nQlw02tjEaQboU8IHo9A+rPOiT0bzCRIzJxNm+9Ff34oNbsR2D
	5m4liH063Rxae6XJpMvyGuSjzoPc37hB6DVY0aSTWuggDW0Wr4+iZkh8P8VQmH9Q
X-Gm-Gg: AR+sD102s4eVaDnDl9alNUBgscvfyBCSf8RXO6la/P9MH470IVOdy0pM5YkQLTRSXsI
	tk5WsSbHxcopBAQbb6Agpgl3CEHz7/NlXrvws/bojDrJ3tZIft8PUA1MLZKYTg2OThdW5xsCP+Y
	24wnmLtubJqQHL3kB8U7hNNfQFArxkHIrw1Q0t/lyIedOtq+qGxYxvXmL+39eXyOXos1SIZJg4f
	xMw9a2MCPrfbewISlvmEMNWBYtWP4mguUD9wpgyA0aJtn0wX7zihftz2gs3cFeZ3bSls6zLNFEJ
	8GyQhBKn6LBEK30AOy/A+ThRPW4wKB9s4v/lYRaszWuZlrBGG9vMd24mr6uRYmAJru454o8KZ3D
	6AIfFGujbiP0Vt65Sn9kJz0m/PBfHOtXn5ZzxOe6MuRByHD3B1hqJDnFWt0XN+DqfgK4oWd1rgR
	n3pZmXskkXtWf1BMtFMBxDlXwhg8YGdHeYwRq0FfkC1XA7hDt5m4n69aOEm2+27QrhoQj+LcPs5
	rbZAw6C0naGIFlHrZtQkHfu+A==
X-Received: by 2002:a05:6102:441b:b0:77b:2881:580b with SMTP id ada2fe7eead31-782bffdabbcmr4067512137.4.1787815312025;
        Thu, 27 Aug 2026 00:21:52 -0700 (PDT)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com. [209.85.222.46])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-78307cc2055sm3817161137.9.2026.08.27.00.21.51
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2026 00:21:51 -0700 (PDT)
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-97ccaa61510so297848241.0
        for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 00:21:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr99IiOuBRdCjjB7nxVMhbxAKaYSkz+UWp3XF9kAPd07eiPtrWr+fvS/3yNWxnZQj23hmKflfUR9Z9z@vger.kernel.org
X-Received: by 2002:a05:6102:5109:b0:777:ab3c:b88c with SMTP id
 ada2fe7eead31-782c0bff4femr3644287137.8.1787815311094; Thu, 27 Aug 2026
 00:21:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <64c6e0191bd8ccef0074ffbb09bd0584680d710b.1787584360.git.geert@linux-m68k.org>
 <20260826205058.a6ff019d0584f75c7f50430b@linux-foundation.org>
In-Reply-To: <20260826205058.a6ff019d0584f75c7f50430b@linux-foundation.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 27 Aug 2026 09:21:39 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWm5N5tbwy3rhaKJu-n_BDmQwGsjze5LquWPMrhPmUroQ@mail.gmail.com>
X-Gm-Features: AcwNN1URxO1QJnlEtHmK-oLPYjqqMK6cTFFsDtUxL-F8NHfwrH50duGsc6bxHhU
Message-ID: <CAMuHMdWm5N5tbwy3rhaKJu-n_BDmQwGsjze5LquWPMrhPmUroQ@mail.gmail.com>
Subject: Re: [PATCH] raid/kunit: Enable RAID6 PQ and XOR benchmarks if KUNIT_ALL_TESTS=m
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Andrew,

On Thu, 27 Aug 2026 at 05:51, Andrew Morton <akpm@linux-foundation.org> wrote:
> OK, thanks, but...
>
> hp2:/usr/src/mm> scripts/get_maintainer.pl -f --no-rolestats lib/raid
> [not linux-raid@vger.kernel.org]
>
> Patches enthusiastically accepted ;)

At your service
https://lore.kernel.org/7a2e5de234cc0286e3fe9bc11b810433775f2280.1787815121.git.geert+renesas@glider.be

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
