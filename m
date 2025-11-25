Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4C521FF21
	for <linux-raid@vger.kernel.org>; Tue, 25 Nov 2025 13:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764076889; cv=none; b=DhnIj2IwVZ83/7SUyxRdLxFl8Og+AXUZVe+T9DhbQCUDY9BvM+LBnr7sGqEFQ79b91RJuDhGJpzfqZUuPyFFojpbMpGb5dlq2550cUyA+O5Ubz4ie8l5emFaIhaRUVJ2MqNpTuz7f0Bby0KnvEkyqBQIseOMjLn7Qnlp4mTdCl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764076889; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TRJSPE3S7oclXCW4n6o924tBovR1+D/3ofcf24294/ycPyCX55yOUKrkc7QMNqoWmBTuPGjfRC8Pwcrh3QU9eOgW//DPbVPW9SpPTknIoyr7SLtcuafWbFSwvGA44HZyKo1PqkQ7qiKDRFCzndoYhPgBCQQN1kZ2rQqzQaLzh/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S+srcaVn; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S+srcaVn"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6419b7b4b80so7790574a12.2
        for <linux-raid@vger.kernel.org>; Tue, 25 Nov 2025 05:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764076886; x=1764681686; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=S+srcaVnwTxEdnt0DzwKVDmyzP6pEIuKZQ6KOQhhkFH55Kf3bIyTii4YGzezHnioU1
         BBYkyEt/Q3kpB1JK8DiFDywmJcmjQi195XAudmtDcJJk3/LP+N05sDr29iajWcEfyspV
         ptVKgZGgloWprMleh/CxAuuHEzJ8Y27OX/vai2k9oJSWWM5Q9P3MjO7J7pdcQQ5/y7yF
         GGNGC4rlVIgqYnpeHKVvw/vBKePkVKfBusJmBUTdghkiVwKK9ZI6p3QTyAS5f7vqJgNI
         zC6XBusssXX52DpdndBIPEmPFZDu3VD3UyZem9oLxxR09sUkNGA8vo83e9BuQa0vLBPj
         ISnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764076886; x=1764681686;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=f+wsLyD6bMdiwp1F+sVJ/YXhdWj0flTc8ClMR0194/oZzWZgJI/V59lEkY6D94efv6
         l4s3BFgvUHzD8Eidl6Y3FJJzLPGzZQsLUv8YqwcCzQtRhQZyG72m3JAoWYyFRXDXrev4
         Kcml91ltD8nQucB6xX55AUUSwCaqKmuaAssD3zEy97JqqODbzShjd4UxMlGXBydi/m7M
         eu9ZsfdfyCYmOcpOWVCwDQikayQOPl4sCVgVhX/4PSroWc3U1ODzaIbgsSkTl1qivS6a
         dYEb6x7DuZVlP/g+U5z35TQwehtJJOFDP+J2oUPitgHXbI44A+S8mmAHRt2rbEx1sO5o
         FjFQ==
X-Forwarded-Encrypted: i=1; AJvYcCU851tw8qMnP87T/rWDjirc2ucbzohQNfU91Getu05buG8Na4tjXMrXABFNg3idYx519a8XUMIY/gmk@vger.kernel.org
X-Gm-Message-State: AOJu0YzcDGVadTErlXn8sbO10LVLbbHM2HXb828EQ9tqvvzeqZjlJ2rj
	d9dyu5ZOsgGytvv+g6sIGC8xQ+9By7mzKhPdj3Fg9ryC1DoLeeQ5bYW++F56+lC4SwnSRv8Wc5V
	Jsysa2QJigZtOYaYyMNfGT2z1bXH+kA==
X-Gm-Gg: ASbGncuRB2Fbb+2TM7mZ+FRGG7Mn73PyqaXHL6z9Q9b11fBmSJFgCN3sIfy9xHevqw6
	x0DvLw7F3KXk6jH/lX8SI/ikg1bwrc3i8vilpoXzvQmJP1bQENrzfeByG8tsdXrCDNEugYuJy7s
	9ynBDKSLs0y4rBsQvb4+neZYk0SdVeFg8harH92mdxZkMSSzo0RywhgFzzUNpfkTb7nVZ4NDvfg
	6HMl+2I7KUV/QCW0jh+s2C4dSbPnFuRY0C0xGw51A4an3NajtWq0+B9WyP9VaqovDIZnkU2etIm
	d55UPNoYC481pioVOq4Iv3j0ELFQtfT3mr4XuFwifnph3du+uy0lsVWCqw==
X-Google-Smtp-Source: AGHT+IFdAjUbTCRihlcnMQbRe3kaTpxY0zS2TJvPnabL+VI06FANQqQrLV6dY7bbefHQ9hiFBD+KK4yE+DNgNHPMVMo=
X-Received: by 2002:a05:6402:280c:b0:640:96fe:c7bb with SMTP id
 4fb4d7f45d1cf-6455469c726mr15216782a12.28.1764076885654; Tue, 25 Nov 2025
 05:21:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
In-Reply-To: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 25 Nov 2025 18:50:46 +0530
X-Gm-Features: AWmQ_bmI0Nc-U-7V1vG_PnxUMzavwAZMXSjJQCtXVqm1t0YM1hU1mPKj8-N19OU
Message-ID: <CACzX3Avd95DD0g1ec5y3Rqhs6fpo0dqcKBScUr17AOHcw_2JhA@mail.gmail.com>
Subject: Re: [PATCH V3 0/6] block: ignore __blkdev_issue_discard() ret value
To: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
	song@kernel.org, yukuai@fnnas.com, hch@lst.de, sagi@grimberg.me, 
	kch@nvidia.com, jaegeuk@kernel.org, chao@kernel.org, cem@kernel.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-xfs@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
