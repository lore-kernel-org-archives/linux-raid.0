Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2352D4B4B
	for <linux-raid@vger.kernel.org>; Mon, 23 Jun 2025 18:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750703565; cv=none; b=LERXDQ0eWPpb6Bms6AMMf6sSlTAN87OWfnjsi2Ovwsr4DbspqXV4gkC157ZCppgqABusdrS1qc5UfR2xb+w4tzhgOY38zTlSbMs34/MKp8nvpArrzSMh5P5J+ZJhHvq8JwVKOwar30Z8lqdTZfgc28mE/GO/I6fUY3jCM1ezGnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750703565; c=relaxed/simple;
	bh=j7unceZnAbI/jKhe8OzwmUSk4YWeCfoezAT5k/+mbtE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ii4Goog7vKlgxq+IEQcvYAXKbohysEZudBUFn0eBEKnVBQ4FlhENPnCDo7qm+mIx7ottSbD9Le55hbNwSct5Q926vqH04yqxaJddhR/7Rt/Sp5eY232hNHvwx4kjRFSBdNjlH9dGkxBcwTRlMkYjaia0AHVxbn1eAZJcMEgdMUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oktM75/g; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oktM75/g"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-31329098ae8so3933047a91.1
        for <linux-raid@vger.kernel.org>; Mon, 23 Jun 2025 11:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750703563; x=1751308363; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kruPxOyyvUJ301Bt/UNLMGQOlJa4yMmtInWP2erojtI=;
        b=oktM75/gX0q64JpCspfA1o9oi9xpCBQhBl2Atw6MTKYMDyZama9AiCbmoa4CTdcFDr
         GwnDI2oEmuBApWVDWD0CDa3QLA9AJ9etfDpMu19SIgIaPlwtuSTVzQFAFNq3JhEdXnTW
         SPwmvc/mfcq7qeHK17gIjmJAe4jfxZqkcuWTRymHCXGLUU2803QLYCNdqnICwyr3FOgH
         ezotd3M9kR+KuO9hyf5b139n8HxRQdTIEIJi6sU2h+Pr6XUu1Lq0RK8fhrlxewOKEPbx
         VHrsiUTWDujiR38kSZgKkpi1VbpUtAyRIo3WFZQycKymwyiQW72Lj397CWruopM1Y3bA
         rMNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750703563; x=1751308363;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kruPxOyyvUJ301Bt/UNLMGQOlJa4yMmtInWP2erojtI=;
        b=bMuAkMNoaHzeAdJho5rUnS9ezPVb8ID58jDtbzpPM7xc9KpSEUFZvxkCMBbAIFAtkV
         CZ/pFZ6FxYt6Yl3b5+MCCxEFvUdIuntOnJEw9rL+nM6Ks3S0+4UNZWButCBA5yTcGSQ0
         mhwVi0Pnez1R3pQRUVUNx52r4ALYuqfIRL/rWOMRoi6Wnc5AdPdqE1vUt9CqFJWXloZE
         XjYECHgbbRkDUQ/cRIaXWf/b6fEcWLGVP2JdJqiMvA/GiwcoFCBXo7s5RjBNsHH2GFDE
         z8F/ZSBSoHmu1FP272wkzhKx00iodJko4YwVXO8VlDJ0rhk2auDzZWMp8NOL1N7u8ZdF
         ZolA==
X-Forwarded-Encrypted: i=1; AJvYcCVqAuD67Ei4pW45Md2/Vck/c1+4Gis8sD3eZFVuMbacBqseZV5njiBQbD1gP8psNB6uTeq0CmsJ9pVC@vger.kernel.org
X-Gm-Message-State: AOJu0Yxov1Q2znma/GJpqzxqMsHN8v3hu4MzmKGk1k2I68/BBttHBsJs
	Mot0aXuxd7JLvb8sTvbqOyRL22xaa167euEWkyURCqSs3GJ5oYFg1v9VGpvxaJARlMH8ySvVIVO
	ZXp7sAi8+A2mH7JM9ondbUSLhOatYnZ+BbE++x1jdnw==
X-Gm-Gg: ASbGncu2dcpi/JROxJKav/pVQFwyoONRhZ76WLYZI1BKeqpZkX3Gn1RANttayYVok2t
	aZc1R0W1rc+O0QRr2D7w3I/RW4J6OlA6CwDWHZRdivyO+7D/XB0Za6mF5H5LjzRv+3UWBIUr/f3
	chNeMo/fh7Qgsrih05gauAc5zH1wTt+Q1003arNV76k6ekuk90+Du0TXRuxokcMaB3F/ats70IZ
	gcC
X-Google-Smtp-Source: AGHT+IFN+MuBxJ+QUL+UQe2hu7b0+Ppkb80MQX/ZVfwxCOW2lGiDat39qnGph06M7YMdl+YKMYdCUOnoxk8zPjTW19g=
X-Received: by 2002:a17:90b:4fd0:b0:311:a5ab:3d47 with SMTP id
 98e67ed59e1d1-315ccc48857mr832647a91.1.1750703562413; Mon, 23 Jun 2025
 11:32:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 24 Jun 2025 00:02:29 +0530
X-Gm-Features: Ac12FXz8Xagh8-R9UdOPbyOpKzegWYcA5INp1WSEVpTVF86rd3gJifht0qGqOmw
Message-ID: <CA+G9fYv2i5AOYOkepUq_Rz1wxfzu1o2W59xDgui7VPw7g-fV9w@mail.gmail.com>
Subject: next-20250623: riscv defconfig raid6 recov_rvv.c use of undeclared
 identifier 'raid6_empty_zero_page'
To: open list <linux-kernel@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>, lkft-triage@lists.linaro.org, 
	Linux Regressions <regressions@lists.linux.dev>, linux-raid@vger.kernel.org
Cc: Song Liu <song@kernel.org>, yukuai3@huawei.com, 
	Chunyan Zhang <zhangchunyan@iscas.ac.cn>, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Charlie Jenkins <charlie@rivosinc.com>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"

Regressions on riscv defconfig builds with gcc-13 and clang failed
on the Linux next-20250623 tag.

Regressions found on riscv
* riscv, build
  - clang-20-defconfig
  - gcc-13-defconfig
  - rustclang-nightly-lkftconfig-kselftest
  - rustgcc-lkftconfig-kselftest
  - rv32-clang-20-defconfig

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: riscv defconfig raid6 recov_rvv.c use of undeclared
identifier 'raid6_empty_zero_page'

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build log
lib/raid6/recov_rvv.c:168:24: error: use of undeclared identifier
'raid6_empty_zero_page'
  168 |         ptrs[faila] = (void *)raid6_empty_zero_page;
      |                               ^
/lib/raid6/recov_rvv.c:171:24: error: use of undeclared identifier
'raid6_empty_zero_page'
  171 |         ptrs[failb] = (void *)raid6_empty_zero_page;
      |                               ^
/lib/raid6/recov_rvv.c:206:24: error: use of undeclared identifier
'raid6_empty_zero_page'
  206 |         ptrs[faila] = (void *)raid6_empty_zero_page;
      |                               ^
3 errors generated.

## Source
* Kernel version: 6.16.0-rc3-next-20250623
* Git tree: https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next.git
* Git sha: f817b6dd2b62d921a6cdc0a3ac599cd1851f343c
* Git describe: next-20250623
* Project details:
https://regressions.linaro.org/lkft/linux-next-master/next-20250623/
* Architectures: riscv
* Toolchains: gcc-13
* Kconfigs: defconfig

## Build arm64
* Build log: https://qa-reports.linaro.org/api/testruns/28829977/log_file/
* Build details:
https://regressions.linaro.org/lkft/linux-next-master/next-20250623/build/gcc-13-defconfig/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2ytmqfZ6v24dxq5kjorJbgH6hC8/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2ytmqfZ6v24dxq5kjorJbgH6hC8/config

--
Linaro LKFT
https://lkft.linaro.org
