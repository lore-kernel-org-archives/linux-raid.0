Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993511A76CC
	for <linux-raid@vger.kernel.org>; Thu,  3 Oct 2024 20:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727988962; cv=none; b=X3jNW2sEIk18YCfK6Vs+fZqctOsviyGlzoAO/SHJMvvfic1pFfyKX29tF2x3dY7ZwMkI95URwPof2Q4DJp87Zshz82Mrz/0jBlBTOs+eZ+4Ci/2dv2gY+F0ihyTSgPY0xKpJEBX5Q3SKUOrCRYgoAMXr5l04k2LDpxH7zabXRqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727988962; c=relaxed/simple;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=A4vXM64t3rSmI6PnHPEriy+agbq7eoD4D6Dqewlh4P1XTuoenUrVjaLa2/RfOZYb+C9z4Sn3sShfgaNL6Orp5xYZy5VbpkZtci49qGM5XoKpIxK87maiE6RtaRmqoa15XZl+Tvfwc5YXWgrD6Jsf9rflsChj9B2YKCQdK9NS8Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CRSNPBD0; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CRSNPBD0"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2fac275471dso14978151fa.0
        for <linux-raid@vger.kernel.org>; Thu, 03 Oct 2024 13:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727988958; x=1728593758; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=CRSNPBD05I4kQS4fGNAKSBTKC4eDHYXEYWmrjhNswG7oevQergXw8IZ+4pYyOIkbAK
         IJJIWWXrN+FBZEF7y8t5J8EFjwfmdX+9ZeNgShrpZo06M7RgZmcDABWRK4FiKkdYqA1Z
         AIrHuEsdJ+OXM6DA6MNHdbyJVn0PgfL4kpuEYUtgYZZKT0L8wbsT+KF09yj4EbJ2xfwT
         OxY4eHP0PsnkBcaHXIDxkRQSi7qFsw0RIBXtbZp2IuEK9epcnCDe/xCftD7VBwSScyj9
         AlSNcEr8q/9iPUTINqo13Y2nVPR4L9B/daSTAp7N9+cgM7PJm8IVOcnu9SdbjVkjn3iI
         tkeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727988958; x=1728593758;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=uGK3Rb6nNSJdiy/E12bMqjwk/salAsvwU9XHSMz1pBjdzGFdOixOB6Fk47tDkMM2WN
         0zlDolVAxbJ7skLAfKnkO0FSaji8OtYC8QstvdQFJhCo9kFGSmgUDXY4dYinxccCzupd
         skpwJIUuC2nQ+yio4p9HtaIQAyHRjmUTi+o76iFoEQWYsDYVyGL5bOVTR9AUbLdQSyxe
         4lV9w5UZs6j/G92vhNao5KVi50MLbX/VdtCpIpPkt0H/6bHbtQHaleQnSyUK5SlAL5IZ
         ocOsRJwjS9MdT5EIDA+JoOeMEEDiU+4HnAgGBfhrkrzCPOG/Q5qCb86F28piLFaIGHDy
         z7gg==
X-Gm-Message-State: AOJu0YwVZMpX+U7q9OfL0K+byER8VLQcsX/p97C99ZruyBZRmBmtske7
	cAaYzdPlk7Nh3YPLd9xYqp05wMIcfCmMXTbfSYUPnxyZ9kxOdnq6dATp7ozPjdq8LUEUPkI4b0e
	AeBjfOz2C67i7f+8f+jj+jXDMCtmQkbur
X-Google-Smtp-Source: AGHT+IGN0QGAn67Kb5HANdtLubSLBRtU3CcetyOgbK8nALaUj+Q4PcWcfAio5tqvUgQAZkDFCpKpUsB/Y6qpDChxR74=
X-Received: by 2002:a2e:b88a:0:b0:2fa:d84a:bd7d with SMTP id
 38308e7fff4ca-2faf392d374mr1315381fa.9.1727988958312; Thu, 03 Oct 2024
 13:55:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: o1bigtenor <o1bigtenor@gmail.com>
Date: Thu, 3 Oct 2024 15:55:21 -0500
Message-ID: <CAPpdf58qewSik62R8tW8Pfs6nnp8jPqiJyORjfOVbQRcNy80Kw@mail.gmail.com>
Subject: subscribe
To: Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"


