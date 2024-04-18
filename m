Received: from ciao.gmane.io (ciao.gmane.io [116.202.254.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB0416C685
	for <linux-raid@vger.kernel.org>; Thu, 18 Apr 2024 22:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.202.254.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713478371; cv=none; b=Otnb2VS/i3QvuRD9UEKJVYBVN1MhSiWvkog3tQmC7N+s7P3XXoXC5DUa40YL74Zm/cNNNnMpue8SZSAFE9lSXH5lGRbAevOSWPI9Ph2BJ10NOTH42ITBkZ1ekKdH47iYO0xxPsmMrwGZjUvHGlTZWiV7QFddEFOFYBXB8/BZal0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713478371; c=relaxed/simple;
	bh=NG3iJ2z5d80JftNaGLVis8QWim7AnGfYM2h3dCaUVvQ=;
	h=To:From:Subject:Date:Message-ID:References:Mime-Version:
	 Content-Type:In-Reply-To; b=gFsrSk0ScqqcNXVYrw02ZuXAlzF/AtcyhAGLiRfXrXk8/mtKaCrrnwPX6UWxvjl3CSeUZh2/6VytR1RBDn9GyU1YxGCMfRhEX/oXw6C01beDihM1NIl3qzmdQW2FKcqEUKeoLIdLUsoJ3l6PivYKIAs8MV+U5/Z2ISVOLISvzQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=m.gmane-mx.org; arc=none smtp.client-ip=116.202.254.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=m.gmane-mx.org
Received: from list by ciao.gmane.io with local (Exim 4.92)
	(envelope-from <linux-raid@m.gmane-mx.org>)
	id 1rxZuu-0000uK-1L
	for linux-raid@vger.kernel.org; Fri, 19 Apr 2024 00:07:40 +0200
X-Injected-Via-Gmane: http://gmane.org/
To: linux-raid@vger.kernel.org
From: =?UTF-8?Q?Sven_K=C3=B6hler?= <sven.koehler@gmail.com>
Subject: Re: regression: drive was detected as raid member due to metadata on
 partition
Date: Fri, 19 Apr 2024 00:07:14 +0200
Message-ID: <uvs5j5$2ri$1@ciao.gmane.io>
References: <93d95bbe-f804-4d12-bd0d-7d3cc82650b3@gmail.com>
 <90ebc7c2-624c-934b-1b5b-e8efccfda209@huaweicloud.com>
 <08a82e10-dc6b-41f9-976a-e86a59cfd54d@gmail.com>
 <fe14b4b4-9ab2-93f5-85a8-3416d79dffa2@huaweicloud.com>
 <5a4a9b82-2082-4d25-906d-ee01b10fad65@gmail.com>
 <cffea7de-edf4-c97b-3fc7-c87038123593@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
User-Agent: Mozilla Thunderbird
Content-Language: en-US
In-Reply-To: <cffea7de-edf4-c97b-3fc7-c87038123593@huaweicloud.com>

Am 18.04.24 um 09:31 schrieb Li Nan:
> 
> 
> 在 2024/4/14 5:37, Sven Köhler 写道:
> 
> [...]
> 
>> The Arch kernel has RAID autodetection enabled. I just tried to 
>> reproduce it. While mdadm will not consider /dev/sd[ab] as members, 
>> the kernel's autodetection will. For that you have to reboot.
>>
> 
> It is not about autodetection. Autodetection only deals with the devices in
> list 'all_detected_devices', device is added to it by blk_add_partition().
> So sdx will not be added to this list, and will not be autodetect.

I apologize. It's not the kernel autodetection. Arch Linux is using udev 
rules to re-assemble mdadm array during boot. The udev rules execute

   /usr/bin/mdadm -If $name

where $name is likely a device like /dev/sda. I'm not sure yet whether 
the udev rules have changed or mdadm has changed.

I will continue digging.


