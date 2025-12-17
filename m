Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC37B33508A
	for <linux-raid@vger.kernel.org>; Wed, 17 Dec 2025 06:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765954722; cv=none; b=V/iSScXptzVL41lWYQhzHFyEOFhoARd/lU3zqcHY4T7qSBC92SWD3EJTcmJ1Tc9Ads03j7FtNvnjAfVNFwwqPOB8dO3LxJRJZ331NdXvRpESn6vsRgzcwb2SbZoS+eWZsHGyJvyxDdZn3DyvLxqLq7ljEtiCJPp3215KFR/A6sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765954722; c=relaxed/simple;
	bh=pQu/hBf8L5aDXZ8wtWpyBocE8I4ewyQcJQ+ZRtFkWtU=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=XjWUGFkR1UAEjN5MnxBiM9bDQTXjVRgMX3g1w/RzoggwBgGQakEJPf8olvibWg6bX2jrdB8rbhaQvaytqsNF7s4X7nD+Co2QY+FwEsd1LfFX285QW8jo+sdj1ZwM3z5fb/YTrF98S1Rhb1q5RvWq4F/6QTYi+1xG2zpN4zlgGc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LKxgWmki; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LKxgWmki"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-640c1fda178so10763651a12.1
        for <linux-raid@vger.kernel.org>; Tue, 16 Dec 2025 22:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765954719; x=1766559519; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lqxYc0cyRo71+CzVO7EwjgLjWMeGbD7zfbwtwI9VKnA=;
        b=LKxgWmkij0nWFtxjzvLJXIHU81E94Dh73sd3Ln/q8WBUOsNdZwiue2wdzEWlJP5U5i
         HBNrMGCbpwGFOEOEF/dtuzgZlqJkYQ0WEQncC7WczhMMUAPyTU9p5Px7FX8ZnT4KGaHr
         T5MBkCGbpmDlyFcSyNzhxQkeUExt1WuzLaFTPagtwzvXgFa3MR14WF3IX9d94SFghl2/
         7VbtFR2r+bFW4IZOSi65d9NAN1Hw4BH49yILEKeVY3FpDLI4ghciRg4RNi1X9Qztu25+
         bZ4+3Lx2ZAUSjbdBsv9TL4VK25IkgGGnOGyPlFAt3RzN3FFVh5wKksfEJulKsvWlvQIf
         AJzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765954719; x=1766559519;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lqxYc0cyRo71+CzVO7EwjgLjWMeGbD7zfbwtwI9VKnA=;
        b=g4nAENtJhkTyu+WFbZXKiH84CJ30Y+7ODGxob6nFCT2OfrnlAoGy2sowOHcpxTdVD6
         RkjJvtUVn3Y+H23js8Ww7MLiOBeoc239fJNuHfgVkXuF+ywWZkiakdrylrc0U2lP0uFW
         7Dm1K3iOS9AM1gGldWPTjmTPL4SjmQZXg0tTqKWj5NnH/Z4zuH0fbsPZssq/tASS9WxG
         ERBJSHRZxDKKzRRJNEpy17EBr78UwW0fzLpzs2Ze25ODGzZf00H8hXjlOScUVtmPXN7o
         3EjixCBMIrvy9AU2lgfM3ZV1U8Z71/lqoIFVodCURpi9ubBHAlwqF0PjSc4K0+HNvVR6
         z4jg==
X-Gm-Message-State: AOJu0YxM84wwHwHT9UwsnYsN3GoVqsbCaGAr+72yIf/yXIz+5dFX9bIV
	MmbJd1SJfftLxTcvWr94h//g5CZ1L2JhPNbLiEVww2MfeqmFUztD7Lr1bJ8Kcg4+
X-Gm-Gg: AY/fxX5nyWcdmnMutxE1OH3ALKGjNZxhbSxGdKXYsTCk1zsUC2ywCICkCKZIAr8cNPm
	WK4otKnFy5KEIZKjho2DOWcSjJEvuErddpXQ2EMtPV+3UfpqmecLf61eyjHf1wEvQrIx1mZr8FM
	oM8KSV5esKD2lOhYjEyI9bN+hcXBU3kdudij2VKYSxfo6koZ87E05AKDY/fvQruYeAP76oVTvql
	rvVR8m4563R9AhXgYqEFJCm54vzCRrldEdnvKmhEea1TrxHu0t79L6s23vTeSw/BC+ECgJNDHIj
	Oz6OqZxfhoDDdXoM63/dpRV3Zq//6jg5KthjuGm9FT22bh3enWnTsXIhvUaw/OJZNIN6saOZDg8
	c8kvDhP00xoAIGtMgPEoDy1nvnaFvteXnRwhnDYqUt5mCdkFivf7H37jsbiXRexJfRvgp/MRZHy
	WA9Zy3QhWiPomXEtgtCh7ZPG95ERi7sWSUQILYTnsayd9La4W9pU4=
X-Google-Smtp-Source: AGHT+IF7tVe/11jCgOYMgyTJLOXY95eapUgqKbFsjetsbIFF9w+QVVY5lbU+P/BVoBHp4tsesLBlqw==
X-Received: by 2002:a05:6402:2792:b0:64b:428a:c666 with SMTP id 4fb4d7f45d1cf-64b428ac732mr884024a12.25.1765954718984;
        Tue, 16 Dec 2025 22:58:38 -0800 (PST)
Received: from [192.168.179.27] (p57afaeaa.dip0.t-ipconnect.de. [87.175.174.170])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64b3f4ea465sm1587542a12.5.2025.12.16.22.58.38
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Dec 2025 22:58:38 -0800 (PST)
Message-ID: <b3e941b0-38d1-4809-a386-34659a20415e@gmail.com>
Date: Wed, 17 Dec 2025 07:58:38 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-raid@vger.kernel.org
From: BugReports <bugreports61@gmail.com>
Subject: Issues with md raid 1 on kernel 6.18 after booting kernel 6.19rc1
 once
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

i hope i am reaching out to the correct mailing list and this is the way 
to correctly report issues with rc kernels.

I installed kernel 6.19-rc 1 recently (with linux-tkg, but that should 
not matter).  Booting the 6.19 rc1 kernel worked fine and i could access 
my md raid 1.

After that i wanted to switch back to kernel 6.18.1 and noticed the 
following:

- I can not access the raid 1 md anymore as it does not assemble anymore

- The following error message shows up when i try to assemble the raid:

|mdadm: /dev/sdc1 is identified as a member of /dev/md/1, slot 0. mdadm: 
/dev/sda1 is identified as a member of /dev/md/1, slot 1. mdadm: failed 
to add /dev/sda1 to /dev/md/1: Invalid argument mdadm: failed to add 
/dev/sdc1 to /dev/md/1: Invalid argument - The following error shows up 
in dmesg: ||[Di, 16. Dez 2025, 11:50:38] md: md1 stopped. [Di, 16. Dez 2025, 
11:50:38] md: sda1 does not have a valid v1.2 superblock, not importing! 
[Di, 16. Dez 2025, 11:50:38] md: md_import_device returned -22 [Di, 16. 
Dez 2025, 11:50:38] md: sdc1 does not have a valid v1.2 superblock, not 
importing! [Di, 16. Dez 2025, 11:50:38] md: md_import_device returned 
-22 [Di, 16. Dez 2025, 11:50:38] md: md1 stopped. - mdadm --examine used 
with kerne 6.18 shows the following : ||cat mdadmin618.txt /dev/sdc1: Magic : a92b4efc Version : 1.2 Feature 
Map : 0x1 Array UUID : 3b786bf1:559584b0:b9eabbe2:82bdea18 Name : 
gamebox:1 (local to host gamebox) Creation Time : Tue Nov 26 20:39:09 
2024 Raid Level : raid1 Raid Devices : 2 Avail Dev Size : 3859879936 
sectors (1840.53 GiB 1976.26 GB) Array Size : 1929939968 KiB (1840.53 
GiB 1976.26 GB) Data Offset : 264192 sectors Super Offset : 8 sectors 
Unused Space : before=264112 sectors, after=0 sectors State : clean 
Device UUID : 9f185862:a11d8deb:db6d708e:a7cc6a91 Internal Bitmap : 8 
sectors from superblock Update Time : Mon Dec 15 22:40:46 2025 Bad Block 
Log : 512 entries available at offset 16 sectors Checksum : f11e2fa5 - 
correct Events : 2618 Device Role : Active device 0 Array State : AA 
('A' == active, '.' == missing, 'R' == replacing) /dev/sda1: Magic : 
a92b4efc Version : 1.2 Feature Map : 0x1 Array UUID : 
3b786bf1:559584b0:b9eabbe2:82bdea18 Name : gamebox:1 (local to host 
gamebox) Creation Time : Tue Nov 26 20:39:09 2024 Raid Level : raid1 
Raid Devices : 2 Avail Dev Size : 3859879936 sectors (1840.53 GiB 
1976.26 GB) Array Size : 1929939968 KiB (1840.53 GiB 1976.26 GB) Data 
Offset : 264192 sectors Super Offset : 8 sectors Unused Space : 
before=264112 sectors, after=0 sectors State : clean Device UUID : 
fc196769:0e25b5af:dfc6cab6:639ac8f9 Internal Bitmap : 8 sectors from 
superblock Update Time : Mon Dec 15 22:40:46 2025 Bad Block Log : 512 
entries available at offset 16 sectors Checksum : 4d0d5f31 - correct 
Events : 2618 Device Role : Active device 1 Array State : AA ('A' == 
active, '.' == missing, 'R' == replacing)|
|- Mdadm --detail shows the following in 6.19 rc1 (i am using 6.19 
output as it does not work anymore in 6.18.1): ||/dev/md1: Version : 1.2 Creation Time : Tue Nov 26 20:39:09 2024 Raid 
Level : raid1 Array Size : 1929939968 (1840.53 GiB 1976.26 GB) Used Dev 
Size : 1929939968 (1840.53 GiB 1976.26 GB) Raid Devices : 2 Total 
Devices : 2 Persistence : Superblock is persistent Intent Bitmap : 
Internal Update Time : Tue Dec 16 13:14:10 2025 State : clean Active 
Devices : 2 Working Devices : 2 Failed Devices : 0 Spare Devices : 0 
Consistency Policy : bitmap Name : gamebox:1 (local to host gamebox) 
UUID : 3b786bf1:559584b0:b9eabbe2:82bdea18 Events : 2618 Number Major 
Minor RaidDevice State 0 8 33 0 active sync /dev/sdc1 1 8 1 1 active 
sync /dev/sda1|


I didn't spot any obvious issue in the mdadm --examine on kernel 6.18 
pointing to why it thinks this is not a valid 1.2 superblock.

The mdraid still works nicely on kernel 6.19 but i am unable to use it 
on kernel 6.18 (worked fine before booting 6.19).

Is kernel 6.19 rc1 doing adjustments on the md superblock when the md is 
used which are not compatible with older kernels (the md was created 
already in Nov 2024)?


Many thx !


