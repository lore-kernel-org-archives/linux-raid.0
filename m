From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: number of global spares?
Date: Wed, 28 Sep 2005 15:34:48 -0400
Message-ID: <433AF058.10006@tmr.com>
References: <1125082848.25483.23.camel@seki.nac.uci.edu>	 <17167.40479.3220.155672@cse.unsw.edu.au> <1125121851.1055.26.camel@seki.nac.uci.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1125121851.1055.26.camel@seki.nac.uci.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dan Stromberg wrote:

>On Sat, 2005-08-27 at 08:56 +1000, Neil Brown wrote:
>  
>
>>On Friday August 26, strombrg@dcs.nac.uci.edu wrote:
>>    
>>
>>>I've been working on a RAID setup with dual RAID controllers and
>>>three expansion boxes - 48 disks in all, including data, parity and
>>>global spares.
>>>      
>>>
>>If there are 48 drives, why do your drive-numbers go up to 59?
>>Confusing but not important.
>>    
>>
>
>Agreed.  The hardware likes to do that.
>
>  
>
>>Presumably these are 360G drives (or there abouts) and you are hoping
>>to use about 42 for data and the remaining 6 for redundancy.
>>    
>>
>
>Around 380G.
>
>  
>
>>I feel this a bit tight but could be workable.
>>
>>If you were using Linux-soft-raid, I would probably suggest 3 16-drive raid6
>>arrays, possibly making 1 a 15 drive raid6 so there is one global spare.
>>However I gather you are using hardware RAID - do the controllers
>>support RAID6 ??
>>    
>>
>
>I'd feel better about RAID 6, but the hardware doesn't support it.
>
>  
>
>>>Please be sure to use a fixed-pitch font when viewing the tables found
>>>below.  BTW, if people weren't so terrified of HTML, I could just make a
>>>nice HTML table for easy reading without silly font requirements...
>>>      
>>>
>>You mean some mail readers use variable-width-fonts to display
>>text/plain?  How broken!
>>    
>>
>
>Heh.
>
>  
>
>>>Does anyone have any comments on:
>>>
>>>1) The sanity of these 10 disk RAID 5's?
>>>      
>>>
>>It depends on the drives.
>>If you are using you-only-get-what-you-pay-for-IDE-drives, then I
>>would say it is insane.
>>If you are using you-pay-for-the-quality SCSI drives, then you should
>>be fairly safe.
>>    
>>
>
>They're SATA's.
>
>  
>
>>>2) The degree of loss of reliability incurred by moving 3 disks from
>>>global spare to data?
>>>      
>>>
>>That depends a bit on your warranty arrangements on the drives.  If
>>it's next-day-replacement (Really, truly) then it is probably OK.  If
>>it is 'send us the bad drive and we'll see what we can do', then I
>>would suggest thinking again.
>>    
>>
>
>This'll be the next thing I ask the vendor.
>
As someone who suports multi-TB machines, I can suggest that you really 
want to have spares on-site rather than depend on the vendor. Not that 
the vendor isn't trying, but shippers go on strike, snow, mud and rain 
can close roads, the vendor's website can be hacked, etc. Oh, and 
earthquakes.

Having drives on-site lets you sleep better, and can be explained to 
management more easily than RAID-5 vs. RAID-6.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

