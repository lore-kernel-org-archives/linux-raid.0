From: Jay Roberts <roberts@oddpost.com>
Subject: Re: New RAID array syncs very slow
Date: Wed, 24 Mar 2004 07:20:06 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40617CF6.1000308@oddpost.com>
References: <40602BE7.8080705@oddpost.com> <Pine.LNX.4.56.0403232235270.13470@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0403232235270.13470@lion.drogon.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This turned out to be really helpful. While investigating why one of  
the drives had so much lower numbers than the others using the test you 
suggested, I discovered a bent down pin in the cable socket. After 
fixing , the stats popped back up to the other drives' levels, and the 
estimated sync time on the 1.3 Duron box dropped to around 4 hours. I 
moved all the hardware back to the original P3-450 box, made sure DMA 
was enabled, and the sync time was now only 8 hours vs 91. A huge 
improvement and a livable time period. I was surprised at the difference 
in sync time between the two boxes.  Almost double on the P3-450 over 
the 1.3 Duron. 

Gordon Henderson wrote:

>On Tue, 23 Mar 2004, Jay Roberts wrote:
>
>  
>
>>I just set up a new Raid5 array using 4 200GB disks on 2 controllers. I
>>created the array, and it begins to sync up, but it will not sync at
>>over 600Kb. It has been over 12 hours now, and the sync is only 7% done.
>>>From reading, I know that sync should only take a few hours, but at the
>>current rate mine will take 91 hours which seems like an insane amount
>>of time. I am looking for any advice on this.  Details follow:
>>    
>>
>
>You probably don't have DMA enabled on the controller. See what
>
>  hdparm /dev/hde
>
>and for all the other drives you have gives.
>
>Do a crude speed test with
>
>  hdparm -Tt /dev/hde
>
>too. You ought to get at least 45MB/sec on a modern IDE drive.
>
>You might have to build a custom kernel to get the right driver for the
>chipset.
>
>Gordon
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  
>

