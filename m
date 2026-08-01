Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE54D1DA0E1
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 17:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785606628; cv=none; b=fXSo/q9MTgzdu0BXGmo4WUzmoNSVpvSSqAQfTuWJx7lf9G6vAY/fCeahkAETawlytS/xYkt3LNF9B79dZ/t1jf1xiptM0F2dTdH03f/RvDfUfsDf+zLc1do6J86gvqFY7MzxHughyYbj1UOLuIZZuHJaBsYxuxxzSNElP8FtCsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785606628; c=relaxed/simple;
	bh=aeknkpDUU+UM6KmIcYBDL4czmpzorN7TTKQ0L+QgBmk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=koQ9jz6Mit+ux+e3wBM4FYdHLOLT2a2/sUKe3KqezQEtL1KrNSg6o4haI4G1TB13mKz0Yp9HhuK3IsBz1fiiFHpAV5T8jaG/kgZJZp3RRxtqn603M4gtx7AqyTncNqZKxElNT2sRgQ68lUbJRNsOgpEYl+HPqWAEpmHNY6sTLxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fjAh63ny; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fjAh63ny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8027D1F00AC4;
	Sat,  1 Aug 2026 17:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785606627;
	bh=KNa89/wuL2PxhurNhh0yonUxFt+5zCI/EIle/urLnC0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fjAh63nyBZKr7fEEfj/lT06SXsT3WYviHotwPflOLJTf7QYTzZpARj8C/vuYzbS+X
	 b3ZocAO/IUskIIhsogQUKP5b5XVw+RGYgSLk5xAWb2zv/mC1PTtbUuft26iMbHoSn8
	 TuHeaVViUafS+jgWSOAP86/PO0Fx6Ac2+yyP4ztIeqFow2xA8+TrOT40umqTKY1qtL
	 YAsxYOucRwoaBILspwfMg3jB1d4rx7JRiUyd/m7uJUKmbVsfk+lxPP4JsGsxIu/Z8c
	 JbXyi5A2cui0mDg+H3Hjf/pIIgRMpn1jdjwJiGqbnqcIiRTa8AteXra9u3WJlSmLKj
	 DHE+iM9AR+d8g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 14/25] md/md-llbitmap: refuse reshape while llbitmap
 still needs sync
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260801172519.2982121-15-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-15-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 17:50:26 +0000
Message-Id: <20260801175027.8027D1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] The newly added `llbitmap_reshape_can_start` callback is never e=
xecuted because there are no callers for `mddev->bitmap_ops->reshape_can_st=
art` anywhere in the md codebase.

Pre-existing issues:
- [High] Use-After-Free in the `llbitmap_create` error path where `mddev->b=
itmap` points to freed memory without holding the lock.
--

--- Patch [14]: [PATCH v4 14/25] md/md-llbitmap: refuse reshape while llbit=
map still needs sync ---
commit a811c308c426ffe3f23803b0888eecbb420a8f6d
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: refuse reshape while llbitmap still needs sync

Reject reshape when llbitmap still contains NeedSync or Syncing bits. This
keeps reshape from starting until the current llbitmap state has been
reconciled.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index f41f9ba2063b5..3b121b372cd8d 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
[ ... ]
> @@ -2025,6 +2048,7 @@ static struct bitmap_operations llbitmap_ops =3D {
>  	.dirty_bits		=3D llbitmap_dirty_bits,
>  	.prepare_range		=3D llbitmap_prepare_range,
>  	.reshape_finish		=3D llbitmap_reshape_finish,
> +	.reshape_can_start	=3D llbitmap_reshape_can_start,
>  	.write_all		=3D llbitmap_write_all,

[Severity: Medium]
Is this callback executed by the md core?

Looking at the md codebase, there do not appear to be any callers for
mddev->bitmap_ops->reshape_can_start. Does this mean the validation logic
is bypassed and reshapes could still start prematurely?

[Severity: High]
This is a pre-existing issue, but can a concurrent reader access freed memo=
ry
during bitmap creation?

In llbitmap_create(), if an error occurs, the mutex is dropped before
mddev->bitmap is set to NULL:

    mutex_unlock(&mddev->bitmap_info.mutex);
    if (ret) {
        kfree(llbitmap);
        mddev->bitmap =3D NULL;
    }

A concurrent /proc/mdstat reader could acquire the mutex after it is dropped
but before mddev->bitmap is cleared, allowing it to dereference the freed
llbitmap pointer:

drivers/md/md.c:md_seq_show() {
    ...
    /* prevent bitmap to be freed after checking */
    mutex_lock(&mddev->bitmap_info.mutex);
    ...
        md_bitmap_status(seq, mddev);
    ...
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D14
