From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Roadmap for md/raid ???
Date: Wed, 21 Jan 2009 12:04:32 -0500
Message-ID: <497755A0.3090600@tmr.com>
References: <18763.7881.300921.177207@notabene.brown>	<496E4E59.4090505@tmr.com>	<18803.57326.591385.40711@nbeee.brown>	<49740C81.2030502@tmr.com> <18804.65407.220481.267665@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18804.65407.220481.267665@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Monday January 19, davidsen@tmr.com wrote:
>   
>> Neil Brown wrote:
>>     
>>> The difficulty is "How do you handle a crash?"
>>> If you crash and restart in the middle of a reshape, you need to know
>>> where all the data is.
>>> To follow your scheme, you would need to update the metadata for
>>> every block that is moved.
>>>
>>>   
>>>       
>> That would seem to be an issue doing it in a large task as well, if I 
>> understand what you want to do. After the data have been written to the 
>> spare space I believe you are going to write it back. If you update the 
>> metadata before the write and something happens you have old metadata 
>> but data in another format. Conversely, if you update the metadata 
>> first, and something happens, you have the metadata describing a change 
>> which didn't happen. So You would have to have a metadata reflecting the 
>> data not being in the array, but actually somewhere else, or you would 
>> have to keep the spare space inside the array, where room might not be 
>> available.
>>     
>
> I "freeze" a section of the array so that any writes block,
> I copy that data to somewhere safe, and mark that copy as being a
> valid copy of the moved data.
> Then I copy it back in the new layout and update the array metadata to
> show that the change-over point between old-layout and new-layout has
> changed.  Then I invalidate the copy.
> Then repeat.
>
> When restarting an array, mdadm checks the copy (which could be in a
> file on a different device) and if it is valid, it is copied on to
> the array and the metadata is updated.
>   

Sounds good...

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


