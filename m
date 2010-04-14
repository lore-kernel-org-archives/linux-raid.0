From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux Raid performance
Date: Wed, 14 Apr 2010 16:50:35 -0400
Message-ID: <4BC62A9B.5030706@tmr.com>
References: <r2v7efa8a7d1003311242vfa92024ar93ad2123a7b49806@mail.gmail.com>	 <20100331201539.GA19395@rap.rap.dk>	 <g2s7efa8a7d1004012007ibe8b42b6k28a6d2a531fb6103@mail.gmail.com>	 <20100402110506.GA16294@rap.rap.dk>	 <x2q7efa8a7d1004021055oe2e832ccl8877e9171b8f3442@mail.gmail.com> <l2j5bdc1c8b1004021739z969b99v6011fcc6fddd470a@mail.gmail.com> <4BB69670.3040303@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB69670.3040303@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Mark Knecht <markknecht@gmail.com>, Learner Study <learner.study@gmail.com>, linux-raid@vger.kernel.org, keld@dkuug.dk
List-Id: linux-raid.ids

Richard Scobie wrote:
> Mark Knecht wrote:
>
>> Once all of that is in place then possibly more cores will help, but I
>> suspect even then it probably hard to use 4 billion CPU cycles/second
>> doing nothing but disk I/O. SATA controllers are all doing DMA so CPU
>> overhead is relatively *very* low.
>
> There is the RAID5/6 parity calculations to be considered on writes 
> and this appears to be single threaded. There is an experimental 
> multicore kernel option I believe, but recent discussion indicates 
> there may be some problems with it.

That is being polite. With that option set just doing a 'check' on a 
raid-5 will generate 100s of threads and max out all cores. I was trying 
to run the experimental FC13 64 bit kernel, and all of a sudden the 
machine came to a crawl and the cpu use went to 95%+ on all cores. Also 
drove the CPU temp way up, so I have to regard this as unsuitable for 
anything but light testing.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

