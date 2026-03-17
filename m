Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6C536403A
	for <linux-raid@vger.kernel.org>; Tue, 17 Mar 2026 09:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773740104; cv=pass; b=jm4A/yTVI24NUzvjTUznFx/oBDYftlrDD2MpypiwiKjB8B1l6lmhWAO+lLBELZeYZZeC6jvVqaiF6An2G/5LNb7N/PCgc0wRAnkMH3XaEANDLTime4xkQNgkXav5Ysp76C+Bqt6FAlaa1W/5dqru+f7dGJ5PX9Ea9XfIEse8ujs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773740104; c=relaxed/simple;
	bh=8UMxssFtujPGQv5HKzBR2G04ZKSbNykw7WqquktdypY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=YBOqEbgMH7xjWGiyiprPLv+V8CA/kJgDXDkJryNFerRgfoDZP6pAqiPmytaxRu8IVugmBE04RVvXlK6NAJ9AdmbZzb534MN1SgDuSNkhU559ievADoR8ea6vI1fynHhfpozfqPK8df2pBtmf+q/hFBIXCDUc6wu7XsgubgOut3g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=terpstra.ca; spf=none smtp.mailfrom=terpstra.ca; dkim=pass (2048-bit key) header.d=terpstra-ca.20230601.gappssmtp.com header.i=@terpstra-ca.20230601.gappssmtp.com header.b=fzKty6eB; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=terpstra.ca
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=terpstra.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=terpstra-ca.20230601.gappssmtp.com header.i=@terpstra-ca.20230601.gappssmtp.com header.b="fzKty6eB"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6644a3029b3so6323008a12.0
        for <linux-raid@vger.kernel.org>; Tue, 17 Mar 2026 02:35:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773740101; cv=none;
        d=google.com; s=arc-20240605;
        b=UZPS8mzcwx6qnWZdNovmCyJdRoDICuTKG1WTQZBTDsENlrQ441HCArG9KhnlsAvIVn
         Z08xSRRw5dQs99bq8naCYKPlsn4F9MIzaCAmUdVuoA+VpHa3m3pnXs26gYIty4cn3VTt
         ISy1w2UNBuVYZryCq1IqEIY1r3NDc2eQCDIX2OUUUJP/4c0fHdhF5+ACfAx9HmtDmCbw
         OEMmrKaxFdKa76+im+YwuM6ydRbkVmbdeHXPEGJ2Zgx3idoIxaPQsxIE67Xlz3rJX6p3
         oGvLCUV6CFHPvh+3zJf2NA1Ecgn5F3/LIzgmKvev03g1kbdM78VEEupxPGy53S/6g6WA
         hfBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=KIgrB2fIDcBQrG86g5cEtlSJ2ze+g6/iOIHNQEzzOIo=;
        fh=X3wQ2D3DBAZuXswHTOsYFcAief3bMBJ7HKWbj/5u/jo=;
        b=baxF6RxTA30cFv7wq6DHD6ej/aZHu7ETPz3y0kFkoFGZJefY+2m57enOsucsFtDFZ2
         m+CgjbK6MJobENP2lgzC8ekZHrJxuz1Z/h17Rutf9EhXJmmYLi7pr77LmWxhJ4GbVHoi
         Bd4WW9E2sg34zknpSXxionKnT4WtxOvgmcSlZqyxmmlaJ0XQEYpK3uBoQS0+4fG7qO8Y
         ldRm7sAVT4ESws3FEIpEIjYqFjrUkqPtpwQ6OsutCifIlj/VPWYAmAQMIB0Wc5DgvFkU
         nvyTIKYKVUDcNrvY/MgNSE1fTqQzRP0oZUxIAE8jpxH77nkwHfbe88VB9vPC+srG/NTo
         v12g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=terpstra-ca.20230601.gappssmtp.com; s=20230601; t=1773740101; x=1774344901; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KIgrB2fIDcBQrG86g5cEtlSJ2ze+g6/iOIHNQEzzOIo=;
        b=fzKty6eBh/HPKu9yXs6Y9dkBkN2rnBy8CJ/5i9dqHnqJNtq5MjWQWknZlPzVotYwaE
         C8Uu6n6Ja2IzfSez/Wc0DML5Vm+OXh+7GCJFSnq6PV1Nk/t9c7jTIrhWCokpCcwEt229
         gM5WtQ4FqwheSBKPoQByIbmxWonlp+1ehme8XXuMKAfElYgt27WjPv+lVUwI7RBNwww0
         WicHLRyc3x1A/XilMT4zfOflqjo4R7hU+Yzke5YieKLfCM6r8JgVnu+xha4BXdxJ2x6K
         Jom5l2k9CS8HPqg7X9HLdGkjlFO6SjEuyw7VILYC1qD0nias9WCpPhoPEKuSJrKJ/zsX
         6Mkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773740101; x=1774344901;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KIgrB2fIDcBQrG86g5cEtlSJ2ze+g6/iOIHNQEzzOIo=;
        b=PYMXwDkqQFZ4I+xTmvMox4L/pydBFM7TXWKsGrTKFtYn8W2AakkWLsVfETNQRqCQ48
         0spp2SBoMOk9ASh0uSmUT8OKo36pGJwpDaVpIgmq7Mly7KnaoV6YBiy9+EeBfEhCmyB8
         mwzz4L2kwc8xIEC6UKb6FazYQGyKHH9jpaH7lyRSvIv8O3YaR64UQQbNMwpM15Jef5lm
         W+4v7vRDmvf+rHQce8t385pwoUeeFXWZ3ffF0oEk+FVum3IBEwwSqHe1tCmJ0mokDHac
         2pdkcgZV+mGMUW4/SgRQgqe5ZozrWK4UMkPaJc0M9s/yActw2Y6/hkAePKQNZmGFy8SP
         EjZw==
X-Gm-Message-State: AOJu0Yzb5XpZnW7/7li3WhuQyKG5ohqvLxmARjBdq5JSrDsq6DcNnNa0
	bXcU1kkTvkqEbkOFUbeGyQb+DL8w2n8+cQI74fpjOLjNWe90dBP7fv+rzP1IJlFPJhiNbNNgYUL
	/MCr/fueKZkbqsSj9vreup13aTp34iNEg3RF69HT+yrtv5Js3049Sh2zcTg==
X-Gm-Gg: ATEYQzz81vs6VB5g+3ORH/89cexJ0nuUNKF2CwFyd8EI2mpJ3B3zx4kMhEzKPBI+Dnq
	DFhWX4HTgZoGi/trmEWfs6/9nJMJVxdhXPjI56dIHJ77FVPfOJ/ZIBf7WaKuqIBrgOZf06Vwko9
	Ncihe3IE8PzD+J/BVof4c+LhbYzCCWcVhx7YTHIFHCoL4rgjxY24lRaatrO5EhOb942pvvZ8Ygc
	eRMXPQdk+esMqLQPVkfbAxMSm4aRzgQogvml4RJ/bOhiqUETZ5ZRFfldDPmdoRKVxExD8i5p0ZY
	j5Lss7vgdeznZrmAGGuYDmGrPG9RpsE388/pvETT1Q==
X-Received: by 2002:a05:6402:5214:b0:662:ac7e:aac9 with SMTP id
 4fb4d7f45d1cf-663babcf559mr9665179a12.20.1773740101286; Tue, 17 Mar 2026
 02:35:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Wesley W. Terpstra" <wesley@terpstra.ca>
Date: Tue, 17 Mar 2026 02:34:49 -0700
X-Gm-Features: AaiRm52f5qhQV87ZXR5w3BclmGRHvwj2F-ImRo7-R5e1x0QHDhr54p9G9fXXOus
Message-ID: <CAA-O0XhEPBYb92+b99UnRpBP2z10fGiqAGrtvkK8A9ihtA=Qzg@mail.gmail.com>
Subject: Bug in RAID10 'enough' when far_copies=2?
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Consider an array with raid_disks=4, near_copies=1, far_copies=2.

The function "enough" in raid10.c requires all four of these equations
to be true:
  Eqn0 := 0 || 1 // device 0 or 1 is present
  Eqn1 := 1 || 2
  Eqn2 := 2 || 3
  Eqn3 := 3 || 0

This behavior is specific to far_copies=2. When near_copies=2, only
Eqn0 and Eqn2 are required.

The documentation claims that for this configuration, the layout is:
  A1   A2   A3   A4
  A5   A6   A7   A8
  ..   ..   ..   ..
  A2   A1   A4   A3
  A6   A5   A8   A7

In this situation, the array should NOT be possible to reassemble from
(0, 1) or (2, 3). The 'enough' function rejects those; Eqn2 and Eqn0
fail respectively. The 'enough' function accepts (0, 2) and (1, 3),
which seems correct.

However, the 'enough' function REJECTS (1, 2) and (0, 3) due to Eqn3
and Eqn1 respectively. According to the documented layout, 'enough'
should accept these configurations.
