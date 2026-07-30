Received: from va-2-44.ptr.blmpb.com (va-2-44.ptr.blmpb.com [209.127.231.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9692D97BB
	for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 20:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785443119; cv=none; b=FekEH55+drwzzhmqet8TnxUdwKxUjrNfOdcWnONgVYBdJoHBfh73s+vzhuZMolNYNSD6YZD4kZhYv3ebzndp0dg+jtVrYdX8I4X0YeTUFjTt3sOsfdV5jSoRXh39OwmWE5PZ+KAyfoY+kFU7VR0xLO23e0VpoWYuHoInnjrdiCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785443119; c=relaxed/simple;
	bh=N1Y18OzAxkT2wkEnJ/O4e2zWeDV9YfVLNuh+olA43zg=;
	h=To:Cc:From:Mime-Version:References:Content-Type:Subject:Date:
	 Message-Id:In-Reply-To; b=dqSQq/tGMEsfmkXOfRb9Zlw4u8Y3wYn88JTZvVBOm3eVyprZU0Pxaay/BLSuEYN5VOeCEGmDZ4kySIf/liYEF/b/usCZZPy4wow6QvYPcA9SpjN4AritLwznxc8GdCvZAJGMyHB8CxPT0ZxrjAGJkn/+0RKeG+nhJvPOTvnnavk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=Z4hgFHY1; arc=none smtp.client-ip=209.127.231.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="Z4hgFHY1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785443107;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=m5Y3tAqBqvJjobXkIkOVtn9SqurkJkf4wyfvAT1fr+E=;
 b=Z4hgFHY1DD7rV5YmWt+5/TVEjcnAQ1ZeWE4fip16F6FEgeWiGpzZJr+jIZHzk9BH5mXqe4
 0EZzY5dwoMXDfEKKQSdTeiU8YHWHJTYFMSOTu58k4UZ9TzQd+/CYk15NVz5Vm43FcLKV7k
 MMLbN2E8qX4YzVzzx7p2B02t0ZR9TXdMw0CUvdu+Dca7uqTu2RexWFwksWFWFN0XWQNDVi
 vdrOCabAEHuOuxVLzrUy4FM4DJNvBNS378Rl9RIjolqZHW+T9waMpVTY01B/IYjANVCSNH
 fgovR9rVC5B7gjjjAGCijPj99TyA5A66tSilesCVqNsmbpVHSbHiRI233txAXg==
To: "Hiroshi Nishida" <nishidafmly@gmail.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260710132346.7295-1-nishidafmly@gmail.com> <20260710132346.7295-2-nishidafmly@gmail.com>
Reply-To: yukuai@fygo.io
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Thu, 30 Jul 2026 20:25:05 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
X-Original-From: yu kuai <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] md/raid5: size the worker group array by nr_node_ids
Date: Fri, 31 Jul 2026 04:25:01 +0800
Message-Id: <10cc8ef5-cbef-455a-b027-7b8bccec49fe@fygo.io>
X-Lms-Return-Path: <lba+26a6bb322+712830+vger.kernel.org+yukuai@fygo.io>
In-Reply-To: <20260710132346.7295-2-nishidafmly@gmail.com>

=E5=9C=A8 2026/7/10 21:23, Hiroshi Nishida =E5=86=99=E9=81=93:

> alloc_thread_groups() sizes conf->worker_groups[] by num_possible_nodes()
> -- the number of possible NUMA nodes -- but raid5_wakeup_stripe_thread()
> indexes it by cpu_to_group(cpu), i.e. cpu_to_node(cpu), which is a node
> id.  When the node map is sparse (for example possible nodes 0 and 2) the
> node count is 2 while the largest node id is 2, so the index reaches
> worker_groups[2] on a two-element array -- an out-of-bounds access.
>
> This has stayed latent because worker groups are only allocated when
> group_thread_cnt is non-zero, and the historical default is 0.  Size the
> array by nr_node_ids -- one past the largest possible node id -- so that
> indexing by cpu_to_node() is always in bounds.  On a dense node map
> nr_node_ids equals num_possible_nodes() and nothing changes; on a sparse
> map the array just gains the unused id slots it needs.
>
> Fixes: 851c30c9badf ("raid5: offload stripe handle to workqueue")
> Signed-off-by: Hiroshi Nishida<nishidafmly@gmail.com>
> ---
>   drivers/md/raid5.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
