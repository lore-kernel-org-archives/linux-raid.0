From: "Eric Wood" <eric@interplas.com>
Subject: Re: raid-1 with  ide-scsi emulation and mkswap failure
Date: Thu, 15 Apr 2004 10:54:22 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <003801c422f9$89e40640$b100000a@M145Primary>
References: <007401c422f0$baec4bc0$b100000a@M145Primary>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Okay, Catalin showed me my goof on the mkswap problem.  So maybe redoing the
swap will keep the kernel from panicing any more.
-Eric Wood

----- Original Message ----- 
From: "Eric Wood"
> # swapoff -a
> # mdadm --stop --scan

----- Original Message ----- 
From: "Catalin BOIE"> > # swapoff -a
> > # mdadm --stop --scan
>
> Why did you stopped the array?
> It must be started when you do mkswap /dev/md3.

Ah, your absolutely right! Duh!!

Thanks,
-eric wood

