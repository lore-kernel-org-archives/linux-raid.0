From: Steven Dake <sdake@mvista.com>
Subject: Re: RFC - new raid superblock layout for md driver
Date: Wed, 20 Nov 2002 17:29:22 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3DDC28E2.30404@mvista.com>
References: <15835.2798.613940.614361@notabene.cse.unsw.edu.au>	<3DDBC0D9.5030904@mvista.com> <15836.8031.649441.843857@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Neil Brown wrote:

>On Wednesday November 20, sdake@mvista.com wrote:
>  
>
>>Neil,
>>
>>I would suggest adding a 64 bit field called "unique_identifier" to the 
>>per-device structure.  This would allow a RAID volume to be locked to a 
>>specific host, allowing the ability for true multihost operation.
>>    
>>
>
>You seem to want a uniq id in 'per device' which will identify the
>'volume'.
>That doesn't make sense to me so maybe I am missing something.
>If you want to identify the 'volume', you put some sort of id in the
>'per-volume' data structure.
>
>This is what the 'name' field is for.
>  
>
This is useful, atleast in the current raid implementation, because 
md_import can be changed to return an error if the device's unique 
identifier doesn't match the host identifier.  In this way, each device 
of a RAID volume is individually locked to the specific host, and 
rejection occurs at import of the device time.

Perhaps locking using the name field would work except that other 
userspace applications may reuse that name field for some other purpose, 
not providing any kind of uniqueness.

Thanks for the explination of how the name field was intended to be used.

-steve
