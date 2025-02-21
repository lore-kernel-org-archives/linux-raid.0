Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC4718C937;
	Fri, 21 Feb 2025 06:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740117885; cv=none; b=fKy+NXZgoIAmog+4IlI2YaOoLKTKW2L64O507JsGaVtoXxuKExUz6pIt8fmwjrRFVCp12gsdVHqOA7UCUi3zWIG24gnZgLc+oCkJCC1AYh9alDEy4J8AECjp04MC4lpfWaZ3IlSxOfWyezdJjSTosSPpoQQli/CO2xKrALtN95g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740117885; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VA78kmNObWQas3F/G+L8PbwKxSKQ1/ZN1B1nNTDHmQv8IySHowbbvE6DmnGhljsoPtxfpX3YZp4jIW152Pen/KvwmfwUSU4a9bCIAHDHqII6el9x5nDMcAeHvUnqtHEtdMQQsfwonFC7JHeLVOWkk+OHhWnYiExfl1CpEPgNas8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FZ08dbvN; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FZ08dbvN"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5ded6c31344so2435088a12.1;
        Thu, 20 Feb 2025 22:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740117882; x=1740722682; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=FZ08dbvNdfbJoVr7X50FV/fphvaCxTUqDGbYjv+l1VQA9txT+knn9eTxzz/H6dTy9Q
         jcDDlwA+ibDFEhW/uFDa0O+rv9emnB1jId9j0PtnbDcTsAyPi5Vma5L2jNkFsao6lYc+
         xPliyQd10E/6QzfznMVHNHFmuBKT5ipRldSXdZWwdQuiQmT2QRaSRGDQhGpJTej/155J
         zKi+jzg6LcCD8g7mFR4LsusYnSNZU0PDedr6KAci2X81d5GeCsGehzR8YhDm1DUk/kuA
         D17PmmdwMkE8g1i1Gslg2k2si6sjG08zujh1LTEJbQuQ3jbfkhMYSCzXbkqXTp/E64bj
         E8OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740117882; x=1740722682;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=vHphDwXPyYMrq4e3T6wTEuhAnhooL6g8baPIsi1Y+b0GzAud9ALGEI+B+vOu8GGJV4
         3KHOiJjmSOb9yfKZlPtAXgSTdI7ukGBWBOrb43RdygxOXKhqGGx7aputDmJdyi6LUgp7
         8mTIyuvVL9IMgqdEhvdsMBM8lDEjLYvXOId80wTe+ADSE9+/p3zOC0P1pSxqfBjemqta
         y+3ttZj1WZ1KR4hTGF69cvh1Od8LtAVM6XibNmep3LClwKRJIH1IO42S4Z3jrj27FlQ4
         qzedU1s6vRbwjVHXBTkTJvTTSrzBd713oOLOm0MxjsEpGUOA4ry8SfC7aG1cownAWl3n
         gvpA==
X-Forwarded-Encrypted: i=1; AJvYcCUjakXSkyuoEMS3jqJbUjsPqG8mUq1e8Yy1mqUbV6+i0YAq+clrMLLBBV1stuj9ym3+0fZQJJKoHe2XnA==@vger.kernel.org, AJvYcCWMzi5AhIkmLXXpGIixx0w++IS+nipnpr1+mwSe8azANyQBZVp/5m1ffUS0ToyZ1zz2hzekQO7ZsdhGDgPR@vger.kernel.org, AJvYcCXPYsiyxFsG177hkqyR2yqm8UD2fk4vBmkyeXsJHMIXMFnympk2NHSoxOqKN0QnKjp+zm7hf3x+VB96sg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxUZGlyJ79W4ZwZddR1djIkRMmvm7Kv3kUCK0uue0XmU8Xv7igP
	Vs9fEFDQY2PHgdg1xqp7wEyoHz/amjoFARjD8heJgbY13rclcAGPIwn9t6XzX0N7YFvZsPtwD9Z
	ELZ4qqkwwHyTGgwawWoM9uIc1jQ==
X-Gm-Gg: ASbGnct5jyFLe2RN8SfSxlZTXyA1oi2RoOXzSJaqw+s1eYgPpxfuYALEMnMNLNLFOBa
	/kMkjwQaBVcZXtAjSRLjuflazK2V2KV4bA0brG5BinKLo+0cg3++/A46jeGN2bLytSjox8gdR90
	K0Cs3FYujj6pzunBkkU9Z+HcCJ
X-Google-Smtp-Source: AGHT+IHmkNdoP0lQmYkaPz1cUQ47LOF6QpXFYHPM4c/oOTSgwo+IVPASjLMMnY/UxaJjHRUbCZd1xBJU1fjX44ztcPc=
X-Received: by 2002:a05:6402:278e:b0:5dc:cf9b:b04a with SMTP id
 4fb4d7f45d1cf-5e0b70bfd22mr3676526a12.1.1740117882015; Thu, 20 Feb 2025
 22:04:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218182207.3982214-1-hch@lst.de> <20250218182207.3982214-2-hch@lst.de>
In-Reply-To: <20250218182207.3982214-2-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Fri, 21 Feb 2025 11:34:04 +0530
X-Gm-Features: AWEUYZk1SsCUpExkqrbtzlKVvVVj5PRdn2lvkfA9m6CAF7VBeabw3D1AzdThJNk
Message-ID: <CACzX3AvYT9mdfzMTgDifLaw_ktumiia+CuNb24GWUFhFYXrtGw@mail.gmail.com>
Subject: Re: [PATCH 1/3] block: mark bounce buffering as incompatible with integrity
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-raid@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
