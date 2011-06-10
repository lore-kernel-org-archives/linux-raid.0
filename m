From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH/RFC] md/raid10: optimize read_balance() for 'far copies'
 arrays
Date: Fri, 10 Jun 2011 10:29:34 -0400
Message-ID: <4DF22A4E.7070504@tmr.com>
References: <1307516445-3208-1-git-send-email-namhyung@gmail.com>	<20110608172157.4d6ac2a8@notabene.brown> <877h8w93bw.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877h8w93bw.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Namhyung Kim wrote:
> NeilBrown<neilb@suse.de>  writes:
>
>    
>> On Wed,  8 Jun 2011 16:00:45 +0900 Namhyung Kim<namhyung@gmail.com>  wrote:
>>
>>      
>>> If @conf->far_offset>  0, there is only 1 stripe so that we can treat
>>> the array same as 'near' arrays. Furthermore we could calculate new
>>> distance from the previous position even for the real 'far' array
>>> cases if the position of given disk is already in the lowest stripe.
>>>
>>>        
>> I agree that it still make sense to to balancing if far_offset != 0.
>> However  there is absolutely no point in your change to the calculation of
>> new_distance.
>> You only wont new_distance to contain a distance from head position if we
>> want to choose the device with the 'closest' head.  But we don't.  We want to
>> choose the device were the data is closest to the start of the device.  So
>> the current value for new_distance is correct.
>>
>>      
> Still can't understand why we choose the closest-to-the-start disk in
> case we could have possible sequencial access on other disk. Probably
> because of the lack of my understanding how md/disk works :(
>    

This code is all based on traditional drives, where the seek time, 
rotational latency, and position on the platter are all factors which 
effect performance in some way. Devices like SSD don't have these 
factors (ie. they are constants) and someday it may make sense to 
rethink this code again.

Also note that "close to current" optimizes seek time, while "close to 
beginning" optimizes transfer rate. Note the total lack of parameters to 
tune "what you want" for a given device.

-- 
Bill Davidsen<davidsen@tmr.com>
   We are not out of the woods yet, but we know the direction and have
taken the first step. The steps are many, but finite in number, and if
we persevere we will reach our destination.  -me, 2010



