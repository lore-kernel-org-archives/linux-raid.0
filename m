From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Building a new raid6 with bitmap does not clear bits during resync
Date: Mon, 12 Nov 2007 10:28:55 -0500
Message-ID: <47387137.7000401@tmr.com>
References: <87lk98ad7e.fsf@informatik.uni-tuebingen.de> <18231.62186.908021.981786@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18231.62186.908021.981786@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday November 8, brederlo@informatik.uni-tuebingen.de wrote:
>   
>> Hi,
>>
>> I have created a new raid6:
>>
>> md0 : active raid6 sdb1[0] sdl1[5] sdj1[4] sdh1[3] sdf1[2] sdd1[1]
>>       6834868224 blocks level 6, 512k chunk, algorithm 2 [6/6] [UUUUUU]
>>       [====>................]  resync = 21.5% (368216964/1708717056) finish=448.5min speed=49808K/sec
>>       bitmap: 204/204 pages [816KB], 4096KB chunk
>>
>> The raid is totally idle, not mounted and nothing.
>>
>> So why does the "bitmap: 204/204" not sink? I would expect it to clear
>> bits as it resyncs so it should count slowly down to 0. As a side
>> effect of the bitmap being all dirty the resync will restart from the
>> beginning when the system is hard reset. As you can imagine that is
>> pretty anoying.
>>
>> On the other hand on a clean shutdown it seems the bitmap gets updated
>> before stopping the array:
>>
>> md3 : active raid6 sdc1[0] sdm1[5] sdk1[4] sdi1[3] sdg1[2] sde1[1]
>>       6834868224 blocks level 6, 512k chunk, algorithm 2 [6/6] [UUUUUU]
>>       [=======>.............]  resync = 38.4% (656155264/1708717056) finish=17846.4min speed=982K/sec
>>       bitmap: 187/204 pages [748KB], 4096KB chunk
>>
>> Consequently the rebuild did restart and is already further along.
>>
>>     
>
> Thanks for the report.
>
>   
>> Any ideas why that is so?
>>     
>
> Yes.  The following patch should explain (a bit tersely) why this was
> so, and should also fix it so it will no longer be so.  Test reports
> always welcome.
>
> NeilBrown
>
> Status: ok
>
> Update md bitmap during resync.
>
> Currently and md array with a write-intent bitmap does not updated
> that bitmap to reflect successful partial resync.  Rather the entire
> bitmap is updated when the resync completes.
>
> This is because there is no guarentee that resync requests will
> complete in order, and tracking each request individually is
> unnecessarily burdensome.
>
> However there is value in regularly updating the bitmap, so add code
> to periodically pause while all pending sync requests complete, then
> update the bitmap.  Doing this only every few seconds (the same as the
> bitmap update time) does not notciable affect resync performance.
>   

I wonder if a minimum time and minimum number of stripes would be 
better. If a resync is going slowly because it's going over a slow link 
to iSCSI, nbd, or a box of cheap drives fed off a single USB port, just 
writing the updated bitmap may represent as much data as has been 
resynced in the time slice.

Not a suggestion, but a request for your thoughts on that.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

