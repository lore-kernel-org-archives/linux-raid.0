From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid 5 mismatch_cnt errors
Date: Wed, 26 May 2010 11:07:26 -0400
Message-ID: <4BFD392E.3030906@tmr.com>
References: <4BF56B1F.9080205@locallinux.com>	<20100521071645.497cdcad@notabene.brown>	<4BF5B7D1.3070808@locallinux.com> <20100521083819.54680dfb@notabene.brown> <4BF5ECE7.7020907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BF5ECE7.7020907@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Neil Brown <neilb@suse.de>, Trey Scarborough <treys@locallinux.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Doug Ledford wrote:
> On 05/20/2010 06:38 PM, Neil Brown wrote:
>   
>> On Thu, 20 May 2010 17:29:37 -0500
>> Trey Scarborough <treys@locallinux.com> wrote:
>>
>>     
>>> Neil Brown wrote:
>>>       
>>>> On Thu, 20 May 2010 12:02:23 -0500
>>>> Trey Scarborough <treys@locallinux.com> wrote:
>>>>
>>>>   
>>>>         
>>>>> I have a raid 5 array with 9 disks and I have a mismatch_cnt that keeps 
>>>>> growing. This is causing file corruption on the underlaying file systems 
>>>>> as well.  I can copy a group of 100 100mb files and then do a md5sum on 
>>>>> them and 1-3 will be corrupt. If this is a drive that is bad is there 
>>>>> anyway to run a report on the count per drive that these mismatches 
>>>>> occur. I have run smarttools test and do not see one drive that stands 
>>>>> out to be causing errors. Could something else be causing these errors?
>>>>>     
>>>>>           
>
> While a bad drive is certainly a possibility here, this is precisely the
> type of failure scenario that would make me suspect bad RAM,
> motherboard, or CPU.  So I wouldn't rule those out as possibilities either.
>   

I have the same thought, I would remove half the RAM from the system and 
test again, then swap to the "other" half and repeat. Of course running 
memtest first is a good idea, but I have seen failures which only happen 
on disk access.

If the system is O/C obviously the first step is to cut the speed back...

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

