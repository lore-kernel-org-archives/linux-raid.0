Received: from va-2-55.ptr.blmpb.com (va-2-55.ptr.blmpb.com [209.127.231.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7AD32FA14
	for <linux-raid@vger.kernel.org>; Sat, 20 Jun 2026 18:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781979921; cv=none; b=KR9ewIX9LR6GrWALJKY3OUg6mbESdIW+RJYkzmqhJWcyGVRULsEvIPoLhliZSe1l5AjcGcyCLnRDUEwnZltODp6dYvPc5T7Md8j+C3/OK1WlEIRLOBML5LcyCSrHUlHt4eILU82MTjsLDqWtd3x7VjFv0UN5uv3q88Ebuve5nGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781979921; c=relaxed/simple;
	bh=m4+vnQCzD4W1MtiBYdXcSLms4gBLg2bJhdg/2zEaZlA=;
	h=Content-Type:To:References:Message-Id:From:Subject:Mime-Version:
	 Cc:Date:In-Reply-To; b=WVfyglFtL8N1k+v21WxQiCyACcmft9BrrE+f+ywA9/hmMyrmFBvDuKi9T6I1+FUxlhXrt68MXplSt6fXeC6U+FsVPC0ZmF7x6VrBx6jO8e3nGBdxIUQRGphE+dvmqAydcQ0njx38aqizH5mNsoB7QgXisV3gMMsKkBgwQbzf15o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=mswArY0c; arc=none smtp.client-ip=209.127.231.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="mswArY0c"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1781979905;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ys4LFglm/KrCkt8cR7S2UM10kO0Eh2S6Upx2AWFDtAQ=;
 b=mswArY0cb94tcnXk6C7PYQ9shZF0k+1JsxGfeCOAJkEOruozknp+LIqEa1fvdkbqJPJiRt
 ldz9URzcj+vOHs0F7CA0mOgLIYN4SdNlSR4DfiZy3XW7+2veDjR8k4t6OEq/B1ZZMxP+jL
 Gafaa+v9xC7WXUnAFsAmy78YlwVaIWSpYTwdH2IdEQBEM36GtNnx3pLlo1w3kL2bWj3Q0i
 Ccj9sNAVPFA7TsrrJtnVzyPrvH92xCx9lI0e3E+SO/krhLGvTaMiWiA490tIli2VwC9v/t
 ccvnTUHOhiAHG7lALXx8hg/F3qheHiXz5Rusx7nwzvbC9XUBz92vJRd1abcn5g==
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
To: <sashiko-reviews@lists.linux.dev>, 
	"Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>
Content-Transfer-Encoding: quoted-printable
References: <20260613182810.1317258-3-abd.masalkhi@gmail.com> <20260613184042.BCEC01F000E9@smtp.kernel.org>
Message-Id: <ecaef394-23a2-43ec-a85b-2e25786914aa@fygo.io>
X-Lms-Return-Path: <lba+26a36db00+c0b92a+vger.kernel.org+yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Sat, 20 Jun 2026 18:25:03 +0000
User-Agent: Mozilla Thunderbird
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v2 2/4] md/raid10: fix writes_pending leak on write request failures
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Cc: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>
Date: Sun, 21 Jun 2026 02:25:00 +0800
In-Reply-To: <20260613184042.BCEC01F000E9@smtp.kernel.org>

Hi,

=E5=9C=A8 2026/6/14 2:40, sashiko-bot@kernel.org =E5=86=99=E9=81=93:
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] The `r10_bio` structure allocated from the mempool is leaked whe=
n `raid10_write_request()` bails out early due to `REQ_NOWAIT`.
> --
This looks like a real issue, do you plan to fix this as well?
>
> commit 3940ccdb4c7c7e19c20f9b5e2e1d12545c2558b5
> Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>
> md/raid10: fix writes_pending leak on write request failures
>
> raid10_make_request() acquires a writes_pending reference with
> md_write_start() before dispatching write requests. Several failure
> paths in raid10_write_request() complete the bio and return without
> reaching the normal write completion path, causing the corresponding
> md_write_end() to be skipped.
>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index cee5a253a281d..c123a8c76ddcd 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
> [ ... ]
>> @@ -1365,7 +1365,7 @@ static void raid10_write_request(struct mddev *mdd=
ev, struct bio *bio,
>>   		/* Bail out if REQ_NOWAIT is set for the bio */
>>   		if (bio->bi_opf & REQ_NOWAIT) {
>>   			bio_wouldblock_error(bio);
>> -			return;
>> +			return false;
> [Severity: High]
> This isn't a bug introduced by this patch, but does this early return lea=
k
> the r10_bio structure?
>
> __make_request() allocates r10_bio using:
>      r10_bio =3D mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
>
> It then passes it to raid10_write_request(). When the bio has REQ_NOWAIT =
set
> during a clustered area resync, we complete the bio with an error and ret=
urn
> false without freeing the r10_bio. Could repeatedly triggering this exhau=
st
> the r10bio_pool, causing deadlocks on subsequent operations?
>
> Note that the regular_request_wait() error path right below correctly cal=
ls
> free_r10bio(r10_bio) before returning.
>
>>   		}
>>   		for (;;) {
> [ ... ]
>> @@ -1398,7 +1398,7 @@ static void raid10_write_request(struct mddev *mdd=
ev, struct bio *bio,
>>   		if (bio->bi_opf & REQ_NOWAIT) {
>>   			allow_barrier(conf);
>>   			bio_wouldblock_error(bio);
>> -			return;
>> +			return false;
> [Severity: High]
> This is a pre-existing issue, but does this path also leak the r10_bio
> mempool allocation when waiting for a reshape metadata update?
>
> Similar to the clustered area resync case above, the r10_bio allocated in
> __make_request() does not appear to be freed before returning here.
>
>>   		}
>>   		mddev_add_trace_msg(conf->mddev,

--=20
Thanks,
Kuai
