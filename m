Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB65E30F92E
	for <linux-raid@vger.kernel.org>; Mon,  3 Aug 2026 12:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785759104; cv=none; b=FBEB8jgto+WjyV/yzlpKlwRhgGaVv+oqBg/giDnP4WnGXkKXAOYKLqp1Mc2YbNYq5Z3VfkyiAjYWHsUvj29hblwhfUrIu269vjJEwgTNyDmVnEkfYTOb5v+LitvR7CumdDdsQvPi3Wd6EXHRlulIrTdWB46dYIJLVvwCIT9ksc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785759104; c=relaxed/simple;
	bh=rbo8PIaMhk65atYrBq/cClo396+fP+QkDtrqh8xKnJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f5EHBv2BrD3Kvrc033sYJK+kRNtgBVqzBsS2arhmDVodRbzYoXkDrbkTyTAUtVTxUC1ElaTa3yGxvq1w5n3vCdbj2JYRLFMz3KYnlY53OLhnmrY9QjkFUL2zmxjkyQ6CFHFwTJDgCKQTIzkqzb9mIO4qVpzE3gILQSF5jnrUu6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=W5gBJSBQ; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="W5gBJSBQ"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6984169c126so5596452a12.1
        for <linux-raid@vger.kernel.org>; Mon, 03 Aug 2026 05:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785759101; x=1786363901; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rbo8PIaMhk65atYrBq/cClo396+fP+QkDtrqh8xKnJo=;
        b=W5gBJSBQZtgKFcZ9SOazbseMgvx+9pxF97RMP2ZpAVO5/6AwO9gcGLkhB+yuMc1n36
         t/gT61k5FKRIoPAvN4+6YirVih9vUrJ3z/VxsxNYfZLYauaaat52l8KZr7/ActGARVKb
         vJcigAZCkqENOXfjL83JQH7AIl/jDXS6WddDQI3c+8BJF2FkGTd4kwHAF+69Zg1aFfjE
         LuHRY+QfNPvDS8QakTzOgj9HyhP1bQK/qqg9x0BGAvN9OJ+NqLZaJT7a0foOARbDUYia
         PUqXwqoFL767aKaX+D73pk0C5Y3lQnHytu0+2U9Umy6B+W7e+vUEWwWFxaRUll2hNzu3
         /YUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785759101; x=1786363901;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rbo8PIaMhk65atYrBq/cClo396+fP+QkDtrqh8xKnJo=;
        b=Y/BtUB4vJ1KLeyDQ5pD5hp1t4rRRm1HpKwWyNJvI6b+/KNZybxR00i5cawy4glMwEW
         mp5uXdnfcwYLZ6vaamLjWHMmp8QPcRtk3C3c6VrRZFI3hxKqEfpEtWa0ISsIiqtQH0yg
         p49Ffi3FM2IBFh1+2lCai8xvLZnlWk/GgTNoHa6oWrvp/3HzjKyD6vIMoRVWEYXk699z
         +W7gjNBJ+FDg0QBgIfn8cNZuZ2JJyBmtrX1P38JuQuLRxTdWDqXNirCy1Jp9kHfhSNAp
         eJpRW8sxfQ8u20BOgWVERz1GjaHNfL4RNtTRB6UeQUEAhDCezCyHsJL63BlegYWuZi61
         Qxuw==
X-Forwarded-Encrypted: i=1; AHgh+Rq7ULLK1q+cXzDda3zUGfdmemRNoCcBgH6TQPCVSp9uFSxzQSwSO6gL0QvJaiiKGpyjcTTDlWkE8AES@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9NwR3et4N7ML8UfgodJdBWuCZtx/jfo+U7n9x461fUYrO9DH5
	xGXPW7KpQvLxr2vWdE0w0CUhDVyYgLJe1OJ2eJzTtt0WrUhU+G00spd4e08vRXBHyg==
X-Gm-Gg: AR+sD12mFFc0WRcyuUkQTdovXE7NsWEeNmuSCrHnQdE41ymdB8m3UPgMwr7xsf2uZM1
	z3HCx32I8gJp38wkk/svHNVdDhhMkFwgCsny+bdYAYIbuvqjTr8qCRSIuq1ZjPhLh3pf3Q2CJSq
	NmnqBAuS8Mhk3E8ae2q5Gu9yWX+EpQTrEbTXbAhkqm07bm3Jk8QH9HKgodoXpLjSvphAw+ZhReo
	d9Jgmx4TIkRLTXp8rUGI9GXxEI5z1wSxdSPA6HMHNhr32rK/iISTQlSp7xvpMB5pKWi13j7G9AR
	f6OthaW54lJojYa+Yr4hln44obsR8c/ellL71YeBrAL8VjVS7dXV35uukgBN3g8j2pnrzNiLQ+H
	KLIdFaMbaxDMe5r/lRdVn6csFuXLWGgVPPN9S7C6PKtZSs7fhX2ey1Lg4EeOjPNRsOdCItbXGOw
	HJjCAJ3i7QDzVA6ctTUU0uTm3xC+d0vdL6jsr0lWYG0SCY0sd7Lw9GT8MZuRNrMo1w8gl/5i1YP
	aJUicA/5z8aJfKYmiexIG90cEKXPBFLZO+DyCBVMtB0f51w/Er6cNenD6JVBXLYyZjfXnD3HB8g
	eO7ZhmmFNfQkubNyVJwzR2EGN2fqdstLaE8=
X-Received: by 2002:a05:6402:4591:b0:6a0:a492:1f46 with SMTP id 4fb4d7f45d1cf-6a0a7c61027mr7449501a12.8.1785759100461;
        Mon, 03 Aug 2026 05:11:40 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a09c5b1a66sm5843022a12.10.2026.08.03.05.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 05:11:39 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Yu Kuai <yukuai@kernel.org>
Cc: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/29] md: improve lockless bitmap reshape support
Date: Mon,  3 Aug 2026 14:11:34 +0200
Message-ID: <20260803121135.268225-1-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260802195038.164272-1-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Kuai,

I ran v5 through the same rig, on the md-7.3 base.
Since patches 6-9 are new I aimed tests at them: array stops under
sustained write load, including raid1 with write-behind (patch 6),
a forced llbitmap create failure (patch 8), and a check that
BITMAP_SHUTDOWN never reaches the on-disk superblock (patch 9).
All clean, so for patches 6-9 as well:

Tested-by: Mykola Marzhan <mykola@meshstor.io>

Thanks,
Mykola
