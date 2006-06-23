From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Is shrinking raid5 possible?
Date: Thu, 22 Jun 2006 20:49:04 -0400
Message-ID: <449B3A80.4070602@tmr.com>
References: <44960C45.9050407@anu.edu.au> <17558.10906.59066.196870@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17558.10906.59066.196870@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Paul Davidson <Paul.Davidson@anu.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

>On Monday June 19, Paul.Davidson@anu.edu.au wrote:
>  
>
>>Hi,
>>
>>I'd like to shrink the size of a RAID5 array - is this
>>possible? My first attempt shrinking 1.4Tb to 600Gb,
>>
>>mdadm --grow /dev/md5 --size=629145600
>>
>>gives
>>
>>mdadm: Cannot set device size/shape for /dev/md5: No space left on device
>>    
>>
>
>Yep.
>The '--size' option refers to:
>              Amount  (in  Kibibytes)  of  space  to  use  from  each drive in
>              RAID1/4/5/6.  This must be a multiple of  the  chunk  size,  and
>              must  leave about 128Kb of space at the end of the drive for the
>              RAID superblock.  
>(from the man page).
>
>So you were telling md to use the first 600GB of each device in the
>array, and it told you there wasn't that much room.
>If your array has N drives, you need to divide the target array size
>by N-1 to find the target device size.
>So if you have a 5 drive array, then you want
>  --size=157286400
>

May I say in all honesty that making people do that math instead of the 
computer is a really bad user interface? Good, consider it said. An 
means to just set the target size of the resulting raid device would be 
a LOT less likely to cause bad user input, and while I'm complaining it 
should inderstand suffices 'k', 'm', and 'g'.

Far easier to use for the case where you need, for instance, 10G of 
storage for a database, tell mdadm what devices to use and what you need 
(and the level of course) and let the computer figure out the details, 
rounding up, leaving 128k, and phase of the moon if you decide to use it.

Sorry, I think the current approach is baaad human interface.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

