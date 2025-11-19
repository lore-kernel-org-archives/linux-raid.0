Received: from amazon.4net.rs (amazon.4net.rs [159.69.148.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5A62DCF72
	for <linux-raid@vger.kernel.org>; Wed, 19 Nov 2025 08:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.148.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763542015; cv=none; b=L/jB4FWusvzppDp/74qJp3meNjoJsoQoZ23bjOvzZgXwEeCyH2s8w8Wrh1vkVNwq+cZokNjIXaKR6esqjoq0q8vRt0HLUiTO+qKA/JmJw5fm+cQbsmzteY8kNIcW4lF/yMLJcyRfREeA9CsoGXJAGm6Zui7cxI6da14ZMI5UiK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763542015; c=relaxed/simple;
	bh=srjKv+YSqbMIm984FFHG6aNIY0FRG97qKu1jLxENXB8=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=NvzCLPDmkbFztGGlnnv6ebh/329HL5HuPXkzpM/ev42pCE5em9vyVRECHDm5T1YI5hL5TeWociNfT8tHXdE2MlAyRA7AsRa8WT19EkSSKy1na44ZjuuJUYFbXg+oNZHCWO8VUKrcK2W753GaNXcRFWB2os6G0DEnwktk3xCG3ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=4net.rs; spf=pass smtp.mailfrom=4net.rs; dkim=pass (1024-bit key) header.d=4net.rs header.i=@4net.rs header.b=rULP0NgJ; arc=none smtp.client-ip=159.69.148.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=4net.rs
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=4net.rs
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=4net.rs header.i=@4net.rs header.b="rULP0NgJ"
Received: from localhost (amazon.4net.co.rs [127.0.0.1])
	by amazon.4net.rs (Postfix) with ESMTP id 718F863BDF66
	for <linux-raid@vger.kernel.org>; Wed, 19 Nov 2025 09:46:51 +0100 (CET)
X-Virus-Scanned: amavis at 4net.rs
Received: from amazon.4net.rs ([127.0.0.1])
 by localhost (amazon.dyn.4net.co.rs [127.0.0.1]) (amavis, port 10024)
 with ESMTP id 2zSeKbDYFFrm for <linux-raid@vger.kernel.org>;
 Wed, 19 Nov 2025 09:46:50 +0100 (CET)
Received: from mail.4net.rs (unknown [10.188.221.8])
	by amazon.4net.rs (Postfix) with ESMTPS id BAAB863BDABE
	for <linux-raid@vger.kernel.org>; Wed, 19 Nov 2025 09:46:50 +0100 (CET)
Received: from localhost (green.4net.co.rs [127.0.0.1])
	by mail.4net.rs (Postfix) with ESMTP id 3AC621623CA83
	for <linux-raid@vger.kernel.org>; Wed, 19 Nov 2025 09:46:50 +0100 (CET)
X-Virus-Scanned: amavis at 4net.rs
Received: from mail.4net.rs ([127.0.0.1])
 by localhost (green.4net.rs [127.0.0.1]) (amavis, port 10024) with ESMTP
 id LGgFLAHa6oWe for <linux-raid@vger.kernel.org>;
 Wed, 19 Nov 2025 09:46:50 +0100 (CET)
Received: from mail.4net.rs (green.4net.co.rs [127.0.0.1])
	by mail.4net.rs (Postfix) with ESMTP id C724316240D89
	for <linux-raid@vger.kernel.org>; Wed, 19 Nov 2025 09:46:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=4net.rs; h=message-id:date
	:mime-version:to:from:subject:content-type
	:content-transfer-encoding; s=4netrs; bh=L6GzHI66w4h3MZOY4yfVk+Y
	hKyU=; b=rULP0NgJ5dp0ZsJHjc0gp/XKvN0oXlphuxtwD/Y+hxg/Nov2MZyZmSR
	JHsZ/cRs9myH55GmV65wLyQN7AZE9m1pqvcMNDflucUey5tgDEhKlOjLERNo/512
	8RcXZCYTlEPdXIc2qrudBs8Qy5+1NU0a/7pRFnNA8oeD5XhsdT20=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=4net.rs; h=message-id:date
	:mime-version:to:from:subject:content-type
	:content-transfer-encoding; q=dns; s=4netrs; b=anhkWLWlPqRn6CAd7
	iKR8fHTKIYVKymBeRfFQb/UpUPWseEAvI3reP/Y2q6q4Ccxdv7hNxrIm3fIlbXSa
	njMQaJaJMIM2t7jF8zrp6hh9iPp5mxo4AA+tcaarDUxZtvZoa8mf5UwRHCBbKpyl
	rC1Bt9t7tnLazFshH1sCkRb+ts=
Received: from [192.168.222.30] (4net.co.rs [89.216.99.97])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.4net.rs (Postfix) with ESMTPSA id 9BEF01623CA83
	for <linux-raid@vger.kernel.org>; Wed, 19 Nov 2025 09:46:48 +0100 (CET)
Message-ID: <54997616-f1c6-489f-8fa1-8b7d733a9b62@4net.rs>
Date: Wed, 19 Nov 2025 09:46:48 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-raid@vger.kernel.org
Content-Language: en-US
From: Sinisa <sinisa@4net.rs>
Subject: RAID resyncing with only one device
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello everyone!

Today, after an unexpected power failure (dead power supply), I have seen something I have never seen before (30+ years in IT):

2025-11-19 09:24:02 green:/ # cat /proc/mdstat
Personalities : [raid1] [raid10]
md4 : active raid10 sdb2[1] sda2[0]
5666406400 blocks super 1.2 4096K chunks 2 offset-copies [2/1] [U_]
resync=DELAYED
bitmap: 42/43 pages [168KB], 65536KB chunk

md3 : active raid10 sda1[0]
2147344384 blocks super 1.2 4096K chunks 2 offset-copies [2/1] [U_]
[=>...................]  resync =  6.8% (146411904/2147344384) finish=623207095.3min speed=0K/sec
bitmap: 16/16 pages [64KB], 65536KB chunk

md2 : active raid10 nvme1n1p5[0] nvme0n1p5[1]
125761536 blocks super 1.2 1024K chunks 2 offset-copies [2/1] [_U]
resync=DELAYED
bitmap: 1/1 pages [4KB], 65536KB chunk

md6 : active raid10 nvme0n1p6[1]
587628544 blocks super 1.2 1024K chunks 2 offset-copies [2/1] [_U]
[=======>.............]  resync = 38.3% (225448960/587628544) finish=112803849.6min speed=0K/sec
bitmap: 5/5 pages [20KB], 65536KB chunk

md1 : active raid10 nvme0n1p4[1] nvme1n1p4[0]
262010880 blocks super 1.2 1024K chunks 2 offset-copies [2/2] [UU]
bitmap: 2/2 pages [8KB], 65536KB chunk

md0 : active raid1 nvme1n1p3[2] nvme0n1p3[1]
511936 blocks [2/1] [_U]
resync=DELAYED

unused devices: <none>


Devices "md3" and "md6" show "resync progress" and it is moving on, but there is no second device.
I for sure know that both "nvme1" and "sdb" disks have been in "failed" state before loss of power, because I was delaying the restart (so I could replace them) 
until the weekend.

After I have replaced the failed power supply, both  "nvme1" and "sdb"  came back online just as if nothing happened, they are working fine, no bad sectors (nor 
uncorrectable, nor pending, 100% health on both SSD and HDD).

About the machine: it is a desktop class home "server", MSI PRO B650-P, Ryzen 7 7700X, 128GB RAM, single Chieftec power supply, 2x Samsung 1 TB 980 Pro, 2x 
Toshiba 8TB enterprise HDD,  APC Back UPS, openSUSE Tumbleweed with kernel 6.17.5.

Update: while I was writing this, "md6" finished resync:

[Wed Nov 19 09:32:30 2025] [   T1127] md: md6: resync done.
[Wed Nov 19 09:32:30 2025] [   T1168] md: recover of RAID array md2

and /proc/mdstat now shows

md6 : active raid10 nvme0n1p6[1]
587628544 blocks super 1.2 1024K chunks 2 offset-copies [2/1] [_U]
bitmap: 5/5 pages [20KB], 65536KB chunk


I'tt try to re-add missing devices later and see what will happen...


-- 
Srdačan pozdrav / Best regards / Freundliche Grüße / Cordialement / よろしくお願いします
Siniša Bandin

