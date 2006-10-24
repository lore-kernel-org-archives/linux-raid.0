From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: why partition arrays?
Date: Tue, 24 Oct 2006 19:31:12 -0400
Message-ID: <453EA240.7000407@tmr.com>
References: <C59E07CE09883545BC9EC6B87E2D3C83523DBF@kdtc.tt.umist.ac.uk> <20061021062648.23c0bd7a@30_bodo.rupinet> <453A232E.8050401@idgmail.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <453A232E.8050401@idgmail.se>
Sender: linux-raid-owner@vger.kernel.org
To: Henrik Holst <henrik.holst@idgmail.se>
Cc: Bodo Thiesen <bothie@gmx.de>, linux-raid mailing list <linux-raid@vger.kernel.org>, Ken Walker <ken.walker@manchester.ac.uk>
List-Id: linux-raid.ids

Henrik Holst wrote:

>Bodo Thiesen wrote:
>  
>
>>Ken Walker <ken.walker@manchester.ac.uk> wrote:
>>
>>    
>>
>>>Is LVM stable, or can it cause more problems than separate raids on a array.
>>>      
>>>
>
>[description of street smart raid setup]
>
>(The same function could probably be achieved with logical partitions
>and ordinary software raid levels.)
>
>  
>
>>So, now decide for your own, if you consider LVM stable - I would ;)
>>
>>Regards, Bodo
>>    
>>
>
>Have you lost any disc (i.e. "physical volumes") since February? Or lost
>the meta-data?
>
>I would not recommend anyone to use LVM if they are less than experts on
>Linux systems. Setting up a LVM system is easy: administrating and
>salvaging the same, was much more work. (I used it ~3 years ago)
>
My read on LVM is that (a) it's one more thing for the admin to learn, 
(b) because it's seldom used the admin will be working from 
documentation if it has a problem, and (c) there is no bug-free 
software, therefore the use of LVM on top of RAID will be less reliable 
than a RAID-only solution. I can't quantify that, the net effect may be 
too small to measure. However, the cost and chance of a finger check 
from (a) and (b) are significant.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

