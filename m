Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F16B25B1D3
	for <linux-raid@vger.kernel.org>; Wed, 16 Jul 2025 14:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752676259; cv=none; b=QdrHmtK0pgQnfATUOLcBYUPspjML9x2XamKNRmyUKwiWgGx9UVVoK0iM7ssrZzANfFnT+WToJ/VhMIdGVdwn2iuHi4uzPGCWjUti5SDJJ3523JUvn98a7jHXbqrFkAt4ysPzXGtkkSWEvwzpQ3W+38yhMymWmNsQztv74a3ul6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752676259; c=relaxed/simple;
	bh=5yadeAhwOkylHohrm8f1lIX7wJNBz6KbhBCyxOoUdOk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=nmoe8u+6b0f/K/Mpg/5qER+bytuNTx5Vy4GoPk4zpm4hs6LW4HohrrQesqiQCF5lsYzZdYpeY5PtuYThXGIXtQF1F98zRz45IIpxAW9QpwT1+p0Ke19f4GR0dVlYlMYS5Rp+F2Du+eafHXxerBAJ5JzDmBEs5G6TgElMrGVB4lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N/4GNW7o; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N/4GNW7o"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-2ff94cc4068so621009fac.3
        for <linux-raid@vger.kernel.org>; Wed, 16 Jul 2025 07:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752676256; x=1753281056; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QxycvHgGPJ3E4s9iGDhShTT9waEDaA7mDINAVVM0J7g=;
        b=N/4GNW7oYVmXmxp5+wCVelV/dV322h+JU8ywUSmIRoa6eaNGqNw8m4APlVardl/rSF
         1+PQkpz4OGNU4JK9G3O8CifkyEIBY0fXVGxO0hvzCYL/C/jemOO11jb8CcpjOsgJyAlu
         3sGlKFmqhyJsemhXwp4R/umjWF8Ho2mqweySShHtQWJLyBMFvXbVvPYQaiX6kKvFGHMZ
         6++GX3xHSx/pQsE/DD7ZRBbQUsnQ3sHrUfEbA03F+BA2cBwtpuQg+nT0rewKnGn+7slk
         2xWaDOkOvrspeJg0yPgwN48vxpY3JHIGUV9FCk1kpPIGYsjJ0TIrU4QmJNXV8Ptxaa+0
         ZCMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752676256; x=1753281056;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QxycvHgGPJ3E4s9iGDhShTT9waEDaA7mDINAVVM0J7g=;
        b=CAodHWfJfpvdFj/vARUIDUqYoygWx0Cp/hCZPjGUkUuZJXVBktZf8d0VPVC+sHLL1a
         NrGghPAs0wuzFRGGzPQOFqoSnHoKfRnM6Xj3+bawvyvFG+5Gs46oQy75PJAFPGQ6rnFH
         Ct4hu519v1rw18Hhcv6gB0wlriIRt9v5R34PuDa7y2fOLkdUqpH2vYcqD2QP2aM6Ibko
         X3eXzGZNKljA6bX9SjQd1ulBQHG5LXInBAJ3MAbjCeeJTTjYRAkusSS9TCBbyf+9E1FJ
         97UZjWJ/NxGLcIxAdr1NTQp97G+tGKGa7/9MQDXYr7p20/kkXrK51z3ic/w2U90ZXBfB
         tm/A==
X-Gm-Message-State: AOJu0YxvkXH48fel833wRSHXQRWbYcSN5mzQ3JwXzLDTSA2Ns/btBAlo
	bU3YG/eMEcPobxfkH0CnROUFRJcLqwFsMNvtKTdAESXmH9kXVrnLxVW4k70uuV3l/yPGr4XKX02
	Qj3xa0J0K2CcHTXOOWGP3v7+J15SAcus4JGUp5og=
X-Gm-Gg: ASbGncv4fuZwY4k9VkJhFTde7tvTWAqpKDDnzgruS6y/UxWoPtDKfJ4ecnC7YewTSc4
	Qo4PxCB/YGV9yVtai4aK1AVz7ewI9UE5Zd0H7F50mgmRVwe7px9GNS8GezyLp4+U+nh6YnaNy1v
	nfTv5rflRMNZG3U09cRixb+kZx3tV8W6Kg+i0Z4uwRKzQ+ZI4PRC6tBJKGCEueHFAsR0NkK7VbS
	nbzbTE=
X-Google-Smtp-Source: AGHT+IG2DINOCvDnsz8dgUzxPKJaP+dWUaSlkznZ/o59XApVZdbVs+r5RJJbcHZlRnOLbiGlzg1lnfmfsXYGuiFR1Pg=
X-Received: by 2002:a05:687c:2f21:b0:2d5:2955:aa6c with SMTP id
 586e51a60fabf-2ffaf544ec5mr3068963fac.31.1752676256308; Wed, 16 Jul 2025
 07:30:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Filipe Maia <filipe.c.maia@gmail.com>
Date: Wed, 16 Jul 2025 15:30:20 +0100
X-Gm-Features: Ac12FXy5AWnqzadysVoATwO-owFMQFOuaBV_iv2n6emvEhCbCa15rZXT_ZbVOZ0
Message-ID: <CAN5hRiUQ7vN0dqP_dNgbM9rY3PaNVPLDiWPRv9mXWfLXrHS0tQ@mail.gmail.com>
Subject: Sector size changes creating filesystem problems
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

When a 4Kn disk is added to an mdadm array with sector size 512, its
sector size changes to 4096 to accommodate the new disk.

Here's an example:

```
truncate -s 1G /tmp/loop512a
truncate -s 1G /tmp/loop512b
truncate -s 1G /tmp/loop512c
truncate -s 1G /tmp/loop4Ka
losetup --sector-size 512  --direct-io=on /dev/loop0  /tmp/loop512a
losetup --sector-size 512  --direct-io=on /dev/loop1  /tmp/loop512b
losetup --sector-size 512  --direct-io=on /dev/loop2  /tmp/loop512c
losetup --sector-size 4096  --direct-io=on /dev/loop3  /tmp/loop4Ka
mdadm --create /dev/md2 --level=5 --raid-devices=3 /dev/loop[0-2]
# blockdev returns 512
blockdev --getss /dev/md2
mdadm /dev/md2 -a /dev/loop3
mdadm /dev/md2 -f /dev/loop2
# blockdev still returns 512
blockdev --getss /dev/md2
mdadm -S /dev/md2
mdadm -A /dev/md2 /dev/loop0 /dev/loop1 /dev/loop3
# blockdev now returns 4096
blockdev --getss /dev/md2
```

This breaks filesystems like XFS, with new mounts failing with:
`mount: /mnt: mount(2) system call failed: Function not implemented.`

Shouldn't the user be warned when this can happen?

Cheers,
Filipe
