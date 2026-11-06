Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.170
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793999874;
	b=y97u9vKAJttFIj6V+WtAHe44I+a6fcwlRsLB7BqcwdczqcziDNP8rNvSL6ZHjQKNyFRU
	 WXs8qwNGYX8DWF74ImWrkg7DMbGseTqfK23Z6R8mZoT3/wellJIw+6WMQlc9iF7Vi6/r6
	 1QGd6Bxe6bPIgAhlYlKKrFH9coR2bcK2xniwEEN27T2606AmgSFzCVxDjAckqjQTpM14Y
	 4jjigmE+Y3yjcuqV+EXow7AEgZ3s6+7VSMEfMOZXC4C+BzUzcg/fW8CDGIBcDqkY210Mj
	 kxOJJMj8toDQfVYdQ93aa+r4CKN1d7m/yeOic5VX9Sq36IpfmPZNbyeNQ4QSa3HBQZA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793999874;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=2Y2QMKHFqDW0NHjVuOKUbThddEaPHy26Bs27ZfqY8i0=;
	b=q47zn6KpbBLqt2fRA/6k4AJBV8pymuDdhrtTmsiuHI+7vErt5gnxVAZF85+Taj4gENEZ
	 RwEGK+yLBY8+zb0y07y4+cCHaLFZHlpCs+sNbk/Go0qyFV5VxJ0r7nVpP/htgHPD+J9dd
	 Wp6K3N02srXhsD8kjjxCl6eiOPGH8Bn1r/nbzk5bvt2N6+7b2JMMo7WKpid4HElsM16K9
	 /T0JDUmpsk+pv7PeLmlEGDGGTlyuIADgFLBJNea4Gl/Xl6nkMrspYs3Xx0D/HWVSUhI1+
	 2rmwf6LJQ6lF80boMTMKVPV3wFqt0kboKp3MFVlQTc9FcmaTghtwbWDfiSmG9poj0xw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pkm-inc.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=pkm-inc.com header.i=@pkm-inc.com header.a=rsa-sha256 header.s=google header.b=XLcI0b1s;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7277E606A326
	for <linux-raid@vger.kernel.org>; Fri,  6 Nov 2026 21:17:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7277E606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pkm-inc.com header.i=@pkm-inc.com header.a=rsa-sha256 header.s=google header.b=XLcI0b1s
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-33c10faf6easo152452eec.0
        for <linux-raid@vger.kernel.org>; Fri, 06 Nov 2026 13:17:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793999873; cv=none;
        d=google.com; s=arc-20260327;
        b=GkeKyYnutVo2eVSUra1U9gCCVowMaT9poPh+9lqjJK8YTyXUCCh1Hy+THgQAckrAzM
         Ur1T9vW0i+sF0D59K3osPNQBKhf2NtokiH246NHrfMP8N/dDdfewNbI84DVqSSioGWTn
         yCdJGetayDwx4HZ3yUjHUFBohDODmUU1pIXUoFzXOFpOVhvay4MWpE2woUKRR/ySVc6a
         1NiVgAtogv7PjUCicnLzk6nbdLXuosxsNPjWlVpA4IqQXLZMvZ3+/MSq4ayxJ2IQ1fNU
         zO3tFyPki3Z+KCokMfbsmBUIyUeNQh+pxsbd+/U7Sb8jKe9qUROlFvjfrSQ6sGoGn+F8
         jedg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=2Y2QMKHFqDW0NHjVuOKUbThddEaPHy26Bs27ZfqY8i0=;
        fh=1GuFve6lNc9hvsAuITm1txFvOHQT2vosSP7ICvc8qdc=;
        b=KP7ktntOB7gC06jsNpF+3ImB0zitNdPMIP5ZOEAWyqRjT+8N7eA9HPbiaHugg1svSe
         zik0bYrKUCvnRTtp11Eg5dJ+ce4JJ6X01q1ryOY/jIyQ6QaWRFj7cKaVO4MIqk+ilhRA
         b92TAq7zClthx0CUTeB5EIFn+lP7DpRoTNvtBMwFAUi2m1rhwG2gy6mttKZN+B2y7HoB
         bjQEWv+qj5K3D/XrM2PW/HWLH9EUvfyb+L5Fw3k9jgFB4aApOxqemkzV+hcEXnKnS6VX
         WEhSQppr0aGS4a7Nu3Kbzr6MXmn56miutd0nBjUXOZOo0PDvt7MWVHIQrVQBFiPZKn8G
         prFA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1793999873; x=1794604673; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2Y2QMKHFqDW0NHjVuOKUbThddEaPHy26Bs27ZfqY8i0=;
        b=XLcI0b1sjYeaPRM1aEs0uGul+62yBxbuKiK8MO3AYp6s6RdcAv6vl4xSI+tO5eAZkx
         QCl7seMMsF3Lac5MLzyJZV9hS48kYUffSGZ8xpXsFmND4MGJ/gOBQqm+FdSNvZjQJM2g
         b7C+RKW0ku0LoojnHUex+LLUiyvZgSGZBcMnVNCDOO2E4lxRKn1o4skGhahUan1qBTCa
         6lqBJNjHtI7StRtwgb7KWx8yjM+aGcptb5JTRm/qSNsiHVVZBkuyIs5cYcD6RpJE6IA6
         TDv3FGaulmwNyKBzhnXsjHtSkxC+MU+IWFnsVRmz3BLZqo9jUGp0EdWiBXtabGPfaziQ
         sydg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793999873; x=1794604673;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=2Y2QMKHFqDW0NHjVuOKUbThddEaPHy26Bs27ZfqY8i0=;
        b=dqNxnX7LKKGuQXuD41gFc5hq9L+sKqH7VzrioTbltjOKEFxFS4M5RRCm4acESJFTnL
         eVjZwlrHM0INBMKW+D/iZj0SgoCWhC2mvUXc5GWO3XbJDW+oEcPng2jyCBvHUsMAS2bu
         a5njTDn5RoM519clhEpkg6+a4r3bvzAan6KEINRwFzE3I/ZPXoNrRmMzb71TJr+1OAlx
         ImIrFLBJmK01EHtHrYNhZGinAjZ7VccjBBhVgFqAeaqSdOEDcReVzMmCO1ZCZrPZriAt
         eMVEPuVL9sZvygeCbGBov8vxykiCCGUQ/theWRA0FGdpEKi4Y97sOOH0byIK5lCET4zE
         RMtg==
X-Gm-Message-State: APuU4Z/3n/7D7AkgwHLcdOvBNPg+wdDcPnu6EVPo8erzrpMLis4Qimzq
	CNE5AtPOwQBLRr/rM91XW8+gX7S5j6z23KD98zJfXu2D9D6+/hwMI7Nt999yD6l+jLgneTSeZl1
	BgRBagZOmROiAFmn4BTSj7g3016063q0=
X-Gm-Gg: AYBFou0jbons9PyNdgHkDgHhY2rY9vSax/EJ0fbrYsme8+/wpw3ToBifvJagbnwZGgH
	xzF3XOe458To16YJRVob5cHtOXXzUZP9joHyQPrsxqYWByPx4nKZ2pOwlP6Aj6DTxGDjEQQztKr
	yJYuewKk66MFb1VmsLd+2V9C4QilvinV++xLVWy3NSLXccU81wiQAWj7dzZeqYRCSWdW1coTXAJ
	OJ2SAvej2qF5YZwXH4u9itQWH5Y697Wluvgnxd0pdnXfg1G1/2sr58V5axFVGokXreZm6zouqjG
	sLt3XALjBmSoArEA75ERTSvz7vfbFtClh54Dsu8aXTWsiJQ5c+2cueyoYyy119b2En0NSdcrFU1
	9KGH/87PMCQt8/zkhWw8H7aW1j7+x2LIKEqka58H1lqkQiPjHktcJgusI8w==
X-Received: by 2002:a05:693c:8852:b0:36c:a1bc:6115 with SMTP id
 5a478bee46e88-36f6f98d2f9mr7196331eec.0.1793999873134; Fri, 06 Nov 2026
 13:17:53 -0800 (PST)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAAiJnjr6fxY1LKmrYbradXPoxW+cS28uLo6VxYkwLxXsTcY4gg@mail.gmail.com>
In-Reply-To: <CAAiJnjr6fxY1LKmrYbradXPoxW+cS28uLo6VxYkwLxXsTcY4gg@mail.gmail.com>
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Date: Fri, 6 Nov 2026 22:17:41 +0100
X-Gm-Features: AclHuK90E8Ig-Zw6mrMxhUyW5WXAVelgZVaoNbxuG0yzDtt3ykgo8_ZmPjdSqUo
Message-ID: <CALtW_ajx9GGRh9US=KxKFPf6KSefpJtYhzUVOo7usO_TVDs-1g@mail.gmail.com>
Subject: Re: xor_gen() md-raid6 performance improvement
To: Anton Gavriliuk <antosha20xx@gmail.com>
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> [root@memverge3 ~]# fio --name=test --rw=write --bs=2048k
> --filename=/dev/md111 --direct=1 --numjobs=1 --iodepth=64 --exitall
> --group_reporting --ioengine=io_uring --runtime=600 --time_based=1
> test: (g=0): rw=write, bs=(R) 2048KiB-2048KiB, (W) 2048KiB-2048KiB,
> (T) 2048KiB-2048KiB, ioengine=io_uring, iodepth=64
> fio-3.43-31-gbfffd
> Starting 1 process
> Jobs: 1 (f=1): [W(1)][100.0%][w=7438MiB/s][w=3719 IOPS][eta 00m:00s]
> test: (groupid=0, jobs=1): err= 0: pid=4837: Fri Nov  6 17:02:31 2026
>   write: IOPS=3791, BW=7582MiB/s (7951MB/s)(4443GiB/600013msec)
>     slat (usec): min=8, max=3073, avg=35.39, stdev=14.87
>     clat (usec): min=2334, max=44420, avg=16845.30, stdev=3951.02
>      lat (usec): min=2375, max=44455, avg=16880.69, stdev=3955.63
>
>
Nice improvement
Run the same test using a single drive, in ideal case the performance should
be 4x of a single drive.
