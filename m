From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Does grub support sw raid1?
Date: Wed, 22 Mar 2006 08:28:28 -0500
Message-ID: <442150FC.2060903@tmr.com>
References: <442020AD.7090902@cc.kuleuven.be> <44202F7A.80901@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44202F7A.80901@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: Herta Van den Eynde <herta.vandeneynde@cc.kuleuven.be>, linux-raid@vger.kernel.org, redhat-list@redhat.com
List-Id: linux-raid.ids

Mike Hardy wrote:

>This works for me, there are several pages out there (I recall using the
>commands from a gentoo one most recently) that show the exact sequence
>of grub things you should do to get grub in the MBR of both disks.
>
>It sounds like your machine may not be set to boot off of anything other
>than that one disk though? Is that maybe a BIOS thing?
>
>I dunno, but I have definitely pulled a primary drive out of the system
>completely and booted off the second one, then had linux come up with
>(correctly) degraded arrays
>  
>

Frequently a BIOS will boot a 2nd drive if the first is missing/dead, 
but not if it returns bad data (CRC error). A soft fail is not handled 
correctly by all BIOS' in use, possibly a majority of them.

>-Mike
>
>Herta Van den Eynde wrote:
>  
>
>>(crossposted to linux-raid@vger.kernel.org and redhat-list@redhat.com)
>>(apologies for this, but this should have be operational last week)
>>
>>I installed Red Hat EL AS 4 on a HP Proliant DL380, and configured all
>>system devices in software RAID 1.  I added an entry to grub.conf to
>>fallback to the second disk in case the first entry fails.  At boottime,
>>booting from hd0 works fine.  As does booting from hd1.
>>
>>Until I physically remove hd0 from the system.
>>
>>I tried manually installing grub on hd1,
>>I added hd1 to the device.map and subsequently re-installed grub on it,
>>I remapped hd0 to /dev/cciss/c0d1 and subsequently re-installed grub
>>all to no avail.
>>
>>I previously installed this while the devices were in slots 2 and 3. The
>>system wouldn't even boot then.  It looks as though booting from sw
>>RAID1 will only work when there's a valid device in slot 0.  Still
>>preferable over hw RAID1, but even better would be if this worked all
>>the way.
>>
>>Is this working for anyone?  Any idea what I may have overlooked?  Any
>>suggestions on how to debug this?
>>
>>Kind regards,
>>
>>Herta
>>
>>Disclaimer: http://www.kuleuven.be/cwis/email_disclaimer.htm
>>

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

