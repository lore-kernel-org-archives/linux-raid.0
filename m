Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E57284B3E
	for <linux-raid@vger.kernel.org>; Tue, 25 Nov 2025 19:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764098408; cv=none; b=DiFKDl7BQpIhj1sMQtc8WPv8ctDB6mldS2qcom6hCiZ2jSdwBxYr5ggqCt75O8vDGYvwiEY16I74J8WVBmC/zGN99UY8GQmu5SWyiGige5Euk5Hw7iGB4nyHHeQnjHnJxNPcAv+1Mr4gPwbUz3SKDbriY1beaTtBQSKWZBUlP5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764098408; c=relaxed/simple;
	bh=weoF253YS0RDYDNFjzSDJ5tIChF4WqxAAq+yZqEKh9c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=NgbHXjNe9TyZ4py5p912wCYrrjAtPmt2+IGbPVK53l9GsK2fhMFoMpfj8ZLlNUJpci5/JbBoCgXSp0W4FAGz868hr1G+DU7dI0pXsx8CQXNwawyDc3z+242GEdg8r3OWMhWja21suofEcpY1quOewT/TIcK2+A2Uaw2FJL4VhhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ou4yP+cP; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ou4yP+cP"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-948c58fe8c2so232405839f.1
        for <linux-raid@vger.kernel.org>; Tue, 25 Nov 2025 11:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764098406; x=1764703206; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wynpj+E5fG2Oh1abG+WZEscR5HBvHm5298AKLCuUClg=;
        b=Ou4yP+cPskomYMeVdRXei3aGe4CA8qWru7OsQP6BwdThf2GaArI8DOmVuUTM/9jgv8
         7yfb3c/0JmSqRsVHmB9X6Phme2s4crzBqQXAGysf6khbNn9GegUtUQKxVlcAy26vQYp6
         kl4sPUIwsjVQr7ahV4j/Ysgjpa1LobItHW3YSAHaxTCkylGkOFUf13dApdSBcuce3quJ
         ddfICYEQhhFNAtAxjqjafE/HQviesUSIZ0VFAkfuiWwoW2sMZmGf6ATN89T2oU4YONDk
         y6k1rY57h3ydl5s0+qPDswY0JwxaJs8RBzn4/NiEMU3SkXxLKVYxTQp/dmil0NkNCP06
         IxPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764098406; x=1764703206;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wynpj+E5fG2Oh1abG+WZEscR5HBvHm5298AKLCuUClg=;
        b=t8KiaPX6NhYKhaDKhZCG0y5Cf2z4G36UC7Fse9NuommsWxeG/Yu79I00FeccLPmrw4
         vEIWdqfCkF0NfYCP3Xgu3zzaxq4uMY/3nKn+loWMuWm4yFuQaV7gObuHhc95PogMERyI
         Z/oE4fzBvHrzrZvYk14cvdytCbJ+EehwnKVcOMy5OD5OUdGf0tR3S0hUv+o/6brXsDHh
         bBRRM3AWd24H60AHC9VdSARp+agDPZJWGpJL+zDr5QHB8yuNFSO/H8n6j4LKK7w1xsoL
         3ntexk6nhr2uB7Y/MKmmarcQsnqZqpxnP8UiMgth1wlaEEONtJ90g/aOUCeeuf9aOcpI
         p2lg==
X-Forwarded-Encrypted: i=1; AJvYcCXwcNFQvC7tTzXegY/eCTGXBraoiP5/hX3pR2oo04X08BOJS/52Ks4wixTSsGJHuvFKmwstj1E/bUM5@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2WlcoMV2pz2M/IyQd+Bf1Ieb01j+OZ7z2ZSwnUpzFiXbtpO+I
	41e+nMmUJBb9qh7LYAmIjvIfOi/86iZ1aJJTgnbcmI+iF1ESENt0tu+dY3XqT+BPy/U=
X-Gm-Gg: ASbGncsWv1YW33SVxnAU5eLRaMGhw/Q/UgyDnui1K7yQwpw1Id1J4UcoelE0uvq5Z2F
	6ieNgc371A4EW7UdwdoSc2VMngUe3pse9qMYQmKWs9XDT9arqzBvZpFU3ucKMCFqtk+k/6I3doa
	40cMEdC/pRHRU6k80QfuRKNPRB5Ij17gDeXVnIwMwCxHIUYvVAhRBDeZr0IXPu8qrs3fzF7OpbZ
	Y0a52anb7upraAq7la/RncKtH/kqrJglOt3AXoojf0hHgkEVVSQLiDJ929DUw8atBOfedHSjPTa
	WQlDlVEnRbayXKziGGUmQF/V0WPN7lo3X95BuaIFPStZVJGWmah68v507TuA+/PzD/i1SCQnRu7
	/259ijy75a+jy4t6Fugrq8KLAVDzga0uG99DS+eKzDNxY6jonmj245/yYZXpwV8tabgWz1L+F8Q
	vo2Q==
X-Google-Smtp-Source: AGHT+IEoSNUPWsr6TkiMj1VyTgtSM+H2mYKN8PQqct0sy21hTM0OQb7u5ZARk6n0QLi/CE7kBBB/xg==
X-Received: by 2002:a05:6602:690d:b0:948:a32b:b6c4 with SMTP id ca18e2360f4ac-949473eb047mr1023076839f.3.1764098406436;
        Tue, 25 Nov 2025 11:20:06 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-949385c2405sm668551239f.6.2025.11.25.11.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 11:20:05 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
 song@kernel.org, yukuai@fnnas.com, hch@lst.de, sagi@grimberg.me, 
 kch@nvidia.com, jaegeuk@kernel.org, chao@kernel.org, cem@kernel.org, 
 Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
 linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net, 
 linux-xfs@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
Subject: Re: (subset) [PATCH V3 0/6] block: ignore __blkdev_issue_discard()
 ret value
Message-Id: <176409840493.40095.8097031483064544929.b4-ty@kernel.dk>
Date: Tue, 25 Nov 2025 12:20:04 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Mon, 24 Nov 2025 15:48:00 -0800, Chaitanya Kulkarni wrote:
> __blkdev_issue_discard() only returns value 0, that makes post call
> error checking code dead. This patch series revmoes this dead code at
> all the call sites and adjust the callers.
> 
> Please note that it doesn't change the return type of the function from
> int to void in this series, it will be done once this series gets merged
> smoothly.
> 
> [...]

Applied, thanks!

[1/6] block: ignore discard return value
      (no commit info)

Best regards,
-- 
Jens Axboe



