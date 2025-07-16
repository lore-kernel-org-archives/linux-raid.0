Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20797481CD
	for <linux-raid@vger.kernel.org>; Wed, 16 Jul 2025 16:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752682901; cv=none; b=khHjVtH6ym/zh1oYVYHnuQiJ+5iwOBZuJHmUnAVElfUnNZfbDLeYWYU0tmRIdmHlpCnc5hnIwz8vVsd+GvlS8qsA9EfurbJq4QE+3N6xjjfFxD67NbMa2apA8PZfx8N1h1PYzvRsWO7St8teeCGxMfvEy23Azq1u3YIkcerFCpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752682901; c=relaxed/simple;
	bh=1D1PeCeQQMWouLOxNEPQgdTt1qGAjESXy0IAjrWCjfM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PuEA9R3gi5nWSMc1lIFcQZ3R8Aq6rk0HAozMYqNHm/2Pg+zT/nUQAkfacwifOqYKgEKWv2c7ExztH5HCSzf0BkUQ28mIqXFFEeOUxDjnI6RzrIuPQVSKL4zF2iTVWDnCS1koUEOKnWS6Qiwoo/D7LdQ78piSCbpmyY3go4mhIt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ms5Rmu46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ms5Rmu46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAC8C4CEE7;
	Wed, 16 Jul 2025 16:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752682900;
	bh=1D1PeCeQQMWouLOxNEPQgdTt1qGAjESXy0IAjrWCjfM=;
	h=Date:Reply-To:Subject:To:References:From:In-Reply-To:From;
	b=Ms5Rmu46lXIO/VQQlhTQKDamciq5AXW+U1wdWO6Z3EeKX32SF04NgKFu4NEYD5cm1
	 HrHk22WVySjnkU7fd6VYoB1rqmBFbGFM88ff7gdgDgVP3cEixBU2my+tob4o3cH9u+
	 +LstnzDpHZp4SFWES6QwRi5MIvUMgKYlo4k4nJPWVHl32oX3U6Ajc19j8f1AJ6ezT9
	 M5lmqmiUOk8pZjzoydP4xnI0uX1h0qpgBykRFcUewBzRbA7fomR+v97qIP9/0FomcK
	 DMHY2xNf/lVj36tK/lDcQ9FLcOhilgA9FyTkgFqcHafN3rUyjNUrqYj362Im0YJ6lf
	 S/GLAHVzbEMpg==
Message-ID: <1cc7f8b1-cd22-40bc-8e8c-45a2cc180849@kernel.org>
Date: Thu, 17 Jul 2025 00:21:34 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@kernel.org
Subject: Re: Sector size changes creating filesystem problems
To: Filipe Maia <filipe.c.maia@gmail.com>, linux-raid@vger.kernel.org
References: <CAN5hRiUQ7vN0dqP_dNgbM9rY3PaNVPLDiWPRv9mXWfLXrHS0tQ@mail.gmail.com>
Content-Language: en-US
From: Yu Kuai <yukuai@kernel.org>
In-Reply-To: <CAN5hRiUQ7vN0dqP_dNgbM9rY3PaNVPLDiWPRv9mXWfLXrHS0tQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

在 2025/7/16 22:30, Filipe Maia 写道:
> Hi,
>
> When a 4Kn disk is added to an mdadm array with sector size 512, its
> sector size changes to 4096 to accommodate the new disk.
>
> Here's an example:
>
> ```
> truncate -s 1G /tmp/loop512a
> truncate -s 1G /tmp/loop512b
> truncate -s 1G /tmp/loop512c
> truncate -s 1G /tmp/loop4Ka
> losetup --sector-size 512  --direct-io=on /dev/loop0  /tmp/loop512a
> losetup --sector-size 512  --direct-io=on /dev/loop1  /tmp/loop512b
> losetup --sector-size 512  --direct-io=on /dev/loop2  /tmp/loop512c
> losetup --sector-size 4096  --direct-io=on /dev/loop3  /tmp/loop4Ka
> mdadm --create /dev/md2 --level=5 --raid-devices=3 /dev/loop[0-2]
> # blockdev returns 512
> blockdev --getss /dev/md2
> mdadm /dev/md2 -a /dev/loop3
> mdadm /dev/md2 -f /dev/loop2
> # blockdev still returns 512
> blockdev --getss /dev/md2
> mdadm -S /dev/md2
> mdadm -A /dev/md2 /dev/loop0 /dev/loop1 /dev/loop3
> # blockdev now returns 4096
> blockdev --getss /dev/md2
> ```
>
> This breaks filesystems like XFS, with new mounts failing with:
> `mount: /mnt: mount(2) system call failed: Function not implemented.`
Yes, this is a known problem. Li Nan was trying to fix this long time ago.
>
> Shouldn't the user be warned when this can happen?
Kernel should forbid larger lbs new disk, however, this is still a missing
feature for now.

Thanks,

Kuai
>
> Cheers,
> Filipe
>
