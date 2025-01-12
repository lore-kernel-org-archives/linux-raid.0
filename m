Received: from wp558.webpack.hosteurope.de (wp558.webpack.hosteurope.de [80.237.130.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3E31BEF9D
	for <linux-raid@vger.kernel.org>; Sun, 12 Jan 2025 19:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736709731; cv=none; b=M71ARN7xmCEuxxC1H5LpIIg2SbtnJ1YU0ROVFT91/AMMOotNMlszryoVaKFB8KtKlBv7Oyg2nJo97vwGNh1MLFS4uE1slTbNupRvV6H0THStbi+BLGVP1an+91h1d2mFJyoY3KSMboBrNu5nuZZ+M8zA/+keYbSiDnWIu9Peh/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736709731; c=relaxed/simple;
	bh=cgLLQCyTQnnEi//hMy0C7mT120dLGOKlaTzPBxvH0Uo=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=Oojs92mC4WYNzwAPy56qvpCY2MX7TsxXWoCVfjZQXn9MtqFZvpInt2479Yp+bSTBKbvjcSr75ZQ3eF7raJzXl+69w9nra37KED2sNemGtEvOoNzoZ5JAw/8POXUFliRsLXx25PfJOAwVDohKVGSLvsedc+jGlxFExhHemhRHTtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=peter-speer.de; spf=pass smtp.mailfrom=peter-speer.de; dkim=pass (2048-bit key) header.d=peter-speer.de header.i=@peter-speer.de header.b=HEr0u7qf; arc=none smtp.client-ip=80.237.130.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=peter-speer.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peter-speer.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=peter-speer.de header.i=@peter-speer.de header.b="HEr0u7qf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=peter-speer.de; s=he112996; h=Content-Transfer-Encoding:Content-Type:
	Subject:From:To:MIME-Version:Date:Message-ID:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=lfr3Tf/BM6MjS7Ebll7D0cUTJ4cpe0txAoppC+oSV5c=; t=1736709729; x=1737141729; 
	b=HEr0u7qfdseefzLZ5lsTcOpucUALqGbXDir23sEMCmS+/nRPCt731ehcFYp1e3MtTPDSdWz9b/l
	kLHhwm1ObCKB19cKTR88SRJw6mZ7u+0QqL1FSRcDULjdLCk8eNRn8pAjG3vT8ypJQ7TraJSvsFFFL
	T5S0HfxCw9wRnIPPR7iXvagsd04odDMhcGaf12MIbFp5tQhdMd7tzEGBETqPU1KHMdab01zgrahpZ
	7Gkiy/IVbtq1S2dHV+BQrn/HsD5jzoQba8dOn+cXZ/9dqgxsoIrWaczYjH3QZd9H49vDbShfZqra7
	vQGlKGgD18lnOgnm93+wddAxNI9G5MwktcbQ==;
Received: from ip-109-090-112-146.um36.pools.vodafone-ip.de ([109.90.112.146] helo=[192.168.122.235]); authenticated
	by wp558.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
	id 1tX3E5-0067jP-1s;
	Sun, 12 Jan 2025 20:02:22 +0100
Message-ID: <c8b2fb3b-80c5-464f-aaa7-0883d5689193@peter-speer.de>
Date: Sun, 12 Jan 2025 20:02:19 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-raid@vger.kernel.org
Content-Language: de-DE
From: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Subject: RAID 1 | Extending Logical Volume
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;stefanie.leisestreichler@peter-speer.de;1736709729;26e6d0d9;
X-HE-SMSGID: 1tX3E5-0067jP-1s

Hi.
I have the system layout shown below.
Can I safely use

lvextend -L +50GB /dev/mapper/vg_raid1-root
and after that
resize2fs /dev/mapper/vg_raid1-root

Thanks,
Steffi

├scsi 0:0:0:0 ATA      WDC WD10EFRX-68F {WD-WCC4J3ADUUY8}
│└sda 931.51g [8:0] Partitioned (dos)
│ └sda1 931.51g [8:1] MD raid1 (0/2) (w/ sdb1) in_sync 'speernix15:0' 
{68c0c9ad-82ed-e879-2110-f4279f31c140}
│  └md0 931.39g [9:0] MD v1.2 raid1 (2) clean 
{68c0c9ad:82ede879:2110f427:9f31c140}
│   │                 PV LVM2_member 326,70g used, <604,68g free 
{hHvrtB-7XOz-L6j6-AnXd-Q3Wh-uHqw-bQ3RQS}
│   └VG vg_raid1 931,38g <604,68g free 
{mopUew-B2i4-9fmo-mlXP-Z8C3-nPYO-XM56AY}
│    ├dm-3 224.26g [253:3] LV home ext4 
{8ee8d203-f306-4846-93fe-225b018f2965}
│    │└Mounted as /dev/mapper/vg_raid1-home @ /home
│    ├dm-1 93.13g [253:1] LV root ext4 
{9f9568cf-d48a-4690-97a8-14576d724daf}
│    │└Mounted as /dev/mapper/vg_raid1-root @ /
│    └dm-2 9.31g [253:2] LV swap swap {9fbbac0f-0d49-47b0-a50b-d293f19f23ef}
├scsi 1:0:0:0 ATA      ST1000NM000A-2J3 {WJB01MEZ}
│└sdb 931.51g [8:16] Partitioned (dos)
│ └sdb1 931.51g [8:17] MD raid1 (1/2) (w/ sda1) in_sync 'speernix15:0' 
{68c0c9ad-82ed-e879-2110-f4279f31c140}
│  └md0 931.39g [9:0] MD v1.2 raid1 (2) clean 
{68c0c9ad:82ede879:2110f427:9f31c140}
│                     PV LVM2_member 326,70g used, <604,68g free 
{hHvrtB-7XOz-L6j6-AnXd-Q3Wh-uHqw-bQ3RQS}
