From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: NVRAM support
Date: Fri, 10 Feb 2006 10:43:32 -0500
Message-ID: <43ECB4A4.6010005@tmr.com>
References: <43EC5655.1060504@web.de> <20060210124204.GC28676@harddisk-recovery.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060210124204.GC28676@harddisk-recovery.com>
Sender: linux-raid-owner@vger.kernel.org
To: Erik Mouw <erik@harddisk-recovery.com>
Cc: Mirko Benz <mirko.benz@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Erik Mouw wrote:

>On Fri, Feb 10, 2006 at 10:01:09AM +0100, Mirko Benz wrote:
>  
>
>>Does a high speed NVRAM device makes sense for Linux SW RAID? E.g. a PCI 
>>card that exports battery backed memory.
>>    
>>
>
>Unless it's very large (i.e.: as large as one of your disks), it
>doesn't make sense. It will probably break less often, but it doesn't
>help you in case a disk really breaks. It also won't speed up an MD
>device much.
>
>  
>
>>Could that significantly improve write speed for RAID 5/6 (e.g. via an 
>>external journal, asynchronous operation and write caching)?
>>    
>>
>
>You could use it for an external journal, or you could use it as a swap
>device.
>  
>

Let me concur, I used external journal on SSD a decade ago with jfs 
(AIX). If you do a lot of operations which generate journal entries, 
file create, delete, etc, then it will double your performance in some 
cases. Otherwise it really doesn't help much, use as a swap device might 
be more helpful depending on your config.

>  
>
>>What changes would be required?
>>    
>>
>
>None, ext3 supports external journals. Look for the -O option in the
>mke2fs manual page. Using the NVRAM device as swap is not different
>from a using "normal" swap partition.
>
>
>Erik
>
>  
>


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

