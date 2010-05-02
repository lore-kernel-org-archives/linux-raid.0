From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Questions about 4k sector drives
Date: Sun, 02 May 2010 19:04:50 -0400
Message-ID: <4BDE0512.8070502@tmr.com>
References: <4BD42B57.9000703@kusche.de> <1272206601.7734.4.camel@faldara>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1272206601.7734.4.camel@faldara>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Florian Kusche <flox@kusche.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Phillip Susi wrote:
> On Sun, 2010-04-25 at 13:45 +0200, Florian Kusche wrote:
>   
>> Hello,
>>
>> I have a few questions about Software RAID and 4k-sector drives. I
>>  already searched the web, but some questions are left.
>>
>> 1) (this one is not directly raid-related) I understand, that newer
>>  kernels can determine whether a drive uses 4k physical sectors even if
>>  it presents 512-byte logical sectors to the outside. (via the
>>  sector_size_supported() patch by Matthew Wilcox)
>>
>> Is this only an information given to userland tools, or will the linux
>>  kernel change its behavior (e.g. use 4k-blocks for such block
>>  devices)? (I guess it's only an information for userland tools.)
>>     
>
> If the device reports it, then the kernel knows it and exports it to
> user space.  The new 4k drives from WD unfortunately, lie and report
> their physical sector size is 512 bytes.
>
>   
>> 2)
>> Will Software RAID work with physical 4k-sector drives...
>> - that simulate logical 512 byte sectors?
>> - that also have logical 4k-sectors?
>> (I'm pretty sure, the answer to both questions is yes.)
>>     
>
> Yes.
>   

Is there any reason not to just align partitions for all drives on 32kB 
sectors and expect that to work on 512b 4kB and SSD? Cautious testing 
here says it works fine, no anomalies, no exciting performance data, 
just works.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

