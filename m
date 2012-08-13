From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: Disk Order
Date: Mon, 13 Aug 2012 10:28:03 +0200
Message-ID: <5028BA93.4060906@grumpydevil.homelinux.org>
References: <50281BB1.6030309@abpni.co.uk> <502842D7.40005@turmel.org> <50284495.2030004@abpni.co.uk> <50284C5F.80808@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50284C5F.80808@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Jonathan Tripathy <jonnyt@abpni.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13-08-12 02:37, Phil Turmel wrote:
> On 08/12/2012 08:04 PM, Jonathan Tripathy wrote:
>> Now, onto the topic of PCIe adapter. I was looking at this:
>> http://www.cclonline.com/product/42541/PEXSAT32/IDE-SATA-SCSI-Cards/StarTech-2-Port-SATA-6-Gbps-PCI-Express-SATA-Controller-Card/CNT1075/
>>
>>
>> Is that a bad model? Seems a little on the cheap side? Can anyone
>> suggest a good model?
> Amazon users aren't impressed.  But the limitation is really the PCIe x1
> v2 bus interface: 500MB/sec.  Two SSDs would certainly overwhelm it, and
> any other similar card.
>
> I have a similar card, the Highpoint 620, in an older system at home
> (PCIe v1): it maxes out at 200MB/sec.
>
> So, it depends on what you want it to do.
>
> {I'll let others make card recommendations--I prefer to *listen* to those.}
>
http://azerty.nl/0-1036-67180/promise-sata300-tx4-controll.html

That card usually gives good results. If you can find the following, 
those are very good:

http://azerty.nl/0-1640-381070/lsi-megaraid-sas-9211-8i-sto.html

There are other, perhaps even more simple cards from LSI with very good 
properties

Cheers,


Rudy -- who uses LSI cards, and still has some promise cards in use.
