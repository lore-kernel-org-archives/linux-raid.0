Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33CC31578E
	for <linux-raid@vger.kernel.org>; Wed, 31 Dec 2025 09:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767171846; cv=none; b=iJWap8u4XJJDe1Gb1Xs2WyCT0+BzU0O85t5WHAHUyKBq7IukPSsDu96TQf+w0YLQ+U/h4IBpB7Dszs29GhJqJ+n/ffZuNx5m9a+C+EZV0Nr3Aaif9REukgn8ClvKs/fofTygwLD0inMAlVUpDw5STPA+i+MMBWupn6iPyIvW6WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767171846; c=relaxed/simple;
	bh=wBtDAUa4HfQQuwxTeAg1zsHMbcGnDDeCzW0ZhtsNrbw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=mBGt7dN0pyARdLXort+flGBKj++b8W06vGt/jYbeWKRJYogsWw/d7ZTscKIaw9faXv7igmFYUh+w3YrYVfvSJjrQME7HwjBHXd8Tss4A1gubuQ0posxABtyYIKodNXGRMJ3/yXbVkXbMPVmKPg2XMxpCFSjlY3cg6ijTVhb4aos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QFjtKQlx; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nFaEBoSx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QFjtKQlx";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nFaEBoSx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767171840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=wBtDAUa4HfQQuwxTeAg1zsHMbcGnDDeCzW0ZhtsNrbw=;
	b=QFjtKQlxIH1f44NZTA1yebybBgJaUf4n7tQnGAz+bCEKdb6gNy9p7EIwfh8efiOMXQ1r/f
	bPUoN09ygi9h2mFlaixGcVk65wiAchgPF6yMv7XLWiV/jC2mW/zU33CBUZnAk4ZzYzxZXY
	2pVmnikATkJyoaLXVP72SMQThCRDZ1k=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-9m3xHDhUPJSBy4Co09_eaw-1; Wed, 31 Dec 2025 04:03:59 -0500
X-MC-Unique: 9m3xHDhUPJSBy4Co09_eaw-1
X-Mimecast-MFC-AGG-ID: 9m3xHDhUPJSBy4Co09_eaw_1767171838
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5958540660bso9135942e87.0
        for <linux-raid@vger.kernel.org>; Wed, 31 Dec 2025 01:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767171837; x=1767776637; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wBtDAUa4HfQQuwxTeAg1zsHMbcGnDDeCzW0ZhtsNrbw=;
        b=nFaEBoSxEuHgDv/wMa1B4H8UaP9YwYZ7HbAJUb0G67HAwAe8eMjGijO44QROKf32su
         b+jFQYzHOnJvIGj1TNnwDlyairOLTP1IPSmXdTfxXn8NgJ3R4PoGKOsm28bZSt+if9vl
         6f2kMR4c55EzKn2bgizZE/EZBtPAfNGEyC+wUivVW0VDFSEjjgGaxeQCSAVeyzBB1LIY
         nIXYxlRiAZARBKPoB8ifEHho2auUCKt+7LnSeem5JqU0wrzfaueEcUuDjtuZq8ugjJTG
         XlqaIzutFBzNTrTvfu/HsO9mz3FTEh7fVqztmN7RCKzfmXiCsIgKzLMfSd/nI9zDnFAs
         MfDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767171837; x=1767776637;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wBtDAUa4HfQQuwxTeAg1zsHMbcGnDDeCzW0ZhtsNrbw=;
        b=wkgVVfYSXEKhQ5Qiebjl0AhIqB+CetLW1IWD4/OUPtAigE30USOnc/jQiODw/R2mkQ
         bJc7itvtyMBpikYoGhroI76YgjDsa5EcRqvWAR9g/1UzEtTMXBr1Rfl2Pvb+sxrgrMXQ
         4cOxtk7OK39LGzk9p6rFYOfuXO88lM5NIcOvW4o0b8WgGeJJxXekHZXm1M7Og7502Bfu
         pDR5FcsY4Tt9oCXu+k2gWsuSt+TG4blIsdnZSVBss5ppKsJNj25sn0Zun2nqodLsx2cM
         tEQauYuqKtzOToGhskj845reAG1ezsHisfrD3i1eEQr011Sob0LXoImzpt+JQsPECgcv
         YAuA==
X-Forwarded-Encrypted: i=1; AJvYcCX9y4kKqSJNiqYTW0/leq8O9qrgt6UgfOtLEsDHD1Jyfm43R8Ay8lzd7j8t+kPYlmXf8OiSxOZ3Ptys@vger.kernel.org
X-Gm-Message-State: AOJu0YzMu0jg+Iwi3ry7GX8p2EbYw+zn53R13FOgmz5UtkGJ7xp4+I/D
	WACvbhzsS/HLHUKBH3aZFbRkrxDohwGoFklfBX8UoDeJ6zJnEid14aiixWRlfSEWeHTWbzUDK63
	oogNcNQ6ERnIxnN5mviqDaJS8BVBcbsq0xlZyrqKHxpRMo3J2RG8h5pJHGvdcyVefnKSazCVhWj
	LZV9KB2Mrxge1s7BhJqj7R3MZqonHeafbYmvUQAg==
X-Gm-Gg: AY/fxX5W7VkWVD2iFcNtaXZ1ohgizIHsGcT5X7vogyxGIpUqKbCsPUItseQQzh7CBi3
	9oRLRSal/01iT2fV8szaaAR/h7dYdA/LeDx3Jongy5ROuo9ufI5nM4E6LsFD4Ejhat8plgTGPUK
	fst1CNRnrWiYA3TpKf+JOHeeErHG7PidlscHk4hyrYAOtvQfN3g78YaSv5rjgcyYdww1co78LOS
	Q9TgV+HVR8K3Wh30mumY3uy9Kp4KZD6/iYkXiUByKeO59VucgNXEcgXwVqy5y9503W7/A==
X-Received: by 2002:a05:6512:234c:b0:598:fa96:70f1 with SMTP id 2adb3069b0e04-59a17d352cemr12056522e87.11.1767171837455;
        Wed, 31 Dec 2025 01:03:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHmVyAD4yf+zCuCe+u3w85kq/u1jDbYERvxaTKgYzY4AeL6rMXK8xYZUDnQjGw/SZUyHMQWhWVY94nXZcdFySY=
X-Received: by 2002:a05:6512:234c:b0:598:fa96:70f1 with SMTP id
 2adb3069b0e04-59a17d352cemr12056504e87.11.1767171837009; Wed, 31 Dec 2025
 01:03:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Xiao Ni <xni@redhat.com>
Date: Wed, 31 Dec 2025 17:03:45 +0800
X-Gm-Features: AQt7F2rCcwML-kjly9VjgfjDrSvdtQm_nkA_HWHJZ9iWiR_oSOIQh1u3NTH7MEs
Message-ID: <CALTww293wnLE2+eZsZ42oyNZhS_cc2agB4GNqTz8j3xiP0ALWA@mail.gmail.com>
Subject: Release mdadm-4.5
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
	linux-raid <linux-raid@vger.kernel.org>
Cc: Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Hi all

I'm glad to announce mdadm-4.5. It is published to both remotes
(github and kernel.org). Here are some highlights from CHANGELOG.md.

# Release [mdadm-4.5](https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/log/?h=mdadm-4.5)

Features:
- Supports --logical-block-size in --create from Wu Guanghao
- Create array with sync del gendisk mode from Xiao Ni
- Update raid6check man page from Mingye Wang
- Re-enable mdadm --monitor ... for /dev/mdX from Dr. Joachim Schneider
- Use MAILFROM to set sendmail envelope sender address in mdmon from
Martin Wilck
- Don't stop array after creating it during assemble from Xiao Ni
- Use kernel raid headers from Mariusz Tkaczyk
- Allow RAID0 to be created with v0.90 metadata from NeilBrown
- Optimize DDF header search for widely used RAID controllers from lilinzhe
- Persist properties of MD devices after switch_root from Antonio Alvarez Feijoo
- Refactor continue_via_systemd() to make it more readable from Mateusz Kusiak
- Remove --freeze-reshape logic in reshape from Mateusz Kusiak
- Simplify remove logic in Incremental from Mariusz Tkaczyk

Fixes:
- Fix crash with homehost=none in super1 from Martin Wilck
- Moves memory management into Assemble to avoid null pointer
dereference from Xiao Ni
- Wait a while before removing a member in Incremental from Xiao Ni
- Some memleak issues from Wu Guanghao
- Fix memleak in udev from Mariusz Tkaczyk
- Support non-absolute name during monitor scan from QRPp
- Mdcheck fix and improvment from Martin Wilck
- Remove POSIX check for name from Mariusz Tkaczyk
- Enable udev block for Incremental/Assemble to avoid race condition
from Nigel Croxon
- Fix buiding errors from Xiao Ni
- Use standard libc nftw from Xiao Ni
- Allow any valid minor number in md device name from Martin Wilck
- Fix RAID0 to RAID10 migration for imsm array from Blazej Kucman
- Don't set badblock flag when adding a new disk from Wu Guanghao
- Regression tests fix from Xiao Ni
- Fix metadata corruption when managing new imsm array from Junxiao Bi
- Add update_super in ddf to prevent crash when assembling ddf array
from lilinzhe
- Disable legacy option ROM scan on UEFI machines for imsm array from
Ross Lagerwall
- Add sbin path to env PATH to avoid command modprobe can't be found
from Coly Li
- Add xmalloc.h to raid6check.c to fix building error from Xiao Ni
- Do not start reshape before switchroot from Mateusz Kusiak

Best Regards
Xiao

