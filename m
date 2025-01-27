Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE81C17D2
	for <linux-raid@vger.kernel.org>; Mon, 27 Jan 2025 14:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737987343; cv=none; b=pqhKCKpASiBWkQSNF2eCsEdkIc1EAR1TxbT7K9dv4eF4GRQSDLxBRwKVBzPjtejBfvZN1pEtH33XLjWexLGZdzoyJUrIfeceVdrcd6a0eF7ooXT+BRNeeNG6uAfee2muy47s4u4WlFqmJMpLt6sm8gfdtshJMgi0RUPpvuGIPgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737987343; c=relaxed/simple;
	bh=SzfJaxV5z2wEu4HS+8S9+FA0HMFiYpl3do8X/uNSNTk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Ovwpv7g6zsUjogZampQVrubr+tVtFmU/wLzeiVro3MyrkiaNhv9Yd1z/WfyrQ0o0BDwvgqhx1FDjrqHuQvpWY0aaNShnYszT5N84EoMKLI482pbnb9MNtpAgWAe70+UnOcblx27F9XwRYOPU5p4Pk/Pa8yya6/s+yJJrD5qtVNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jUcANbH4; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jUcANbH4"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e46ebe19489so5997235276.2
        for <linux-raid@vger.kernel.org>; Mon, 27 Jan 2025 06:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737987339; x=1738592139; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SzfJaxV5z2wEu4HS+8S9+FA0HMFiYpl3do8X/uNSNTk=;
        b=jUcANbH4F5ZqcHEk/tUpZoqtrR6wL24zNAmikeuhBlWLL/YSpN1b74Zdy9+0f/10xi
         OvYdzUf1aPgWjKhU2f025xajy7wj2A6j7k0QTlqTcHIyI59wsso8g5FPhP52U3TL/LhW
         Z72NAQbgrq7ltdDUt03LxRbPtTye0Oi+SOzcxxei0TAQD13cF8h3bryBYv33824LsZv3
         K+0b27LDzkN5VpdaE8DAu4J0Tq5AznoCzPsjHUPfqnN47o7NrVQyLyWHNYU1ycIeyC7F
         cH5R00lzGVELgvXSDlSsjEXBpQ4uzmCdioSp5btuNxVs6ZorwGmVAErWDLlm4p1nd/4n
         gckA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737987339; x=1738592139;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SzfJaxV5z2wEu4HS+8S9+FA0HMFiYpl3do8X/uNSNTk=;
        b=JyDCR5jOMooGUOqXrZ+kdk3fBfB1WKU3idqddNULT/jpv5EBsMe3T2neKFyx0f4Ky1
         b93KNeye5+O6zINlbXwUmzqQp9vcmg7UArhed31fpKeFAzaDoaymgFxMOp8XWJwaPqR+
         bbBuNW+wuDtiBRtd9Zah6BaxxNmzTvCHz2m8lmZ7KNBjW/7yUjB8BCtEdkiDXmODje9o
         32f/0lIrIxgoGKgq8upRyObeK0vqZLRP0mdc5Tbiqab6rr/5vVyBpi4sOdbwEgls3oGg
         xrS+vASQHRla9szpceHo502HQZPugfwKaHogC5tQC+sZurpEn43KW2DPf3U/8LA3vm71
         osOg==
X-Gm-Message-State: AOJu0Yxc6J0diXS9S4UFrDQQmVwIxjmWGXtYHpDuq5h9LV6ktgHR9IH/
	JME9ieN4/9U3zZf61T5sjutnruRZSsBeQDwwJW+kzqjSrK/jZa1pVrYKAFBo0Kl8eQw9qoLHylt
	NcwmMI7ucAhoT+07vuYhheH8hnZkIY1LE
X-Gm-Gg: ASbGncumOZ107pQr92nk7DkzxrZ5VDrWSdD7ZIgOuwFZkGSkAsUm8kNnUMzUCMzQC1m
	0A3EwK0Z0Kt/3zoi51Um4X9b5uM2YJG0BgH/YztoVaSnEonKuvH3fhzwq32vkj088
X-Google-Smtp-Source: AGHT+IEA6InxdSNiEIjvH8VdR6IsyBEQnN//GXzrHZ7Wfl2vh50qn3gA/OmCN0fzQX/a2yXMftIJyKhDhJ6nlkpzE/A=
X-Received: by 2002:a05:690c:9a07:b0:6dc:7877:1ea3 with SMTP id
 00721157ae682-6f6eb6b08d9mr305118687b3.17.1737987339680; Mon, 27 Jan 2025
 06:15:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Mon, 27 Jan 2025 16:15:29 +0200
X-Gm-Features: AWEUYZksplPra8O-8ukD6hHLQ8enCSsfdY-k4qedT_arTdvIyf2BfthO06upXjg
Message-ID: <CAAiJnjojkqPOE9B1NH3F05znW8bGGMK+OMChXXaexHXJP63Few@mail.gmail.com>
Subject: Add spare disk to raid50
To: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, yukuai3@huawei.com, 
	Shushu Yi <firnyee@gmail.com>
Content-Type: text/plain; charset="UTF-8"

How to add a spare disk to raid50 which consists of several raid5
(7+1) ? It would be more economical and flexible than adding spare
disks to each raid5 in raid50.

Anton
