From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: [PATCH] [PPC32] ADMA support for PPC 440SPe processors.
Date: Sat, 17 Mar 2007 12:09:31 -0700
Message-ID: <e9c3a7c20703171209m55fd9dfsbba0e4fff5c6350d@mail.gmail.com>
References: <20070315232956.37DAB353A6C@atlas.denx.de>
	 <200703170909.13869.sr@denx.de>
	 <e9c3a7c20703171117w7989adfehda99416265eef906@mail.gmail.com>
	 <200703171943.27465.sr@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200703171943.27465.sr@denx.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Roese <sr@denx.de>
Cc: linuxppc-dev@ozlabs.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> The current implementation builds on my embedded PPC4xx system without any
> disks the objects async_tx.o and xor.o into the kernel which I definitely
> don't need and want. And I get something like:
>
> async_tx: api initialized (sync-only)
> xor: measuring software checksumming speed
>    8regs     :   145.000 MB/sec
>    8regs_prefetch:   115.000 MB/sec
>    32regs    :   176.000 MB/sec
>    32regs_prefetch:   135.000 MB/sec
> xor: using function: 32regs (176.000 MB/sec)
>
> upon bootup.
Understood I'll change it so that xor.o and async_tx.o are off by default.

>
> Best regards,
> Stefan

Dan
