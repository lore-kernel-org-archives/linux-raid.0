From: Jeff Garzik <jeff@garzik.org>
Subject: Re: NCQ general question
Date: Fri, 03 Mar 2006 17:19:05 -0500
Message-ID: <4408C0D9.4010202@garzik.org>
References: <5d96567b0602282304o558fb564jd72784bafdd289f5@mail.gmail.com> <440561CB.30201@yahoo.de> <4405A656.1030602@rtr.ca> <20060301135547.GV4816@suse.de> <C6838977-5411-400F-9548-2F22598DC2AE@egenera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <C6838977-5411-400F-9548-2F22598DC2AE@egenera.com>
Sender: linux-ide-owner@vger.kernel.org
To: Steve Byan <smb@egenera.com>
Cc: Jens Axboe <axboe@suse.de>, Mark Lord <liml@rtr.ca>, Gentoopower <gentoopower@yahoo.de>, "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

Steve Byan wrote:
> On Mar 1, 2006, at 8:55 AM, Jens Axboe wrote:
> The problem with TCQ is that the host can't disconnect on writes  after 
> sending the data to the drive but before receiving the status.  The host 
> can only disconnect between sending the command and moving  the data. 

That, but also:  The standard PCI IDE hardware interface prevents the 
device from selecting command $N's DMA data out of $M active write commands.

With reads, the device has more freedom to process the requests 
asynchronously.


> Consequently TCQ is useless for writes, which is where you  really need 

Agreed.


> it. It works OK for reads. TCQ was really invented as a  way to allow 
> CD-ROM drives to play nice on the same ATA bus as disks.

Disagree, you are probably thinking about bus disconnect associated with 
the overlapped command set?  AFAIK TCQ has -never- applied to ATAPI.


> The reason you need write queuing is for data integrity reasons, not  
> for performance. ATA disks effectively get command-queuing on writes  
> even without TCQ and NCQ - they simply park the data in a volatile  RAM 
> cache, tell the host that the data is saved on persistent  storage, and 
> then asynchronously write the queued data to the  physical media. The 
> drive reorders those writes and will gather  sequential writes.

Data integrity -and- performance.  Performance increases for all the 
standard reasons that an asynchronous pipeline increases performance 
over a synchronous one.

The write cache means that requests on the device can be processed 
asynchronously, but without NCQ there is still a synchronous bottleneck: 
  the device<->controller pipe.


> However, note that all filesystems that make even a pretense of  trying 
> to maintain filesystem integrity after a power failure (note  that the 
> Windows NT implementation of FAT32 does not attempt to  maintain 
> filesystem integrity after a power failure) depend on  knowing when data 
> makes it to persistent storage, so they can order  their writes 

True.


> correctly. ATA disk write caching breaks this guarantee.  To restore 
> filesystem integrity on a careful-write filesystem like  most unix 
> filesystems, you have to disable write-caching in the  drive. This 

False, as Linux has proven:  barriers can be implemented with 
flush-cache commands.

Disabling write cache is not your only choice, and using flush-cache 
gives you better performance than flat-out disabling the write cache.

	Jeff


