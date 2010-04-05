From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Linux Raid performance
Date: Mon, 05 Apr 2010 18:49:24 -0500
Message-ID: <4BBA7704.700@gmail.com>
References: <r2v7efa8a7d1003311242vfa92024ar93ad2123a7b49806@mail.gmail.com> 	<x2q7efa8a7d1004021055oe2e832ccl8877e9171b8f3442@mail.gmail.com> 	<l2j5bdc1c8b1004021739z969b99v6011fcc6fddd470a@mail.gmail.com> 	<4BB69670.3040303@sauce.co.nz> <4BB7856C.30808@shiftmail.org> 	<4BB79D76.7090206@sauce.co.nz> <4BB8A979.3020502@shiftmail.org> 	<4BB91FBC.10504@sauce.co.nz> <4BB9C76E.7080607@shiftmail.org> 	<4BBA3ED9.6040800@sauce.co.nz> <j2wc268e4661004051403m94fba242v5a53dee2cee72cc4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j2wc268e4661004051403m94fba242v5a53dee2cee72cc4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Drew wrote:
>> The RAID array is 16 devices attached to a port expander in turn attached to
>> a SAS controller. At a most simplistic level, surely the SAS controller has
>> overhead attached to which drive is being addressed.
> 
> Don't forget that with a port expander is still limited to the bus
> speed of the link between it and the HBA. It doesn't matter how many
> drives you hang off an expander, you will still never exceed the rated
> speed (1.5/3/6Gb/s) for that one port on the HBA.

If it is a SAS connect to the RAID array, they are often quad channel 
cables (12Gbits/second-ie 4x3Gbps), this is what is on the external 
connection of the card, not a single channel sas/sata like the lower 
end stuff, and most of the more expensive expanders and raid cabinents 
use that.

Still the entire 16disk setup will be limited to be less that whatever 
the interconnect is, and if you start piling more than 16 disks onto 
it things get pretty messy pretty fast.

> 
> Say you have four drives behind an expander on a 6Gb/s link. Each
> drive in the array could still bonnie++ at the full 6Gb/s but once you
> try to write to all four drives simultaneously (RAID-5/6), the best
> you can get out of each is around 1.5Gb/s.
> 
> That's why I don't use expanders except for archival SATA drives,
> which AFAIK only go one expander deep. The performance penalty isn't
> worth the cost savings in my books.
> 
> 

