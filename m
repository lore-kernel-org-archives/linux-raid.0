Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DBA3ED122
	for <linux-raid@vger.kernel.org>; Fri, 26 Jun 2026 10:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782471170; cv=none; b=awP0/ESI+F/7JWXwSnh29ebe4xd6aRj0a6Hg631yi3yfmsSnSaD5lLJoB439cZ4+w8V85kmOjD6BVuCftqtS6jsWYAWM2Dgouc1oB8IMeGuUWcGM10Im5Bw9ZSIhLdYQ+L6jNnpxsvPG0oxL82n2jb3S+yUCwxAXfP5d2wbFFh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782471170; c=relaxed/simple;
	bh=fS91BX94afUHBq0hR34eheoAQu1ZkCenArwqnm/q0JY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n00rVKi2QrhmV1fHqDEDBTS0G3/HI3dODwRr9gVcHoOD7L+5C40TKJbMPA6rpcS3I1PotV27Ale8DABNgi/mSKiJZgvgdDOCEnSF+NiiObDy7mMiTTsdnjtk0wBXt7n2NVZABeaPR4Hd6mf+xS8YBFxCW8nsnlOaALbbnmOYHaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bPiJMKGv; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bPiJMKGv"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-45fd464d51fso416796f8f.3
        for <linux-raid@vger.kernel.org>; Fri, 26 Jun 2026 03:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782471168; x=1783075968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=No42VPQLeiDXP/prwUIiSxKS26SONyeJJDp1wy05z7k=;
        b=bPiJMKGvzpPB2mJWo58/v7LnHeXOROLyM2VFiFkdVlp/EtwsUvHhRgohifpOIjQTc8
         KsxexOkeaM9WdwrgJe33pU2IbAGCYUIax134vQBKQplkguF1+XFEbMkbmGK4JLWDWs7O
         peBruK7CwPNzqtsEyZeeHCQUo5P4zdMHOnz9onP0KiHLEWaqRDl9zOcpvKzTgsnbKpd1
         309jKMP9cCBxl7ntWk0ZA2j2OnTBF+qw/6S9dCtUA8zlu97+5ngZQvVGOkceS2Kh5QtG
         W+IIBLdpkWO1L9gfzZEjNbK/YXtnFJnjLUHGUJzLZdOW225VZJF5LBhsG2YeGDjc+E/w
         eeSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782471168; x=1783075968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=No42VPQLeiDXP/prwUIiSxKS26SONyeJJDp1wy05z7k=;
        b=YJX0tuD74NkpmEA3uEFs1fjlOjdmVFBhoJcZnQJOX1GGLr+C8ACrKsggN+ivZ2Bu1Q
         aSbR4UQGx7zahLFSh1WVHoUt7BbrJiWczlal5e9ZkFeopRouA5aPuALgpleQv5s9O/Lk
         fBbTE2XY0YDaTamFBKYNC5qwSuH2uF66Mzr9TAcDCtgYDdX455o7YHH6jGty97NWY7w7
         KaNbZ3BlLJCGgcHhkIXlQ6j8fvx2rTNQkRQkaIvHCKQAuxCW9krQdJqIjuFrRNWhfUg0
         AIEMqHEH4VxIpQI+OYYwMI050ltnVfd18v9ASX+7ihQfuUknqZDCAZQnDi5gN/I7QIMe
         xcuA==
X-Forwarded-Encrypted: i=1; AFNElJ99vcoEKfov82yIcIHI9yYGDFW3JAmtdY/pGpY6YX3cawcA1MvCSxcFlkNvHaSE4hHXS9sSNMNgPYZM@vger.kernel.org
X-Gm-Message-State: AOJu0YwA56YFcQgN673Bc6PqAoxc1u9cVMfyJPB67v2MOPQJ9H8lWYuF
	FD0DprTufjMg7x8wrb1uGMrDw7a+7bXZ89IhE7PyhnFEiPhtjtApJFFT
X-Gm-Gg: AfdE7cnoOPbIV3yf5x/ASF0P5r+xOl1FNEqMDqUfrNQdTGa2Sttma+YIhj/b/L7jJK+
	gUZEsUeq5CwtQ5V4/62yChCq0iDuVWzJh+00xG5uYwQpClakBqx02VOIuZyRLyvuynqdaGJg8g+
	HrCzCjRuLxqPHUwbTUVjWQFu8XTcUTlA8ZhnewUaNISyl3tAOd7SyzxehAfaomJdJXhOiD4lC7i
	rCDyXDtNdnwTZDiFNN+hQwI2KgjycAB3mg82BKTOGGkPcTmGX5axo12Ijx9X8FyuoRMLLv1DmBD
	us3uVkyn+NEa9ekjnWscioeV+/RVei0D8rAsQJqjU2v+E5vwWiQmBrfXpJDRAMfu1B0HU/JJ3rB
	wKQ2xMvJdXgVea325JQiwjFlc5GRnPQ2F8jfwH7SQebfP0NSqI+WzAnxQDaV6My7WG0LFVYyOGI
	boMN9ZyAEPLs3D6QmumJHh6DKmAuCyLMZgaxVI7RtUvXD132NI5A==
X-Received: by 2002:a05:600c:1d0d:b0:492:1e36:85dd with SMTP id 5b1f17b1804b1-4926689f6d5mr98905305e9.37.1782471167704;
        Fri, 26 Jun 2026 03:52:47 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46f8d6f10absm2089932f8f.5.2026.06.26.03.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 03:52:47 -0700 (PDT)
Date: Fri, 26 Jun 2026 11:52:46 +0100
From: David Laight <david.laight.linux@gmail.com>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, yukuai@fygo.io,
 linux-raid@vger.kernel.org
Subject: Re: [PATCH v2 next] drivers/md/md: Use bounded strings ops when
 setting disk->disk_name
Message-ID: <20260626115246.3477f614@pumpkin>
In-Reply-To: <20260626085141.3AEBC1F000E9@smtp.kernel.org>
References: <20260626084334.3012-1-david.laight.linux@gmail.com>
	<20260626085141.3AEBC1F000E9@smtp.kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 Jun 2026 08:51:40 +0000
sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] Inconsistent coding style for the sizeof operator in newly added code.
> --
> 
> commit 663613700e83a5bb9c1749d80b4fae68752645fb
> Author: David Laight <david.laight.linux@gmail.com>
> 
> drivers/md/md: Use bounded strings ops when setting disk->disk_name
> 
> This commit replaces unbounded strcpy() and sprintf() with bounded strscpy()
> and snprintf() operations when setting the disk_name in md_alloc() to improve
> safety.
> 
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index d1465bcd86c81..afbdc52a11270 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -6354,11 +6354,11 @@ struct mddev *md_alloc(dev_t dev, char *name)  
> [ ... ]
> >  	if (name)
> > -		strcpy(disk->disk_name, name);
> > +		strscpy(disk->disk_name, name);
> >  	else if (partitioned)
> > -		sprintf(disk->disk_name, "md_d%d", unit);
> > +		snprintf(disk->disk_name, sizeof(disk->disk_name), "md_d%d", unit);
> >  	else
> > -		sprintf(disk->disk_name, "md%d", unit);
> > +		snprintf(disk->disk_name, sizeof (disk->disk_name), "md%d", unit);  
> 
> [Severity: Low]
> This isn't a bug, but there is an inconsistent coding style for the sizeof
> operator here in md_alloc(). The adjacent branch uses sizeof(disk->disk_name)
> without a space, while this newly added branch includes a space. The kernel
> coding style prefers no space after sizeof.
> 

B****r I only fixed one of them :-(

	David


