Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862EEDF49
	for <linux-raid@vger.kernel.org>; Sat,  6 Sep 2025 02:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757125020; cv=none; b=AQvznYihlWAExZBlRqWpUoBpFUG5pCXbDgv0rkb19Zs7V4yg1uun4oHDxa1WCxjkoH5TA7BTLwZnhLI8lT6ncAwB3YEv9IwHNyqU4v76wHPXQHwnqeCV4dPHy6SzlrhJrffvR9vUPxXgxQqyNHFtericM4RrqcjfsgJgiBOe2ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757125020; c=relaxed/simple;
	bh=O8uaoID5sXjij8/TzkdAxLmo7l5pCEoFlolGBnJKgQ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=ZxdB4T32moqBwQDLFJtri8LaSfrEInTMn7wyxvglc6judojLLJAc0v4Rewi/Pw+jYQFlzwdSXCcGVC2HFqPKyyxVRijbN0rOUvAtG596ZcQhB0DrxyVT6NauTffczacArAjXI/5UpWQgfDlKxTJvfu2iGjA8A8k7sryy25zz+mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=coPJumRR; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="coPJumRR"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-24b150fb800so6255425ad.2
        for <linux-raid@vger.kernel.org>; Fri, 05 Sep 2025 19:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1757125017; x=1757729817; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O8uaoID5sXjij8/TzkdAxLmo7l5pCEoFlolGBnJKgQ8=;
        b=coPJumRRsbdLhLzUg0Y0NEhcZiW9vuCFwml5tu12/HneqpUQZToidw1DMuSWTfy150
         MQ6pxpB9Pn7tkZl/p3pldrS2eYV05tPQctzvxUxLXzxDTh7KBn3V6skX00uJa1Fj9CAO
         Xu/YMA4afSyC1UtR5Ie59ZHWdDvOkYfVCgk3TGRKVWAKSJ19+nYK07Mj+Ncz0mtEpta8
         noX9usI9SvX1dxTdh6CGyB2rg+ntr1oLWudBExeo2orXEAHmgAY+Fx2lC1U0Q/g2PCtA
         bBXVfsjfptgTxYXEBqIyTOQtrjqEvocS+N1a6HsbdLjDOVxkBzWIhtKvWjWiIF3ZS4Di
         lVsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757125017; x=1757729817;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O8uaoID5sXjij8/TzkdAxLmo7l5pCEoFlolGBnJKgQ8=;
        b=iBhNceLK/MYHVdpg74osPwWjGUFV/ODKjX9PnFZ5A7LjC/yb9xQMo1Bce1uvfRKMug
         XNIru2k1T9iFwWvdu0LV679bn3gqlLtQXEBkqBgf6fImKNHaq2C8Zm7ji6WgUV5cbdDK
         d99IH9kpcuapLc+2Lm2eV0aaEOYV3KXYKwrT4C/p0Sq0M+BpPd1UnP/swOiAwnYWvzav
         dnR9fDYjCKo5gI6rKPZ/0ye52vpj0WaB2G9NP08L5Az1g6tuBv/RY/OHIO9C2lahx1hk
         qmYacpPm1j4vtJpYMBPMhEGGTOCBuf8juCGM5Hgsb4+tnWh4RNvKCKsQIdLmmKpvr91N
         j/1Q==
X-Gm-Message-State: AOJu0YzkN6OJDYQP/ce7v8lk9Sjbkz4U2ghw1AK19YA1aFQl0PKLSPyD
	ai+jzLjlm0VFDzm11vRPKNjR6c0kLAlXlz4dHGcB712RfE+mY3NSM/wITKJkA3HJ2drhGwaa3zr
	djFJ4+IqIoJ3Tl+TKht4lXkQ3AHie4WU5ttfZbMg=
X-Gm-Gg: ASbGnct8mFvXLtKCswJ2YnGFZueQawjSZNp9Qt42glYHRGugwIvyOt73kQgaGMDSoxg
	HtcG+i9+h0WIDdwSBS7gv1jpfYClwS/Z/zf8ky5ZsCRszVslkIywRS4ICG1XcAOarIfuE+XCfM/
	a+LgDkeVQR3e4C9Yq8AFDI9goKb297uPIjEnFNTTnYtjwXjmR/cL7mmBFBTYZo/rtkkWQ7atObk
	knEUFHXseCYqswfrA==
X-Google-Smtp-Source: AGHT+IEbOIfbYdqsdzjCDQ1bcU1Itel5eDBExsKlHbrwDgCEwNHyaxI44Ubqx8OFoXR1FT68dxdQjZvoOiguPuaYV/I=
X-Received: by 2002:a17:902:8ec5:b0:24d:5f38:ab67 with SMTP id
 d9443c01a7336-2517653b8f5mr3973925ad.11.1757125017260; Fri, 05 Sep 2025
 19:16:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <109aahg$34jlp$1@dymaxion.cjsa2.com> <37f99719-4bb1-489c-8246-e6dffc8b0bf9@youngman.org.uk>
 <109b62i$e2l$1@dymaxion.cjsa2.com> <d8fdc2a3-ef96-4e18-a0de-f962f6dfca57@youngman.org.uk>
 <9f66f430-bddb-467a-9156-df91252586be@thelounge.net>
In-Reply-To: <9f66f430-bddb-467a-9156-df91252586be@thelounge.net>
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Date: Sat, 6 Sep 2025 04:16:44 +0200
X-Gm-Features: Ac12FXwqn6mQ832bJ7sar9jxfXi8ez1NUTG5cMnldx1-KEWX6_Y9cZwDP2QcSFE
Message-ID: <CALtW_ajXDDSUns_H8Ve2fG60ZJ0bX-yRWCO6PaZ3xQhCY6y5dQ@mail.gmail.com>
Subject: Re: What is the best way to set up RAID-1 on new Ubuntu install
To: linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

> the UEFI partition must be FAT and can't be a RAID partition becaus eof
> the limitations of UEFI

3rd attempt, let's see if this one gets through.
It can, at least on RHEL and derivatives.
From my notes: mdadm --verbose --create --assume-clean /dev/md/r1_efi
--name=r1_efi --level=1 --metadata=1.0 --raid-devices=7
/dev/nvme[0,2-3,5-8]n1p1
You have to select "EFI file system" for the file system in the
installation and that was it.
