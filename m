From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Recovery Raid6 Degraded
Date: Mon, 13 Apr 2015 22:38:58 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1504132234220.16871@uplift.swm.pp.se>
References: <CACsoFmjWW7mqSA8OKZZEPhpFidf-exSMm771ZOp0TssSYydcrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACsoFmjWW7mqSA8OKZZEPhpFidf-exSMm771ZOp0TssSYydcrw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Emanuel Domingos <emanuelsdrock@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 13 Apr 2015, Emanuel Domingos wrote:

> guys, following guidelines on wiki, before to try recreate my array
> I'm sending this mail to listen the experts.

Good choice!

> I would like to aid as a problem in my raid arrays after a crash in
> which I had to restart the server.

What kernel version and mdadm version are you running?

My first recommendation would be for you to compile latest mdadm from 
source:

"git clone https://github.com/neilbrown/mdadm"

Then compile it and use that to do the --assemble-force operation that 
failed before. This has helped others.

If it still doesn't work, please provide dmesg output from when that 
operation occured.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
