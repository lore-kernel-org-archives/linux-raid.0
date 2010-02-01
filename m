From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Why does one get mismatches?
Date: Mon, 01 Feb 2010 16:10:15 -0500
Message-ID: <4B674337.4090900@tmr.com>
References: <166572.83607.qm@web51301.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <166572.83607.qm@web51301.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org, Goswin von Brederlow <goswin-v-b@web.de>
List-Id: linux-raid.ids

Jon Hardcastle wrote:
> --- On Thu, 28/1/10, Goswin von Brederlow <goswin-v-b@web.de> wrote:
>
>   
>> From: Goswin von Brederlow <goswin-v-b@web.de>
>> Subject: Re: Why does one get mismatches?
>> To: linux-raid@vger.kernel.org
>> Date: Thursday, 28 January, 2010, 20:24
>> "Tirumala Reddy Marri" <tmarri@amcc.com>
>> writes:
>>
>>     
>>> I just tried and miss-match count is zero.
>>>       
>> Interesting, is XOR engine
>>     
>>> doing something wrong ? . Then I ran a test where I
>>>       
>> raw-write the file
>>     
>>> to /dev/md0. Then did the raw-read for the same size.
>>>       
>> In this case XOR
>>     
>>> matched as expected. Then I failed a drive using
>>>       
>> "mdadm -f /dev/md0
>>     
>>> /dev/sda". Then I read the same size data again from
>>>       
>> /dev/md0. And
>>     
>>> checksum matches too. 
>>> What is this mean XOR engine is doing right thing. But
>>>       
>> "chec/repair"
>>     
>>> test is not functioning properly with XOR-engine ?
>>>
>>> Or is this something to do with  how the buffers
>>>       
>> are handled ? may they
>>     
>>> are cached ?
>>>
>>>
>>> -Marri
>>>       
>> No idea. But if everything works without the XOR engine and
>> gives
>> mismatches with then I would think there is a software or
>> hardware error
>> there and not in the cable or disks.
>>
>> MfG
>>         Goswin
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     
>
> i think my RAM is fecked - does that sound like a possible cause? memtest86 gives PAGES of red errors when run but the POST gives nothing and the machine boots.... it has 512MB
>
> i have some more on order as a speculative.. 
>   

I would bet that your RAM is broken. Any errors indicate bad RAM, no 
errors indicate no persistent error. Scrap that RAM. More will make the 
machine faster, too.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

