Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6A21FC0F0;
	Fri, 21 Feb 2025 06:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740118103; cv=none; b=tLmeu9DsAXcMq9+vu9/zVuvv9/31rNzZpdDe5smznhBDrexCNoiVgfmELwy7LPgCcy1IKwXouByn/5hP7Q1Dx1A3e01zWvSMI6BoC6BSKBTjyrhb0s8IwHJTdYKoMY5hiu0+BEuX1SZ7oPVrp+gaqM7zenl8VYn2dpbrOXolwx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740118103; c=relaxed/simple;
	bh=EEUMHT+MXWjcUhxvJADFxvqGCYi33zuKXrJ0i9XJBVE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EGtVA9jYXN2lPw7pvXutT7cOmlazPgz6hKqYLcNyIP8Ph+bsM5TJT62VtgRCFixIO0oUlgN7JCZAl4yo/YqHEvDJhg4cBzci5REVmGHmNqoqxNI7l6CO9KsuAxhM0c7l9y8Q/fmDKOtU5okFBXuhOxxlEY/ilW+imYeeTmtz3yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JfN0znBh; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JfN0znBh"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5e095d47a25so3311023a12.0;
        Thu, 20 Feb 2025 22:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740118100; x=1740722900; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rXIAsbh7aHz7zxtPXm+IGu5FLVtJIRSaOQX3D3d9lVk=;
        b=JfN0znBh2Halh14G2Qa35XqHpFC2QEIQRaN2Jwup9Wy59bf7tHZqK4Tv6ksMUs5qiu
         yaL0Ge/CS5IECO/zYhgZDFXqOPRP9xSHmHOJA6kiOKZtoe1UuVxIDIET1rRszjdf4NxQ
         hwkkmkEU2FuA905cfFUhp5hy2uSXjU5Fh4CjhLq2CqdKs4Ioypop/HGSyj0UtPtVPFAi
         yyfJColKYAbKm0ey++mvZkECtHU4R8iP3tE70/I14Yc1kElPQWw6oYD85AkJAQffOWVg
         Ii+Md7nSbC6pP1zHSNOBi18+VOfBV1TRBIKx6MqA3RWy56E9N3/BCp4sT5sge+Xly9Ev
         4WFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740118100; x=1740722900;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rXIAsbh7aHz7zxtPXm+IGu5FLVtJIRSaOQX3D3d9lVk=;
        b=SDo31vdm6sinTF+C3lU9cAjCQxhwwo+kIpmiL2q0hgRKTZmfh205rU8yC6sCwOb5S9
         ntoXP/fwevvuE6qmBgsGyN3EZ3BBNCGCOVGUEClHDebBQ8XXjEXZhKAxyaGZ4KdzpAAU
         tuif/YlsNGBGdPCnMVMBrwyH33RIp+rGyYgtKsfeNokRWUV9ZGcHz74acrkRAgnJI0s8
         Rk55iq9vqbYbnB+Xwt5h7wT1LpWucIr4JpCwAEsR1zP+E2XLWFm8ZxvXwpRrIYx/DPVF
         1SrzW5C+9B4Zi1ITRleyUNC89QerPBoVooWyv3pulUuZineEH2vYXq2KmRsklWi7k76T
         1bfA==
X-Forwarded-Encrypted: i=1; AJvYcCWQnu/YPoNS/7+QH86FMz9yQ5Zq9HIikKDfo/UR647SI7WRIDkURwMiMEcqy3pU8K9IFmfk10wQNFKGSE6l@vger.kernel.org, AJvYcCX6w/HYYfN3/QTobGsASpDz9GvtdAI5Ud9f57gJiqSD+oetGVfw9+HgSmP69A4Z324yQm7yDcJrx5+iOQ==@vger.kernel.org, AJvYcCXT+NKAazaeKBhpzvCu6RQtvE3oW/mmASY2CdRB/yVXF2A0P/MeUHJdtrAV11EC4jdYRCIXUNkTTyCdYA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwpLHnekJSGF9C5zE+xMK6fvvw+ltiWNTOI0X0wYrlQ7vNFReEc
	AznGjfuMQktn0P0fx17O3kx9thxZIBniKyZBYyg2oNqKou0TVGLGWM6Cja8/4brmY4Mfougpkm4
	QnE7H+7+PNMLXuUZSaq/8wAURhg==
X-Gm-Gg: ASbGncsa8z0XSxfGTQIotIdxdvOeae0Ep2fXOCprxruXokHIlx1jtAl4zC2MdIyZUOr
	5mPeqFQDyqAo5afNQzqpVCzQww1eytDwaQKkS/9tqLT6EnXqfumPKOvwWLDkZvgy47s8ff7crfd
	jl5mvoHGYmeRXwfGv+EF0uWYz/
X-Google-Smtp-Source: AGHT+IGSAJUMw9Sp7hFY2WSXAN+Y4fq4PMpBrLP5G4AqJ4vrGshfCGfm1O5FpHInDxMpuH2GdwnOkP66SmpgZvdDGeQ=
X-Received: by 2002:a05:6402:5109:b0:5e0:82a0:50e6 with SMTP id
 4fb4d7f45d1cf-5e0b722e6d9mr1358230a12.20.1740118099837; Thu, 20 Feb 2025
 22:08:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218182207.3982214-1-hch@lst.de> <20250218182207.3982214-4-hch@lst.de>
In-Reply-To: <20250218182207.3982214-4-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Fri, 21 Feb 2025 11:37:43 +0530
X-Gm-Features: AWEUYZnDTwkGMWyCUgvudiybYOkTa2ek7SZeupMzTfedY5-h6_e7HuSEjs9i1cY
Message-ID: <CACzX3AsGgjJOtOo-y-oJ9K+PKm+EgSxTjOJ+UyozYguzhxpe9Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] block: split struct bio_integrity_data
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-raid@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> Many of the fields in struct bio_integrity_data are only needed for
> the default integrity buffer in the block layer, and the variable
> sized array at the end of the structure makes it very hard to embed
> into caller allocated structures.
>
> Reduce struct bio_integrity_data to the minimal structure needed in
> common code, and create containing structures for the payload + bvec
> allocation for submitter provided buffers, and the default integrity
> code.  Stop using mempools for the submitter buffers as they don't sit
> below the I/O stack, and instead always use the mempool for automatic
> integrity metadata instead of depending on bio_set that is submitter
> controlled and thus often doesn't have the mempool initialized.
>
Like Kanchan already pointed out, it seems you are referring to
bio_integrity_payload instead of bio_integrity data in patch title and
commit description.
