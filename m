Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BF5171B0
	for <linux-raid@vger.kernel.org>; Mon,  8 Apr 2024 23:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712619118; cv=none; b=D2awUvJwx78idFJtaNCBEdqRXhbBfaFNhu1PhyIl18bfiv0s4qMqnHDJOqqFL1otsk9YyE8STjUzZLVsWk0Ch5Ciq+v1Ib5YGIkCM8AYoZVzi5l9MaYPsXqEkBoKYRgsepgRYeDPRiSXtDFdzL+otWWLAMhSJQ0xJnpcitKIzzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712619118; c=relaxed/simple;
	bh=qbG3MEoQ1B6o2Vzuce9E/QrBGehqLqJ3vtzqMCQ0los=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=P3XfhGozODm5Lc0InMubNQJ//vYXobjSjbxjVoOJsV1R37HWy6tQ8/cl2uQ8UN6959Ho46OWcHHrhByVyMAc0VD+UEUsV36VjD/AQ9Xul3ZE69H1y68PBxyVYqBdmz9OjOfSxhitARRuYqcHCb6tUYU6eCBAZEDynbh09vc6itw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BFJ4tLqP; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BFJ4tLqP"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-56c5d05128dso5612964a12.0
        for <linux-raid@vger.kernel.org>; Mon, 08 Apr 2024 16:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712619115; x=1713223915; darn=vger.kernel.org;
        h=content-transfer-encoding:to:content-language:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y1/5ah+6OcdQNDxv+m1z5XD/UdrDcBe62SfOCPxq5+U=;
        b=BFJ4tLqPPKqsSdn6rbgmJYz053aHjqNmAGa030BfIDWlvPDEfMraZ1HsKq/yDp9/8m
         6ZUlg28zJiQcf3CmliDKZj6aTYd4P91onLbjpemXaueirYJStkkRvTdeIRCXkz+2vgge
         iWi3vrUn24w0VZdFUkeqsdvNYp6YlOxCq/siSjzswO+U81e8nOnIoYkTmZGOQA96EQtI
         nJ22+i/Wc0Qk7H1ViXs/6K+0e5KJx1091O9+aAj6KCuv50C22cnRlJU5d+XvmMpJqZ4E
         f7xTFjoRzdhPE94kqrA4h008pZixGk4OrlUaUZSbqTZAUwSpqtIb8BhS61I/uy5FZ9JH
         56rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712619115; x=1713223915;
        h=content-transfer-encoding:to:content-language:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Y1/5ah+6OcdQNDxv+m1z5XD/UdrDcBe62SfOCPxq5+U=;
        b=mHb6/P4ukwDGjZIiZ2LCHWXrhV5Nd6cC3enObU1lxQkWgzZcTpZVtMhNl4abjP+Iy0
         5XUtKMZ0LI1GVh+3HY56DGsVg6YbN2Kkrz3gdM/FvrHUQQxcOe2X45BT9EUbgkN/Hgks
         1edPfI6shc10d07ntokbTQQ1WJJPkL99+FPZWu5cP5ZBSQ3rMAMHrhGu5aT48NGo/lOT
         JmxalqGVNs6EpHo5QCdj6yvjpzAZuza0STUPn/EcX+M0K15i4CZuhP/7FaWYCUTbIiao
         yXZK7dwk+PgP9ydx6EYudsJeKydj0VNngL67tLr9SwDBybzB4D3GJrcAZVMWi5sjOzs0
         Z/Fw==
X-Gm-Message-State: AOJu0YzfR4UMLycyj1q2eC9PSZPCw7uLeli5KwIo323TNd2btdYQTbMe
	BDHlyhbzEAfiYoBZO1QfurpVtHej7vtcg8cPEkBNRcOVGeour4vTEpg5sVl5
X-Google-Smtp-Source: AGHT+IEBseSRNcddoqyx1dIWfbN5nxJTf9Hu+SaMaHfQ3wYoBKPTTz6gMisSZWfZrUW//LlBUdVRaw==
X-Received: by 2002:a17:907:9449:b0:a51:ce01:d637 with SMTP id dl9-20020a170907944900b00a51ce01d637mr4239385ejc.63.1712619114935;
        Mon, 08 Apr 2024 16:31:54 -0700 (PDT)
Received: from ?IPV6:2a02:3102:6876:11:5b51:e1db:2186:dbe4? (dynamic-2a02-3102-6876-0011-5b51-e1db-2186-dbe4.310.pool.telefonica.de. [2a02:3102:6876:11:5b51:e1db:2186:dbe4])
        by smtp.gmail.com with ESMTPSA id g15-20020a170906198f00b00a4e2bf2f743sm4925311ejd.184.2024.04.08.16.31.53
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Apr 2024 16:31:54 -0700 (PDT)
Message-ID: <93d95bbe-f804-4d12-bd0d-7d3cc82650b3@gmail.com>
Date: Tue, 9 Apr 2024 01:31:35 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: =?UTF-8?Q?Sven_K=C3=B6hler?= <sven.koehler@gmail.com>
Subject: regression: drive was detected as raid member due to metadata on
 partition
Content-Language: en-US
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

I was shocked to find that upon reboot, my Linux machine was detecting 
/dev/sd[abcd] as members of a raid array. It would assign those members 
to  /dev/md4. It would not run the raid arrays /dev/mdX with members 
/dev/sda[abcd]X for X=1,2,3,4 as it usually did for the past couple of 
years.

My server was probably a unicorn in the sense that it used metadata 
version 0.90. This version of software RAID metadata is stored at the 
_end_ of a partition. In my case, /dev/sda4 would be the last partition 
on drive /dev/sda. I confirmed with mdadm --examine that metadata with 
the identical UUID would be found on both /dev/sda4 and /dev/sda.

Here's what I think went wrong: I believe either the kernel or mdadm 
(likely the latter) was seeing the metadata at the end of /dev/sda and 
ignored the fact that the location of the metadata was actually owned by 
a partition (namely /dev/sda4). The same happened for /dev/sd[bcd] and 
thus I ended up with /dev/md4 being started with members /dev/sda[abcd] 
instead of members /dev/sda[abcd]4.

This behavior started recently. I saw in the logs that I had updated 
mdadm but also the Linux kernel. mdadm and an appropriate mdadm.conf is 
part of my initcpio. My mdadm.conf lists the arrays with their metadata 
version and their UUID.

Starting a RAID array with members /dev/sda[abcd] somehow removed the 
partitions of the drives. The partition table would still be present, 
but the partitions would disappear from /dev. So /dev/sda[abcd]1-3 were 
not visible anymore and thus /dev/md1-3 would not be started.

I strongly believe that mdadm should ignore any metadata - regardless of 
the version - that is at a location owned by any of the partitions. 
While I'm not 100% sure how to implement that, the following might also 
work: first scan the partitions for metadata, then ignore if the parent 
device has metadata with a UUID previously found.


I did the right thing and converted my RAID arrays to metadata 1.2, but 
I'd like to save other from the adrenaline shock.



Kind Regards,
   Sven
