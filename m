Received: from out203-205-221-209.mail.qq.com (out203-205-221-209.mail.qq.com [203.205.221.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F50534F24A;
	Fri, 12 Jun 2026 06:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781245357; cv=none; b=KmgOu6b5rzWVFXijKheAt9l5q/l6bzsoDUnn2xJEL209LMYKY1Q9+F77oZlkDwDrReJqw3om5OGKBufrx7GhG8o2MXv1O6jz0o/RbOItaKnneIXZ1/P8I4b2GVN9bAaOKsLCOg0EMxhKNURTpFBU0LX491wIn+Ef00UID20Fio8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781245357; c=relaxed/simple;
	bh=WMik9pL4MeGFzj//lquOqWDkMajn6hiwrobghb+GSOo=;
	h=Message-ID:Mime-Version:Content-Type:Date:Subject:Cc:From:To:
	 References:In-Reply-To; b=P09ROebGv61sjnFv867O/W+V+HfFaJEzelDlNXDiyeDhLiHBcdYpmz9du+smM3BpDFQdccsZQww9oGk/bRXObEcDqpjpPrawbcPkpngS99iZtr/hSAdgDic8JYKgJx8DaG2/3/tmjiE0oBoW4mWMQGd/vA4q5gNTzX79/o3qx9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=UF7G8Cm6; arc=none smtp.client-ip=203.205.221.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="UF7G8Cm6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1781245352;
	bh=E822EMdhQUnvD7bulWCf0qfNe8vhG8Ff8vgqBAPVX5U=;
	h=Date:Subject:Cc:From:To:References:In-Reply-To;
	b=UF7G8Cm6YRy/r3NLnIQ+NixVGLBqfCtMb5zpkyWVcNe3POV03HS28clSL+5FO1SpS
	 6xPZEwMHRjAsFTOjtyLKZdGrNzz2/Z/H39G2Nso+Tdzb613z2Q5UHAcN9gsgNPr69C
	 6zcxWANwoTlFmm8ZREnQacmEqawjuIkxHcjcjz4Q=
Received: from MacBook-Pro.local ([183.134.211.52])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 5992A89A; Fri, 12 Jun 2026 14:22:25 +0800
X-QQ-mid: xmsmtpt1781245345t6es7kli9
Message-ID: <tencent_FC2A050632F9FE8144160E5727753208CC0A@qq.com>
X-QQ-XMAILINFO: N/WmRbclY25GWzE5ajnLdNS+4hfpAUXx6Bvtjp03eBFFA35WIxKvqZ5anvknTF
	 XtP4HJRvJfB88Xs68psHeb+HfKDguonbQU1oCbPMPSq0SeZdnysCEGAihdYU1SQ9w3cczEW86Ggh
	 iY7Il1Da75vASfVQMMHcD0x0GHaT7ni0+HNfM8wV7khXZA87Sap8Q11vFs2ntZyOwKwLtZ58R8P+
	 /0+CNWlQtwiIWV4jwFNfRzaCKskPatJZOwkQ+tAXZ2OMGz0vyPQqHFnHd+hfBpdk52YsqifoIxXf
	 43fL7URAgqkiFRSJZ1NtTVB+cX60Ll4tu4BwOfs59vlgOD+f5sBdJtZhKv+CeODpS0P895fWI01e
	 tly+YYBRAEVxT4c/m7OScfu7bnk0u2r1UU/voWOZ+abtbIjlCrsaMMW9gzDQWmgAVkMLh7hJBz//
	 MmCGh6anULSVwN1QS8agXs6+jJHO07K98JEvGbpQVv0LStVpSNuSi97F+frOtGkbuuRXOMQ1FbxJ
	 pq8yy+fj91KXt4W8t3LOm2y4OiPyIa5/co+vsAnemGuG+KSdO1T34h3ohM758sVhFGR8d2ypcTfz
	 Z7eXsbxBVlM0wM7p5m9LOs92+CfHRzlF97/e+zzV3wgL/8jr66oCBQL0XdfHQ5YRjAFiF8y8Xhwx
	 Q7DpgCC4Y0h+HjhWT6bW+oSm50Cai2dWtgG/hHlqUVyIao8ELez1T6WDJt1pauc3zbBLac0hp/NN
	 7hVb+sZXqbRQE0/b1CafQBko6vcsbLsoc1hUV0lx9fFpbo6hQ27lFDg4DGEScy1igiwGIAft0+96
	 kggNYGXyFA08X3SbgM0gOhvrrtm/TV1h+bGnYe7yuAyGnFui2z/hJaK1KEe4CH/xF6PsL4W5VrFb
	 DZtIrgD263CAciw8H28VnAHSX2za3uqKwnluhsWlEGEaiVp2j7JiXSVR6JoovgaeYPPV6vdei+6A
	 qbHfc8cfKLs47WiPwtKh3cr7+jTEQSBssxwZE+8Lz8zO+tT0FoMuwIZ/TQ3NDP5E9TdSdtfhwdeN
	 VFVAVP3Q9wKi7lg7aLRURVlnpJ9sphz4d0gLc/27B0TswymFgBCIypRC+2XWI=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 12 Jun 2026 14:22:24 +0800
X-OQ-MSGID: <DJ6URYSQMK5K.1031WP17GIX62@foxmail.com>
Subject: Re: [PATCH] md: use READ_ONCE() for rdev_attr_show() mddev check
Cc: <lilingfeng3@huawei.com>, <linux-kernel@vger.kernel.org>,
 <jianhao.xu@seu.edu.cn>
From: "Li Nan" <magiclinan@foxmail.com>
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>, <song@kernel.org>,
 <yukuai3@huawei.com>, <linux-raid@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20260611083510.476945-1-runyu.xiao@seu.edu.cn>
In-Reply-To: <20260611083510.476945-1-runyu.xiao@seu.edu.cn>

On Thu Jun 11, 2026 at 4:35 PM CST, Runyu Xiao wrote:
> md_kick_rdev_from_array() clears rdev->mddev with
> WRITE_ONCE(rdev->mddev, NULL), and rdev_attr_store() already snapshots
> that same shared pointer with READ_ONCE(rdev->mddev). rdev_attr_show()
> still tests the pointer with a plain lockless `if (!rdev->mddev)` before
> calling entry->show().
>
> A running system can reach this by reading rdev sysfs attributes while a
> device removal path is tearing the same md_rdev down. In that window,
> rdev_attr_show() can pass a stale plain guard while sibling
> rdev_attr_store() already observes NULL and returns -ENODEV, leaving the
> show path to operate after the shared mddev pointer has been revoked.
>
> Use READ_ONCE() in rdev_attr_show() so this sysfs read side matches the
> existing visibility contract on rdev->mddev.
>
> Fixes: 9cfcf99e7ed6 ("md: get rdev->mddev with READ_ONCE()")
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
> ---
>  drivers/md/md.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 92ec4be20db8..a021cf4a798d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3704,7 +3704,7 @@ rdev_attr_show(struct kobject *kobj, struct attribu=
te *attr, char *page)
> =20
>  	if (!entry->show)
>  		return -EIO;
> -	if (!rdev->mddev)
> +	if (!READ_ONCE(rdev->mddev))
>  		return -ENODEV;
>  	return entry->show(rdev, page);
>  }

LGTM

Reviewed-by: Li Nan <magiclinan@didiglobal.com>



--=20
Thanks,
Nan

