Received: from va-2-49.ptr.blmpb.com (va-2-49.ptr.blmpb.com [209.127.231.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D281723EAA0
	for <linux-raid@vger.kernel.org>; Mon, 20 Jul 2026 02:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784513840; cv=none; b=qyYGCeDhbBXJ6+75UKDnD5Mt/Rj8j9oPTrAMZg3kPtvTTq8cgl1/8c2FSpEbcbzuzWO84m7bMT1qRKpq2KE+uL6KaiJ0xjOt54TDDC4YKcnN9hPBp2l+KaMpDD/+tlYgj8uqnvMKFfAovv9P/Ow+I4bKlbEcD+OUDIFEvyATggA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784513840; c=relaxed/simple;
	bh=wq5onmj3z56JRKLjT1Z3vE4bsCyYBS+8qiyyEdN+X48=;
	h=To:Cc:In-Reply-To:References:Subject:Date:Content-Type:From:
	 Message-Id:Mime-Version; b=eGoKe7RjkC7tVkwW3CZp3G9d6mgUQk9PbaikJebd40wraJJfLmoPb/9bxQxfKqLij0BeuI3ObX2+UDjcR7BPi1rBOxeYuBsHzYAFy1trnl8z2hJU/2iuKwbqrrkPquMCgdOsrCNM6GUeuyjjYER6G9TgeeWQinYAdd+c5BsW5sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=HEK5Utu6; arc=none smtp.client-ip=209.127.231.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="HEK5Utu6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784513829;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=AVGndNr7JKcSJm9Ofxs6ACxgZtpM1U8v/ptHvvgCuNE=;
 b=HEK5Utu6AsVK0px//Hh/gBDzofnG269y6U9CSRYRJyWAH1Yo7fP54aJGhMUQY7jT6vYEZp
 5bA42vqVL+W2i4tpMI11jXi2xZrb/eo+2PUoeHmsFxGgy7o2JSp4qkAuQPXd9ZZMv+3WCB
 p4BAlr4+Hfn1nKsfxXlgQdt5iwv1I2FBGxR3l0ZQ7r7cPvreqqNEOSRWBr/RIY8Xvu+QxN
 qFZjQq9vLhTxhaYz862fR1m10CfWXG1ZCW1xqbuOiJTtIsuxi6GokaEDVueOCtQ0rKkU2I
 MLqjX1I+nlM6qyFdbVVamXw8fF8o5OSY4JBJf013Ax3e5ipazxF9R4ZKcGujnw==
To: "Mykola Marzhan" <mykola@meshstor.io>, "Song Liu" <song@kernel.org>, 
	"Yu Kuai" <yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"Hannes Reinecke" <hare@suse.de>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
X-Lms-Return-Path: <lba+26a5d8524+714532+vger.kernel.org+yukuai@fygo.io>
In-Reply-To: <20260719144227.940444-2-mykola@meshstor.io>
References: <20260719144227.940444-1-mykola@meshstor.io> <20260719144227.940444-2-mykola@meshstor.io>
Subject: Re: [PATCH 1/3] md/raid10: restore still_degraded detection in recovery
Date: Mon, 20 Jul 2026 10:17:04 +0800
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.157]) by smtp.larksuite.com with ESMTPS; Mon, 20 Jul 2026 02:17:07 +0000
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <0f8c2dc8-8c3b-44f0-b81b-84e0adb9ab1e@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Reply-To: yukuai@fygo.io
User-Agent: Mozilla Thunderbird
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable

=E5=9C=A8 2026/7/19 22:42, Mykola Marzhan =E5=86=99=E9=81=93:

> raid10_sync_request()'s recovery arm passes still_degraded -- "will
> the array still be degraded after this recovery completes?" -- to
> md_bitmap_start_sync(), whose !degraded branch consumes the chunk's
> NEEDED marker, the write-intent record.  That is only safe when the
> recovery restores full redundancy; otherwise the record still
> describes writes an absent member missed.
>
> Commit fe6a19d40ceb ("md/md-bitmap: merge md_bitmap_start_sync()
> into bitmap_operations") turned the detection loop's only assignment
> from "still_degraded =3D 1" into "still_degraded =3D false" in its
> int-to-bool styling pass, so the flag has been constant false ever
> since.  raid1 and raid5 were converted to "=3D true"; only raid10 was
> inverted.
>
> The result is silent data loss on a classic-bitmap raid10 that stays
> degraded across a recovery.  With mirror pairs {A,B} and {C,D}: lose
> D, keep writing, lose B, add a spare.  The rebuild into B's slot
> strips NEEDED from every chunk -- including chunks whose only
> unsatisfied intent belonged to D -- so a later --re-add of D sees an
> empty intent record, completes instantly, and serves stale data.
>
> Restore the pre-conversion assignment.  Only the classic-bitmap
> recovery arm is affected: llbitmap ignores the degraded parameter,
> and the resync arm passes mddev->degraded directly.
>
> Fixes: fe6a19d40ceb ("md/md-bitmap: merge md_bitmap_start_sync() into bit=
map_operations")
> Cc:stable@vger.kernel.org # v6.12+
> Assisted-by: Claude-Code:claude-opus-4-8
> Signed-off-by: Mykola Marzhan<mykola@meshstor.io>
> ---
>   drivers/md/raid10.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
