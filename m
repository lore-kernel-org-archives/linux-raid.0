From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: Kernel 2.6.32-5-amd64 fails to boot.
Date: Tue, 01 Feb 2011 23:46:14 +0100
Message-ID: <4D488D36.2000208@grumpydevil.homelinux.org>
References: <26.D7.19545.BDE784D4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <26.D7.19545.BDE784D4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/01/2011 10:44 PM, Leslie Rhorer wrote:
>> -----Original Message-----
>> From: Rudy Zijlstra [mailto:rudy@grumpydevil.homelinux.org]
>> Sent: Tuesday, February 01, 2011 3:02 PM
>> To: lrhorer@satx.rr.com
>> Cc: 'Linux RAID'
>> Subject: Re: Kernel 2.6.32-5-amd64 fails to boot.
>>
>> On 02/01/2011 09:52 PM, Leslie Rhorer wrote:
>>      
>>>> On 02/01/2011 09:23 PM, Leslie Rhorer wrote:
>>>>
>>>>
>>>>          
>>>>> doesn't boot, either.  It gives a bit more detail in the output, but
>>>>>
>>>>>            
>>>> nothing
>>>>
>>>>          
>>>>> illuminating.  The old kernel (2.6.32-3-amd64) boots just fine.
>>>>>
>>>>>
>>>>>            
>>>> Can you enable serial console and catch the console output that way?
>>>>
>>>>          
>>> 	Well, not easily.  I don't have a serial terminal.  I suppose I
>>> could set something up.  You're suggesting I poke around to see what md
>>>        
>> is
>>      
>>> reporting?  Also, I'm not sure why - if the keyboard console is failing
>>>        
>> -
>>      
>>> the serial console would work better.
>>>
>>>
>>>
>>>        
>> Serial console can be captured to a file and then the output analysed.
>> So you can read afterwards the messages that are flying past.
>>
>> What i do in such case, is that i take serial connector from a laptop,
>> and run a terminal emulater like minicom. And capture it to a file so i
>> can analyse what has been happening.
>>      
> 	Yeah, I don't think there is anything pertinent prior to the md
> failures, but it might be worth a shot.  I don't have a laptop, but I do
> have another server sitting right below the one in question.  The main
> problem is, neither one has a serial port.
>
>    
Network console? I could tell you how to setup serial console, but i've 
never done the network console
