Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617F416F908
	for <linux-raid@vger.kernel.org>; Wed,  4 Sep 2024 21:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725486715; cv=none; b=SCRC/VMrVUdzciLNF+VYWZAVgRCrE7cG/hJ+sOhotOsBg3Zn1045IOi5OcKbas+TIqoN9J86WSf1SeuenwXUqp96f/QnEzEt0a9copXPMs2QWMRV44NEojt6R2w5/rthijPm/4ZqJMmwqBVU9hUlIK3a1D+AcT+Gn0tTIeymtvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725486715; c=relaxed/simple;
	bh=qwgRKamDhentjUajt1G802PXLOyGDsMichiNx5i98/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r4djYW4092U1ZFEoIrpzCB7YkdznEpcbjsF6V9JcTOPF/iYtgc74v5DnfZf7zzWtxmTd402Gi+22Cx8/Lv7cIG5IipCh4KVDDZSLxwjZAZPt1ZbN3efQ9HyVjwgDA8M+PE2PUaSn7BfhksFAj7EYSLZqT643jYA4EOsq7rCCHps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CE987JlC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CE987JlC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02A9C4CEC2
	for <linux-raid@vger.kernel.org>; Wed,  4 Sep 2024 21:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725486714;
	bh=qwgRKamDhentjUajt1G802PXLOyGDsMichiNx5i98/U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CE987JlCCwafDiROFRkkaKgnKT4j0Pgo0w8lH2hKZBZlMHRFxx10aAljNueCPEBgH
	 w0TQd973jQe+EPjWsWTH4J4cBsgwvd/FCCzjFRhcU2te9rjhT9WqZYEmFNsZYrVpqC
	 OWkbFU7qpGBNYinBce9+jtk+xyvObyD9q0FYnuBmDULz1voE4eUHLpsUdTGnSYHpP6
	 iju7UQ3A0FDE2GrHdw++JCq1DTbKDhzlMbLXgzfdgLFzme7VSdrZ5jW/FUleMzak99
	 FHZnBzERsv/I+vVH2hKNVA1auY+qAUBRNBw2fSoGJ51m4XfFvHdCclDoCqLNMXonP/
	 G68j8V90UCzcw==
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3a043390078so360145ab.2
        for <linux-raid@vger.kernel.org>; Wed, 04 Sep 2024 14:51:54 -0700 (PDT)
X-Gm-Message-State: AOJu0Yytj/GXJ7BsP7tFWUnkbaZ2CigvMV+qSW7n+PK0Iy35ov9WbkH8
	vfVeAxIiL/67cVrSEqOcYdMMwtzu2MNwF4YtHWzPa2F1SqHDRfHLlYJgyxZrrPlsATMq1VvHMUl
	AyTuyhsYxljdplFcWe1WkXmqQpRs=
X-Google-Smtp-Source: AGHT+IEmbeDxHhHtzY6ryOJ5zcPLdD+bBjEJ5wSsbmH4SleJEvkWcfPIlM7ZPO9R3Xstee83WD7oESMuZx1Xt9roWSQ=
X-Received: by 2002:a05:6e02:1d8a:b0:3a0:468c:8e2c with SMTP id
 e9e14a558f8ab-3a0468c900emr10669005ab.24.1725486714291; Wed, 04 Sep 2024
 14:51:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240902083816.26099-1-kinga.stefaniuk@intel.com> <20240902083816.26099-2-kinga.stefaniuk@intel.com>
In-Reply-To: <20240902083816.26099-2-kinga.stefaniuk@intel.com>
From: Song Liu <song@kernel.org>
Date: Wed, 4 Sep 2024 14:51:43 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4WTvtQrjusPfGy+C03iXigOdEANQezxqC1XxQ=h5KzBg@mail.gmail.com>
Message-ID: <CAPhsuW4WTvtQrjusPfGy+C03iXigOdEANQezxqC1XxQ=h5KzBg@mail.gmail.com>
Subject: Re: [PATCH md-6.12 v14 1/1] md: generate CHANGE uevents for md device
To: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
Cc: linux-raid@vger.kernel.org, yukuai3@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 2, 2024 at 1:38=E2=80=AFAM Kinga Stefaniuk
<kinga.stefaniuk@intel.com> wrote:
>
> In mdadm commit 49b69533e8 ("mdmonitor: check if udev has finished
> events processing") mdmonitor has been learnt to wait for udev to finish
> processing, and later in commit 9935cf0f64f3 ("Mdmonitor: Improve udev
> event handling") pooling for MD events on /proc/mdstat file has been
> deprecated because relying on udev events is more reliable and less bug
> prone (we are not competing with udev).
>
> After those changes we are still observing missing mdmonitor events in
> some scenarios, especially SpareEvent is likely to be missed. With this
> patch MD will be able to generate more change uevents and wakeup
> mdmonitor more frequently to give it possibility to notice events.
> MD has md_new_events() functionality to trigger events and with this
> patch this function is extended to generate udev CHANGE uevents. It
> cannot be done directly because this function is called on interrupts
> context, so appropriate workqueue is created. Uevents are less time
> critical, it is safe to use workqueue. It is limited to CHANGE event as
> there is no need to generate other uevents for now.
> With this change, mdmonitor events are less likely to be missed. Our
> internal tests suite confirms that, mdmonitor reliability is (again)
> improved.
> Start using irq methods on all_mddevs_lock, because it can be reached
> by interrupt context.
>
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> Signed-off-by: Kinga Stefaniuk <kinga.stefaniuk@intel.com>

I am seeing new failures from mdadm tests, for example, test 01replace.
Please run these tests and fix the issues.

Thanks,
Song
