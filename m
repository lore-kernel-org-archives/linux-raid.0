Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF2532A3DA
	for <linux-raid@vger.kernel.org>; Fri, 22 May 2026 11:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779447745; cv=none; b=i4tULbhT2t1ze2Uh7DvH9mIm1Vidq468G6/PMRSkKfQqK+vyF2PpIVPDYBG6/6UioJgrRMCKiJWw38FniAlnghGVmftbC531NFCPpaig1IQbHVmnJ1RXvb0puulmhhBq3mOKQr8a1nvKgnk5F41V8dqrTUq1dF+bw+G9UsmBJsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779447745; c=relaxed/simple;
	bh=HjcRq1lGbTiZ/1JJ40hbmU1JymlezMGSDUOj1hBKe/g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tPELNdSHYcYMcsVgyIB98aA5g0WkO0ItlfZlwYRQc/VLtr6kGeTTNhHAh0nPHS1vu0ZxEoPU8qYwuLFifODqsNxuq3j74DF/1iRhQQ1QpDXoCzEW7OvZHGfkLw5ash1c1BLO3u+N8X8YyyT+5vpPGRZmrkxiM9UsIblW+O9wnPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JeKtsEzE; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JeKtsEzE"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4891d7164ddso37482175e9.3
        for <linux-raid@vger.kernel.org>; Fri, 22 May 2026 04:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779447743; x=1780052543; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HjcRq1lGbTiZ/1JJ40hbmU1JymlezMGSDUOj1hBKe/g=;
        b=JeKtsEzEFt4ji4VtfK7F74GAKj0AbQ4Y4lbYGHGikc8zhmIcqVx5F43k3T1JeG5CaI
         o/bjcc1+eBFSykThiqp81OEsyreXY3ZIyffaOqrV7WGr2WUcbdDc+jS5GbYxWziz7VHm
         cJ7+6UUb8bU5O9jUBmFTfAQkblulo3D9L69ds0fjDQudh1d72pbwpEmAv572ABrRnzDx
         PqQwk4rNBNHMS2rH/2gMGRg0dFCOesfTLZMUnnqnE4eJWBnZbUdcVF9K5ysWBWz0YxET
         U9QnfXnI3Df4EBcZXOy9e9RnZVKir9dcLzytg0SRlUrpy3HA0gNskQsvBQb33EU4p/8r
         rn+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779447743; x=1780052543;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HjcRq1lGbTiZ/1JJ40hbmU1JymlezMGSDUOj1hBKe/g=;
        b=Q9L2SzHP39VehcV1GylTr7AZfpxtzJKrwSQbrn9qC17qlHM5XZNoZttxrm7WnS1n+R
         mzGIEtJLeQ8ZSH/K7zZEI+MMZScy6RsR72+F0dc68ottq8oy7eWCmyFWidliFcN4E+lp
         vrMQ04TJXqVP+XKb+JEcf0g/quP/5azUtJjtgkHcVjHfMRpCNfkDdi/NscTE1YrDho4s
         mw0q3wvj7wJ83r8DM3gvAxm40d/G0wWqzCjZqWKjKQ55QEWstAL3wohbf8kulz/Ue1zK
         K5oshjyDXOov8AwddP5uGW6Ui02Ys5AXgTvHBAQ/aWFtoUtH9HkOWkMppvxLk9jKymYA
         RAfw==
X-Forwarded-Encrypted: i=1; AFNElJ9omqjq+kvqWvO75jttmiWF1+gUQ4aGS2VutApt37dARjDrDqB9OzMPgx8l1mOxn4Q9H8YlbEpzMJxd@vger.kernel.org
X-Gm-Message-State: AOJu0YyhjYP957prWdzW1ypozDA6SB6nBkJMkF5uJlOJDMpn6CKD7ns5
	pKqDuEF74choltW0yqAqnuYj9NHedkBe18spnozIDhTrMsRpwH9eqFFB
X-Gm-Gg: Acq92OH3mBtukKr4gdYecPhP9MCisL16FvtcIGgwwQw5ENe5w9PTP/pBrgRkWuwoXY8
	k6CI1Su2g3flcOOMN4hy4Wdh4HPf2g38PTfsGfo2IMYUw/Es3wFlwuYtLk6VhNtgnR84txmdrZD
	bXo9OZcQ7LYxjPaYL0WUmI+hWu/n4CIg7VKuTTt2OYasXzlhEUmmUg80mX6qTy2LfCG6FfEmqN/
	y6nwD2TIynyT6UjyM1c3u0EXeneIcsyJV/e5kyTsFEmnf9adG8Pv4JBDOoA3gd015T31XsRDrPg
	NZW+oeY74Fcp54+RSD0nmWXbRyr+jx2GOtoU1xl/GLZhHaOY64pTttP2tv3eqxSLys5zFiSgLmu
	NTzcbAyOleQCW/S6zwlHF1UeXbmuMG80HhrGSVGX3FzvEUdmfNjd2zsG/ebdAiw7eeN/Gjyuf0V
	FoEMrWCgXx4EGWeCw7FpBJb1XuvMSxEffO5PH2MIxTdj6VYB8UrVpc4HizkRT56uIg
X-Received: by 2002:a05:600c:5298:b0:48f:e230:c3fb with SMTP id 5b1f17b1804b1-490428ddd40mr40608625e9.33.1779447742457;
        Fri, 22 May 2026 04:02:22 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:612:951:d06e:b718:93a2:5b39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49042aec059sm15945285e9.28.2026.05.22.04.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 04:02:21 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: Yu Kuai <yukuai@fygo.io>, Xiao Ni <xiao@kernel.org>
Cc: song@kernel.org, xni@redhat.com, neilb@suse.com, shli@fb.com,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai@fygo.io
Subject: Re: [PATCH v2 2/3] md/raid1,raid10: fix error-path detection with
 md_cloned_bio()
In-Reply-To: <aab7e7ea-737a-4bc6-a50c-f6ed7b38c37d@fygo.io>
References: <20260501114652.590037-1-abd.masalkhi@gmail.com>
 <20260501114652.590037-3-abd.masalkhi@gmail.com>
 <71990de4-1113-4b7d-8a50-ca1d82802a03@fygo.io>
 <CAF-RUYVK34e4ShHLd4nYGBdB3yxX4BBkS-woxBnmCuj_6vUisg@mail.gmail.com>
 <4ff43e8f-6405-4ce8-8cdf-f71e0bce4d3f@fygo.io> <m2pl2pkttv.fsf@gmail.com>
 <aab7e7ea-737a-4bc6-a50c-f6ed7b38c37d@fygo.io>
Date: Fri, 22 May 2026 13:02:18 +0200
Message-ID: <m2lddblnb9.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, May 22, 2026 at 12:23 +0800, Yu Kuai wrote:
> Hi,
>
> =E5=9C=A8 2026/5/21 17:14, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>> The original bio resubmitted via bio_list is not executing in the raid1d
>> thread context, so blocking on is_suspended() is correct and will not
>> cause a deadlock. The suspension deadlock risk only exists for
>> md_cloned_bio executing in the raid1d thread context in the error path.
>> And in this case it is always true that if we are executing in the
>> raid1d thread context the bio will already be a md_cloned_bio on entry
>> to md_handle_request(), even if current->bio_list was set, because (and =
as
>> @Xiao has mentioned) every time we split a bio in the error path we are
>> resubmitting the md_cloned_bio remainder, never the original bio.
>
> I do understand this, if original bio or resubmitted bio only split at
> raid1_read_request, there is no problem. What I feel is not safe is that
> bio can split somewhere else.
>
> This is possible for raid5, However, take a closer look at raid1/10, I
> feel it's not possible for resubmitted io to split in bio_split_to_limits.
> Even if it happens, it's probably someone else to blame.
>

Agreed. Since bio_split_to_limits() has been mentioned, I am wondering
whether a resubmitted md_cloned_bio could end up being split there for
raid456. I have not looked into the raid456 code yet; after finishing
raid1 and raid10, I will move on to the others.
I am considering skipping the redundant call to bio_split_to_limits()
when md_cloned_bio() is true. However, I am not sure whether this would
be safe for raid456.

> --=20
> Thansk,
> Kuai

--=20
Best Regards,
Abd-Alrhman
