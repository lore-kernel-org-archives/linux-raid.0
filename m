Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52894AF168
	for <linux-raid@vger.kernel.org>; Mon, 31 Aug 2026 17:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788197334; cv=none; b=VrbLi2bI+6M6SmvY90Nd094e1M9j/fu8kp8GV09WUuV0MNyHB6DAvZIpgdZtmuXagpeRy6rduOL+6P2eBObCnHJVVYGuwM60zpCxFTtaqNIhM5fxHVdTdwCz5Tulxu6A7tA6p85x6nT2UmSLuklPd1QR1620i+VUPZLweROxEr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788197334; c=relaxed/simple;
	bh=GOxF4+FqMhr/lhDE020fcDMULlmXpJl04VhsmZiQUpk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aQdkbeGoV3WXZ4Zo8avBNnLChgZxtlktpKq0A0fn/IgDd/4TTDVozVb5nE7rBL8xRGfvVLHqGWOrefq7tWfONQT8IBXu+mo52Nj/U5YPcDCM8pufIIQFLYisfAeHRfjCN6xZnyxmvbKfjVE390OroT81g2hou5nHaeWNtz2O3F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OLJQC5lO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OLJQC5lO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362E51F000E9;
	Mon, 31 Aug 2026 17:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788197333;
	bh=jgYLKb19s2S1773nWsUP+QIVH54amtIxh0QTttT/Z5s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OLJQC5lOPeLOXkT9DenncjWSj+h/4sXLsTgeEpZiSTNsC0qI1SvrsnS17vzKt7S7v
	 vVIYc+0aseXdKUmVIUnxSj2vH0vlPQEuBzxWe+TKYyT55xHclAJVTzpzlzJHEUlu2w
	 o0URowDDXbBZoyHdMiNCbf7dvtwBi2LUYHiPT2gZxXyXTv0U9MBAZWVHxCro++b/he
	 s90TUSLOHopxGfKeeuV8gbTBKdlLFVUkBHbM8gr3zdNntqpa/tm7Dw3nnwquJoWlYm
	 fOOeLPw4L5cPk7kQREQIUnzfN2R+Z/NK+J6oWBFvVIPbreeAFYt9dRvhkLRGATteKZ
	 bDAFC4OX4upoQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-5.10] md/raid5: let stripe batch bm_seq
 comparison wrap-safe
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260831133314.4125787-624-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
 <20260831133314.4125787-624-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 17:28:52 +0000
Message-Id: <20260831172853.362E51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Lockless Read-Modify-Write (RMW) race on batch_head->bm_seq co=
uld result in a stale bitmap sequence number.
--

commit ec929cd222791eadb056199cc433123ca41575a6
Author: Chen Cheng <chencheng@fnnas.com>

md/raid5: let stripe batch bm_seq comparison wrap-safe

This commit fixes a sequence number comparison bug in
stripe_add_to_batch_list() by changing a direct greater-than comparison to a
wrap-safe subtraction to ensure proper bitmap batch sequencing.

Link: https://patch.msgid.link/20260618025735.915113-1-chencheng@fnnas.com

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -992,7 +992,7 @@ static void stripe_add_to_batch_list(struct r5conf *c=
onf,
>  	if (test_and_clear_bit(STRIPE_BIT_DELAY, &sh->state)) {
>  		int seq =3D sh->bm_seq;
>  		if (test_bit(STRIPE_BIT_DELAY, &sh->batch_head->state) &&
> -		    sh->batch_head->bm_seq > seq)
> +		    sh->batch_head->bm_seq - seq > 0)
>  			seq =3D sh->batch_head->bm_seq;
>  		set_bit(STRIPE_BIT_DELAY, &sh->batch_head->state);
>  		sh->batch_head->bm_seq =3D seq;

[Severity: Critical]
This is a pre-existing issue, but could this lockless read-modify-write of
batch_head->bm_seq result in a stale bitmap sequence number?

During concurrent additions to a RAID5 stripe batch, threads handling disjo=
int
subordinate stripes (for example, sh1 and sh3) hold different stripe locks.
Because they do not contend for the same stripe locks, they can execute this
block concurrently on the same batch_head.

Could this concurrent access cause one thread to overwrite another thread's
newer bm_seq with an older one?

If a data race results in the batch head storing an older sequence number,
could the batch be written to disk before all required bitmap flushes have
completed? If a power failure occurs under these conditions, it appears the
dirty bits for some stripes in the batch might not be recorded in the bitma=
p,
which might lead to data corruption during array recovery.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831133314.4125=
787-624-sashal@kernel.org?part=3D1
