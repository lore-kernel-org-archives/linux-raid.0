Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA9C42CB08
	for <linux-raid@vger.kernel.org>; Mon, 21 Sep 2026 07:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789976291; cv=none; b=Mbg/UjVPu+vfwvg1xXPKM1NVsn5eu14wsLI7OdWsIiC5uN5NkFWOgZA6Ycdzpe+7AGwbsIZs3WkCVwiJGVafWkKXtcJf//mUZxkiWa7/tY7V7owZZNMoKhJVSAZk73NH9Qjc9N0IBgxG8EcVnlSzdex/FSxvuf2Wn35SwgquG+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789976291; c=relaxed/simple;
	bh=tTVw7moGmIC5PyyaCXTOsgusQyZBF/dcfqTNZiwL09E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MQFnwLYpRnAA1hyyQKT8OoWBgBL6LNkgjeyNKU8QfbXQKGqe/9L6Mn5AD4c3IBh58BmyCktIJdcZPA5tZbr7A+hWAMOyNsVP14aUhIq1CI8UPkBm115b3euCzJL5F+Lmc7oU0tZsOttZrOQ27M2weKKbZ3cXOBlw4PyWQp7ndjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VgVHaV8Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VgVHaV8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4C01F000FF;
	Mon, 21 Sep 2026 07:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789976289;
	bh=InGINt/3C+24AGrr3ZUg19vuBCNrdC9SJMAWWcNPGuY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VgVHaV8Y+tc5jH32FLH9h3TopIJjJGSLHHSnoP47DDmcvz+3G0YPLhlR0gVDCLCLW
	 LVGrctkmk2ZEYKQ1qee88tr99xeQTZv12xaXYj0OVuBXy6bp+VHrw3XcuD7nlAPlmf
	 Oy8t6wISFUB+H35WzPdAT2e3wasW5P0wNs5xoPiItUd7FYzH50NP9Eo7Z+fNF3biz4
	 i9+3XIgJq/rxgedbNdC/23LE5oJonQ8FkOSQsc4FnMlUQvSJEowjsqr+LmC++NDdPs
	 ETA7P34xtbW8R3I4FnvpeccaVDSHY1vRj5tHHWtGiTSRIpC6+2afMPyLBLTXsNY5/k
	 sKio7bvevlsQw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] md/raid10: Don't free conf on raid10_run failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhihao Cheng" <chengzhihao1@huawei.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260921071537.2902362-4-chengzhihao1@huawei.com>
References: <20260921071537.2902362-1-chengzhihao1@huawei.com>
 <20260921071537.2902362-4-chengzhihao1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 21 Sep 2026 07:38:08 +0000
Message-Id: <20260921073808.DE4C01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] md/raid10: NULL ptr deref and I/O hang on raid10_run failure
--

commit 1bebf502d0ba7be4661dc272d82091e48c0924ff
Author: Zhihao Cheng <chengzhihao1@huawei.com>

md/raid10: Don't free conf on raid10_run failure

This patch prevents freeing the configuration on raid10_run() failure to
avoid a null pointer dereference later during shutdown. It modifies the
failure path to skip raid10_free_conf() and clearing mddev->private, leaving
the conf structure allocated.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 1093c798d9dde..9e4d4202f35cf 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
[ ... ]
> @@ -4106,10 +4106,8 @@ static int raid10_run(struct mddev *mddev)
> =20
>  	return 0;
> =20
> -out_free_conf:
> +out_unregister_thread:
>  	md_unregister_thread(mddev, &mddev->thread);
> -	raid10_free_conf(conf);
> -	mddev->private =3D NULL;

[Severity: High]
Does leaving mddev->private allocated here expose the array to panics and
I/O hangs when raid10_run() fails?

Since the sysfs interface ignores personality run() failures:

drivers/md/md.c:level_store() {
    ...
    pers->run(mddev);
    ...
}

The array remains pseudo-active. If subsequent I/O requests enter
raid10_make_request(), they can hang indefinitely because they attempt
to wake a NULL thread:

drivers/md/raid10.c:raid10_make_request() {
    ...
    bio_list_add(&conf->pending_bio_list, mbio);
    spin_unlock_irqrestore(&conf->device_lock, flags);
    md_wakeup_thread(mddev->thread);
    ...
}

Furthermore, if a concurrent teardown or flush raises conf->barrier,
wait_barrier() will call stop_waiting_barrier(), which unconditionally
dereferences the NULL thread pointer, causing a panic:

drivers/md/raid10.c:stop_waiting_barrier() {
    ...
    if (thread->tsk =3D=3D current) {
    ...
}

>  out:
>  	return ret;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260921071537.2902=
362-1-chengzhihao1@huawei.com?part=3D3
