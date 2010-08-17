From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: reboot during reshape: superblock incorrect, cannot assemble
Date: Tue, 17 Aug 2010 22:23:54 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1008172222500.8562@uplift.swm.pp.se>
References: <AANLkTikX5+MCicoYShS_=MqpuCr0CMgS1S2n97-k_Aoy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikX5+MCicoYShS_=MqpuCr0CMgS1S2n97-k_Aoy@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joris <joris@v5.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 17 Aug 2010, Joris wrote:

> Various people suggest wiping the superblocks and re-creating the
> array. Is this the best option?

Do not do this, since you were reshaping it'll break "everything".

You didn't provide what version of kernel and mdadm you were using, I 
suggest trying with 3.1.2 or newer at least, 3.1.3 preferrably.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
