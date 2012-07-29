From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: problem hot-adding spare / internal bitmap problem?
Date: Sun, 29 Jul 2012 10:32:34 +0300
Message-ID: <CAGRgLy4VEa5b0bJ8g__HaZaVWdEsA75mg2Mg3Rp3K8cTutTxwg@mail.gmail.com>
References: <alpine.DEB.2.00.1207290601000.27169@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1207290601000.27169@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> write(4,
> "bitm\4\0\0\0~\332I'%L\33n\363\303\24J\237AY\322\267\252J\0\0\0\0\0"...,
> 2560) = -1 EINVAL (Invalid argument)

This mdadm version has a problem of opening the device with O_DIRECT,
but then using an unaligned buffer for write().
Your strace doesn't contain the open() command for fd=4, so please
look earlier in your strace to confirm the O_DIRECT part. Also,
confirm that this write that returns EINVAL uses an unaligned buffer.

Once you confirmed these, grab mdadm 3.2.4 or the following commit:
6ef8905 super1: make aread/awrite always use an aligned buffer.

Thanks,
Alex.
