Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0131E503C
	for <linux-raid@vger.kernel.org>; Fri, 17 Jan 2025 18:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737139091; cv=none; b=GTXKo0TOzwofQRQo9VXGTM8VzjR81FeF4A4hI0S89Ur431WI07N2OZMkuLKSDgaVtptEFA3p4TJ4N2UgmKvoFl9Le9h9hA1I5MH8qjZksfUyFIegW4wvgKRDwTCba1iaKp3rWIWVBf5u44JjY94HHiufjcOZC1JZgxz32kOR/xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737139091; c=relaxed/simple;
	bh=XYU/ZozG0L9l9TKrgW07GMe+aE1P/J2PYafZHZ9l7FM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qUCu25L2hrd6oHsvivrc94yd47VjM4H5zQ9P3KyR991ZFJxMSS9GqAEsxs2nLKMQIQFVGGUP8QIJ5/ueclHgnOybt9nXnQcLrUvT7rvnU/z20mGb9viGLh+DM7xTscmxKmWCByDMrCzpgibEsdu4su/4ZUlNzbKEQ1DxqAVdclk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sABoEuaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sABoEuaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88051C4CEE4
	for <linux-raid@vger.kernel.org>; Fri, 17 Jan 2025 18:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737139090;
	bh=XYU/ZozG0L9l9TKrgW07GMe+aE1P/J2PYafZHZ9l7FM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sABoEuaKBgjqpxSauJh8Ji2KVWXPRqVE6Nz0LV/0kcln2xCtn8bIPnJ43LLtwbkqm
	 5ZwPiCyUQ7nB0wG0orfVZMYeFWPic3CJwV5wostn/6I1XAiga+XIW89NK/ZL5abglj
	 9mAYR/OU/MUJ7Fd1VL2KKIKGUvpygL8OXROv9cqhdgxQcj6jXMsA1loSy/CaqxpNDV
	 kDBXbtZQXa5TuCEavg2stAvnNKAkFLr8sa2vfSTslf5MrpwK/A8g9aeQ9typkWmhfc
	 EweL3+LvApYTkBuBHl6gFl/zmqG/N5+YNPleOg/fDI36VEturl17T8tiraaeGH37rj
	 6yCz0fuNKCwXQ==
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3ce873818a3so21811615ab.1
        for <linux-raid@vger.kernel.org>; Fri, 17 Jan 2025 10:38:10 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUtT3KpClg0YnbrgLK9zNvenp1MDcE57Sg7mYgVxcq/O4WMnF9J96aJj7LPdJoajXYyWCJqthwJpPUf@vger.kernel.org
X-Gm-Message-State: AOJu0YyCILLW4vOs01pKmyGFd2PEVOduyt3KhVu3VdCOIxuv1W922MvT
	EJZvIqyMXBZg7LgquBbGdCCL/ppuBFOZWzOPr95gShJr9psEeqx4gMqM6E6qs3P5zY6EfW+db0f
	Fexn2m5B9G5+H4iPtlS4iqXHHQpo=
X-Google-Smtp-Source: AGHT+IHtuu38dzvC+J8YwJrLSJmHsZxoMiDxmpVXIaDhc1l1Wwjt3NmZR7YZATrzeb5KkyrJAF4EVF/78iwsy8+bIB8=
X-Received: by 2002:a92:c26d:0:b0:3ce:46e2:42a7 with SMTP id
 e9e14a558f8ab-3cf74410c4fmr26828795ab.9.1737139089916; Fri, 17 Jan 2025
 10:38:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250117071540.4094-1-xni@redhat.com>
In-Reply-To: <20250117071540.4094-1-xni@redhat.com>
From: Song Liu <song@kernel.org>
Date: Fri, 17 Jan 2025 10:37:58 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6WrG+R1J5nZdZ+xzB=EwC-wfM2u75E5d1M2=g6_4HRMQ@mail.gmail.com>
X-Gm-Features: AbW1kvaBtZaw1-fUZ7rIhWrg0nON_3KRPlomgwaNlnQ-px4oXlKMSMocHzpv9Ac
Message-ID: <CAPhsuW6WrG+R1J5nZdZ+xzB=EwC-wfM2u75E5d1M2=g6_4HRMQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mdadm/raid6check: add xmalloc.h to raid6check.c
To: Xiao Ni <xni@redhat.com>
Cc: mariusz.tkaczyk@linux.intel.com, linux-raid@vger.kernel.org, 
	ncroxon@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2025 at 11:15=E2=80=AFPM Xiao Ni <xni@redhat.com> wrote:
>
> It reports building error:
> raid6check.c:324:26: error: implicit declaration of function xmalloc
>
> Add xmalloc.h to raid6check.c file to fix this.
>
> Signed-off-by: Xiao Ni <xni@redhat.com>

Reviewed-and-tested-by: Song Liu <song@kernel.org>

It appears I cannot push to the mdadm repo on kernel.org yet.

Song
