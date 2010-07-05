From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Write-intent bitmap decreases or increase performance of RAID5?
Date: Sun, 04 Jul 2010 20:11:23 -0400
Message-ID: <4C31232B.1080700@tmr.com>
References: <20100629201153.GA13018@localhost> <20100630111854.006ec4d0@natsu> <alpine.DEB.1.10.1006300729150.8623@uplift.swm.pp.se> <20100630115927.090751dd@natsu> <alpine.DEB.1.10.1006300857300.8623@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1006300857300.8623@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Roman Mamedov <roman@rm.pp.ru>, Shaochun Wang <scwang@ios.ac.cn>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mikael Abrahamsson wrote:
> On Wed, 30 Jun 2010, Roman Mamedov wrote:
>
>> This is not necessary. See the dd man page about the conv=fdatasync 
>> switch.
>> You can even test with just 256 MB this way, and still get an extremely
>> accurate result.
>
> You're right, for writing this is ok. For read tests it's important to 
> use more than ram though, to avoid doing performance testing from 
> block cache instead of from the actual drives.
>
See /proc/sys/vm/drop_caches.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

