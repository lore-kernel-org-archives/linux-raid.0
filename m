Received: from sg-1-14.ptr.blmpb.com (sg-1-14.ptr.blmpb.com [118.26.132.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FEC354AF9
	for <linux-raid@vger.kernel.org>; Mon, 19 Jan 2026 09:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768814125; cv=none; b=kMmTIQji6lHCLr18hILkglSO2pki9moI3iZwTUPlATT1/9SWPZzxLgDgR14+G9OyuXKNFgf4rZZcBje7GH1xMR0V9JYQohxSRg0HasKohmPjZ9Kln/xp6AoI8U40xgwXb2JI+UFD4oig390iC0jXlPO8hrAYB6v4Cn0aM77O4Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768814125; c=relaxed/simple;
	bh=/jR/DDg28Bq82bLYxRFOfd5KwM44alu+otgvq31+wTU=;
	h=To:Subject:Content-Type:From:Date:Message-Id:Cc:Mime-Version:
	 In-Reply-To:References; b=n+9kE0nW5/555hrR/PbYOqx13J6bmbB6nELb7Wg0AbaRjEUEw9ODRDeEFcpa1AJcRWdo+6/flwt5+coC+fiuZuZlmkqTRggCGbC7JPJSD9nXCohhsQNl0EiZzdPLO0aZP7Eqqcy73J+43YffGqq2RKT81yhbiZcuCEPRweUjKE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=oqbj4D36; arc=none smtp.client-ip=118.26.132.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="oqbj4D36"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1768814110;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=nve/lEPQ8FIm2ARwIn1X0PS7HLjoF415xN0V/N/r68Q=;
 b=oqbj4D3639q6z26X4Ju504mgFGR6l0FaZDBukyUTe2xoctauWHd6twFBlLty4GdLcljfCB
 GViTEupAgRHRGewCvTNHXWhJ+SMREdBmgBtbYi8lO4bsopbKgL+tRQ+dFLwK/8ytj4LGmc
 y12C/V1RE7pePg8+Ds6pugQcOq6+Tols4wRU+nh4fPwlZ+VME8sXCrnoXGk+bvxFRsAJPw
 wG0dzqhWmwE5el5SQ9Rft+vKyJtsBefo9iI+p466YzcprH+5Sq3E4wZBLIpwBM3uU/khaQ
 DyLg72OvM02ii71n+L8xw3SJXY3U1J/9abIVEOqYevwL1ulqb3J0VfYAjUgKFw==
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH v5 07/12] md: support to align bio to limits
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.185]) by smtp.feishu.cn with ESMTPS; Mon, 19 Jan 2026 17:15:07 +0800
X-Lms-Return-Path: <lba+2696df61c+56400c+vger.kernel.org+yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Mon, 19 Jan 2026 17:15:06 +0800
Message-Id: <3a7da5e7-9a47-4f43-8931-ffb1d2844751@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Cc: <linux-raid@vger.kernel.org>, <linan122@huawei.com>, <xni@redhat.com>, 
	<dan.carpenter@linaro.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <aW3q1SnU4gN9Ahba@infradead.org>
References: <20260114171241.3043364-1-yukuai@fnnas.com> <20260114171241.3043364-8-yukuai@fnnas.com> <aWpUYD1D1n-HJR9u@infradead.org> <df394803-b5fe-484f-a12d-dd10645d7a04@fnnas.com> <aW3Tc66fqSwv319o@infradead.org> <f7ba27c9-fc7b-44d5-9ddd-2bfb370e29d3@fnnas.com> <aW3cxxnbRmon9aYJ@infradead.org> <8b44bd64-efc8-428a-ad2f-9a9fcda786a1@fnnas.com> <aW3q1SnU4gN9Ahba@infradead.org>
Content-Language: en-US

Hi,

=E5=9C=A8 2026/1/19 16:27, Christoph Hellwig =E5=86=99=E9=81=93:
> On Mon, Jan 19, 2026 at 03:43:34PM +0800, Yu Kuai wrote:
>>>> 64k boundary is still necessary for small IO.
>>> What do you mean with "necessary for small IO"?
>> io_min and io_opt is quite similar in mdraid, IO aligned with io_opt
>> can get the best bandwidth, and IO aligned with io_min can get the
>> best iops. Currently chunk_sectors is the same as io_min, and
>> bio_split_rw() will try to align IO to io_min. I don't think we want
>> to remove this behavior.
> I'm still confused.  Let's go back to your example:
>
> 32 disks raid5 array with chunksize=3D64k.
>
> Let's look at writes first:
>
> Each I/O that is full aligned to 31 * 64k can be handled without a
> read-modify-write cycle, so splitting I/O at that boundary makes perfect
> sense.  Below that there really should not me much difference, i.e.
> splitting anything at the 64k boundary is not useful.  So you want the
> chunk_sectors to apply at the 31 * 64k boundary, and the io_opt as well.
> And probably io_min too. (all just looking at writes).

This sounds reasonable, however, I'm not 100% sure split at 64k boundary
is not useful, I must run some tests to confirm. This behavior exist for
quite a long time.

>
> For non-degradead reads, not much should matter.   All reads should be
> reasonably efficient, splitting 64k boundaries is going to make the
> implementation trivial, but will make your rely heavily on plugging
> below, and also means you use quite a lot of lower bios.

Correct, BTW, even if we don't split at 64k boundary in bio_split_rw(), rai=
d5
will stil try to split at 64k boundary in chunk_aligned_read(), and this do
rely hevily on plugging below.

BTW, current plug limit really is too low for huge array, like 32+ member d=
isks,
only 32 requests and at most 128k per request. However, I still can't find =
better
solution other than simply increase the limits.

>
> For degraded reads, each I/O will always read 31 * 64k.  Splitting at
> 31 * 64k makes the implementation much easier.

I don't feel this is correct, each I/O will be handled by stripes, so a
4k read to the removed disk will only need to read 4k from other disks.
Anyway, this does not matter.

>
> I guess you want different boundaries for reads and writes?

Yes, this is still a potential demand, I'll test and take a detailed look
at other personalities.

>
> Note that io_opt and io_min really just are values for the caller and
> not affect splitting decisions themselves.  Of course the underlying
> factors should be related.

Thanks for the explanation, I'll feedback soon after testing.

--=20
Thansk,
Kuai
