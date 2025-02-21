Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E38318C937;
	Fri, 21 Feb 2025 06:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740117914; cv=none; b=LC/pnS0sY+jdGaK0u4+8vu2BU+F2YeD1NmNdd+63NddwnEvPmRv2RGIdQ1UsiXKDltsaNZVJ6U+HV6wwtbw5tS8VTooEKdN5uLwJ3VAf7KlfoU+jeagcmGm5ndKlJjgX8osAF3IgT9Avpt8Fi5UjoJFZM3B8bNMA2OftKUAdA4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740117914; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QzWkoeeQwAOKhap8VKLiKF00Jn97GwVeZDsQoJfusnlaglsriAPm0V8rzWT9fM1jLw66hMDrnhbzmBOTDt4XGzcl59NRoNYY/0Hl0MX7yX4UwHttFa3jx7Fw0x8gbWGJXY3eomCMtoRtTJ5XNIgDd1La1qaZLyUx0RLOlzGI5YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HPgxv01U; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HPgxv01U"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5deb956aa5eso2137645a12.2;
        Thu, 20 Feb 2025 22:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740117911; x=1740722711; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=HPgxv01Utnm/qpgecx+p/qkYFLVsmr4iRrbwJl0Qnc4OzyCCkhn6UxZMCRXRaMQ5UO
         mazt9Y3/+gvmamOcQdhvR3fVhI81Pcz6YlYHER4EWNdIffS0U1BtZ27wmHSQVmOWlnx9
         gdiAHOMWUuou8AMpb2aZWfiHggP4is/CXdOxG72y/juarnxo0qAoLXcT8u+xABwko5Ez
         fTRflxRWgG/zhYWjFqrfkRmb9RDSeqp1xIP1i2wzuX8Hj1y3l8kTZiZYbeygCXFR5AAf
         gCEsZWZk9oPSKh8SOsGj2rL+r5QL15wxfHlom5xXpfVsXiCqExAAO9pI5u+lP49pN9yf
         j5Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740117911; x=1740722711;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=ovhld4+ZVX//RKmUfRdaNaqEsbcDbQ22IamBSonnGz++1+IyBtSu+Jgf8kQuYjQUKC
         thGTZ8Kav6AuqnXDGDS3wP5JdlXYdSGNRmSazHoYfPiJ1LP4rQjP254c4NXuqEuavMIb
         7gzbQUkszU8Zf0MH+wzhJCltX/dEo06+8yZbD2UyuXNZZNvSeqWyMFGdBNQUcbGB2m47
         zVzi2uuyNkaFz3ar7g9O8CHLXolAxlGGLJThvaSg1laA+F8sVXwQ2BL9TjvoUPY3SSXx
         BOzlBYrmPWKoyGkbQfNlZNHsohIsQINc0p4yOYrZJfMzEnVlOLt4fKa+fOT+Al77jw3L
         lCKw==
X-Forwarded-Encrypted: i=1; AJvYcCUh2sWA7zT/1hjv4WyRWhAl5cJH/FOm5Xz6XsLvvyLwU00cXbMlNV1d10cgu/bU5QTz/FXglettXv5K4A==@vger.kernel.org, AJvYcCVUS4RjIO41gtq62M1DPi7GXpla0PMGj9d/4z6K5855WTNLTBM2KsuzGVBNlgbCH0iMvkU0XwBkxeuf43nM@vger.kernel.org, AJvYcCXq99utsRyLGdni8D0mlL0978xQKgndGDGm8lDaba/9ZaCSkaf3mFZZPe1RcyoVOU6a3/u3ou1uF7g0iA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyzqlGNa0TThNeEHHlfzE6LRIl+/jmvobQYvf/4Lf2Msyf+in2g
	dsvYJOQ1eoCAc3bkybPC7fuXCYhBQZ9taum8VjvEMIXrTzOJPYU2MlQM4zW3NajN6wse2KU8DqV
	BbvM6i/i5pt8ieRHRCdOsA3bkQqc94aSgEA==
X-Gm-Gg: ASbGncuBFAOwNFpxpoE0KBJCw+og+6kRPpoWMHsN7HpDm181veoGl81TD0PoRkEDSvs
	b91gJykoajGw+nG13iMhhsL4Wm47FdbLYm5EGjqL8jRpZ+/OqZCud49wI3nrBF6vQ4NLIqTfe08
	9b3Srzub7KwXQFfQR2T27R7O0Y
X-Google-Smtp-Source: AGHT+IFqsqLmxocQugIbK9vjPZU3nLOPCvJu1kzDH1vvkFxoyZXwF1pH6DjSYYeOAnii7MMypyKnceinr2h+ryT68v8=
X-Received: by 2002:a05:6402:3815:b0:5de:b438:1fdb with SMTP id
 4fb4d7f45d1cf-5e0b7266b9amr3458312a12.30.1740117910650; Thu, 20 Feb 2025
 22:05:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218182207.3982214-1-hch@lst.de> <20250218182207.3982214-3-hch@lst.de>
In-Reply-To: <20250218182207.3982214-3-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Fri, 21 Feb 2025 11:34:33 +0530
X-Gm-Features: AWEUYZnkH4bG6S-2IdwNrETUoshkkeTOmDbjml1QjZGKr8spA9_vriFJNjo0jaw
Message-ID: <CACzX3Av7H8NOT=J1uae4u9VYVw72BBmDaNENK1uXz=pfBMrkVA@mail.gmail.com>
Subject: Re: [PATCH 2/3] block: move the block layer auto-integrity code into
 a new file
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-raid@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
