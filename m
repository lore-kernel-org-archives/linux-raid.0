Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9220372064
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 10:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782124219; cv=none; b=YZAdCRPZ2NNde1mkbsrHwCKteqeRoGHUu4bnoR1vcVsW5rmAI+XkiUJLVfYXM28zD4XwyO5D9eJP0gSzS4SEF0fxZRLRoK5m3M0CCy9EHpyLYDl9FBLi7X0sod2CfUC+29770ifNRIsil9XKAjPOboGsF0WlMx3DYF9KWXNNBkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782124219; c=relaxed/simple;
	bh=Ii1KCfk/Q6UmKa4S2HR7teKRK6ri3Hm0oX1mojujygk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kw7hyH+9+GHkF9fDWpDXw2rrFfaGcww7t7XfWxy1PbspRN8VN1Dg31T/s/MxOm/mhyd5RV7irQdfxg2JSSRcy4fYHYp3lcNfro6yVhiqYm7QIZwsk/MntHw0uUohR+ba9Tx3CJUYkDQmMSpAscBhg9/JyWLDDMoPoEWi6hWxI00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ApO76NQZ; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ApO76NQZ"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2c0aa420401so25320645ad.3
        for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 03:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782124217; x=1782729017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ii1KCfk/Q6UmKa4S2HR7teKRK6ri3Hm0oX1mojujygk=;
        b=ApO76NQZxYkUBNnZ5Vcvlu5SZVHKL/I011mmvA9x9mX3vzAPErJ9Mht8X86RqpUGOs
         lQdjikfO3hrXe8Z/0WTcXf8K9bpRPMmwIhBn82oqCUmfrFu6ENl/DeXETsTFenVZf3v4
         Xa0MRjB33JmHGvgMNOvlC0no2h9NMMdRVi5uwEb723yfdlKM5bB0D4QF/l9xuumNW+YD
         06WG8kNHangKhBTKlU1foujW8DLWleEiIpBAz3tiey7E2TwhYcE5wiEyi6Yaov5YcgwM
         GkQjV8BveJHkm3z57YPYBQh01ObNM7ZFTaLNa4GHhXYcm1cwMg+DdykByYycq8sAG12h
         eRcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782124217; x=1782729017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ii1KCfk/Q6UmKa4S2HR7teKRK6ri3Hm0oX1mojujygk=;
        b=Ng4bRAKVpVP04prja2Yp+Gxf/yDAuXmePHIcO2QiXSC2Mp/nlbzb7sgAVEABInIXVE
         T7lOi8ndN3JxwWK/1AhP79agI/+qQCSQxSz/PjD1zvjRVr5szq/dyF4VAOdMjNuR5teH
         Ss75Hnhi3ayoFakDUDvzNLlRhMlAfE0f7O8XXLAp3QhfQGnx5bdFFYW11lL8epNfGd3b
         mkwLugzekFJF3XYt1LQxKg5MmHHTwR4s7QWLXrQCfv2fyM5Cur9G43nqI4B1Bt6J4czZ
         hxwzG7T/+S7DCKDdrdHuSORnwKyeboVOwb226v65pqT150/s9J6VcUi5jxAc6kPPsJf3
         WTzw==
X-Gm-Message-State: AOJu0Yw4ieXj5YO+3xy3aW9yBKJW5PReW195/GvPQRnMIbj89IYlmowo
	Q1KrSv5vSDtPKMMw+ECzSiFrmLFkYuXWM+LuO+15eLOEkUY9P0NjKVos
X-Gm-Gg: AfdE7cnMlWSEWaQo+/ZgMBkKDqDGk0JiB3ARfHTI78c3xEdy8ZIe4MhWucLtRWlV+Qr
	Jl5hOGs5XyD+ZM89/e2nku0zBgPwRps5v3I8JBT7Meza7aCij5AvbpwIuFOEbRlj3QBIi03Vfrq
	sDxtHnEs8eeBH0LN+Ii6dAKJhdWkHJUX2AzZ2ua9tKaiEzjkC5vkXq5Xb6AhuS60k4QvLgSrf12
	wYQSZhhzAZ7+SGV+kpNnTr/ACiEeXsG/jXsWJfiEpGhSqMTb4AeMy9Qq7rfqxqHLusXPeVX1b0d
	eNQ5BcoVS8CP7z4yxs4vojrV5To/Bpg2RHwh0NvmYyAeR8oC7Rg8lUwDuK3xqovrYQptCzI4U+m
	dnw9dT7RcHKCa9/3jjbZOm1vAAz1okcE2GcD1SCJrkI6hX8dmfBbNPskmIH+iPoJbklPRSx7Cmh
	42f3RRqt4TS7N8aQ==
X-Received: by 2002:a17:902:d4cb:b0:2c6:f3ae:2383 with SMTP id d9443c01a7336-2c725b93678mr133806555ad.13.1782124216347;
        Mon, 22 Jun 2026 03:30:16 -0700 (PDT)
Received: from fedora ([106.219.196.189])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c742fdd411sm80718545ad.0.2026.06.22.03.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 03:30:16 -0700 (PDT)
From: Sajal Gupta <sajal2005gupta@gmail.com>
To: error27@gmail.com
Cc: linux-raid@vger.kernel.org,
	song@kernel.org,
	yukuai3@huawei.com,
	tomasz.majchrzak@intel.com,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] md/raid5-ppl: convert pending_flushes from atomic_t to refcount_t
Date: Mon, 22 Jun 2026 15:58:58 +0530
Message-ID: <20260622102859.38034-1-sajal2005gupta@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <ajj1yljwrUk0bZwp@stanley.mountain>
References: <ajj1yljwrUk0bZwp@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Dan,

> Have you tested this at all because it doesn't seem at all correct to
> me...

I have only done compile test, sorry, I forgot to mention that.

> How I imagined this would work would be:
> patch 1: add a break statement to fix the use after free
> patch 2: s/atomic_t/recount_t/

> The difference between atomic_t and refcount_t is that refount_t warns
> about overflows and underflows.

I did it like this because that is the pattern mostly used in the codebase.
Simple s/atomic_t/recount_t/ would have
refcount_set(&io->pending_flushes, 0) in init
and then later refcount_set(&io->pending_flushes, raid_disks) in
ppl_do_flush, which is not the usual way. I am treating it as a proper reference
counter rather than a mechanical type swap.

If that is too invasive, I’ll rework it into the break fix first, and do
s/atomic_t/recount_t cleanup separately.

Thanks,
Sajal
