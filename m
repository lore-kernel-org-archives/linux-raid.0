From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID5 kicks non-fresh drives
Date: Fri, 26 May 2006 13:32:28 -0400
Message-ID: <44773BAC.9090002@tmr.com>
References: <1148571503.2772.35.camel@hendrix.hollabaugh.com>  <17526.7947.129968.287311@cse.unsw.edu.au> <1148596237.4957.4.camel@hendrix.hollabaugh.com> <Pine.LNX.4.62.0605260956120.20178@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.62.0605260956120.20178@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Craig Hollabaugh <craig@hollabaugh.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Abrahamsson wrote:

> On Thu, 25 May 2006, Craig Hollabaugh wrote:
>
>> That did it! I set the partition FS Types from 'Linux' to 'Linux raid 
>> autodetect' after my last re-sync completed. Manually stopped and 
>> started the array. Things looked good, so I crossed my fingers and 
>> rebooted. The kernel found all the drives and all is happy here in 
>> Colorado.
>
>
> Would it make sense for the raid code to somehow warn in the log when 
> a device in a raid set doesn't have "Linux raid autodetect" partition 
> type? If this was in "dmesg", would you have spotted the problem before?
>
As long as it is written where logwatch will see it, not recognize it, 
and report it... People who don't read their logwatch reports get no 
sympathy from me.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

