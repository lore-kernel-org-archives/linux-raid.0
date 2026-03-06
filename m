Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7577D34A794
	for <linux-raid@vger.kernel.org>; Fri,  6 Mar 2026 11:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772795892; cv=pass; b=HOIoKJZZ1rtfIeEpYPkomXobF+XAtpDKYVDDRw8/XhvQalnHCcLyfOEr9trgRFCULUl12J4PEzJvik7LugJjSjD3WmX9Yh1OfM+ZaoT4oTlE9wAhDYLnL01jhHgquD2/2/iZLrFvxBeNF6vnYnDTLLoBegLHtc1DbBJEkW2Fnfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772795892; c=relaxed/simple;
	bh=zQ5ojADWZle7PtrUOVlrzCWshr/h5UnNkNE/+yx34Kg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=TWmxo+mcMugByxLtVE8PvHJzGMFbFP2fXPorN9uHdMRcs9bk3jJ+GWgBgYc7qPUuei006G6cXLOJIKv0eIEEP6JfUMQp3/q/T2JAUf0R10B4i9beWOHSYjioUsFhq9JxDkPD+CFlTc0fq8qvcd5Cj5GJdt2QOMsL+M/85b600zE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gNDOlP9p; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gNDOlP9p"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6617f0bcad2so1903455a12.3
        for <linux-raid@vger.kernel.org>; Fri, 06 Mar 2026 03:18:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772795889; cv=none;
        d=google.com; s=arc-20240605;
        b=ead18vgG2cK9nxWqY3jde+7n7Q38wNEeGQfNq2L6/Ndvf5MukrT9vG3vhKGYXvDr11
         HXostsNehXOO/i29fLqXQGYeJ46u9eNnqYyR/GiuUjULxHykwypYkLU8l80CuTlPXuot
         coNE8xoVWEkHdyP5qTTryFHNmzSVlvJGZ0OoEzPatVpoEyCWCx03i2Reb7SzkWlcYwZC
         mHydVB3lMUE4Ee8lEC4HZBgV+/RK6xyKDCXqwmhGJZj5cLWaEo1aaXEEIUKnTEVIOmOc
         FOQrafVPgNjcWdVHg9XHxiMKW1tSMRByzhRTi00zTRIutMRgJgnzKJScAwcZxnJp9/Ao
         5YBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=zQ5ojADWZle7PtrUOVlrzCWshr/h5UnNkNE/+yx34Kg=;
        fh=X3wQ2D3DBAZuXswHTOsYFcAief3bMBJ7HKWbj/5u/jo=;
        b=jj+T/Xjkg8gPizSy9h59I6LIs0tPZoL3LpaKTpiC9Wc2RX6Qtm1ru8CHneEWalODf5
         TMrG2gcH6gXFlESMo13b/KOOBlWfixl+vSYqrmD5A5yZLUlgTlh2HIhCo//EyOz5AjfW
         sMxHV7RRbviD+jGGw2+FoBYJgoCpqI5a2P5m3n5f3uBTkYeRIjDG2Dkb/ouCOnKiiFPO
         pSobVecB9SH5goQVV6e9eAZUgRaWjZYotYTT5zx7+XOuK6PEq6RziKuhsaqpNDX00tO/
         JjybF3hpIjoUJKSNEdp+6WxCgDpRZmJ4m89LZ8Z6qYOIQo3R+J5f10uGpAzH2z0LHzUf
         1DCA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772795889; x=1773400689; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zQ5ojADWZle7PtrUOVlrzCWshr/h5UnNkNE/+yx34Kg=;
        b=gNDOlP9pgReSbEJVDup/co+SVXK2za3WiJ84yAkozzxZ5DEbe/oIyMqDiC6yXBtQUR
         +Hrhm0FKg5SAx3xCkEhnn/2jem6WTaa58iQCrZK7bIr4Vzicd696ZxPht5wValI1+g72
         7Fs7oXqm1bJO7H+t2N6mD8RRK5Iw4I4ZE3eR4UJqLnY/4OlxdGYfhV2UZT5tfQwQI0N6
         AUk+8pMcQhw3YtFMY04KdNORzk43zBx29vYQ7g4vEc3YiPrO9kQP5QWNm9jesPCbbA55
         r11Bi8kL0YJiIni/3H89S84dzd+7hcNDuSvQ5GOi/YnD7lZQpZMNfY6ySHuPI3hDiCWJ
         w/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772795889; x=1773400689;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zQ5ojADWZle7PtrUOVlrzCWshr/h5UnNkNE/+yx34Kg=;
        b=KAONqrBhrNVPdUcunNpDeHvZL5cdPPSO4UKOWG1yiL4MhF0OlcULiN7D0NRhNRGRm4
         FjW/PelIrAWd0Le3bJe5UIAvc9XMt9s2bfViX3lGU9f++ul7ltXILCjW0jE5PhublBMj
         rqLFLFtURQnG3Et+v5rxSdIw7aEpZLbcpsxpsMeQ7xX8uVcBk1vJLU4y6hg3mb2AzqGO
         Y/3ttPje98neHJaKzBBRMm9YR9hpyK01eHcF6JSU0dW3abuLSVb+KPgQVYhifYHs2Qmo
         Mx5F8zulRKJBHQriWmrtB4H7T8/UJRD0vMAtLeHS6cBGPm5U9ulEX3Zs5q0Gqgx3OPh/
         sJtw==
X-Gm-Message-State: AOJu0Yz0UFMsgipN51E8tQKolX36eTdn19+UrWncOVoHOHWaDVose9+h
	CaggSZnrCroPJmSsLQlH7Fgriky6g5SuYzWh9ALNtq0Gx2EIsqPckOgl7wQC5MIarQJA2GHRCne
	0Bh3GJYitCdmWhJFGRGKJyM88OjRW4sNKXbav
X-Gm-Gg: ATEYQzyvkD8lrp/GOQAMz4j6RwoVqyr9DPnYeam5e7ypZozBUm3jP8y7wmhE5urWAKs
	D+YZGNcjXtCim0ZjhkKidfviSLHpe+6rUvg4PwxR9yhqxAyGyLEOJdoutehYxkYdRdHXgFYKywN
	VNHSnSGs2hen02fFwY7bBleQOV5apBka6h5oVn5kBVEjVRggwiYUOADzN1b6fOKX8JPQvYJkRkI
	cGm7Ay49tx271y75hnzZ9YrZq0iEHxqj/7iN9/P3j5fw9lcjlbiG2sHzOGvowR4guYqQc78+ywD
	0mEAbLlP
X-Received: by 2002:a05:6402:5208:b0:65c:6d0:d9f8 with SMTP id
 4fb4d7f45d1cf-6619d4f4252mr817714a12.25.1772795889491; Fri, 06 Mar 2026
 03:18:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Fri, 6 Mar 2026 13:17:58 +0200
X-Gm-Features: AaiRm501VzfWBM6utPGA276qrRTHFuTCYfc_Z_L2qYIuW2QSZDjo9nXce3azJCM
Message-ID: <CAAiJnjrPXEdgt5U5=13e62z4Vw=UzPaSZO8NpoqAoNV2+KQSTQ@mail.gmail.com>
Subject: md-raid support 50/60 & spare space support
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi

Are there any plans to add support for md-raid 50/60 ?
Maximum recommended number of disks for single raid5 shouldn't exceed 8.
So raid 50/60 would be very useful for systems with 64-96 disks.

And also any plans for spare space support (instead of spare disk) ?

Anton
