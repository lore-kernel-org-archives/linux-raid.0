From: berk walker <berk@panix.com>
Subject: Re: raid5 software vs hardware: parity calculations?
Date: Mon, 15 Jan 2007 19:35:37 -0500
Message-ID: <45AC1DD9.9070402@panix.com>
References: <2A887D754684B6703B52E126@emerald.sei.cmu.edu>  <Pine.LNX.4.64.0701120935000.18431@twinlark.arctic.org>  <F4B05AD60951BBA089A81535@emerald.sei.cmu.edu> <e9c3a7c20701130120o246f5cf1i8d364777123c50d8@mail.gmail.com> <45A917B8.2060706@tmr.com> <eobpl9$df3$1@sea.gmane.org> <45AB9DC6.50509@tmr.com> <45ABAA43.2000902@robinbowes.com> <Pine.LNX.4.64.0701151321190.16472@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0701151321190.16472@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: Robin Bowes <robin-lists@robinbowes.com>, Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


dean gaudet wrote:
> On Mon, 15 Jan 2007, Robin Bowes wrote:
>
>   
>> I'm running RAID6 instead of RAID5+1 - I've had a couple of instances
>> where a drive has failed in a RAID5+1 array and a second has failed
>> during the rebuild after the hot-spare had kicked in.
>>     
>
> if the failures were read errors without losing the entire disk (the 
> typical case) then new kernels are much better -- on read error md will 
> reconstruct the sectors from the other disks and attempt to write it back.
>
> you can also run monthly "checks"...
>
> echo check >/sys/block/mdX/md/sync_action
>
> it'll read the entire array (parity included) and correct read errors as 
> they're discovered.
>
> -dean
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   

Could I get a pointer as to how I can do this "check" in my FC5 [BLAG] 
system?  I can find no appropriate "check", nor "md" available to me.  
It would be a "good thing" if I were able to find potentially weak 
spots, rewrite them to good, and know that it might be time for a new drive.

All of my arrays have drives of approx the same mfg date, so the 
possibility of more than one showing bad at the same time can not be 
ignored.

thanks
b-

