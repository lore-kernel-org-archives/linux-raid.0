Received: from va-2-46.ptr.blmpb.com (va-2-46.ptr.blmpb.com [209.127.231.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8514086A
	for <linux-raid@vger.kernel.org>; Mon, 20 Jul 2026 02:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784512980; cv=none; b=klzrY0Jg6PuwC5ni1it/nbxRn9jnAvTPkN/9qZRdHdmNBHID61cKsna4vGAjSYuA/OlNkZN2M3QaxwkzHLqTMC+HGTPkTK0jXVN6V3PwQSNiYmXZfoV9x+cH+R8tQIZcVVuYYqD5/CBF6numCEuLUOk/kHJAupIvWNlT3JpuCfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784512980; c=relaxed/simple;
	bh=hpZDvPir2hDtltyxdICt+piPcKut/7oujDFIgSE+Kh0=;
	h=Message-Id:References:Mime-Version:In-Reply-To:To:Cc:Date:From:
	 Subject:Content-Type; b=rwpawmeItXEDznF2S0N3Hc1BCAW7KBXN8Em0pGZzbne5aLWQJ0lpUemhp3lU4CmjlORZ//NK51h9YpXylCT2BesI16XCebV3CEy/PswcyHu3zfqj+eEM+N6YhT9uJV+6Oq2EL7vF8yXQnd2RC51wym1ajTdGKyEnflZa31mLCqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=POFqDvyv; arc=none smtp.client-ip=209.127.231.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="POFqDvyv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784512974;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=+6P4MmkH9fpYQ29POx/UAVnBwGssmmicbVi3PDCSIng=;
 b=POFqDvyvCXFjOM5x7pg+99y/tg0GpnqcVRhYeUlNmpdxohu8G3evu9DReYjy/rEE0oBGvD
 f8opJ/EFL049Y8I1waFCLuBmForkIfwE2k2ib9PtGix7wjc92QIJJJVCiBnkNPoz5haFNe
 2EImFfqt1jSku7etxB7q9SDrNCk/dIFNOloayrRg+QKEQxTFxpPzpxXwUPMgXcbEe+6LkB
 0oBYAG5CjSe/R4RQSJ7bYCPC8kkp1EqHwxTfa2ji6oKkblHS/RtKDj0uEYGpoYAnXn79I6
 XYjFHXfSU77Bw+qENaVezjCrzDUe8B2UEK3L3jfqMDlD9WnB/KW994G0fDDg3A==
Received: from [192.168.1.104] ([39.182.0.157]) by smtp.larksuite.com with ESMTPS; Mon, 20 Jul 2026 02:02:52 +0000
Reply-To: yukuai@fygo.io
Message-Id: <266b1203-6555-450d-9140-8f81ecb58979@fygo.io>
References: <20260719144409.940492-1-mykola@meshstor.io> <20260719144409.940492-4-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260719144409.940492-4-mykola@meshstor.io>
X-Original-From: yu kuai <yukuai@fygo.io>
To: "Mykola Marzhan" <mykola@meshstor.io>, "Song Liu" <song@kernel.org>, 
	"Yu Kuai" <yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Mon, 20 Jul 2026 10:02:49 +0800
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH 3/4] md/md-llbitmap: unmap sb page before freeing it
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a5d81cd+463241+vger.kernel.org+yukuai@fygo.io>

=E5=9C=A8 2026/7/19 22:44, Mykola Marzhan =E5=86=99=E9=81=93:
> Every path in llbitmap_read_sb() that maps the superblock page ends
> at the out_put_page label, which frees the page and only then unmaps
> it:
>
> 	__free_page(sb_page);
> 	kunmap_local(sb);
>
> The page comes from alloc_page(GFP_KERNEL), so kunmap_local() is
> currently a no-op everywhere except CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP
> builds -- where the page really is freed while a live mapping still
> points at it.  Unmap before freeing.
>
> Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
> Assisted-by: Claude-Code:claude-opus-4-8
> Signed-off-by: Mykola Marzhan<mykola@meshstor.io>
> ---
>   drivers/md/md-llbitmap.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
