From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Write-intent bitmap decreases or increase performance of RAID5?
Date: Sun, 04 Jul 2010 20:14:21 -0400
Message-ID: <4C3123DD.9090509@tmr.com>
References: <20100629201153.GA13018@localhost> <20100630111854.006ec4d0@natsu> 	<alpine.DEB.1.10.1006300729150.8623@uplift.swm.pp.se> <20100701064044.GB6058@localhost> <AANLkTilnBWCGHUgQnmrzSzpo7TRYSedBVUZEOHKI4MmG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTilnBWCGHUgQnmrzSzpo7TRYSedBVUZEOHKI4MmG@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Majed B. wrote:
> How much RAM does your machine have?
>
> Write to the disk an amount that is larger than the amount of RAM and
> see if you get the same result.
>
> Also you can use hdparm to flush the caches before running dd the 2nd time.
>   

See the meaning of the fdatasync option to dd and the 
/proc/sys/vm/drop_cache control. You are right about hdparm, but it only 
matters if you are using tiny data, drive caches are small.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

