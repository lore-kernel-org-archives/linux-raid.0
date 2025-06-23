Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404A41E5B71
	for <linux-raid@vger.kernel.org>; Mon, 23 Jun 2025 20:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750709797; cv=none; b=dCp9DlJZz33kE4AHnsCqSShehNITdp7AXWCA2TckaePm1B65jVrinr1+KG3EnfXfE3RIM7AHQeWFd9AVf9+lwfw/VX14ewKO4MH2ovDoy09VJfYfjREl9blvamK9rg50nIKGvpFyQG3sVEnr+D230aUJOdPElsnPlP6YGpee7r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750709797; c=relaxed/simple;
	bh=JHHXqv0LaT+Sl9mMFX/Ae6l9ALRIkBrhLo7JcOJOnXA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ELOH5bht1+z1Uqurbd2hOH9jMWbZ0pap/9y/zLTRv1kAIgxjonJuYC4IlUoO8cz38jj4nPqcN/ZKmVuJ7mQh1SJZhV+7l7RkrqbbhaBkR+FYV0K+V1lzgQ/wdAd3e0yW8aVzOcA2c/bIBcSR5lNCK1kyMW9bKlpTxYocWcRWWFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=tXUJe9oN; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="tXUJe9oN"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ad572ba1347so753543166b.1
        for <linux-raid@vger.kernel.org>; Mon, 23 Jun 2025 13:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1750709794; x=1751314594; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cLEkhYw1KwcHEqZHkPQE50lr62xelk0uLtioyAiJVJY=;
        b=tXUJe9oNg8+uQVv49CD8mgmz9klrDGFsyJAfbZKMIclzg64Tkixjdg+llde+d3/PW9
         J5FpS7gbvZ1co/4wopPUJOztYbF1WTVdxFo6GPBXA/nCZj6POKhs74+5sCSxiOqcOlyy
         yEitmOuj3WSzQBpw3UyxeJ0u6vfI2RYgedn+8RRqdZ3sTdLTaoDvI1ibyEkbqM8Zc/I4
         kr4wve48PmGI9HIA9+cLgOUNVjoj/duNco0inyiEVMKzmIlHjZgjMUMujeF4/q4QJ8iQ
         3TOUAA4h37EpaO2DEPl1b/rExi0k4EUpomTOYaU2rP7zU3BXeaI5wFM4AyAD7sY1JR15
         WlcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750709794; x=1751314594;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cLEkhYw1KwcHEqZHkPQE50lr62xelk0uLtioyAiJVJY=;
        b=BRLBSp/FoFD0Br/WqiBDqgZ+wkxfwFU6qUnOW8KCt+Uwhww4as3U3oVwwoEKbAWoQ2
         Y9j/Bt5p+4cGleH1P80l0ViPJLA6QzExJmigSbv7Mf+sskiqmyh2dZmwh7N6K23hg2Y/
         fBBRJV0JbCMhW0z21mPiwPeLcQ0oSoCzbk983u66ALBdssel1nCZUWZySwoQNQZ2XM6q
         ooVtJBySiokMND0L/bH0M/yK7GGFu0iLaZKnqJYpEcNIle+2jkUPNzsdrnQVcOfmYaTt
         8x0DdnU8HkRrWK3p69iluMR2PrjRHjtjxcToibJIoej+hOEcxqYxtlUbybfhtaERXFdD
         konA==
X-Forwarded-Encrypted: i=1; AJvYcCWoeRlAEOJrDbNpUZX3XNSklps2iFtFZwbLbG8/Tx4q3oLSBZk0QqnhjICT891sR1e2wmNDegeobmqW@vger.kernel.org
X-Gm-Message-State: AOJu0YycgM4WUkyfQGkQr1Vbpzj8ZgGFhr39GztIklHkNoMwvL89qTUf
	2e4h8nkDD0n/ECxtiECF7OJEVMO3EkafvpZrO3TxPj/hEyBKgSZv2E6HlyjeN2q1GK95QfDt57a
	eE9yHjk7x+kISsIRL5Ufk6kFdgdXg33XgznyHLZ8rRw==
X-Gm-Gg: ASbGncun78egAIUY4Nea36z6x67w3iSJQlWKr/MpTNtI+NyZbnsdiSCyszA+w/VYbH+
	Cifjo4HdsF6NSJWOkrFkZtLxx9WOCSq+eC2mNMLkIPt3sMwBlEQQnucweDbECiSlArKqKbJgQvz
	0FWhoRiR1+MEMgZxwx1yekHywdW71adhxrYWp2dK4hTtWGyDNES0g1LTfhInQ5Cf9/T+M18x/W/
	K/E
X-Google-Smtp-Source: AGHT+IH8W2k769PxImmVrKNQTA+EhZNwz6gwpGQ4i/8HcB79n2XQjF93ywieBigkgN2AUYS9QOJXJEjcKy0xawy54jc=
X-Received: by 2002:a17:907:2d89:b0:acb:b900:2bca with SMTP id
 a640c23a62f3a-ae0574451e3mr1122168866b.0.1750709793540; Mon, 23 Jun 2025
 13:16:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+G9fYv2i5AOYOkepUq_Rz1wxfzu1o2W59xDgui7VPw7g-fV9w@mail.gmail.com>
In-Reply-To: <CA+G9fYv2i5AOYOkepUq_Rz1wxfzu1o2W59xDgui7VPw7g-fV9w@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@rivosinc.com>
Date: Mon, 23 Jun 2025 22:16:22 +0200
X-Gm-Features: Ac12FXyUtlAN5mo5G7XVHNzzalU5xEO1E42U1lrA8NLKvGONdwjAniZqy-W01ts
Message-ID: <CAHVXubif=dPF2u=dQYhRR-VaRutX=b+7NmTkE5B-L+OxA5Krig@mail.gmail.com>
Subject: Re: next-20250623: riscv defconfig raid6 recov_rvv.c use of
 undeclared identifier 'raid6_empty_zero_page'
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: open list <linux-kernel@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>, lkft-triage@lists.linaro.org, 
	Linux Regressions <regressions@lists.linux.dev>, linux-raid@vger.kernel.org, 
	Song Liu <song@kernel.org>, yukuai3@huawei.com, 
	Chunyan Zhang <zhangchunyan@iscas.ac.cn>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Charlie Jenkins <charlie@rivosinc.com>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Anders Roxell <anders.roxell@linaro.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 23, 2025 at 8:32=E2=80=AFPM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> Regressions on riscv defconfig builds with gcc-13 and clang failed
> on the Linux next-20250623 tag.
>
> Regressions found on riscv
> * riscv, build
>   - clang-20-defconfig
>   - gcc-13-defconfig
>   - rustclang-nightly-lkftconfig-kselftest
>   - rustgcc-lkftconfig-kselftest
>   - rv32-clang-20-defconfig
>
> Regression Analysis:
>  - New regression? Yes
>  - Reproducibility? Yes
>
> Build regression: riscv defconfig raid6 recov_rvv.c use of undeclared
> identifier 'raid6_empty_zero_page'
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> ## Build log
> lib/raid6/recov_rvv.c:168:24: error: use of undeclared identifier
> 'raid6_empty_zero_page'
>   168 |         ptrs[faila] =3D (void *)raid6_empty_zero_page;
>       |                               ^
> /lib/raid6/recov_rvv.c:171:24: error: use of undeclared identifier
> 'raid6_empty_zero_page'
>   171 |         ptrs[failb] =3D (void *)raid6_empty_zero_page;
>       |                               ^
> /lib/raid6/recov_rvv.c:206:24: error: use of undeclared identifier
> 'raid6_empty_zero_page'
>   206 |         ptrs[faila] =3D (void *)raid6_empty_zero_page;
>       |                               ^
> 3 errors generated.
>
> ## Source
> * Kernel version: 6.16.0-rc3-next-20250623
> * Git tree: https://kernel.googlesource.com/pub/scm/linux/kernel/git/next=
/linux-next.git
> * Git sha: f817b6dd2b62d921a6cdc0a3ac599cd1851f343c
> * Git describe: next-20250623
> * Project details:
> https://regressions.linaro.org/lkft/linux-next-master/next-20250623/
> * Architectures: riscv
> * Toolchains: gcc-13
> * Kconfigs: defconfig
>
> ## Build arm64
> * Build log: https://qa-reports.linaro.org/api/testruns/28829977/log_file=
/
> * Build details:
> https://regressions.linaro.org/lkft/linux-next-master/next-20250623/build=
/gcc-13-defconfig/
> * Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2ytm=
qfZ6v24dxq5kjorJbgH6hC8/
> * Kernel config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2ytmqfZ6v24dxq5kjo=
rJbgH6hC8/config
>
> --
> Linaro LKFT
> https://lkft.linaro.org

The following diff fixes the issue and to me should be squashed into
commit 44add101db9e5 ("lib/raid6: replace custom zero page with
ZERO_PAGE") so adding Herbert as cc:

diff --git a/lib/raid6/recov_rvv.c b/lib/raid6/recov_rvv.c
index f29303795ccfe..5d54c4b437df7 100644
--- a/lib/raid6/recov_rvv.c
+++ b/lib/raid6/recov_rvv.c
@@ -165,10 +165,10 @@ static void raid6_2data_recov_rvv(int disks,
size_t bytes, int faila,
         * delta p and delta q
         */
        dp =3D (u8 *)ptrs[faila];
-       ptrs[faila] =3D (void *)raid6_empty_zero_page;
+       ptrs[faila] =3D raid6_get_zero_page();
        ptrs[disks - 2] =3D dp;
        dq =3D (u8 *)ptrs[failb];
-       ptrs[failb] =3D (void *)raid6_empty_zero_page;
+       ptrs[failb] =3D raid6_get_zero_page();
        ptrs[disks - 1] =3D dq;

        raid6_call.gen_syndrome(disks, bytes, ptrs);
@@ -203,7 +203,7 @@ static void raid6_datap_recov_rvv(int disks,
size_t bytes, int faila,
         * Use the dead data page as temporary storage for delta q
         */
        dq =3D (u8 *)ptrs[faila];
-       ptrs[faila] =3D (void *)raid6_empty_zero_page;
+       ptrs[faila] =3D raid6_get_zero_page();
        ptrs[disks - 1] =3D dq;

        raid6_call.gen_syndrome(disks, bytes, ptrs);

Thanks,

Alex
