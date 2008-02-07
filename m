From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mdadm 2.6.4 : How i can check out current status of reshaping
 ?
Date: Thu, 07 Feb 2008 16:15:58 -0500
Message-ID: <47AB750E.2060202@tmr.com>
References: <79188012.20080204070802@j8.com.ru> <18343.38465.112723.66522@notabene.brown> <58351009.20080205121332@j8.com.ru> <18344.13816.921912.885730@notabene.brown> <119270390.20080206221505@j8.com.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <119270390.20080206221505@j8.com.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas-Sokov <andre.s@j8.com.ru>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andreas-Sokov wrote:
> Hello, Neil.
>
> .....
>   
>> Possible you have bad memory, or a bad CPU, or you are overclocking
>> the CPU, or it is getting hot, or something.
>>     
>
> As seems to me all my problems has been started after i have started update MDADM.
> This is server worked normaly (but only not like soft-raid) more 2-3 years.
> Last 6 months it worked as soft-raid. All was normaly, Even I have added successfully
> 4th hdd into raid5 )when it stared was 3 hdd). And then Reshaping have been passed fine.
>
> Yesterday i have did memtest86 onto it server and 10 passes was WITH OUT any errors.
> Temperature of server is about 25 grad celsius.
> No overlocking, all set to default.
>
>   
What did you find when you loaded the module with gdb as Neil suggested? 
If the code in the module doesn't match the code in memory you have a 
hardware error. memtest86 is a useful tool, but it is not a definitive 
test because it doesn't use all CPUs and do i/o at the same time to load 
the memory bus.

> Realy i do not know what to do because off wee nedd grow our storage, and we can not.
> unfortunately, At this moment - Mdadm do not help us in this decision, but very want
> it get.
>   

I would pull out half my memory and retest. If it still fails I would 
swap to the other half of memory. If that didn't show a change I would 
check that the code in the module is what Neil showed in his last 
message (I assume you already have), and then reseat all of the cables, etc.

I agree with Neil:
>> But you clearly have a hardware error.
>>     
>
>   
>> NeilBrown
>>     
>
>
>
>   


-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


