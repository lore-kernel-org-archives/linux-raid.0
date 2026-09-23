Received: from va-2-60.ptr.blmpb.com (va-2-60.ptr.blmpb.com [209.127.231.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0513B14B1
	for <linux-raid@vger.kernel.org>; Wed, 23 Sep 2026 11:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790162636; cv=none; b=sNg5+ZKDvwu2WMLMS4WcRgmTsmSfj9FNppudoupl1PQoNgJTMHD1QuNS1WhlHvVkMaBVFNUMwk3+9v19TP/iWz/XdzVwtr0uJ6Q6qER+qk6aMzhLxwIVZQIEI8pOl0CoXMOe8Zbvnh0htQ9qO0a7YZwzNuMQpuDyDffsp4Ap1N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790162636; c=relaxed/simple;
	bh=jWa+1IFgCZrNjNXiwQnuLWYI46HHUEwvbGXCyk9jkcw=;
	h=To:From:Date:Message-Id:Mime-Version:References:Subject:
	 Content-Type:In-Reply-To:Cc; b=lgPYkpsHTXzu4pK781XyccN9fGGh+LjJWPkFotp4znrQbDPG649SZgxoFZyFKiX8ysuv+9J0/+cs+YdEhwMUVRGO+ZTD2RcxEI6HZjTXJw7whRrij6R6rAWQfGVpETnhkwkwfYn4rkMbTUF/IlSjK2/5oVDZCSR98MOuuNOnsOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=grzHRcGG; arc=none smtp.client-ip=209.127.231.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="grzHRcGG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1790162629;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=bC0/fN7waNqoJr2je2YuDDBCo+ld0k0RwfKkIsE8pEM=;
 b=grzHRcGG3//3TzDCrnfvIsPw7uoKVhw2740OVWgCCQUymFfc/73pCw83alD3gCxcugkhgu
 Cg3QV6bJhC+dpwXmjj0y4A7cl/1Zktcq+/olai/XmMPyKgtKjIgQS3aeTRUCa7YTaMHK5r
 mVevLk2t2Vt4Bg+0qIrylY3Q7FwCUHkqSD+5QEzfWXIgNbu05rLhPzMWmWEtacg7QmOZYy
 PISQlP2lp077Pykji+yGeCdIaqMjrLfao1FTawU89Q2QzapTrTSzgiHha0pbchlquRgel1
 CrAg07pDliKUG1S5G4Ch9IFmtTZrix0Zzlzz8XnUNwjp7EGhqcXQHMAMsi3fcA==
Received: from [192.168.1.104] ([39.182.0.179]) by smtp.larksuite.com with ESMTPS; Wed, 23 Sep 2026 11:23:48 +0000
To: "Svyatoslav Nikolenko" <nsvatoslav515@gmail.com>, <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Date: Wed, 23 Sep 2026 19:23:45 +0800
Message-Id: <314ed63c-e29b-4fa0-9f24-57b5f868fab6@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
References: <20260922125418.2715-1-nsvatoslav515@gmail.com>
X-Lms-Return-Path: <lba+26ab3b6c5+f27c93+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Subject: Re: [PATCH] md/raid5: fix NULL pointer dereference in raid5_has_ppl
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260922125418.2715-1-nsvatoslav515@gmail.com>
Cc: <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<syzbot+270624bb31d478afe62e@syzkaller.appspotmail.com>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable

Hi,

=E5=9C=A8 2026/9/22 20:54, Svyatoslav Nikolenko =E5=86=99=E9=81=93:
> Check if conf->mddev is non-NULL in raid5_has_ppl() before testing flags =
to
> prevent a KASAN null-ptr-deref during free_conf() cleanup paths.
>
> Reported-by: syzbot+270624bb31d478afe62e@syzkaller.appspotmail.com
> Tested-by: syzbot+270624bb31d478afe62e@syzkaller.appspotmail.com
> Signed-off-by: Svyatoslav Nikolenko <nsvatoslav515@gmail.com>
> ---
>   drivers/md/raid5-log.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Looks like this is already fixed by:

https://patch.msgid.link/20260915081731.122933-1-chengzhihao1@huawei.com

>
> diff --git a/drivers/md/raid5-log.h b/drivers/md/raid5-log.h
> index c8332502669e..5a144051b142 100644
> --- a/drivers/md/raid5-log.h
> +++ b/drivers/md/raid5-log.h
> @@ -51,7 +51,7 @@ static inline bool raid5_has_log(struct r5conf *conf)
>  =20
>   static inline bool raid5_has_ppl(struct r5conf *conf)
>   {
> -	return test_bit(MD_HAS_PPL, &conf->mddev->flags);
> +	return conf->mddev && test_bit(MD_HAS_PPL, &conf->mddev->flags);
>   }
>  =20
>   static inline int log_stripe(struct stripe_head *sh, struct stripe_head=
_state *s)

--=20
Thanks,
Kuai
