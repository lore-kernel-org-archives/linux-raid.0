Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7423938F630
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 16:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785687208; cv=none; b=cm62mHmonTLFm6WX0Zz4n5XAlY3U19Tfx5pDWIR5W36NJ8v69GOUaW1P/T2Xlu2cjWRmqHncoyIsPpkwtyQZWUxzafVHw1K9XbyGEuCxVnCo8IKEhRBQecMcJ1LYRfo9cID1+RuxPNNII+zmF4eoZRprs6FA3rHNy6amIvZnLbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785687208; c=relaxed/simple;
	bh=7myla9USysFiM8O/xFcSNQmsTlyGZFg7AKare+L+fwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f/rqn6a/b3TYuO8xPJJ2ch6wgvX/Nd5CCPVVIUGoN1cZfh72dkGHsFuYWRUFQJO+2q/iCAJDhj5pQLZDHr6IHRUbWnG7lOJKbdBRPnMTxtPNnk0Lm97rhp2Nkb7NmhsfDM3orcKOahB9Ph6SOrF5LTXta1xkf2iDVAPL6NQl7HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=lzdsZNOt; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="lzdsZNOt"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so13505225e9.2
        for <linux-raid@vger.kernel.org>; Sun, 02 Aug 2026 09:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785687205; x=1786292005; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7myla9USysFiM8O/xFcSNQmsTlyGZFg7AKare+L+fwo=;
        b=lzdsZNOtESfTGK9QcRbYHwAf3AzGOiK54OeScBUBWAKgjX4EXGyLajlNoJNPiE36r2
         TcoVQyboqrDjv/y1mNN03HHBDe5MdXlOA7LlqZtowYqSHXkA7I7S3SWpdqDaQTRsk+1Y
         qff6k3f+bYH9w6gScTCh1HMb/kqNxfP56flZOiDhNkZ0euPEfW5Inejt7zizFfbloNo5
         N3ZrKruWG0y7V8rJjeKQ40MQsIWcQCHPT8+9OdsbaIsK6u2ogCmqd46o1mBnySoJWlaj
         T+dSuysV4457NcGlFI9Slh+MZV2K+b3xb76Oq8CgbTqlLvNl+ivdU4qidhWgaUKlIcY9
         F/fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785687205; x=1786292005;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7myla9USysFiM8O/xFcSNQmsTlyGZFg7AKare+L+fwo=;
        b=iNdoR3vRLGvCY0xiS5Vw7v7ENb9oGKmvIxYCW0eSuAR2ccSb4BiGH91N6SVPFB4KDW
         sJF3pG4nRmtHWBYIA85Y08BoqjFMZMn/kDZcJpy2EOdka/0IJ0UA8VSGYlqPD/9ok5D1
         ++f9BfpdjX6IDuVn4llCyEqOTMfczrxqJanLjGOdp+VMYSvuul718PtUbulcpBKxzjIO
         O3yag2cEjXvBbsVGGSNNuldNcOavuNE8CHm4kM/nuo929k+Nw6n569xbvx0OqdF/IFSV
         PSzEaDzMcg4r64Jk9gq7BPyuF21S/HBzRMyH9J5Ry3wAM9JyfXC7t2tVnSd3qAgGfCpU
         0j6w==
X-Forwarded-Encrypted: i=1; AHgh+RqyaWY7IMBvSVH0f8Ya7tnwxGD7BY6nrbizys+yDZU6Ny4LIOmz9euDDDP+BsGWh2Zg1Dw3xGKSTAHm@vger.kernel.org
X-Gm-Message-State: AOJu0YzVGYD+PF99RNWad2JDATa1JsMaGoXI8lirGYJ6TRD48BCSbd+u
	de5tk/PoqgCl13dHLFSOX9V9v8yiri9Q0K7Qlk2CuSE6TthANhwBUIinC6l6eaLCEg==
X-Gm-Gg: AR+sD11DkJ4mQ4OgnSfJsQYfL2AG3GGNRKBJvx3XgXt+rh6X9kOt0LrKW0EmsiJs2ri
	cz1K2wlBK/M/NZ1JCoxhnkqBAnveqVlKy3ngu2oVSf9YI6ZGH3kM0HifKDsz9FhmKPZrpdZfTuv
	1ubNfSbtIs1bOLCRTOoBY4tU4kcc/EoBlf8U47VLT/TBAjtvg5AweoI9rjXZPK49K9l2veWDnb1
	cFOwNtOb7AHhEqo9Olfw5yLFsOR53AnTEkU7XNWcjHSw1PQjE70BlIqVYpIdHvHbKg3d1DFjWFJ
	BhdVH3NCkCzzB+btlKtb9Gqnjla1XGHIPT5+s2eHH3i+R9z+IJpqr/OBIAEvPMuQHs2J+m9HQj8
	x9MnFRldapZFSAeH1vZcCwsjpUifRKPZktV7txiF4NCpHth7R3skNAKZZcvVz3ZAWnjHRxPdXbO
	YprYx/P1P0BhAGnbH7QCrPgsCaj0Em1r+g0tx4EfaTt4gW3rnfp491luQufaWAtdyqIRRw2O6CN
	tgXBLiN4rGuZFibw59DGBFvCafAOtngWmWrXcXjqiYyQOl8Fkq7p1oKGGaK85RMhrpEa3ZfddNV
	zkNYAHIJ2EWXTgkC62ilVMsj
X-Received: by 2002:a05:600c:4747:b0:495:734e:4825 with SMTP id 5b1f17b1804b1-4980c674a20mr121031555e9.16.1785687204618;
        Sun, 02 Aug 2026 09:13:24 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49807b916e1sm125469675e9.9.2026.08.02.09.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 09:13:23 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Yu Kuai <yukuai@kernel.org>
Cc: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/25] md: improve lockless bitmap reshape support
Date: Sun,  2 Aug 2026 18:13:08 +0200
Message-ID: <20260802161310.8097-1-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260801172519.2982121-1-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Kuai,

I ran v4 through the same rig as v2. All 25 patches applied cleanly
and build individually, the four problems I reported against v2 stay
fixed, and extra tests aimed at v4's new code (the raid5 boundary
split, the resize quiesce, the new reshape_lock under PROVE_LOCKING)
were all clean.

If raid10 tests on this base hit KASAN in free_r10bio(), that is Chen
Cheng's separate r10bio bug, not this series; with the fix from
latest md-7.3 the same tests are clean.

Tested-by: Mykola Marzhan <mykola@meshstor.io>

Thanks,
Mykola
