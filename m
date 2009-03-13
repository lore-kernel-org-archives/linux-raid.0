From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Reliability of bitmapped resync
Date: Fri, 13 Mar 2009 13:19:48 -0400
Message-ID: <49BA95B4.9070605@tmr.com>
References: <20090223194019.GA3488@lazy.lzy>	<b2460d0414270e6a6be4c91ec2d5a071.squirrel@neil.brown.name>	<20090223201905.GA7585@lazy.lzy>	<e3d195aab8b8de113e146e2932996777.squirrel@neil.brown.name>	<20090223214016.GB18555@lazy.lzy>	<16ff0082259ce384e30c4a7f9a0e66fb.squirrel@neil.brown.name>	<20090224193931.GB3470@lazy.lzy> <18852.44880.811967.897554@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18852.44880.811967.897554@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday February 24, piergiorgio.sartor@nexgo.de wrote:
>   
>> Hi,
>>
>>     
>>> I'll wait for these details before I start hunting further.
>>>       
>> OK, here we are.
>> Some forewords, the last disk to fail at boot was
>> /dev/sda, this data was collected after a "clean"
>> add of the /dev/sda3 to the RAID.
>> This means the superblock was zeroed and the device
>> added, so it should be clean.
>>
>>     
> ....
>
> Thanks a lot for that.
>
>   
>> Now, one thing I do not understand, but maybe it is
>> anyway OK, and it is this last line:
>>
>>           Bitmap : 945199 bits (chunks), 524289 dirty (55.5%)
>>
>> Because the array status was fully recovered (in sync)
>> and /dev/sdb3 showed:
>>
>>           Bitmap : 945199 bits (chunks), 1 dirty (0.0%)
>>
>> Confirmed somehow by /proc/mdstat
>>
>> How it could be 55.5% dirty? Is this expected?
>>     
>
> This is a bug.  Is fixed by a patch that I have queued for 2.6.30.  As
> it doesn't cause a crash or data corruption, it doesn't get to jump
> the queue.  It is very small though:
>   

Belatedly I ask if this went to -stable for 2.6.29.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


