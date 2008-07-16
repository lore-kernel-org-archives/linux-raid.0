From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Tue, 15 Jul 2008 18:52:59 -0800 (AKDT)
Message-ID: <Pine.LNX.4.64.0807151851110.32734@filesrv1.baby-dragons.com>
References: <1216130769.5633.318.camel@sam.localdomain> <487CC660.9030004@ziu.info>
 <487D09E7.1010805@sauce.co.nz> <Pine.LNX.4.64.0807151831070.32734@filesrv1.baby-dragons.com>
 <487D6168.6020308@sauce.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <487D6168.6020308@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Richard ,

On Wed, 16 Jul 2008, Richard Scobie wrote:
> Mr. James W. Laferriere wrote:
>>     At what level (2.6.26) does one set readahead ?
>>     I've searched 'mount' ,  'mdadm' ,  'Documentation/md.txt' .  Where 
>> else should I look ?  Obviously I am missing something .
>
> Hi Jim,
>
> /sbin/blockdev --setra 65536 /dev/md5 gets it done here.
>
> Regards,
> Richard

 	This does not bode well for my memory ,  It's already in my 
optimizations shell script for startup .  I thought it looked very familiar , 
But the usual places didn't bring it up .

 	Thank you ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
+------------------------------------------------------------------+
