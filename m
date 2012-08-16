From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: raid5 to utilize upto 8 cores
Date: Thu, 16 Aug 2012 09:03:03 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1208160901010.27104@uplift.swm.pp.se>
References: <CAEyJA_sSzmgcK6miWfxC4jgvbH7WJ_hgZhnmFABaK9r7X=SLDQ@mail.gmail.com> <502C8C18.5070501@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <502C8C18.5070501@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: vincent Ferrer <vincentchicago1@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 16 Aug 2012, Stan Hoeppner wrote:

> performance, and decreasing drive life.  That's not an issue with SSD,
> but multiple rebuilds is.

I remember seeing MD waiting to rebuild when it detects components being 
on the same physical devices, doesn't it do that (anymore)?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
