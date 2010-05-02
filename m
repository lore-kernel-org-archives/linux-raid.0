From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID5
Date: Sun, 02 May 2010 18:45:34 -0400
Message-ID: <4BDE008E.8050105@tmr.com>
References: <s2q6b16fb4c1004182046x5464351m861ccaf9850f33df@mail.gmail.com>	 <j2k4877c76c1004182121w3edcf996x2ee8ee0eca398985@mail.gmail.com>	 <4BCEFE66.6010607@tmr.com> <l2g4877c76c1004211243n6dfa55pfee322db20ba6f08@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <l2g4877c76c1004211243n6dfa55pfee322db20ba6f08@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Kaushal Shriyan <kaushalshriyan@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Evans wrote:
> On Wed, Apr 21, 2010 at 6:32 AM, Bill Davidsen <davidsen@tmr.com> wrote:
>   
>> Michael Evans wrote:
>>     
>>> On Sun, Apr 18, 2010 at 8:46 PM, Kaushal Shriyan
>>> <kaushalshriyan@gmail.com> wrote:
>>>
>>>       
>>>> Hi
>>>>
>>>> I am a newbie to RAID. is strip size and block size same. How is it
>>>> calculated. is it 64Kb by default. what should be the strip size ?
>>>>
>>>> I have referred to
>>>> http://en.wikipedia.org/wiki/Raid5#RAID_5_parity_handling. How is
>>>> parity handled in case of RAID 5.
>>>>
>>>> Please explain me with an example.
>>>>
>>>> Thanks and Regards,
>>>>
>>>> Kaushal
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>>
>>>>         
>>> You already have one good resource.
>>>
>>> I wrote this a while ago, and the preface may answer some questions
>>> you have about the terminology used.
>>>
>>> http://wiki.tldp.org/LVM-on-RAID
>>>
>>> However the question you're asking is more or less borderline
>>> off-topic for this mailing list.  If the linked information is
>>> insufficient I suggest using the Wikipedia article's links to learn
>>> more.
>>>
>>>       
>> I have some recent experience with this gained the hard way, by looking for
>> a problem rather than curiousity. My experience with LVM on RAID is that, at
>> least for RAID-5, write performance sucks. I created two partitions on each
>> of three drives, and two raid-5 arrays using those partitions. Same block
>> size, same tuning for stripe-cache, etc. I dropped an ext4 on on array, and
>> LVM on the other, put ext4 on the LVM drive, and copied 500GB to each. LVM
>> had a 50% performance penalty, took twice as long. Repeated with four drives
>> (all I could spare) and found that the speed right on an array was roughly
>> 3x slower with LVM.
>>
>> I did not look into it further, I know why the performance is bad, I don't
>> have the hardware to change things right now, so I live with it. When I get
>> back from a trip I will change that.
>>
>>
>>     
>
> This issues sounds very likely to be write barrier related.  Were you
> using an external journal on a write-barrier honoring device?
>   

Not at all, just taking 60G of free space of the drives, creating two 
partitions (on 64 sector boundaries) and using them for raid-5. Tried 
various chunk sizes, better for some things, not so much for others.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

