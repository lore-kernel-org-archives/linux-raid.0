Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A476522CBD9
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785703605; cv=none; b=hqmg4nZVDidufFHPT6wRjMUkAhn8T1tQy9MQpE1Zt2OODEf/lcLOcuzXAxCgfWsKO2xj9wwmTzd+ehmgEuXZHJquAYCCVQuJ+n+HWEMiVdJrxq3qxTHbePvndHJ5k9xRq9x3TXmRVN0ns8f2r2HInnzuQPMihBMEh3/Q2GhRGiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785703605; c=relaxed/simple;
	bh=3PvPE9ByeR40I35Fm9L411Exs+mgXvT8QAnbSqTrmcM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RfUp6I3IrYNUb6cPPBlMPpKk3PsIDGRVgK722XF4YidPlpdz4UqRMoJ3yL+lGrPgawyLtKO0KPbY+MMzebb/WiCCRSYI1lU+lgui/Ixf3pkEsIVP+xKCHEntt41v6rl7ZvVX0KG+D6LVNueDu4ftX6VuBpcNLz19XS84YZ2Oe5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VO3ZcS/K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VO3ZcS/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C4D1F000E9;
	Sun,  2 Aug 2026 20:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785703604;
	bh=oYy6SRJSsM1NseBL7vTfTAZgkyDEHPa6dBNHifZsn6A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VO3ZcS/K2e22HqSR4uso+u5c7aIcGu0Bw1Fg1lUizFhnk2xENBm8pRMaQ8onQqyLT
	 clYmxQG/JGF4U/7na4Q/x2ijp20iEaJds6oZk9iFe2tbS2+K8Zgc7Rlym8kWqPz5sG
	 wtSSxZE0uJdFvQH4E+/IOFkJkYVA1Aeq1hVXoT3Pu7gAbdWyWIYk3c8XKzAvmwSFiT
	 ia36nckWAIH9G73wAUfI5/As9XBEwqYx3t4fniuWRie7Q8Cw4/K+cpzaCTbanKQ6M0
	 7m+pRgSHRkFCjkPDwoyPKphxJmZ+y36Q8D7fDOJJh0MbDXOnXacQ6yaOGHNZ4BdGcx
	 ru/z6KSRpusLQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 25/29] md/raid10: split reshape bios before bitmap
 accounting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260802195038.164272-26-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-26-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:46:43 +0000
Message-Id: <20260802204644.32C4D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Double-splitting a bio using the same mempool-backed bioset causes=
 a deadlock under concurrent load.
--

--- Patch [25]: [PATCH v5 25/29] md/raid10: split reshape bios before bitma=
p accounting ---
commit 6f3a3e2c85f7d5d7d630d6c3cb813006807edbdc
Author: Yu Kuai <yukuai@fygo.io>

md/raid10: split reshape bios before bitmap accounting

Use the shared mddev_bio_split_at_reshape_offset() helper so RAID10
submits only one-side bios to llbitmap during reshape.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1873,6 +1874,15 @@ static bool raid10_make_request(struct mddev *mdde=
v, struct bio *bio)
>  		sectors =3D chunk_sects -
>  			(bio->bi_iter.bi_sector &
>  			 (chunk_sects - 1));
> +
> +	bio =3D mddev_bio_split_at_reshape_offset(mddev, bio, &sectors,
> +						&conf->bio_split);

[Severity: High]
Does this introduce a mempool deadlock if we need to split the bio again la=
ter?

If this initial split succeeds, the thread holds a bio from the conf->bio_s=
plit
mempool. Later, the thread proceeds to __make_request() and then to
raid10_write_request().

If the target disks have bad blocks, max_sectors is further reduced, causin=
g a
second split attempt from the exact same mempool:

raid10_write_request() {
    ...
    if (max_sectors < r10_bio->sectors) {
        ...
        bio =3D bio_submit_split_bioset(bio, r10_bio->sectors,
                                      &conf->bio_split);
    ...
}

Since the conf->bio_split bioset is initialized with BIO_POOL_SIZE (2), if =
two
concurrent I/O requests cross chunk boundaries and hit bad blocks
simultaneously, could both threads allocate one bio each, and then both
permanently block in mempool_alloc() waiting for a second bio?

> +	if (!bio) {
> +		if (rw =3D=3D WRITE)
> +			md_write_end(mddev);
> +		return true;
> +	}
> +
>  	if (!__make_request(mddev, bio, sectors))
>  		md_write_end(mddev);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D25
