From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: recommendations for stripe/chunk size
Date: Wed, 06 Feb 2008 17:37:18 -0500
Message-ID: <47AA369E.2090501@tmr.com>
References: <20080206202536.3316124D1D@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080206202536.3316124D1D@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wolfgang Denk wrote:
> In message <47AA08E7.5000801@tmr.com> you wrote:
>   
>>> I actually  think the kernel should operate with block sizes
>>> like this and not wth 4 kiB blocks. It is the readahead and the elevator
>>> algorithms that save us from randomly reading 4 kb a time.
>>>
>>>   
>>>       
>> Exactly, and nothing save a R-A-RW cycle if the write is a partial chunk.
>>     
>
> Indeed kernel page size is an important factor in such optimizations.
> But you have to keep in mind that this is mostly efficient for (very)
> large strictly sequential I/O operations only -  actual  file  system
> traffic may be *very* different.
>
>   
That was actually what I meant by page size, that of the file system 
rather than the memory, ie. the "block size" typically used for writes. 
Or multiples thereof, obviously.
> We implemented the option to select kernel page sizes of  4,  16,  64
> and  256  kB for some PowerPC systems (440SPe, to be precise). A nice
> graphics of the effect can be found here:
>
> https://www.amcc.com/MyAMCC/retrieveDocument/PowerPC/440SPe/RAIDinLinux_PB_0529a.pdf
>
>   
I started that online and pulled a download to print, very neat stuff. 
Thanks for the link.
> Best regards,
>
> Wolfgang Denk
>
>   


-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


