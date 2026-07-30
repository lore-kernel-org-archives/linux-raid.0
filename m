Received: from va-2-48.ptr.blmpb.com (va-2-48.ptr.blmpb.com [209.127.231.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE503B8111
	for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 08:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785400088; cv=none; b=KRwN+a2/myiHC9wPmKaK8ek1PN7WK0YOXFBeoR70qIeNFuE+EnF4y0Up7mFfpNLUYJ1aYaVtA1g+QqkCC5trpXCVKEnMb+7FPl1D/SjDiXw/SHm7k5bm306biKO8JPDfD6H9sdL1b+sWEyCIC5K5IbJgus8lMbS3uJfGoDZsdCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785400088; c=relaxed/simple;
	bh=J8hboDhTwnBp9kHdy3SFl8nA+6yeqsHSCVF+IpT2dMQ=;
	h=Cc:Subject:Date:Message-Id:Content-Type:In-Reply-To:To:From:
	 Mime-Version:References; b=Ep8L2WSJImUqwK6Xl5+qVokT8Dt/GJPIadwXddG6hIqL1itPpPhlCfYfDKdJrEqa9IOY+XWHwd9kyfPKqiRpCfhOc7sX1tT/LXXWFIHsdMftMqAi3soWM48lVWaL4dntwX7e948JYHSApIKX6Ahv2MenQgdRBaJYzumO3DLkTK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=CTs0kQ2c; arc=none smtp.client-ip=209.127.231.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="CTs0kQ2c"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785400067;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Tx6MaENeJkI6WOcc38XFx8oqCUhlOi0iUNqQKX8wtPQ=;
 b=CTs0kQ2cjMLfVnzAKJGxUJ9P0Q5kLqi5jIT35tA4iitH2jRMj48g9iEK5bsLZxGJLgw4P2
 64B7xOOb20YbLaCwvqmtNc/DKr8Gy2Fcy991hAT3qL8CwhJDfU5ZKV6pC4KkFZ0HxcG4+u
 btASxTAyDPe3KbT33Bd+Atnc2H+eV8oM+cAaRIZSaG+jIZWmhKuVeFsEGHxZ2YiLFENU1U
 11qgz6nEL2ukK/7zH3KcZNFgKi86tAiLOslKxD0LYXmdWwKgJzrfhN8L7y2VYCkgsiM9Hr
 f+amNjc7hHE9mJME0tS24quEsYFHhQru84h5wrOm03sxuJCecRV+CYnmrvbUuw==
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] md/raid1: protect sequential read hints for read balance
Date: Thu, 30 Jul 2026 16:27:43 +0800
Message-Id: <0d46c447-4a2e-4b28-a33e-24253656bfa5@fygo.io>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
In-Reply-To: <20260623075940.2476255-1-chencheng@fnnas.com>
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Thu, 30 Jul 2026 08:27:46 +0000
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>
Reply-To: yukuai@fygo.io
X-Lms-Return-Path: <lba+26a6b0b03+0c8ea4+vger.kernel.org+yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260623075940.2476255-1-chencheng@fnnas.com>

=E5=9C=A8 2026/6/23 15:59, Chen Cheng =E5=86=99=E9=81=93:

> From: Chen Cheng<chencheng@fnnas.com>
>
> The patch just suppress KCSAN noise. No functional change.
>
> KCSAN reports a race, point to update_read_sectors() update next_seq_sect=
 vs.
> read next_seq_sect.
>
> Protect next_seq_sect and seq_start with READ_ONCE/WRITE_ONCE, otherwise,
> read balance see stale sequential-read hints.
>
> KCSAN report:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>   BUG: KCSAN: data-race in raid1_read_request / raid1_read_request
>
>   write to 0xffff8e3a2d6736d0 of 8 bytes by task 593784 on cpu 10:
>    raid1_read_request+0xe5a/0x19f0
>    raid1_make_request+0xdf/0x1990
>    md_handle_request+0x4a2/0xa40
>    [...]
>
>   read to 0xffff8e3a2d6736d0 of 8 bytes by task 593776 on cpu 11:
>    raid1_read_request+0xe3f/0x19f0
>    raid1_make_request+0xdf/0x1990
>    md_handle_request+0x4a2/0xa40
>    [...]
>
>   value changed: 0x0000000000356368 -> 0x0000000000356370
>
> Signed-off-by: Chen Cheng<chencheng@fnnas.com>
> ---
>   drivers/md/raid1.c | 18 ++++++++++--------
>   1 file changed, 10 insertions(+), 8 deletions(-)
Applied to md-7.3

--=20
Thanks,
Kuai
