From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: Recommended pci-e 1x SATA cards.
Date: Thu, 14 Apr 2011 21:14:39 +1000
Message-ID: <4DA6D71F.6000007@crc.id.au>
References: <4DA6CCFE.8020708@crc.id.au> <20110414165433.7a7d1cdc@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110414165433.7a7d1cdc@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/04/2011 8:54 PM, Roman Mamedov wrote:
> On Thu, 14 Apr 2011 20:31:26 +1000
> Steven Haigh<netwiz@crc.id.au>  wrote:
>
>> I'm looking at adding a couple of SATA ports to my home server and
>> figure its probably better to get a 1x pci-e card instead of using the
>> PCI bus.
>>
>> Has anyone got any recommendations on cheap pci-e SATA cards that work
>> well with linux?
>>
>> Any comments on these?
>> http://cgi.ebay.com.au/PCI-E-PCIE-RAID-Express-Card-SATA-II-Controller-A24-/220762966195?pt=AU_Computer_Components_Controller_Cards&hash=item33667f88b3
>>
>> http://cgi.ebay.com.au/PCI-E-PCIE-RAID-Express-Card-2-SATA-II-2-eSATA-A25-/300543913241?pt=AU_Components&hash=item45f9d02d19
>>
>> This is a jMicron adapter - but I haven't heard much good or bad about them.
>> http://cgi.ebay.com.au/PCI-E-PCIE-Express-Card-2-SATA-RAID-II-Controller-/260745100434?pt=AU_Computer_Components_Controller_Cards&hash=item3cb59e7c92
>>
>> Any others that people recommend?
>>
>
> JMicron is okay, it's an AHCI compatible controller, so does not even require
> its own driver module, it just uses 'ahci'. Keep in mind that it is not a
> PCI-E 2.0 device, and the transfer speed will be limited to 250 MB/sec over
> both ports (and because of various overheads, something closer to 200 MB/sec).
> A couple of modern disks can easily reach and become limited by that.

Hmmm - this might be an idea... I have two 1x slots on the mainboard - 
and I have 8 x hotswap bays. The current setup has 5 drives (2 x 80Gb 
RAID1, 3 x 1Tb RAID5) plus one eSATA drive off the mainboard. Speed is 
great, but I can't see myself getting more than 8 drives in this unit - 
ever.

> I suggest that you avoid Silicon Image 3132, they have data corruption issue
> (on some board designs?), triggered or amplified by transferring via both
> ports at the same time, at full speed.

Thanks for the pointer!

> If you can spend a bit more, try finding a controller based on Marvell 9123,
> which is a 2-port SATA3 chip for PCI-E 2.0. For example "ASRock SATA3 Card"
> which is sold separately (from motherboards) for about $33.
> https://encrypted.google.com/search?hl=en&source=hp&q=ASRock%20SATA3%20Card
> The only downside of that device, is that it doesn't seem to be compatible
> with PCI-E 1.0, it is 1.1/2.0 only, so will not work on many old motherboards.

Hmmm - I tried looking for these anywhere in Australia and came up 
empty. ebay is probably my preferred source for any card - as a lot of 
the time stuff like this is just not available in Australia at any kind 
of decent cost.

--
Steven Haigh

Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299

There are no great men, only great challenges that ordinary men are 
forced by circumstances to meet. -- Admiral William Halsey
