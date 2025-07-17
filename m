Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFF6635
	for <linux-raid@vger.kernel.org>; Thu, 17 Jul 2025 09:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752744810; cv=none; b=RRl8ALrZwxHeSQ5SSSk+qAFDrork6cisksQ2l4S7rHm4KisE6QZnZ3T44KRBwqQTK6u2EBxRmE+dmifU8Y8LLGn74Oq3Ygu7FWJLmSt3yMIAMVeOlH1CFVHRgGrdY59leDxc3Fy1u6jq5pJ6e5jLqsga+FkkkI1mMx69Y6vEPLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752744810; c=relaxed/simple;
	bh=TJK9eAn19UQA7O4TOfKHLnfyaq0osxkXLp4lFk6ESNY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CYnC9Flv4kAeERS914Bo3IBGFfQETQn9u8fg1Q07BA5ZfVECxsJoZ/sPZVD9hqm6wgv/Hquios0Dmx4JHZra9d2h+ZQc9UxG56sPyFnWjIaQviVFwW15VaLXLfeIItFzPN82afqRIB1VX32NGOVguDXzug7B+rXNfCNQe9oU3WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nks1jkFQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nks1jkFQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752744807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aE29yVYTLWdUuiu71tNQZ4kQ0jy17jpFL0yDlkGlUrc=;
	b=Nks1jkFQfSUvJ+yjgCPc82Jm2jbKXXcs96R0mWb0OdQJBN7pgRWRV7vbwhjzJPGJ0pQFLR
	T52A8E5Q3B6JM7lYzY9vpfxDWFZVckPzonc1RiHqxC3GNmyJcg00XMRWpZHmjCpTdDGnR/
	N9qkth+3h+dWdHDAXokhXo4H6xSOai8=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-k76NSttVN_qFmbomtj9Dkg-1; Thu, 17 Jul 2025 05:33:26 -0400
X-MC-Unique: k76NSttVN_qFmbomtj9Dkg-1
X-Mimecast-MFC-AGG-ID: k76NSttVN_qFmbomtj9Dkg_1752744805
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-558fb734a30so449662e87.1
        for <linux-raid@vger.kernel.org>; Thu, 17 Jul 2025 02:33:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752744804; x=1753349604;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aE29yVYTLWdUuiu71tNQZ4kQ0jy17jpFL0yDlkGlUrc=;
        b=Pr383/HFLZoMfNnL9shB9vm4MIFJ6hA9B+PZ/JQkMksBEWKzgBRzhQb39pINfLMVJW
         5JQ0fV1VhbcVJKI0w2CYTcBZj/SMgxwDDcEA5Ny6idW7y2L/Ym86+rVR4/tOVTeKovHA
         OIv9kULB7IC5zaFJrgbw1VuMf4IUpe8jd18kBBna7TqKE4fy+wqSkQU71ZKCqn+l1PIS
         Xd8Q84BbuqaaP8C/xK99XjkStANYO+k6Jcpo9AVKm4h6RLeGXunnZNH4/pQ41p9TNQJf
         vcKMIgtpu/vNYjrulW6pNFU1AnbffzNU42mR5FwK//9/T87YllRyCGqKo25VrvmbF/Da
         sDhw==
X-Gm-Message-State: AOJu0YyLyNRjoTWN0YeUiTmceer1Ccpjh+yg8FQ1hHR+MdiJiCOJz04c
	sXYGBPXrkuOTWFwJhzW7V7AIeFEKVOSOsZsiOqOIgvIhOicE6cCKNhP51N4iof73QQifH+bZHyX
	TmLdDbAYh3Y8kbrlIYpsWUEUt5NGjgevVAuQaVSwN4hSdtn0b9KF4g00ajkCVZr40WuH+JyLaAM
	YtoAEiiDBIifCVlhJfQhRN+Hh7/p7LwL7/sZtAJQ==
X-Gm-Gg: ASbGnct6zr/T8ACUvBhgvLuzVl7EQwaWRvLF2vSAE3E48ZWo47iUxyXZJdtJbQ8GH3T
	LL4Vk4h7Q/Qhbr/M5rQdyj5maz1GtrSgI3OdQSrRbqWD20bGH1PQ/0k4n59c/EakNDuszpPHt74
	clBe+BqkpukotfbUb7OCTg2g==
X-Received: by 2002:a05:6512:b0a:b0:553:d884:7933 with SMTP id 2adb3069b0e04-55a28aa46f5mr755248e87.6.1752744804514;
        Thu, 17 Jul 2025 02:33:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7IMLladhC0LPsL3TNZzlyHwRH7GH3c+VZ+5m7u9WV++qarVBqppGA5M02rSLiZZu2NckdPrylPN+x3cfgnlA=
X-Received: by 2002:a05:6512:b0a:b0:553:d884:7933 with SMTP id
 2adb3069b0e04-55a28aa46f5mr755243e87.6.1752744804056; Thu, 17 Jul 2025
 02:33:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHj4cs9wqRvxxTVMYxPcaCQoedeRNn6CHJ_K5GsqS6YKMHeXiA@mail.gmail.com>
In-Reply-To: <CAHj4cs9wqRvxxTVMYxPcaCQoedeRNn6CHJ_K5GsqS6YKMHeXiA@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 17 Jul 2025 17:33:11 +0800
X-Gm-Features: Ac12FXxhyHtXt-pLZgZ5fAZfVSuqpxld9kFKYNusO1V_aXy8ULxaczUVtO5nm38
Message-ID: <CALTww2_+3zTsbSxr36iscO6q0iV4VYLRE-PNKZ_aCRS5TDCwBw@mail.gmail.com>
Subject: Re: [bug report] blktests md/001 failed with "buffer overflow detected"
To: Yi Zhang <yi.zhang@redhat.com>
Cc: linux-raid@vger.kernel.org, 
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, linux-block <linux-block@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Yi

Is it possible to use the latest mdadm
https://github.com/md-raid-utilities/mdadm for testing? This problem
should already be fixed.

Best Regards
Xiao



On Thu, Jul 17, 2025 at 3:21=E2=80=AFPM Yi Zhang <yi.zhang@redhat.com> wrot=
e:
>
> Hi
> I reproduced this failure on the latest linux-block/for-next, please
> help check it and let me know if you need any infor/test, thanks.
>
> Environment:
> mdadm-4.3-7.fc43.x86_64
> linux-block/for-next: 522390782310 (HEAD -> for-next, origin/for-next)
> Merge branch 'for-6.17/io_uring' into for-next
>
> Reproducer steps
> # ./check md/001
> md/001 (Raid with bitmap on tcp nvmet with opt-io-size over bitmap
> size) [failed]
>     runtime  3.511s  ...  5.924s
>     --- tests/md/001.out 2025-07-15 06:27:41.496610277 -0400
>     +++ /root/blktests/results/nodev/md/001.out.bad 2025-07-17
> 03:10:50.718820367 -0400
>     @@ -1,3 +1,9 @@
>      Running md/001
>     ++ mdadm --quiet --create /dev/md/blktests_md --level=3D1
> --bitmap=3Dinternal --bitmap-chunk=3D1024K --assume-clean --run
> --raid-devices=3D2 /dev/nvme0n1 missing
>     +*** buffer overflow detected ***: terminated
>     +tests/md/001: line 69:  1835 Aborted                 (core
> dumped) mdadm --quiet --create /dev/md/blktests_md --level=3D1
> --bitmap=3Dinternal --bitmap-chunk=3D1024K --assume-clean --run
> --raid-devices=3D2 /dev/"${ns}" missing
>     ++ mdadm --quiet --stop /dev/md/blktests_md
>     +mdadm: error opening /dev/md/blktests_md: No such file or directory
>     ++ set +x
>     ...
>     (Run 'diff -u tests/md/001.out
> /root/blktests/results/nodev/md/001.out.bad' to see the entire diff)
>
> --
> Best Regards,
>   Yi Zhang
>
>

