From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: How to avoid complete rebuild of RAID 6 array (6/8 active devices)
Date: Sun, 29 Jun 2008 17:58:30 -0400
Message-ID: <48680586.609@tmr.com>
References: <41931C59-9A91-47A6-A81C-EC14001DA95B@gmail.com>	<20080625161357.GH23944@skl-net.de> <18532.50062.63173.620773@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18532.50062.63173.620773@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Andre Noll <maan@systemlinux.org>, Dave Moon <p.b.w.tortilla@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Wednesday June 25, maan@systemlinux.org wrote:
>   
>> On 15:37, Dave Moon wrote:
>>
>>     
>>> 1. If mdadm encounters a bit error during a RAID 6 rebuild, will it  
>>> just give up on that particular file and move on to recover other data  
>>> on the array? Or will it trash the entire array?
>>>       
>> The kernel will stop the array and give up.
>>     
>
> Not quite.  It will stop the recovery.  It won't stop the whole array
> though (I think...).
>
>   
>>> 2. Is it possible to cheat mdadm by somehow replacing the new "raid  
>>> metadata" on the 6 drives with the old data on the 2 drives? Will it  
>>> make mdadm think the array is clean, consistent and nothing ever  
>>> happened?
>>>       
>>> Please do note that I did not write ANY new data onto the RAID 6 array  
>>> from the time it was degraded until the time I brought it down with (-- 
>>> stop).
>>>       
>> Use --force, Luke. Man mdadm(8):
>>
>> 	-f, --force Assemble the array even if some superblocks
>> 	appear out-of-date
>>     
>
> --force only updates enough superblocks to assemble a working array.
> For raid6, that mean n-2 drives.  As there are n-2 drive, it won't try
> any harder.
>
> You best bet is to recreate the array with --assume-clean.
> Providing you have the chunksize, order of devices, etc the same, you
> should get your array back.
>   

Then what? What's going to happen when he does a check?

Of course build an array out of drives so unstable that you can't safelt 
*run* a check is another topic.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


