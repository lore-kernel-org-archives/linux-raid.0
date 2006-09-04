From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID5 producing fake partition table on single drive
Date: Mon, 04 Sep 2006 13:55:52 -0400
Message-ID: <44FC68A8.4010002@tmr.com>
References: <1155987607.7207.23.camel@localhost.localdomain>	 <17641.25141.373827.77279@cse.unsw.edu.au> <1156200453.19051.13.camel@fc6.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1156200453.19051.13.camel@fc6.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Neil Brown <neilb@suse.de>, Lem <l3mming@iinet.net.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford wrote:

>On Mon, 2006-08-21 at 17:35 +1000, Neil Brown wrote:
>
>  
>
>>>Buffer I/O error on device sde3, logical block 1793
>>>      
>>>
>>This, on the other hand, might be a problem - though possibly only a
>>small one.
>>Who is trying to access sde3 I wonder.  I'm fairly sure the kernel
>>wouldn't do that directly.
>>    
>>
>
>It's the mount program collecting possible LABEL= data on the partitions
>listed in /proc/partitions, of which sde3 is outside the valid range for
>the drive.
>
>  
>
May I belatedly say that this is sort-of a kernel issue, since 
/proc/partitions reflects invalid data? Perhaps a boot option like 
nopart=sda,sdb or similar would be in order?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

