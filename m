Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935DA34AAE4
	for <linux-raid@vger.kernel.org>; Tue, 23 Dec 2025 01:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766454091; cv=none; b=rZMvcdYQNhjBUSkgfLu1a8zzjvFn/HzsbrE6iBXTSBaIk0fviR06/NZTPVrBGX+y8QiohJdGuDULFOdPL692zg23vNTx0QK+tOU35DvsJsg3ubOby0AtNALbPDKoI4P//HYES3yELhZDZ9NDzTANV6Ur0StkPI6a5B+6q9/G98s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766454091; c=relaxed/simple;
	bh=Dw1tVh0CmnWqKDbnt9xHH3i4dpkMlWgLPtv4rSVZoxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wb1+Ru68OjCEY7d198CYqso/1y2KJ5dEqbaigI8DO+78twc6/phQpAlrVRB9uUPOFe4NUsbNxaONFIkzbIHUVlHqlxOUpBTcwGnY9ZgYDICEgs6l3YhDEzuKvZ7lfWPYOr/CCpy6E0HjrJPwxjs4ATU+e4RNb+zYnCXnUPhossI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OfOsId7s; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OfOsId7s"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-59b25acdffbso259143e87.2
        for <linux-raid@vger.kernel.org>; Mon, 22 Dec 2025 17:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766454088; x=1767058888; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uzc2azkAT7+UZs63CJT4nkeSpZYqRpvq+hUurVd9/nU=;
        b=OfOsId7sIcDGQy2pTh1vUpxLeUMu89wMN8s4Lk5g1kjn6irxsnAKWeUrpNqRGyoG36
         KeetWAt4xPplCAfvWllRU2qX5LiXDYmB4HICp0vluIlAJj36byf5FlO7IURPnAFcLIfz
         EdOrskXj59Xi4pyqUHPyuUwgjUIFaXZtWIz1k+TrIRp3q+8hANEkpNpTzlkL1uX3AgQ0
         ZClbOvf3LRxSqsQg1qNBWzRHYzc57vVVkz/mG+VKQYTkkt3PAwUnDwDy8f5K8XKVszoR
         AeOMq3ZA8JcsAWy+d3QFwQ9mUBT9ymlXsOOpr25TL6BQd5Dr8Z9ZO80mclH1UxWOzlrI
         yN2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766454088; x=1767058888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Uzc2azkAT7+UZs63CJT4nkeSpZYqRpvq+hUurVd9/nU=;
        b=mczHjCJJho/bkvQtp0V3saibuqpF8V93/AAMlC0GRhvADGYoT4PdnkmX7Meja6DXBK
         iwRrOYjyBYeQnxi07HNdlX5FahLSDNAdgcznSx5le0GzvOdOPDVVlogQM9dvT7XqM7D4
         2mZXBTwmJWB7HkO3iUuLcn7xaKbhgZArQ2dZf7qiANp4y+mt+f8q/3ohF5ESN2PlG7j+
         VyKlsyiFUEMbI/1tAIoqf0peWBl65gjaCRllVEjhl7KIHIt/FDHpE3G08OSAfcJbDWzo
         qJab3DStrqI6SMhfSl9GBTMUU7Ui0JP4PntRouqY7d8ADcug/VQuOdMN28Hi1xeRcDFl
         UIFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBgYFFaDIFTzDV1F9oq5lFsqA9CaMbBWW1lTb411J2NVGek+g9nEtQJ5ATJMbxX/vDvNF699baw17B@vger.kernel.org
X-Gm-Message-State: AOJu0Yymn33i3c1AuBxjgUfnTDtGgpl+EGJvPOjKTTqSv00lRRHh1jVm
	3X5XDToTwKizcZIDVIz3KTG80ja5Ds53k7wtkaPjoAxBCIBxYF0QUhuY
X-Gm-Gg: AY/fxX6lDS3fvhMwwf1iz2qIfII+mgbLjS4Wla6mQy51NA0eVk05hagCQJr26Npp7Xh
	PZn2SUyweBE4a3UEmAoMZIeyjrB1gGWi1A8caC8l4RtZFHEtMt6oNqVBEeAZavcWk+US4Ng28QK
	FnWHfV6jOxwocAaRYzksggXLixaC9Jh+6Pp7veQfmhBW8dUu+ATIHlgH0MyocnbqUHVOv2p06Jv
	160KG6MLMLaP/A/3cL+VYrxofyPrUwzMy7aYYvn6q3rJ3f5Ez7zIYkGqbFZFOCs4OwOKo9XSTcJ
	NdbLnfsahryZME1D1Hly7fUdapiubVcOt2H3jIwZBcoPr/yNZRTMcVZdSJ/JiH10EeGjUnCYPsd
	aL00/IZ0EPyvwm7YpJPKSOa+oAn69bIMNooF5Z46GMmfPGNC3Di7HzfgTWyNBv4z8/LIKShTpKu
	m9L+RXgIR4
X-Google-Smtp-Source: AGHT+IHWUix04V1tUMjJhj8LmwIJFsrYjMJ2eegt/yizChdKwHOARh8H0MmDtl7KvKnzF0od4dTcxA==
X-Received: by 2002:a05:6512:234b:b0:59a:123e:69ab with SMTP id 2adb3069b0e04-59a17d08c20mr4858078e87.10.1766454087534;
        Mon, 22 Dec 2025 17:41:27 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-59a185d5ea6sm3600776e87.5.2025.12.22.17.41.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 17:41:27 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: gmazyland@gmail.com
Cc: Dell.Client.Kernel@dell.com,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	mpatocka@redhat.com,
	pavel@ucw.cz,
	rafael@kernel.org
Subject: Re: [RFC PATCH 2/2] swsusp: make it possible to hibernate to device mapper devices
Date: Tue, 23 Dec 2025 04:41:14 +0300
Message-ID: <20251223014114.2193668-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <86300955-72e4-42d5-892d-f49bdf14441e@gmail.com>
References: <86300955-72e4-42d5-892d-f49bdf14441e@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Milan Broz <gmazyland@gmail.com>:
> Anyway, my understanding is that all device-mapper targets use mempools,
> which should ensure that they can process even under memory pressure.

Also, I don't understand how mempools help here.

As well as I understand, allocation from mempool is still real allocation
if mempool's own reserve is over.

-- 
Askar Safin
