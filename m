Received: from out203-205-221-173.mail.qq.com (out203-205-221-173.mail.qq.com [203.205.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71ACC3603C2;
	Fri, 12 Jun 2026 03:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781235747; cv=none; b=Qvca0K3hp/Qg03Tg6pBC7gPhfVCiWidJ9FNUaHpZe/9iBCLFHQtw8Z1j1/lo8IOKd2EnZDKxVpxeo2D6Xjvtq+ef7/YvD66YODrnLnses8Ay+eJqX4EjnkN6WyZzIkmiOhr6RIItPrlYudYAW7OqZ7c1abF20AD9Dea71+xPXdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781235747; c=relaxed/simple;
	bh=mKppnnTNwnkDifGuAcfFSpt17fVj6kGXJZeZGLCxdm8=;
	h=Message-ID:Mime-Version:Content-Type:Date:Subject:Cc:From:To:
	 References:In-Reply-To; b=ZrTuT56ZgXFQ5D6xuyX684NyULfhsRbZe3hwoZNaYR2Vn9Pa4hiRWtx0nTC+rE1YfDFPv07fmu5EcfR46Nzz3eGOO3OQeCE61AhrqmSQwYiUylxTuo53abom2P/92joMaofIhr4uS/9Q6p4C+PKsRp0JD5/2jNfvxs6IPkBvm2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=NjZ2YL3u; arc=none smtp.client-ip=203.205.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="NjZ2YL3u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1781235734;
	bh=NXxX8/9PnNAzXYohj12a41uRp6rccQG2w5HCfd+OWdY=;
	h=Date:Subject:Cc:From:To:References:In-Reply-To;
	b=NjZ2YL3uqDtNnqH4gMACCXSmZtkD59P+aR3AiwGFlESJbZ/faobJYc0AYYHaFgnfK
	 Hu7l8AtWcN65lINtOfn5moDEI6QC/ir0vO00FfE+LtithEXjgJ9QBwnW0eMATCAoI4
	 qd8011x6Qt2BIViOjHZJ1G0XrKd/eYdMJ3zh8ngk=
Received: from MacBook-Pro.local ([183.134.211.52])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id A871844A; Fri, 12 Jun 2026 11:42:07 +0800
X-QQ-mid: xmsmtpt1781235727thqz2v3x1
Message-ID: <tencent_1A4057A928F0CDF70F24A070B03ABFB34A05@qq.com>
X-QQ-XMAILINFO: N/WmRbclY25G/eSd+kw32SZEag5sioUJpXCSW70G/O1YuMG/HlF/O3bwAVExIh
	 B8dxLGmRlpeXP+Xp8KsFMTyQly2sXfa03zb9OX2eYOpjNmuh9kyOc9RTj9CpR/GH80qnK8LePSPr
	 esFeA2bO6q8+odDYt2UPu8MGDdl75XtcyRsAXfUyB8gdgl/NrAOJbSgZaVbIzhi5d8COM/gqYCo/
	 e5zdZu7iLJLOJ3ROWa6o6fQsLG2qhLhSHQCJsX37F4C/KEUYJUKu/GPOPzchCrGPmrgSzQciEtAz
	 /AKv6Jar//E1FMpNvmPYeRdzEWep9vGmd3VxUynbfJbRKFvJLrqHw5VfYaagOYGyuaCXbpyAtR1Q
	 LS5MvbKpDZQrvnnS/Tpf03urCe5qgySv0GPQPQog3wnLfKDuPutPRldMpR7bBZZFd99LPPB1DkBC
	 GHw/mV6eKVaOpj0WTgZ35Ayx6JUzk1+0cUInLmOFKW6nv/4RJ2m7dEptnXG6ABLX19tskUdJ2HaF
	 OFikOd7IR6n3Wsw+SlZjfRxnsHDhZXzb4xhCsrbOh4Z3t7I5+iO1yjtI1OGZIWv3UTZH8iL/gnf3
	 iIPyr224FaYuQz9TDabVGS9ctXR9MnrmLVgAbjaJwEW9IICnaEAR021ljshK1AjwiPejc90yoCyV
	 x93iXhyg35Y/zp7D81SU2/h2L4clY1jD82Y1AdxOs6hUPfr94n74kjQPDPMV61/lpiv3llr6YvMv
	 ScSpXvM1cXFugzdbUsxPci2ITFDyFsubfxhE83h+XO202/psSVXa1YjKc4q4r64DMUW2vS7ItZKY
	 76RRSZ0dfZQ/0MmDOFxje8F4KbChBeHuwGJY4gVudnXOzgG3P7W5Bjx1SMDT2grvJnoBFcUHn2TB
	 4zwyrw04lOCMo9mJz7GVQ6LtRkH17mDrWjOhwS3CXOwhXF01xwqxEUPxJGtb6qkUTJiBmXknXfBJ
	 DbuKv3kqNXQ/7Ve+DTcXlmwpyHoGIgHaezZ7tMMErBdEoT5x4PpkNqVsp9xyxWsBiV7mwZ14v5du
	 gdD1yYx8qn43hxww6BOiXKjKvdxTzCPyNMnDpzg8cxMgxGbII5
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 12 Jun 2026 11:42:07 +0800
X-OQ-MSGID: <DJ6RD8E9SW2O.3HCM18370KWGY@foxmail.com>
Subject: Re: [PATCH] raid10: badblock-aware reshape write error handling
Cc: <linan122@huawei.com>, <xiao@kernel.org>, <linux-raid@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, "Cao Guanghui" <caoguanghui@kylinos.cn>
From: "Li Nan" <magiclinan@foxmail.com>
To: <ghuicao@163.com>, <song@kernel.org>, <yukuai@fnnas.com>
X-Mailer: aerc 0.21.0
References: <20260601054630.74483-1-ghuicao@163.com>
In-Reply-To: <20260601054630.74483-1-ghuicao@163.com>

On Mon Jun 1, 2026 at 1:46 PM CST, ghuicao wrote:
> From: Cao Guanghui <caoguanghui@kylinos.cn>
>
> Replace the FIXME in end_reshape_write(). Instead of failing the device
> immediately on write errors during reshape, attempt to record badblocks
> using new_data_offset with is_new=3D1.
>
> rdev_set_badblocks() returns true on success. On failure (e.g., badblocks
> table full), it has already called md_error() internally to degrade the
> device. Queue WantReplacement for member devices regardless of badblock
> recording success, but skip this for replacement devices to avoid
> replacement loops.
>
> On successful write, clear stale badblock records at the new location
> since data has migrated.
>
> Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
> ---
>  drivers/md/raid10.c | 27 ++++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 4901ebe45c87..08d58a1c680e 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4991,9 +4991,30 @@ static void end_reshape_write(struct bio *bio)
>  		      conf->mirrors[d].rdev;
> =20
>  	if (bio->bi_status) {
> -		/* FIXME should record badblock */
> -		md_error(mddev, rdev);
> -	}
> +		set_bit(WriteErrorSeen, &rdev->flags);
> +
> +		/* rdev_set_badblocks returns true on success.
> +		 * On failure, it has already called md_error() internally.
> +		 * Use is_new=3D1 as reshape writes target the new layout
> +		 * (new_data_offset).
> +		 */
> +		if (rdev_set_badblocks(rdev, r10_bio->devs[slot].addr,
> +				       r10_bio->sectors, 1)) {
> +			/* Queue async replacement for member devices
> +			 * For replacement devices, do not trigger WantReplacement
> +			 * to avoid circular replacement storms.
> +			 */
> +			if (!repl) {
> +				if (!test_and_set_bit(WantReplacement, &rdev->flags))
> +					set_bit(MD_RECOVERY_NEEDED,
> +						&rdev->mddev->recovery);

The logic here seems a bit odd =E2=80=94 several mechanisms are chained tog=
ether.

The correct logic might be:
  1. If there is a replacement, fail directly with md_error
  2. If not, mark the badblock and set WantReplacement

> +			}
> +		}
> +	} else {
> +		/* Write succeeded, clear stale badblock records */
> +		rdev_clear_badblocks(rdev, r10_bio->devs[slot].addr,
> +				     r10_bio->sectors, 1);
> +	}
> =20
>  	rdev_dec_pending(rdev, mddev);
>  	end_reshape_request(r10_bio);




--=20
Thanks,
Nan

