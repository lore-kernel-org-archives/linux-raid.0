Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.60
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792823590;
	b=4ENcenCPEpJkJ91KV3LmHt04Ao0NtgMOJ54eMB+e/HwsTZdAh5I490Saai7IRMUsWiso
	 IM5r/CIBlWmkQgxdjdxfAGLt7JIrUKHuRXJnBQWoYdGmGk3jRvzHH5F3Ur1K5MlBdBn7j
	 27K9RwpHfSs2lYMxU74tLi8FfCUCgomLur0R7S3GX/3LfYaZRmCF6RYbS6WE2HQYZFsMk
	 96RRo6eADFkJHk99JxYqo9KGVk6HQTeGzC/1g/v12RWndAI/OlwQyn100aT8PXVTmpHno
	 Bj/ILFT9fPDHAHbdi6gj61J/06wql/shn1yurEOI0nFiNpVgKUYF/EgjXO86iq7kPGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792823590;
	h=DMARC-Filter:DKIM-Signature:To:Cc:Received:X-Original-From:
	 Content-Type:User-Agent:X-Lms-Return-Path:Subject:Date:Mime-Version:
	 From:In-Reply-To:Reply-To:Message-Id:References:
	 Content-Transfer-Encoding;
	bh=NV8H7vMnU+tiimOuO5f71C2SIErBYloa4sE3LXq63Ck=;
	b=08SSD/Ws/QQmiRlb9q1j35QPPzUMiRXTnllLTU1tuq2Ni+G2VlvPzgeRfttvfaWFuNH1
	 SL2zydyeqoepJNpIXWXK3vXCmWDSEK43UzRmHmTo1LblMp3W7jqsDS2dSUW9btcRzJNTj
	 el2TvHkYkmUyp2nyi0/C7lH1RAFzc8c1ege+tEQ9Rxu1usjFdBSSJHcrQrS4F8TpJUl0W
	 d3/Q1iq2GXvVosgRFaOOVvK+10ZElMN1q+TKNk/mJzJkC2Oa4fZyrxEpfhmGSj7OZHP9J
	 DhSgO9NPwPzxuOn4XrHbn+RfcHh6dAptY3m2GpESL+G5WfJw9Pa/ZD5U9HXbniiMvnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=a+VsqC0J;
	arc=none smtp.remote-ip=209.127.231.60
Received: from va-2-60.ptr.blmpb.com (va-2-60.ptr.blmpb.com [209.127.231.60])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454C2606A31B
	for <linux-raid@vger.kernel.org>; Sat, 24 Oct 2026 06:33:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 454C2606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=a+VsqC0J
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1792823581;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=NV8H7vMnU+tiimOuO5f71C2SIErBYloa4sE3LXq63Ck=;
 b=a+VsqC0Jt86t/2cdz1HhoFdDj4Y20xFhQCz6iyOmoVzvKwZZGzoMnKI3/ZWIvAElwVumB6
 UcLAZKBQWCRMJGrAuc9lvvBley4Ir7FjXAI5CDnf2Q9e66J3c+Dz80NMEG6r3daAPUzkzK
 qM5LrBz8Jp07PUsLsXqHNYl33hb1TszCUWbFOvo3wDzwkBCkE/ioNM6/MCVbYOFsjCGmDZ
 tLdTAVh5xQNGPWauKX3XKMzcjsfKEw/WmRj8yewrdS9M1yU7PJzqppglTH1JpiY1sxqgM0
 Wns19piUjsCEvXlTE9j4u9UUmG3kln/7jRPvdI1m/u+JsDQtRYp2v3tSwLVbNQ==
To: "Doug V Johnson" <me@dougvj.me>, <linux-raid@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Cc: <song@kernel.org>, <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Received: from [192.168.1.104] ([39.182.0.21]) by smtp.larksuite.com with ESMTPS; Sat, 24 Oct 2026 06:32:59 +0000
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26adc511c+480ceb+vger.kernel.org+yukuai@fygo.io>
Subject: Re: [PATCH v4 1/3] md/raid5: freeze and interrupt reshape when handling failed reshape
Date: Sat, 24 Oct 2026 14:32:56 +0800
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
From: "yu kuai" <yukuai@fygo.io>
In-Reply-To: <010101a142f57e37-cd14b78d-54cd-447b-9888-87f166a937ab-000000@us-west-2.amazonses.com>
Reply-To: yukuai@fygo.io
Message-Id: <67302483-c3c3-47e1-9576-4d0a8e44c170@fygo.io>
References: <20261016042537.277516-1-me@dougvj.me> <010101a142f57e37-cd14b78d-54cd-447b-9888-87f166a937ab-000000@us-west-2.amazonses.com>
Content-Transfer-Encoding: quoted-printable

Hi,

=E5=9C=A8 2026/10/16 12:25, Doug V Johnson =E5=86=99=E9=81=93:
> Set the reshape freeze flag to prevent automatic reshape resumption
> and interrupt the current reshape with md_sync_error() so that a
> reshape always stops no matter how the failed reshape is triggered.
>
> Previously, if there were no faulty or out of sync devices but there
> was an unrecoverable read, the reshape continued and was not cancelled
> after handle_failed_reshape(). This caused some data corruption as
> block writes were cancelled but the reshape nonetheless continued.
>
> Prior to Chen's fix, the kernel would deadlock with a failed stripe
> read.  That case also caused some data corruption, so Chen's patch
> did not introduce corruption in this case.
>
> An example test case showing how this happened before this fix is
> demonstrated by the following:
>
> Simplified example (schematic logical sector numbers):
>
>    1. Before reshape, destination D contains data for logical 20-27.
>       The new geometry will use D for logical 100-107.
>
>    2. Inject bad-block metadata on enough members that the old source
>       stripe cannot be reconstructed. Logical sector 100 now returns
>       a read error; sectors 101-107 are still readable.
>
>    3. Reshape tries to read the source block for logical 100-107.
>       The bad-block records prevent a successful read/reconstruction.
>       Failure cleanup cancels the destination write:
>
>         Source: logical 100-107 --X--> destination D
>                                       still contains data for 20-27
>
>    4. Without interruption, reshape continues and completes.
>       The new mapping now sends reads of logical 100-107 to D.
>
>    5. Reading logical 100-107 succeeds, but returns data for 20-27.
>       Previously readable sectors 101-107 now return wrong data.
>
> Code that injects bad blocks to demonstrate this problem before and
> after Chen's fix as well as after this patch can be found here:
>
> Link: https://github.com/dougvj/md-raid-reshape-badblock-corruption-test
>
> Fixes: 788e4139463f ("md/raid5: fix reshape deadlock while failed devices=
 more than max degraded")
> Link: https://patch.msgid.link/20260624075824.2601110-1-chencheng@fnnas.c=
om
> Assisted-by: LLM
> Signed-off-by: Doug V Johnson <me@dougvj.me>
> ---
>   drivers/md/raid5.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b91545ce090d..86ea65559576 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3773,6 +3773,10 @@ static void handle_failed_reshape(struct r5conf *c=
onf, struct stripe_head *sh,
>   	bool was_expanding =3D test_and_clear_bit(STRIPE_EXPANDING, &sh->state=
);
>   	bool was_ready =3D test_and_clear_bit(STRIPE_EXPAND_READY, &sh->state)=
;
>  =20
> +	/* Freeze reshaping to prevent data loss */
> +	set_bit(MD_RECOVERY_FROZEN, &conf->mddev->recovery);
> +	md_sync_error(conf->mddev);

On the one hand, MD_RECOVERY_FROZEN can be cleared in many ways, like reass=
emble the array.
On the other hand, reshape_offset is still set after md_sync_error(), the a=
rray will still be
considered as in the middle of reshape, we can't just leave the array like =
this. For example,
read/write to the reshape window will be blocked forever, check LOC_INSIDE_=
RESHAPE for details.

Unfortunately, I don't have a clean solution for this situation for now. It=
's true we can't
continue to reshape as data can be lost, and it seems complicated to revert=
 the reshape.

> +
>   	if (was_expanding || was_ready) {
>   		atomic_dec(&conf->reshape_stripes);
>   		wake_up(&conf->wait_for_reshape);

--=20
Thanks,
Kuai
