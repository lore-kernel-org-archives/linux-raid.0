Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F15A221D9E;
	Wed, 26 Feb 2025 12:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740571848; cv=none; b=FzDmQK6Hc7am74BjNy+uRJ7+y6ZxUl+6C8LLUh1DOFgM4hubWVbIio8Ne6Ky+5J+N4zADrqamFoVCvo8aett6pHDGVyXDA3HI05ueYbDVV4AXpsAPS9pgC5fhYbJDcJJTkte+PPkGeexESRJw7yi6guSz8X7PD+u5dZQdmgdQI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740571848; c=relaxed/simple;
	bh=1hsY1mzdKYsDcAX5t0fakckOi/QFoEJVBbyh7+t2eEw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lAh6jeIMsWFdhZlA+6Ewi/tHPV2fAPOjO+Zn1UEiMoRzjqQmHNL/1tQ4zmt115Ef3lpAj9y78s5mZXAZWQq2GdpvBktkTdJ9Wq0vOnSnKbUnjXJBEMS4fnO80ViYsvUpLA2mEulYzcREItSxDyUWS8F9fbO+iNYj/Lr7Jv9BT7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UGKtJ7fN; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UGKtJ7fN"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5ded46f323fso9313256a12.1;
        Wed, 26 Feb 2025 04:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740571845; x=1741176645; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1hsY1mzdKYsDcAX5t0fakckOi/QFoEJVBbyh7+t2eEw=;
        b=UGKtJ7fNNefnBrFXBPqyHK3vq2v3xhNKkMw4yCnCKr6bEuNudbDQWpHWMyrUagWlAH
         CFrFRZtgEI00Ou1dnEo+hd/yCMhmHiYqfRnMz3Ag6qvHUp8EAqrElWrjNGPb9h8d9/+l
         IS6/5hzgMfdjn7xohBPLw0eS4x4NT7f2QOyxQ3pNsPDdLSjSb10ZHzSKinyPcSSCw7qV
         3RphqlBJU+/EiwWwwJBoAPB4IimR3JSdtATV5iJef+ygGTqvsVpMmPietGIpf4d2VuS7
         KDgjFZ6AUE4JK4W0B23dMARJCir8mIDfll1CCTHVthef9MiKT3REyJMq3rjDxrNpnV0h
         PtgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740571845; x=1741176645;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1hsY1mzdKYsDcAX5t0fakckOi/QFoEJVBbyh7+t2eEw=;
        b=mwSMZ8lXDJAJ7SrO2VOXuR3mxaPKXFvIVtyJCkQS+uFhoYi+E6B1u24suWWNJwxdmE
         ZxM985DzO4JmLay+cbrD1H3HcNxCYjG89sM8fXPFvB67llP0QsZdwQAjdaWSRselgIxd
         ZzATjfr82WavxnwUbBYxIHN2aq++9+WxADYq45VBmbnmX8MxskrU2nxP0QFoP/lhqZUF
         DgVSOhFvnUbZwV0hfIDji/N98Lde+FKrolCT7a/9yAr8vquPTE5qV2SI9AD4lDa9m8rB
         2oWEFne9QibOEit8Tkt8I2NoM/F6FSSp2RlyAHEFV8cGX49GWZziALHQt5kj8FDPOzhe
         i0RQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeS4EauPF93AkvRf6i5YRgQ4Ogi3c95a1uKxhCSxliA7lASLnSiVi9WNFGIZCYMiSIIaLtJFO+dIWBE94O@vger.kernel.org, AJvYcCWKwKsASYNP1dZcgDB6K6oDAkPfc3bJ5Uv2d3zx1fyGTQh9p3q0Garb5oJPnHImColinyI3fYPtxiPABg==@vger.kernel.org, AJvYcCWVsIRTjJsuYpUdMme7tEiFpoQ4DT9HQ1KqIdlBXdj4SBvVCSWVWN0mwA9j1aNFpBSJWcNuoCDm09uFDg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6YCvbADcfu+2fYi1Rpww8f5U85cQAsMhk4/TDFkBDnKYeHM6f
	thfS4KhIHrEXc06ML6lmJWtQwJTEnOaFmiRc2c0JyNnLjE6zd8KucTkurtQM8i90QK9uwOz6Zbx
	XnsTW7k5CPifuvJvewbrKCT/eYA==
X-Gm-Gg: ASbGncv4w15f6LeYCgOzlh1FsX/hFjcRmCIti6BdthUpjR8VqvC4uKliyI7qjDIngfs
	Hkbmyowro7/VtsDNUrvS+iisabjdB7niwOKv9HUs3khHYzAc5XiErkaCLt9JhhNtJLCq1LZdudP
	n7Bm4AMZw=
X-Google-Smtp-Source: AGHT+IHS9F8DlHa7K4yiHRckEu2zP4JjVIGRYLXSIkjDC4JMBWupeCSjJPkj7sbydkOYnkvniICQtsy9U0hKiLbYKCw=
X-Received: by 2002:a05:6402:248c:b0:5da:d76:7b2e with SMTP id
 4fb4d7f45d1cf-5e4a0bf28cemr4160664a12.0.1740571845232; Wed, 26 Feb 2025
 04:10:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250225154449.422989-1-hch@lst.de> <20250225154449.422989-4-hch@lst.de>
In-Reply-To: <20250225154449.422989-4-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Wed, 26 Feb 2025 17:40:06 +0530
X-Gm-Features: AQ5f1JrUAunE97qcBFzsGJ8UeHsmDYeNRHuc2DNDRpHEkUPXoJiDcNi2r1VbuQI
Message-ID: <CACzX3AtVtC11+DWuxQf97p8hDAJw_f_LxgBDSydfE0enr-KaFA@mail.gmail.com>
Subject: Re: [PATCH 3/3] block: split struct bio_integrity_payload
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-raid@vger.kernel.org, target-devel@vger.kernel.org, 
	Hannes Reinecke <hare@suse.de>
Content-Type: text/plain; charset="UTF-8"

Tested in-kernel block integrity path and io_uring PI interface path
using fio workloads with this new in-kernel plumbing.

Tested-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
