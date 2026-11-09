Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.28.82
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794182870;
	b=2QGQkW+ZOwVPj26oPGkVgGHra2P7ojgGkR2I31jlqCRLSgpUB3utjKKMFXH7YsvqRYfy
	 sI4kjY05LgnYCMTXia7nwJopqjirmNQBw8bvi7U9qUFO3w8BtMnW168TYTOIxVxI0ulLv
	 Mt6NYV4/15kj0g/78q/MYFs9h4vXFJUrAVRxHsvp7P5d8QPySDmH2ZCYIOp3vjpQs6pUJ
	 JtOlG9f4jV/x4Vc0TGxcBp2qokWBymD0hxsc/zoqH+crptNMnbq1itSKDATnIAj9f6dWY
	 0hOl9hWkZDC62+eC2buS/ZTulIajuO1IEmScIV9bczJKWA1W66h+H/9/JMPJbk08H5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794182870;
	h=DMARC-Filter:X-Alimail-AntiSpam:Received:Date:From:To:Subject:Cc:
	 Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=tuLjWHT7O7Uhmb/X83BwnDETIrTG37q5Rvks1VNUKQI=;
	b=vm8NftYmft+Stf4hBYheqOTtZ3LAoFzz/2BGc/gl8MJOCgQhJHnKwaDPzKFwGawKuC+Q
	 5LMPH4CyEXK55448UCLqh5vMTXHawFB0Cu+nqzdhw3Pvc25Auf/FCLOKdzOABqOAtrm2d
	 rNbp9MDAWaz8Q3Wy6ks0th3QiLLzGyqOiaMi12uuYX5DhHD9lvESy/zLkSSUsvf9CESsY
	 8/4uMDymtNQVOhTa7g07XIoXpXHoNc4OSKE2wJkl5VhnGAdj15s3PRs3TuyeaNq/CtlKf
	 3kEaz6IG06rllFcYXasrraSAYsCRXhEhJJnBPHaEOV60diqQXCj4iBc1WWz9+Ao6iyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=e16-tech.com;
	spf=pass smtp.mailfrom=e16-tech.com;
	arc=none smtp.remote-ip=115.124.28.82
Received: from out28-82.mail.aliyun.com (out28-82.mail.aliyun.com [115.124.28.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D74606A31C
	for <linux-raid@vger.kernel.org>; Mon,  9 Nov 2026 00:07:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30D74606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.1487254|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_news_journal|0.0391081-0.000991383-0.9599;FP=16572315342230904156|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033025068124;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=2;RT=2;SR=0;TI=SMTPD_---.jzgZnlg_1794182859;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.jzgZnlg_1794182859 cluster:ay29)
          by smtp.aliyun-inc.com;
          Mon, 09 Nov 2026 08:07:40 +0800
Date: Mon, 09 Nov 2026 08:07:41 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: linux-raid@vger.kernel.org
Subject: panic for md ddf (14disks/raid6) on kernel 6.6.161 but not on kernel 6.12.115
Cc: wangyugui@e16-tech.com
Message-Id: <20261109080740.EF23.409509F4@e16-tech.com>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.83.11 [en]

Hi,

I noticed a panic for md ddf(14disks/raid6) on kernel 6.6.161,
but not happen on kernel 6.12.115.

Call Trace:
 <TASK>
 percpu_ref_kill_and_confirm+0x39/0xc0
 __mddev_suspend+0x5c/0x1e0
 ? __kmem_cache_alloc_node+0x1bb/0x320
 ? _kstrtoull+0x3b/0x90
 raid_disks_store+0x4a/0x190
 md_attr_store+0x84/0x100
 kernfs_fop_write_iter+0x13b/0x1d0
 vfs_write+0x2bf/0x3e0
 ksys_write+0x63/0xe0
 do_syscall_64+0x62/0x90

Do we need some backuport for kernel 6.6.y?
any advice please.

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2026/11/09


