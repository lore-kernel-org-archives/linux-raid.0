Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2312586FE
	for <linux-raid@vger.kernel.org>; Mon, 19 Jan 2026 19:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768849526; cv=pass; b=TkybI1ij10QEEmERN8DlZSdt/IoVEusThbULUVyhNqNzVvoga9e9nYhsQLR4eIH5lhosxD9gLM/vh3HUMbT9wU79bSOjz/mhHZ3LuOoDHmWdTQlkjTq6JDx6IAJJiVeCdiIrdSRj0WnFLKG29dfhwJeHUrOGdGa379xbQXecgBA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768849526; c=relaxed/simple;
	bh=bybEJguKXbE2d7zF7ORE6oCRmzBwHxewJFM3FrI/fkM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gEuFXFVaru/IKPgXYUMamPCFjh5ACSY7drOILZvilogKqkCgjD7mFekJI95VzZIePb8Ph84/bvyK54YcJJjxSzyq3cEd6flbwZRu9uPb5EvlEV0PV4TJ5zPtsNKDQckz8bbiYxKnFpwy52/VwM9xRTTz9cDb+LOAUkafrzopb0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=cUiqE0fU; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="cUiqE0fU"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b86ff9ff9feso52055166b.1
        for <linux-raid@vger.kernel.org>; Mon, 19 Jan 2026 11:05:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768849523; cv=none;
        d=google.com; s=arc-20240605;
        b=D+84iABPMP8Oaa/vV9ax4uw2l5uZzzHr9rrOR3ogfUZriSgR2+2idOqWWaLaP/WTp/
         RsFgVx4UIewUniftHdiQvuvj6kHOG38Q5Mri2EZb6v6RuUsbSkDzWFBawF91VkcF1+0l
         FFZ+Sl4Or8dvPZYulv5unTQb2aI5xqIMkeFgZ0m2in0Ueq70ZPbj/DIkXs8Nwk+tD7EE
         gO85kfyo1gnSg3rtEM6I1wQnIBuAAx+Aof8Ig6xn8q9exlcjdIUsXbMKPBfAvka6jEmD
         J160dCXSt+OT3bBi2K4FnUUmthuk08lWD2KE+3ztz7jUHo7ERHor7uDwQ/BzF58Ap189
         ORxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bybEJguKXbE2d7zF7ORE6oCRmzBwHxewJFM3FrI/fkM=;
        fh=DESHT0KYP4DOhwum9FL+qdvlwAcKj9JIpWToxehGGIM=;
        b=CO0gzzfmYEU+8qcMLPMF3K6omJxjYQFmm/5YjUSW5ag7TDTUIuxMNw+YcTPEyLvjNG
         zSncR4pv88wBJ1yVgxLXiiL4uWGQYiVSGLdLF//7tZ/uTbhvf7zD/nvejZKrovy1weF4
         8hbgrmurupDb5ytfBQVLnT1wX0meqygN2q/KrpZcjw09Uqk25SiPoYWfWX27M/GxdNLn
         PDHZe1BChude13kfjLev82FHk7nhzuGVaWPkXVukFu4c4YIxl4a7oVG5Yuke2QDJM9Ld
         2MYZoLY+ypz93pQCi5QohdIc0dwtsqixGN4Jhme2Ku0312el44xyFkQxhSzPJNYvjqzT
         KT/g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1768849523; x=1769454323; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bybEJguKXbE2d7zF7ORE6oCRmzBwHxewJFM3FrI/fkM=;
        b=cUiqE0fUBgtOvDz/rexZqrryElcQjJDw0mCn0CJzHVu++u2OMlDrUtHJ9Cw9mAEgdd
         ugzJnNKBQMdV9yD3SsMMCISub9PEiuzxnLwQYai01PcMonuaufrC6hw6bykpGhz5d2Zo
         I2QVoOZnklhbzK02bOgaHSWN1vxCFRUw4GYO0n84xQMnB2uYZql3sYAr0h3L+AzBcOhJ
         jDsSQsNA9oJ1WjsmJ5TUYPyCnPOqmuBPnma6X1/3SiXnKNl9Oe82TMEO1MXLmD8soSjX
         jAOAakae7yPC7Wk04SjCOuA2hkJYGRlTxb2+epyCwJ7hyEUfa1VxMLVSBxtYDXb9Zxg2
         2Fqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768849523; x=1769454323;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bybEJguKXbE2d7zF7ORE6oCRmzBwHxewJFM3FrI/fkM=;
        b=Wzqddnk/evevPTuvv4t9Z0JE2qy6lk0SvX8NjmJfd3lmZ9QR1i7Dyd1pM8VNfu/9Y1
         Kwt6toPSrnDgOhlHpv1MVWagqN4MpM+HDH6fXL+Gp0ElSIqhXAW7aooYngaiALFjeTaQ
         kLRB0+ycaRx2Qo26oRwRfbjyS+9J5/okyjFlXsq/fktC+wsVlH/5xhn9Go/FbRi+aYGq
         VGCNDDpPqy/SF9gq1/C14vEuqLMrb1XZ+aQXLJsjf5yvT+QWXQQi8WC+ibqHg6rkUw06
         xIlya//VN7WOopHSwDmPucPJBnOfwvnKJzYWQ4FOXYqM+ftie4kv4MdYf5v8pBXnz4Zc
         foPA==
X-Gm-Message-State: AOJu0Ywzaowoi/1sO90922pi2SKUPU4/yYz8xxZ3E0hiSKmE0Hrt+SgW
	QIC1wkCP86Le7P8qonBGF/y7lkcpgILaVkh5QVWkWAK2N7fWPK2lGs5WF+6QKuztv1r98ts0g9Y
	R6fv56vl2jrFe9iJGJYeAs0CNZ8fWDFcrJy9Ul09WPv+PRFRY5K4k
X-Gm-Gg: AY/fxX6vuUBsIf6nwODW1l9pDYjlf9Do1G8rrhPcbdBdzdrvEXUTEJQH3aXk9aomaX0
	rZb193Z3ZyWmJFhTXoY2XmiB8qxuilWj/FkD1izG4Ts//T/8sHjWMg5joAMlTsdj1OGRoLbsC5F
	i16ebETBpFRPPKk5V+BldQFyeSAALaF5UgN3a5FylZILQ3mwoIXb4+vlGtRr1bDSveWwNbcbI6J
	Xe1f9/3GhvtB72C8DvgEgo68/bu7Vug9YiZXjY4qekfqaR3/leQLetlGFcGGMqQaKB2fBe8gTyy
	pYGwJsZSaLGQyGLNneSnV0EaxPXEOMSGGMlmGh8=
X-Received: by 2002:a17:907:3c8a:b0:b87:6f58:a844 with SMTP id
 a640c23a62f3a-b8792b3a359mr649117866b.0.1768849522741; Mon, 19 Jan 2026
 11:05:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMGffE=Mbfp=7xD_hYxXk1PAaCZNSEAVeQGKGy7YF9f2S4=NEA@mail.gmail.com>
 <b1824ba1-a051-4c4f-bbf9-c28fb225edfc@fnnas.com>
In-Reply-To: <b1824ba1-a051-4c4f-bbf9-c28fb225edfc@fnnas.com>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Mon, 19 Jan 2026 20:05:11 +0100
X-Gm-Features: AZwV_QibKvhINBkT-3EgeIOs456IgGW1TB_M5oqvckIf0A71Pi29D0uYGnV-lmk
Message-ID: <CAMGffEkvZUAgjxYSPL39tfDhWqxZB-o-zbe-rrMAPeuQ0vr4fA@mail.gmail.com>
Subject: Re: [BUG] md: race between bitmap_daemon_work and __bitmap_resize
 leading to use-after-free
To: yukuai@fnnas.com
Cc: linux-raid <linux-raid@vger.kernel.org>, Song Liu <song@kernel.org>, 
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kuai,

On Mon, Jan 19, 2026 at 5:44=E2=80=AFPM Yu Kuai <yukuai@fnnas.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2026/1/19 23:14, Jinpu Wang =E5=86=99=E9=81=93:
> > We are looking for suggestions on the best way to synchronize this. It
> > seems we need to either: a) Ensure the md thread's daemon work is
> > stopped/flushed before
> >
> > __bitmap_resize proceeds with unmapping. b) Protect bitmap->storage
> > replacement with a lock that
> > bitmap_daemon_work also respects.
> >
> > Any thoughts on the preferred approach?
>
> create/free/resize and access bitmap other than IO path should all be
> protected with mddev->bitmap_info.mutex.

Thx for the suggestion, I will work on a fix.
>
> --
> Thansk,
> Kuai
Jinpu
