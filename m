Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D213A962D
	for <linux-raid@vger.kernel.org>; Thu, 30 Apr 2026 10:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777546128; cv=pass; b=rvAzd8tNWgxq0+OKy7JhUH5ncaCEM+5+H1az45a1VctpN0rVqeV6OYwjKXOdK/wN3Lxm7B2e3rpsEqT38NBssgUmiqjr5bb/NvyZBFYOvZlrb1yDSeJR7fmEPHhyepLk69+qHlkBCVV0QDsxzYtRyHNFtr8K3Hl42L1MViSw+8I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777546128; c=relaxed/simple;
	bh=F8XMV3cuAenphEgvZslv5chRO43byv5xw4UQmmq21RY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=nG64+WUYEjgPIpOXlkBJ6jD0FluXKl3DtByumBDNyeOKn2H0EWk9JsYZzjhq4zcf/f6OqSeXuTg1xiYNwh28lVrNeOoNTUM71fjVmDLKsoGW4M285kagTZ171oJS0J2VV4wp4pNKzG+cAZlzlcyqlwVQH+JjVEd/X40J2eYsZjY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d5GGLV+d; arc=pass smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d5GGLV+d"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-6589bfb4de2so276279d50.2
        for <linux-raid@vger.kernel.org>; Thu, 30 Apr 2026 03:48:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777546125; cv=none;
        d=google.com; s=arc-20240605;
        b=fAKu5jQN0HfwF7Vak8drWvwL1JsKWebTKbpXvnSxh+LFPYlSKlfJS7JqLH/OnM4x8u
         lrZOAWIJ8LWT9UNYYk+Ez6Il/xagVR6uggHL5n005/axYD6JU5lt2WiikcdJYrOcElXN
         f6Svp8C2Vzh15a9Lbnhskk4srtZZfWUrpHL6tFZ7bhCwaslnvO0NxwBcWvMN490/V7vS
         N3M7jGB6UuBYGeSGWAvbjW2PHi4jmvMHFdEVSDg55LtMFD+ohMK7Ipyal1CPFlv4kGHP
         s/VX4lc4bbUhso/0vjk9UwVu7mSRi6kjNQhYk2BeBzKdtl9eWyDYsoGo9m+7CUijiu9M
         XoPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lBlYW1b8LolauY86+IKpopncOcEc2j0vUOOjhEjsF8I=;
        fh=X3wQ2D3DBAZuXswHTOsYFcAief3bMBJ7HKWbj/5u/jo=;
        b=U8AGbp3znH8fuGBIW5ieJysjeoy7hXUAlJGsSJKVU4D8SwpXyvWrP1ItOLJ0vfWZvL
         AIqmQyMLYeu8D1UsaKex6bxzFgJh6FbtejmlJc36MtHV67yqw/QOuTwIzA87Alj/fOnB
         BC4NvsJKZTkZDhGG6m8T3yrVOeyNDDaB3jRUulPCT3vExjunKuU76EW7LeBXXKqtqSRK
         oy7QVHyOj20VY6WNlJTcFjqrqJ6Oe/2Xo85q0h6s7zJlWz7uE6E40gXnkFfDkBikyhKK
         WaVdRmh4z4M9QYbLnb6DEoC7b+oCv5/gls7+uZjfM+0EzvUuO4aM4DTx9qafG+/ScB/s
         WjDg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777546125; x=1778150925; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lBlYW1b8LolauY86+IKpopncOcEc2j0vUOOjhEjsF8I=;
        b=d5GGLV+dciktIKtnciwsUum3UxNSq1YQfIP3cpSWosixghVzseiYbjO5ie7bHCI/6f
         DKOGzt6fTdVwoeNSiKTE6S2FtqyeueUDsvq6pOM2NiXeiee74RcpTTFlbdxKb+rMtPWg
         mAM6goXEHRsZ3Ng1mEP0G/yHqhCdK8NFML+fVF0R1pE5hHTQ7lkg5YXKdwMrI4G2fqiO
         QuolfV6f5QFf+23weSqs/dy2UtYtSk5EuxGT0jkJuHyH7ABKKSZhSYqCa3Ufo4wYOHO0
         aDLhFPrRJKinOo1Z/5F6CSiGj20m50WPBpFuH/xeclYp2qKYkBGNsGdy6xbctWa+GCfw
         RhWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777546125; x=1778150925;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lBlYW1b8LolauY86+IKpopncOcEc2j0vUOOjhEjsF8I=;
        b=tR4AscUNZolxEFbsDxTYc/m2J8vQfaAJG96fo0tC4YMQXGpmETAKKDrJyJFCikVpP6
         a2isjsQ2S5kJCYBHq14REk2gLNbdiiWotv3x5fJOc7oNjHVzDs+zHicHdc5IX54K6D0d
         efLewE+9S9A78xIuPcSa+VKA7+NhOZnkwxmNeCZgms2gei6XqmMGF3YOyUWyufEpwRJo
         ZBcW9jPymN1CWKhiOi1E5Cmn75u7OJPn4KhQWvyB//AQXRHbHndxLJCDRhRSF1Kd5S2O
         eNmLgu1N5d53faSSfVveqwxpJsFWhRTPEA5qcHvPSFM/T7AnLGPPc4XHT7JJwMx3qJoE
         x8ug==
X-Gm-Message-State: AOJu0YxmnE9WTCy5v958Y4j6ekjKp/QhEBI3obvMP77OGnEicaqeDmpA
	jNH920KeduwYE7Ux6PdiWosi7M6NZu1Vj+SoY0ppJrUuq6PiANapAMOJRH+Th3K0kf4Gp6wEMI+
	3RBlTCEPfG2osM0GFwGtLJG/+pVaKUDgaubyvjTM=
X-Gm-Gg: AeBDiet8FC0bOfQndwoykLF8I5z8UR4JX2lNTunZHcGEshGSOpaIV2iuY6xUogHCOzE
	s/lnYx447FvUDR118jW/mPdKQwTNWk07Wkcgg5bBbISFERdcINfooQZ3whe44ZSqvR/hG2ho7Yv
	99Pj5/NIBvhBKKO/CJXxWx+x9WXc7xNL9RmlTPZ9BlkI7FWJxKqeuGHRqVTvj+rflyE4GCVA2Ds
	kGneSfzXbQD9f/vneqrRwNe2Dc4a6Kk6jsekrUcdOJvP0bCIBIauxnoY1ZgNkf03TXXH62rG1Sk
	dpGZGv5abADbF944nVb6+rP/ACI=
X-Received: by 2002:a05:690e:b45:b0:654:c28:598 with SMTP id
 956f58d0204a3-65c18aec741mr1682649d50.9.1777546125290; Thu, 30 Apr 2026
 03:48:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <afKLmiyhEe4Om0Nt@mail.bitfolk.com>
In-Reply-To: <afKLmiyhEe4Om0Nt@mail.bitfolk.com>
From: o1bigtenor <o1bigtenor@gmail.com>
Date: Thu, 30 Apr 2026 05:48:09 -0500
X-Gm-Features: AVHnY4Idh0VFGRDipeV_HvRhYSnbaoKaVIDVtdgovKZ-EgLbv9dsOe1hVkGOLjg
Message-ID: <CAPpdf5-+uD7fk-h5RR57PfJybku01CxXZvRx6mFE16L4duTyKQ@mail.gmail.com>
Subject: Re: Suggest me a cost effective SATA SSD?
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 29, 2026 at 6:09=E2=80=AFPM Andy Smith <andy@strugglers.net> wr=
ote:
>
> Hi,
>
> I've inherited a system with a pair of these:
>
> Model Family:     Crucial/Micron Client SSDs
> Device Model:     CT4000BX500SSD1
> User Capacity:    4,000,787,030,016 bytes [4.00 TB]
>
> Their write performance is terrible. Struggling to get 20MB/s sequential
> write. Their TBW count is low so it's not an issue of excessive write
> cycles. I've searched around and established they are just really bad
> SSDs. They also don't support SMART self-tests, which seems like a
> really cheap thing to do.
>
> I'm further confident that the problem lies with these SSDs because
> there is a pair of much better SSDs in there and they perform as I would
> expect. However, the use case for this storage is for lower cost so it's
> not an option to just buy more of those.
>
> So, could anyone suggest a decent low end (consumer/prosumer market) SSD
> model that is known to work well without terrible firmware bugs under
> Linux, preferably with power loss protection? Low write endurance is
> fine. Capacity of 4TB ideally.
>
I would suggest that power loss protection be sought using a UPS - - - imo =
a
better idea.

HTH
