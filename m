Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7A31AA7A6
	for <linux-raid@vger.kernel.org>; Thu, 21 Nov 2024 08:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732176623; cv=none; b=TQn4BNVv4uXD1anJD16m3LoUAH0e/EibaC6Fd1U+D7FbXKswvrbl0O+qJmUgEATpAK+odVSNGxrCLfer4SpAdZc8vBkBm6XhG8YOwgNStKA6q7ZxZkeRPQPuRhiigv3y00tY+0h65+7GvlPXZ7c4qls7QdBrv0xA0WSUjwbPe40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732176623; c=relaxed/simple;
	bh=J1CNHD/ipIg/L0Nh/y/WM5Z08MZpn6PYb6fY+01z9XQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=agDNcNWdYGFhfO0rrtdgaXYPfKWzuA4LwDrVF+M0h0U03s023ja5aB/fOa1cBsnDFV2O1hvcRNfTtwwHNrx4KLd3CnE0aKcOapbpbdU+HBjv0NDIt2sWsLnAhZxLAkkHgpUTcfxIZk4SXJz3ed7kbOmqod/ScW8FRVkvJvvLYAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=LtFs0KfB; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="LtFs0KfB"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5cfe48b3427so71775a12.1
        for <linux-raid@vger.kernel.org>; Thu, 21 Nov 2024 00:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1732176618; x=1732781418; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J1CNHD/ipIg/L0Nh/y/WM5Z08MZpn6PYb6fY+01z9XQ=;
        b=LtFs0KfBVjtiXWCIpbHI5W3LOrfWt0PiTMKu7TXcHIiskylcF0AHaqWTpMsSXwZYpt
         MOBfwNdds1WolKK38NFIxVJlcDumpWTviCzN5Tlw9eLpx6QMsb1ArArY4MK27CXAUXNi
         MHtJINV/3DQqHq+AQPSMRCWTdXLZfTj2ktZ9S5lX+JW4qKalLC+TkeHuaCLNkc4l3Sv1
         EZSz/9B08uOyZk8JpU88TrsquTA0E9LgmmiWSsbH4f+Q1To01YT1k4f4jc6b1sTyEpGg
         lEv55vP+ALInOO2yEQCVWn+SxD4HZvxIy4QkV76eHMJ1SeeTBMTzu7vfSHWgu23fwGVR
         bdxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732176618; x=1732781418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J1CNHD/ipIg/L0Nh/y/WM5Z08MZpn6PYb6fY+01z9XQ=;
        b=i4mDBxRAOBj3gYY9jxI98mxQ9TuYgU8WMj37M9FwU5yVUpzKIVyprs6gjxzDQnI3uz
         VD1OiJmx/ZOr1qGCWIVQX8dqbz5cgQx/pLSq4qnqT22lKejvpWpF5cQxFSb3ulgve3Kn
         J1hNvLW6jRSSL14l3+6P65Cajon4N0sDpDtGhU0J1L+Oyj6082av1jDQIyQeeu8Pogj8
         TWnkOK2Sh9Qdc/LIPPMhoB+6UYu/qQ5zEdswQGY5Sw6W5XTlEaTUuFvlBQ7jFmDIEJ61
         pGx1uN41KJf7MwaOo7mPuvVPaJS2u25LMuPPz1AYQrl+XZcf3F8Bo6fYnQ+hpCsXR/Em
         u9bQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRIkRyuPRxhFjNKlZGZljQeWLhc/QraDUWirEMjmKQ7FfxUawZWQl9AB/jlWyWT3wx/1HUUUaFtuC/@vger.kernel.org
X-Gm-Message-State: AOJu0Yxhq+sfdvo/E+xq6KODNwVsf2/humNfh0smvaCbiSkDIUNyzlB4
	kmxMu2eNJ0UqSZz3Dj+LgGJ6I0Fri9A+/GhEPPa7rnm6JjJ1fn9HcNauBqsw4ag0ihbMvqakE0J
	rB5Id2fzvt/92JsTNch9UnUr2QBeyE63ys/xbJg==
X-Gm-Gg: ASbGncsBZAf6B97BhuYl4djeKt2pLXPks8nwQRhYLpmg5URoqb2rRvcLgxQWSqBYjxC
	fAwDK5EPWqUDWKeHR26F8bg+eVcfPlRE=
X-Google-Smtp-Source: AGHT+IEMvl1hbMySB0BrKqNmTgujNgYhCn5cHtxvHqbfm5g+a6bdtUVeU22KGhY3n+Q/ksiLTGSywShZMRKkUP051/E=
X-Received: by 2002:a05:6402:2695:b0:5cf:b99c:3afb with SMTP id
 4fb4d7f45d1cf-5cff4ccff67mr1591425a12.6.1732176618599; Thu, 21 Nov 2024
 00:10:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <adf796b9-2443-d29a-f4ac-fb9b8a657f93@huaweicloud.com> <20241119152939.158819-1-jinpu.wang@ionos.com>
In-Reply-To: <20241119152939.158819-1-jinpu.wang@ionos.com>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Thu, 21 Nov 2024 09:10:08 +0100
Message-ID: <CAMGffEkODwo19u0EjKojQ0WaWVkvOOB8aRR8R3NXn+oC6TFQWQ@mail.gmail.com>
Subject: Re: [PATCH md-6.13 4/5] md/raid5: implement pers->bitmap_sector()
To: yukuai1@huaweicloud.com, Haris Iqbal <haris.iqbal@ionos.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org, 
	xni@redhat.com, yangerkun@huawei.com, yi.zhang@huawei.com, yukuai3@huawei.com, 
	=?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 19, 2024 at 4:29=E2=80=AFPM Jack Wang <jinpu.wang@ionos.com> wr=
ote:
>
> Hi Kuai,
>
> We will test on our side and report back.
Hi Kuai,

Haris tested the new patchset, and it works fine.
Thanks for the work.
>
> Yes, I meant patch5.
>
> Regards!
> Jinpu Wang @ IONOS
>
