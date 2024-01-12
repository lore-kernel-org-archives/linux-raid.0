Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0B21AAAE
	for <linux-raid@vger.kernel.org>; Fri, 12 Jan 2024 17:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="B1zE97HP"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-360576be804so3927445ab.0
        for <linux-raid@vger.kernel.org>; Fri, 12 Jan 2024 09:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705079493; x=1705684293; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S0Vttk9vgl2pIMZk4UzP9itUkUCCJPY3X5z+XJAuPbg=;
        b=B1zE97HPQzLGblOmsHguugiebBfCO/69AbpkCODREWsibnawlve1iD+cUEL0GG3D2I
         QV+RCa6LPy9EaAukV80yZ8dZBxC1GSHTGxCKYmAbqT2sf4G30GeGa3TMWUXRLaF6Robc
         4beIHej1J/psD3xwU9JJJ/n9ciURg3xFTWX9VPTrFG0KvRYl7RZg//g+eYDd6EOGsqaL
         d08JlCJDP3hWg7yEzMqXPeavr835esleZwSPRpZ64giYKlL18yCDskFAOv0WHpDdCO4w
         eSPuBVZ1+lSObUExP1SjZ6v5eVvFFXtFsjyNh4IrRc1X0hDn8VC3HUkG2nm2PIbSO2Ex
         MpWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705079493; x=1705684293;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S0Vttk9vgl2pIMZk4UzP9itUkUCCJPY3X5z+XJAuPbg=;
        b=Wp/tkt4SnmmRhO82mLZ1HbPbSEm9ihErd8Si8GL4UAptyvroOgWvW3GIzKg0gmjjCF
         vW9P0IqfgSLmZWxKoXfeGxNwUxDgopDDMGhUIW6uCeUgq4UN1o0DD9aTqLmSMQMKMGLF
         e6APaCPiRr3qPU2PCU3Pt67G/hq4gpBIJjSE6Yirzcd5CcphL6ohKZJyz2VWYnqbHhWe
         Dd0JmTp4Wn3krEl/HtMY6zXPMqb6lF4AwG4BSjUTCQf2ZouCFRkj4XWesrQ+Zh5qzkdn
         Y9zL/me7XYq01tH9l4MPiyAdDpL7/Q1E0D5BPU4EwRhJDGbM3eO/7FcMpWwUM03Up4sb
         9Ehg==
X-Gm-Message-State: AOJu0YygLwjNQvzVqLuvRTLrfbiszhLwhmSHFriLAq2EsGowcAZ+SgkQ
	18f8ktXIbQaC0n2NaC5vqzEtzkOMCza1+A==
X-Google-Smtp-Source: AGHT+IExhFWsKAwiuWBQQgdWYJDuVJ2ab3qaEJpjWi6IK6vFjpLjekkwD3havgCps5qaeYm21SWGTg==
X-Received: by 2002:a6b:c845:0:b0:7bc:2603:575f with SMTP id y66-20020a6bc845000000b007bc2603575fmr3634052iof.0.1705079493696;
        Fri, 12 Jan 2024 09:11:33 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id cq9-20020a056638478900b00469328386c8sm995517jab.162.2024.01.12.09.11.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jan 2024 09:11:33 -0800 (PST)
Message-ID: <79f0bbe3-ade9-43a2-8372-dbe8598c2fd8@kernel.dk>
Date: Fri, 12 Jan 2024 10:11:31 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] md: Remove deprecated CONFIG_MD_LINEAR
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 Neil Brown <neilb@suse.de>, Guoqing Jiang <guoqing.jiang@linux.dev>,
 Mateusz Grzonka <mateusz.grzonka@intel.com>,
 Jes Sorensen <jes@trained-monkey.org>
References: <20231214222107.2016042-1-song@kernel.org>
 <20231214222107.2016042-2-song@kernel.org>
 <CAMuHMdUtzhwHLa_DTtH00YsZ6t_CefZjZj6oS_mpckHDNXpYWw@mail.gmail.com>
 <CAPhsuW6KVN1c=dB1RXVQjygBevVcb_1qQJoLz3zA-qTVVmbCAw@mail.gmail.com>
 <20240112171010.GA18360@lst.de>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240112171010.GA18360@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/12/24 10:10 AM, Christoph Hellwig wrote:
> On Fri, Jan 12, 2024 at 09:08:04AM -0800, Song Liu wrote:
>> Thanks for the heads-up. I honestly don't know about this use case.
>> Where can I find/get more information about it?
> 
> What NAS uses md linear?
> 
> Either way you can always set up a dm-linear table to get at the
> data.

Or just boot an older kernel... Seems like a bit of a contrived use
case to cater to.

-- 
Jens Axboe


