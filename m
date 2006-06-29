From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Cutting power without breaking RAID
Date: Thu, 29 Jun 2006 14:50:46 -0400
Message-ID: <44A42106.3040801@tmr.com>
References: <20060628214350.GA23970@rigacci.org> <17571.20553.319133.437688@cse.unsw.edu.au> <20060629094806.GB8313@rigacci.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060629094806.GB8313@rigacci.org>
Sender: linux-raid-owner@vger.kernel.org
To: Niccolo Rigacci <niccolo@rigacci.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Niccolo Rigacci wrote:

>On Thu, Jun 29, 2006 at 02:00:09PM +1000, Neil Brown wrote:
>  
>
>>With 2.6, 
>>   killall -9 md0_raid1
>>
>>should do the trick (assuming root is on /dev/md0.  If it is elsewhere,
>>choose a different process name).
>>    
>>
>
>Thanks, this is what I was looking for!
>
>I will try remounting read-only and killing the md0_raid1.
>I will keep you informed.
>
>  
>
Why should this trickery be needed? When an array is mounted r/o it 
should be clean. How can it be dirty. I assume readonly implies noatime, 
I mount physically readonly devices without explicitly saying noatime 
and nothing whines.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

