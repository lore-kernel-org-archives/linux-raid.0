From: Alexander Shenkin <al@shenkin.org>
Subject: Re: SMART detects pending sectors; take offline?
Date: Tue, 10 Oct 2017 10:00:47 +0100
Message-ID: <dd9d09ef-5191-a955-5b99-0fbcaea30665@shenkin.org>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <aae31b06-f0b7-5d58-8dee-02867fcd23ec@aei.mpg.de>
 <8caa4fe1-c51f-6f3a-e16b-8795cf1b4071@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8caa4fe1-c51f-6f3a-e16b-8795cf1b4071@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 10/9/2017 9:16 PM, Phil Turmel wrote:
> On 10/07/2017 04:21 AM, Carsten Aulbert wrote:
>> Hi
>>
>> On 10/07/17 09:48, Alexander Shenkin wrote:
>>> My SMART monitoring has picked up some pending sectors on one of my
>>> RAID0 + RAID5 drives (it's one of the infamous 3TB seagate drives... my
>>> other 3 failed earlier... this is the last of them, that finally has
>>> gone as well...).  I've just ordered a replacement (Toshiba P300) that
>>> will arrive tomorrow... but the question is, what to do in the meantime?
>>>   Should I take the drive offline?  I suspect so, but would like to
>>> double check before taking action.  Thanks in advance for any advice.
>>
>> Given this is "only" a single sector error I would keep it running as
>> long as you can physically install the new drive and only then take it
>> offline.
>>
>> At least theoretically, it may be possible to force the rewrite of this
>> sector and use the spare sectors of the disk, but I'm not 100% sure if a
>> simple md check would already trigger it - usually you need to write
>> "new" data to defective sectors to force the drive's firmware to use the
>> spare sectors.
>>
>> But given the replacement disk should arrive soon, I would not act
>> before that and run with a degraded RAID5 until then.
>>
>> I'm a bit more worried about the RAID0 here, do you run RAID0 on top of
>> RAID5 or what is the exact set-up?
> 
> So, no regular "check" scrubs.  Check scrubs fix pending sectors by
> writing back to such sectors when the error is hit.  As long as there is
> redundancy to obtain the data from, and the drive in question actually
> returns a read error.

Thanks... I know nothing about "check scrubs".  Could you point me to a 
good resource?  I've found 
https://raid.wiki.kernel.org/index.php/Scrubbing and 
https://raid.wiki.kernel.org/index.php/Scrubbing_the_drives, but it's 
hard to tell exactly how the system should be configured in order to run 
these regularly.  A weekly cron perhaps?  And, should it be just check, 
or repair?  etc...  Any help you could offer would be welcome.

Is this something I should run now?  I figure it's a bad idea to push an 
array that is starting to degrade... haven't had a chance to replace the 
drive yet, but will get to it this week.  Probably best to start the 
scrubbing routines once I have 4 good drives in there I figure...

> Since this is a desktop drive that is known to not have SCTERC support,
> you *must* reset your driver timeouts to 180 seconds for a check scrub
> to succeed.  You will also have to do so with your P300 drive, as
> Toshiba's website says that drive is not NAS optimized.
> 
> Please read up on "timeout mismatch" before your array blows up.

I have timeouts set on all drives when the system boots, and the same 
script turns on the P300s' SCTERC.

