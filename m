Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4144595B
	for <linux-raid@vger.kernel.org>; Sat, 13 Jul 2024 12:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.222.135.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720874845; cv=none; b=m4RcaKBM2y5/dk1n5mLRMRxn/sY2I4EzzgZeKAt2dj3x1krXfsPr4i1PDBc+6699/zAcuhWOCPotV1lIZjbUF6O+k3dbv99eIMGBDVP+iCzynsOqHE+O336SVHgDRoCTH25Hj2PKyhywHI+L5t7qR/iSLcZN7gboL08uQmgBKew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720874845; c=relaxed/simple;
	bh=xZLNfkg6Nq4XTIY/Bndu/mqP9e+QUaD+KGDAB6Xqkz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mW+ZaxE91EdA/ygdtxCH5QNwkFx5haEvA7/TchF6U50cBaUtasg3cLf23xwz+9nyTXE7YG7g32NTaFpYLUftYTICZMx7+x1nKexrrxtA91ARC9iUm5Hc9dwk0CBHE5q3pqFJ3pZTxCy3kgYMxiENXn9LKmv1mKPPAOvfvQPT+PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl; spf=pass smtp.mailfrom=o2.pl; dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b=iB4SSS82; arc=none smtp.client-ip=193.222.135.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=o2.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b="iB4SSS82"
Received: (wp-smtpd smtp.tlen.pl 47963 invoked from network); 13 Jul 2024 14:40:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1720874440; bh=xZLNfkg6Nq4XTIY/Bndu/mqP9e+QUaD+KGDAB6Xqkz0=;
          h=Subject:To:Cc:From;
          b=iB4SSS82aYraFWXixHvG2FD9hrUQUmU8dBCukI87ok1j7C2uUUiNJfGvpgS2HXjzt
           AF/Pg9LgBTimUgcbFzl74csu+59Vf1rUvYrcyU6oYQM4NmDFfYDrXxeuJEqOYDyfnE
           /m4zKBnkiByN7oCRQZWO6GAY0Lc/xyjp0VTAdfhE=
Received: from aafe223.neoplus.adsl.tpnet.pl (HELO [192.168.1.22]) (mat.jonczyk@o2.pl@[83.4.134.223])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <yukuai1@huaweicloud.com>; 13 Jul 2024 14:40:39 +0200
Message-ID: <5d698ca4-b6a0-4567-ab6c-899b34293056@o2.pl>
Date: Sat, 13 Jul 2024 14:40:36 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid1: set max_sectors during early return from
 choose_slow_rdev()
To: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, Song Liu <song@kernel.org>,
 Paul Luse <paul.e.luse@linux.intel.com>, Xiao Ni <xni@redhat.com>,
 Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <349e4894-b6ea-6bc4-b040-4a816b6960ab@huaweicloud.com>
 <20240711202316.10775-1-mat.jonczyk@o2.pl>
 <e9585300-1666-ca71-8684-8824fe2ddaf1@huaweicloud.com>
Content-Language: en-GB
From: =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Autocrypt: addr=mat.jonczyk@o2.pl; keydata=
 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
 TANkZ3QqXNX2
In-Reply-To: <e9585300-1666-ca71-8684-8824fe2ddaf1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: 2cda0889d6b0ad5206b8d2265bcfc8ce
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 0000000 [IYNR]                               

W dniu 12.07.2024 o 03:16, Yu Kuai pisze:
> Hi,
>
> 在 2024/07/12 4:23, Mateusz Jończyk 写道:
>> Linux 6.9+ is unable to start a degraded RAID1 array with one drive,
>> when that drive has a write-mostly flag set. During such an attempt,
>> the following assertion in bio_split() is hit:
>>
[snip]
>
> Thanks for the patch!
>
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
>
> BTW, do you have plans to add a new test to mdadm tests? I'll
> pick it up if you don't, just let me know.
>
> Thanks,
> Kuai

Yes, I'm working on it.

Greetings,

Mateusz

