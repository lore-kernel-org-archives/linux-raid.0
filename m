Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7CC25B0AA
	for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 17:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784134905; cv=pass; b=ebsnzhHOaQt9tkoMyEyw/n7c2vRmWn0NRAekjRJA9pXkPcT6dCuHaWU1BPtjPivCf4dHjhZGnD3TQoyHxR55aYqdVoqRyMLWl69edw9gCjy8O/9n4B+3dxFe2wL07oEgZvEIjaQ1tOW9JRUtc1iGG0RhLj5yqMxMX0YtW/ir8nY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784134905; c=relaxed/simple;
	bh=rCoq72j9eC+jNm7z7kSpMJNlbsd2d/ojERZY3ZXsJoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lefhKZGQbiDScdLTGVCH8hP3G7oplmp49HBSmyWPW5mtpAd3fiV+/TVyz2UvTIjXNyjOz/99+uuIdyZzBAqmd1ozQar/6AesOR8WiUR1bYNih2nMsJMb/uM4C3YB6OeFN8wJeeSWRX3Erm4z9sF05FXtsyx7AxLb7PAmkWoapPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=LDSF/PUh; arc=pass smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="LDSF/PUh"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-ca957338f14so783249a12.1
        for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 10:01:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784134904; cv=none;
        d=google.com; s=arc-20260327;
        b=W/6k3UdVKRWYawYZqMQP6U8UebYWFonLSMeSbSUpkBOI4GMcugAObId7e/r2kFL61q
         AyYtQ13qd8KdVMAzBfprUgLPF8LeB+SAMdtWF1zU/SQ0KAkhfNEoT64O/oOocswo62/U
         +FdQrDna6G6hcZzYcmVUZxuanLIOvC6e8e9dginXLf4C3nMnrA+tbEYkqPF+eR67FVAr
         Jww1QoFuYUXZLfuZoPLyKCD4P7e44rv+TTZdkJaovXvBLV3JVYi98k+Yv+Ja1GMm97+L
         QYXRlGq0yY0nF2fc7PHae1YTG1/ri4oQCpxhzfUydg9wB9nui3JDt4AuAFFmzDPeFqfJ
         EVuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ls3e0qtbPz0DNUO/UfdGrLxq9+YUeHg9fVDHxsD9NFE=;
        fh=c8hnnVq24el6fZS7iSbcqFOytgVEy5OPZKUq5paioA0=;
        b=rD9tsJX82aDwwCpHFBpvTeFAQ7fAgp4Ufnw3mnzHPWGg3YFB6PCmycSgauOsFVWmUX
         FIpdn6PNtRmg8WYQSspKxebVb/iyoQRgrBRR8UPKIwvFlmVwpMoiUpY19+boknnTxNgC
         C5dKFvn7ihqFkQknoCr3enFnY8kpBdkxSpnbnARCtPXIH+3BC4wD/iLOI+w6KF3+7z6n
         e8yIey7MT6WSOBhnr57rRglVbGa6BZQMfYuQG7LEWx41vVCkUvEDmM5TBp6DDCCD1OBa
         EsUk3uvQRHdq3MIkOtQt1lwUPukITeUFG8L2g2SgWPMAaalj7AaYVD7hPl7qXsubBbG6
         fTGA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1784134904; x=1784739704; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ls3e0qtbPz0DNUO/UfdGrLxq9+YUeHg9fVDHxsD9NFE=;
        b=LDSF/PUhJfO9jbm6lwC6PvsRwbtKY/Us6YcjZkM3aiWjPJhAh2dxKrINEJnEGTR9tG
         QOrINZIQp6UqonrdHjp2TKE8CC0mKu/2AIM+VSoO1YshT67IUZSEFO+cY0dmER9NKMSk
         3wplMO5AMiEA81Mwu3E+mh68y4FubdfkPGDAZtSUQqH9aDzGJi7fUP0aIk62uqiOReTe
         ylE5d5a2nCYV3ZsVpgsUylrm0uX6LsAYUJdxrlHtieLyd7PN0OoTF5m37iGiKeEhxkyr
         URMwzvlPvWySbdVdZCROiUGhZF5hNcsJNbu5o+vPZRxeVS97qJnOpX2TUERXag/KfSdX
         OGdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784134904; x=1784739704;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ls3e0qtbPz0DNUO/UfdGrLxq9+YUeHg9fVDHxsD9NFE=;
        b=lkdZ7VJ7prIvfWwBFUQ/wu3e60cBd4xBY4n/XB2+qzWNTNzUqOMFJ+m19+rvHOdDY3
         N/UbsHtg4B/BENVanOg09vY3+Zz1InvjsYbiUxpQI36r11BlIIh5WenYr1/pFJTT49W9
         ILs3FQn4NDmOQiD5pfsG/WeXa/Okab2Uxs0nL/vluIpZsKF/sF4fmaKxNZ7+3aG/RpA3
         0zZ9RxF/UhaqxZVvsybZHc14ys9jzLkJMtc5YpTWFitlSbZq7sk2jGnl27UejNNic6wR
         Rpd5oqtt7a80D7lr9R5aVk6/1pPc4H6a1m4Zb2YsDD6kPRAJim0dRjzp7G3MQb6cuD9w
         s7aA==
X-Forwarded-Encrypted: i=1; AHgh+RoxkAfwSAyZhKojr97SWPic5vGtNV/M0WJxT0y98k9OoLF258y6kGVQXBk7kKGGo8xJ1S4GXfZ3PFv8@vger.kernel.org
X-Gm-Message-State: AOJu0YxLbfBJZRFyHknjHTUdg8SQm+qko79dhn0V0rcCBa1gjNyNST1A
	SOv75O97jHsoWIply5jtcMUB6AFlmuO4nPSb3SjDqrfd3wlDB58D5mdCRYI3pzAY5lFEExrM5z8
	or2/PR7k4yguA4jmoHp0uEuqm0BND3md3Bo4I
X-Gm-Gg: AfdE7clzTszJdfpNYPdOAAuUpmgOdcCk4rKrf4rajimqSGF5hZNkYXCLM/2Bi1JUMcS
	/UirLvuW1lRV5CVDfv8MKu4OWrexuvgwFeJi6boqKskhN6AXZiXHlntO2iu1Bai3VHS55PJnKhs
	+XHRZWABcDNqVf0vnHvYjIx8RMACSphfL8Y/CE1b81jS98O67GTeSPMP+v8fZBVqMsw7/oGLpGz
	pCd0f/qrd02VnFBeKpSoP+QIVaq4RHSSKGZ1Czm/Vt07rT6R3lZaA4siCCIucCdRm8zVOLvRQ==
X-Received: by 2002:a17:90b:5870:b0:36d:de94:f31 with SMTP id
 98e67ed59e1d1-38dc7c44fd6mr12962625a91.7.1784134904117; Wed, 15 Jul 2026
 10:01:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <8dcbfa43-c687-49bb-81b5-e6b8e8848c77@hunenet.nl>
 <m2y0fcesbe.fsf@gmail.com> <cff97a09-ee38-4785-9a45-1fd562fbaf5e@hunenet.nl> <27223.46342.543928.404779@quad.stoffel.home>
In-Reply-To: <27223.46342.543928.404779@quad.stoffel.home>
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Date: Wed, 15 Jul 2026 19:01:31 +0200
X-Gm-Features: AUfX_mxpFWsDnqZ6Ydrw7lpEqTMYuNTU8vCZnlLB_WDpPIy3cMgnzyeTg_VEoTg
Message-ID: <CALtW_aj4NJcknh5O49=UOr_pGdJ6v=c2yYyAd0TrZOM672_WpA@mail.gmail.com>
Subject: Re: Subject: RFC: Read repair for md RAID1 after mirror read failures
To: John Stoffel <john@stoffel.org>
Cc: "G.W. Kant - Hunenet B.V." <g.w.kant@hunenet.nl>, Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>, 
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "yukuai@fygo.io" <yukuai@fygo.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> It's not a simple problem.   For long term archiving, I would try to
> use something with RAID6 or more, and ideally have a filesystem which
> also checksums data.  This is what ZFS does, and which bcachefs does
> as well, but since they're both out of kernel, I don't use either with
> my current home linux setup.
>
> But for long term storage, that could be the way to go.  but then you
> need to periodically scrub your data, which means reading it all,
> checking the checksums and re-writing and fixing corruption.
>
> > My concern is not recovery from an existing read error=E2=80=94that is =
already
> > handled by fix_read_error()=E2=80=94but rather the long-term aging of c=
old
> > magnetic recordings.
>
> You really need three or more disks with multiple parity and checksums
> for long term storage.

dm-integrity ...
