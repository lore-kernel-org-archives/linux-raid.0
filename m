From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Linux Raid performance
Date: Sat, 03 Apr 2010 14:37:37 +1300
Message-ID: <4BB69BE1.5090107@sauce.co.nz>
References: <r2v7efa8a7d1003311242vfa92024ar93ad2123a7b49806@mail.gmail.com>	 <20100331201539.GA19395@rap.rap.dk>	 <g2s7efa8a7d1004012007ibe8b42b6k28a6d2a531fb6103@mail.gmail.com>	 <20100402110506.GA16294@rap.rap.dk>	 <x2q7efa8a7d1004021055oe2e832ccl8877e9171b8f3442@mail.gmail.com>	 <l2j5bdc1c8b1004021739z969b99v6011fcc6fddd470a@mail.gmail.com>	 <4BB69670.3040303@sauce.co.nz> <y2i5bdc1c8b1004021832x283f72f7uea429f24d79b6fa2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <y2i5bdc1c8b1004021832x283f72f7uea429f24d79b6fa2@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Learner Study <learner.study@gmail.com>, linux-raid@vger.kernel.org, keld@dkuug.dk
List-Id: linux-raid.ids

Mark Knecht wrote:

> Richard,
>     Good point. I was limited in my thinking to the sorts of arrays I
> might use at home being no wider than 3, 4 or 5 disks. However for our
> N-wide array as N approaches infinity so do the cycles required to run
> it. I don think that applies to the OP but I don't know that.
>

I said I thought the busiest CPU was the parity generation one, but in 
hindsight this cannot be correct, as it was almost maxed out at half the 
write speed the array achieved when it was empty.

Regards,

Richard
