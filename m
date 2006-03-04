From: Steve Byan <smb@egenera.com>
Subject: Re: NCQ general question
Date: Sat, 4 Mar 2006 15:23:01 -0500
Message-ID: <C7155197-3E90-4EDF-9D1A-5A5210248938@egenera.com>
References: <5d96567b0602282304o558fb564jd72784bafdd289f5@mail.gmail.com> <440561CB.30201@yahoo.de> <4405A656.1030602@rtr.ca> <20060301135547.GV4816@suse.de> <C6838977-5411-400F-9548-2F22598DC2AE@egenera.com> <4408C0D9.4010202@garzik.org> <98B59AFC-2781-4A8A-82E4-C923B4A48F9E@egenera.com> <4409E623.5070707@garzik.org>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4409E623.5070707@garzik.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Jens Axboe <axboe@suse.de>, Mark Lord <liml@rtr.ca>, Gentoopower <gentoopower@yahoo.de>, "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids


On Mar 4, 2006, at 2:10 PM, Jeff Garzik wrote:

> Steve Byan wrote:

>>> Data integrity -and- performance.  Performance increases for all   
>>> the standard reasons that an asynchronous pipeline increases   
>>> performance over a synchronous one.
>>>
>>> The write cache means that requests on the device can be  
>>> processed  asynchronously, but without NCQ there is still a  
>>> synchronous  bottleneck:  the device<->controller pipe.
>> True, but I think that is fairly small compared to no-write-cache- 
>> and- no-queuing case. Write-caching is the major win; optimizing  
>> the data  transfer is only a second-order effect.
>
> Measurements on NCQ in the field show a distinct performance  
> improvement...  30% has been measured on Linux.  Nothing to sneeze at.

Wow! 30% is amazing. I'd be interested in knowing how the costs break  
down; are these measurements published anywhere?

Regards,
-Steve
-- 
Steve Byan <smb@egenera.com>
Software Architect
Egenera, Inc.
165 Forest Street
Marlboro, MA 01752
(508) 858-3125


