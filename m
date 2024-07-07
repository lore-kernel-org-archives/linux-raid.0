Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A448D39AD5
	for <linux-raid@vger.kernel.org>; Sun,  7 Jul 2024 19:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.222.135.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720382224; cv=none; b=LwrtqF6+vtS4AO1U0jh6/lz0JsAO1amL01jI2L+Rx3bN5zNLZKQ1+q8UOxsgfTNku0fD/74gvpc/VTVuzfEPOd7NtdTPfXEEfs+xnJqzdm+42Zhv4yTPimKseF+CGm6/luWGpCZau9jtOhACnaeJflviHgr5rvxJXr2K5mQRdKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720382224; c=relaxed/simple;
	bh=q6/jRZtqsE3Cn59iyfo+2FWJygpr/zkT0pcQNmhnO58=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JNfyTxtEmuJflxZLDpWUH/qlFeVo38Zm+6Hs8K1tv0WhSwQ3zkDEl2k66M27U3tcNsEwKr15duhbx2ZWbkyp/IUAc5KeSqhmr/O8IVFUujnh5O9H5CEtnM/XtvqxjKT4zUyaEON6dSKewQSd0bQAotD+L9q9FXCkrzrwCAD6LQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl; spf=pass smtp.mailfrom=o2.pl; dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b=uGlNR3SU; arc=none smtp.client-ip=193.222.135.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=o2.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b="uGlNR3SU"
Received: (wp-smtpd smtp.tlen.pl 20924 invoked from network); 7 Jul 2024 21:50:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1720381820; bh=q6/jRZtqsE3Cn59iyfo+2FWJygpr/zkT0pcQNmhnO58=;
          h=Subject:To:Cc:From;
          b=uGlNR3SUDtCS2tRHO2hNO1SfM3LZKFcD7329ziYyIGzZh7KlMTkITKperOBL2+h7o
           jKwHMnSPIeS26fdCfKr/JHGhlNr9TPX25ubXx9voacNFSQkDRjsiqleTEOVJ39e6iN
           3GOyAvy3VP1p0ZmSW/tW69viKS3SrYgsbRK9T+yM=
Received: from aafe223.neoplus.adsl.tpnet.pl (HELO [192.168.1.22]) (mat.jonczyk@o2.pl@[83.4.134.223])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <linux-raid@vger.kernel.org>; 7 Jul 2024 21:50:19 +0200
Message-ID: <3f934c1b-756f-4560-9798-98a74c32d857@o2.pl>
Date: Sun, 7 Jul 2024 21:50:16 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] Cannot start degraded RAID1 array with device with
 write-mostly flag
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: regressions@lists.linux.dev, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, Paul Luse <paul.e.luse@linux.intel.com>,
 Xiao Ni <xni@redhat.com>
References: <20240706143038.7253-1-mat.jonczyk@o2.pl>
Content-Language: en-GB
From: =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Autocrypt: addr=mat.jonczyk@o2.pl; keydata=
 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
 TANkZ3QqXNX2
In-Reply-To: <20240706143038.7253-1-mat.jonczyk@o2.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: cbed63988452608ec28fa2cdc602d631
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 0000000 [oVPw]                               

W dniu 6.07.2024 o 16:30, Mateusz Jończyk pisze:
> Hello,
>
> Linux 6.9+ cannot start a degraded RAID1 array when the only remaining
> device has the write-mostly flag set. Linux 6.8.0 works fine, as does
> 6.1.96.
[snip]
> After some investigation, I have determined that the bug is most likely in
> choose_slow_rdev() in drivers/md/raid1.c, which doesn't set max_sectors
> before returning early. A test patch (below) seems to fix this issue (Linux
> boots and appears to be working correctly with it, but I didn't do any more
> advanced experiments yet).
>
> This points to
> commit dfa8ecd167c1 ("md/raid1: factor out choose_slow_rdev() from read_balance()")
> as the most likely culprit. However, I was running into other bugs in mdadm when
> trying to test this commit directly.
>
> Distribution: Ubuntu 20.04, hardware: a HP 17-by0001nw laptop.

I have been testing this patch carefully:

1. I have been reliably getting deadlocks when adding / removing devices
on an array that contains a component with the write-mostly flag set
- while the array was loaded with fsstress. When the array was idle,
no such deadlocks happened. This occurred also on Linux 6.8.0
though, but not on 6.1.97-rc1, so this is likely an independent regression.

2. When adding a device to the array (/dev/sda1), I once got the following warnings in dmesg on patched 6.10-rc6:

        [ 8253.337816] md: could not open device unknown-block(8,1).
        [ 8253.337832] md: md_import_device returned -16
        [ 8253.338152] md: could not open device unknown-block(8,1).
        [ 8253.338169] md: md_import_device returned -16
        [ 8253.674751] md: recovery of RAID array md2

(/dev/sda1 has device major/minor numbers = 8,1). This may be caused by some interaction with udev, though.
I have also seen this on Linux 6.8.

Additionally, on an unpatched 6.1.97-rc1 (which was handy for testing), I got a deadlock
when removing a bitmap from such an array while it was loaded with fsstress.

I'll file independent reports, but wanted to give a head's up.

Greetings,

Mateusz

