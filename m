From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: How assemble this array? All devices listed as spares and busy.
 Huh? Unclear what this means.
Date: Mon, 27 Jun 2016 20:18:37 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1606272017530.28955@uplift.swm.pp.se>
References: <CAM=c-cABEJMShf0m=evmehcfuCM5pBcp5iFOOAi5V1XRa2ekiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAM=c-cABEJMShf0m=evmehcfuCM5pBcp5iFOOAi5V1XRa2ekiQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: dave dowless <ddowless@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 27 Jun 2016, dave dowless wrote:

> I ended up rebooting, but a force assemble returns all devices are busy. 
> What gives?

That typically indicates that the array is already running. "mdadm --stop 
/dev/mdX", and try again.

There should be nothing in "cat /proc/mdstat" when you do assemble.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
