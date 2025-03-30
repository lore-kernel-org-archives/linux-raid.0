Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B43F27713
	for <linux-raid@vger.kernel.org>; Sun, 30 Mar 2025 06:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743315952; cv=none; b=iX/EF6DVYjnA9HNlyA7yz+uN+WL3FnEXox6NS3o301I+/emOspwB7zbH2P71FD4bH5i45xGrHeNon2fmk/D0oOeOHZbCuJ6BVzVx5JlR4i8TWEF3/skBdY8hes5kTs3eome5T2AHlJYx3xp7GDQ0PBb5zJN25dI55Htc5TEdUyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743315952; c=relaxed/simple;
	bh=+A26t3HGiCqjHxaTkcbOdw6hQHe7GfRUJicJRVB9tZQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HmZIdReMesdMZVSrXjFd2AIVEu7hUZ4GpRxfbEpOeilQJmT9XbjjLO4axwvFZm6QcyDgf7wVbtCt6Y9arSzBAUUfEWY1GraaRCA1XIMSwa+i0VkLx8GvQMZnhTubtomIoGbB9AXcWQrsyMoI1FIRcnpJMSQUa3TAK9IaqzB+R8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iRx/0uTP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iRx/0uTP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743315948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+A26t3HGiCqjHxaTkcbOdw6hQHe7GfRUJicJRVB9tZQ=;
	b=iRx/0uTPPugzUPW9Z9tYCwcB+QeYAwfmE4ZXv3ZcPy/6M6T9OFnaLpIQ/Sm5VdXwnOvL9v
	C0ONrSCNxgdjmyN9Fye7CnzFZVqutdDHK/aXbZt7ri5gYqJ595HjcWeNiU/mrNmsWaSaQD
	lQSHhOrQ6t/6haEuG7kxu9AeGPaoFNQ=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606--iMY-66tMhmCaBCwVcrMMw-1; Sun, 30 Mar 2025 02:25:46 -0400
X-MC-Unique: -iMY-66tMhmCaBCwVcrMMw-1
X-Mimecast-MFC-AGG-ID: -iMY-66tMhmCaBCwVcrMMw_1743315945
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5428d385b93so2284169e87.3
        for <linux-raid@vger.kernel.org>; Sat, 29 Mar 2025 23:25:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743315945; x=1743920745;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+A26t3HGiCqjHxaTkcbOdw6hQHe7GfRUJicJRVB9tZQ=;
        b=V2sxFPfSk2afxBeJNQGR40PYZuho90lCng0FJVRXSy30qj2hGMWWc2Po/9ON98g/Ob
         79SS5f2jGXx75FViqogguDaf6ZLOXsC73pOC1DjRF1PjkvvZBXtYW4mJ1JmMfmPQsyVN
         pROikJ3bmxgrmWWBUPXJQqIjBiQn8VfzSmXseDoUSfDcr/bSvGf5l1rlL5aGJeiCjU4s
         PM23ch1Oa0Sd5PNgQOGTyK/OcDQwZzxqEFfsAcbubbTOwx31F6pvSCDpEI8TVlTENyAS
         dn8WTyalh99LWdeVQ/zTUjFWHjhqMawg5Q7yPiB8q1iuDA4u4egW2ERzY/FLsqKpCjEE
         EFAA==
X-Gm-Message-State: AOJu0YwUzwrA1y+VRPthgrCxItjcl2eIraVb6iOeeSLlTEt7t8ix80d/
	04MbLvG9kew43bdVJPaUECPLguOLFOx0zvJNFPv6g/lHyAUVvpQoQIuxiTlzYn8JJxQUxULPoOw
	Vllys5VJhG7AtwZx28Xmq2DuUJPKGjIs/ijWmJFILB60twFYgQXrUpPdv80up1yNLElAqnZ6G3M
	czyi9j/K3JboDrWQFfqg4Rsv/hYzEYDP6zeQ==
X-Gm-Gg: ASbGncs1qclvH4zuPC0P+ucT3ZtURoRCUTZrI940kcBppGKgWTNrMmWX5iH5WOR/Uyl
	1swLb03LWI9FnCcCxY4rj+YeFOdLFhJnFhtmt+rfZ1zEBsOGx7IzZ1z3sGC5XXoRlaFVMRg6ZvA
	==
X-Received: by 2002:a05:6512:3d8c:b0:545:2a69:b1f4 with SMTP id 2adb3069b0e04-54b10ecda43mr1354802e87.29.1743315945083;
        Sat, 29 Mar 2025 23:25:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGlC5br7XLmWe7u64dWTS0rCop8WohkHAM992BILYfGz4Ed2XtfWR3V+s7fAiEwQqmxPMDvygnMwL58HjQrJiA=
X-Received: by 2002:a05:6512:3d8c:b0:545:2a69:b1f4 with SMTP id
 2adb3069b0e04-54b10ecda43mr1354797e87.29.1743315944664; Sat, 29 Mar 2025
 23:25:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <lMRgP8wc-P3iUlmbrsOKyuXM834ndQZZUThbeEUIO0WoNKKMQLd-T5P6QrFMEYiYAoQUAWkFGaggDTMSzZFw9KzBagunLy1mRNDk2TljKUM=@pm.me>
In-Reply-To: <lMRgP8wc-P3iUlmbrsOKyuXM834ndQZZUThbeEUIO0WoNKKMQLd-T5P6QrFMEYiYAoQUAWkFGaggDTMSzZFw9KzBagunLy1mRNDk2TljKUM=@pm.me>
From: Xiao Ni <xni@redhat.com>
Date: Sun, 30 Mar 2025 14:25:33 +0800
X-Gm-Features: AQ5f1Jq00XNJN3TkSyJjLZfJ-ifXEAajh66gKMAgOgJiUTxfbCOcf2ppxG3LNw8
Message-ID: <CALTww293D+_TNY5OoS3ceqhg0QL3xPVH7g2O_kvEcjA6aZOVVA@mail.gmail.com>
Subject: Re: RAID 5, 10 modern post 2020 drives, slow speeds
To: David Hajes <d.hajes29a@pm.me>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi David

The io performance decreases when sync io happens. It's expected. How
about the performance without sync io? And what's your kernel version?

I read other emails in this thread too. Your sync speed also decreases
in three days. I can't understand this. What's the io environment
there? It's better to describe more about the situation too.

Regards
Xiao

On Sat, Mar 8, 2025 at 2:36=E2=80=AFAM David Hajes <d.hajes29a@pm.me> wrote=
:
>
> Hi guys,
>
> I have issues with RAID5 running on post-2020 14TB drives.
>
> I am getting max writting speeds of 220MBs.
>
> If I understood properly docs, RAID5 with three drives should have 2x wri=
te/read speeds.
>
> Single drive tests running 190-220MBs, no issues in SMART reports.
>
> RAID5 with 4 drives...same speed.
>
> RAID10 should have 2x write, 4x read...still running 220MBs max as RAID5
>
> I have played with chunk size...default 512k-2MBs...no difference
>
> "Read-ahead" set for md0 virtual disk
>
> NCQ disabled - set 1 for all physical drives
>
> I have basically tried every suggestion on famous ArchWiki.
>
> I have tried SAS2 HBA...same results.
>
> Initial resync drops to 130MBs
>
> Debian 12 running on SuperMicro 10 series MB. 32GB RAM, cpu max 30% load =
during tests/real-life copy.
>
> Is it possible this weird issue is linked to HDD timeout described there =
>>> https://archive.kernel.org/oldwiki/raid.wiki.kernel.org/index.php/Timeo=
ut_Mismatch.html
>
> Any suggestion, please?
>
> Array should be doing 260-560MBs with ease
>
> Regards
>
> Hajes
>

