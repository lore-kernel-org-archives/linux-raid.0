From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: feature suggestion to handle read errors during re-sync of raid5
Date: Sun, 31 Jan 2010 19:04:15 +0100
Message-ID: <87bpgai21s.fsf@frosties.localdomain>
References: <alpine.DEB.1.10.1001301331560.15329@uplift.swm.pp.se>
	<4B6471A1.2070407@texsoft.it> <4B6482BD.6090102@anonymous.org.uk>
	<alpine.DEB.1.10.1001302228540.15329@uplift.swm.pp.se>
	<4B65AD05.5050000@anonymous.org.uk> <4B65B10F.6060501@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B65B10F.6060501@shiftmail.org> (asdo@shiftmail.org's message of
	"Sun, 31 Jan 2010 17:34:23 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Asdo <asdo@shiftmail.org> writes:

> John Robinson wrote:
>> On 30/01/2010 21:33, Mikael Abrahamsson wrote:
>> [...]
>>> I think the 4k sector size on WD20EARS (for instance) is supposed
>>> to add more ECC information but I'm not sure how this will affect
>>> the 10^14 error rate.
>>
>> iirc part of the point of moving to 4K sectors is to improve the
>> error correction to something like 1 in 10^20 or 22 without losing
>> storage density, partly by using what was lost before in
>> inter-sector gaps and partly because you can do better with more
>> bits of ECC over more data.
> I remember the other way around: the purpose of 4k was to keep the
> same error rate while saving storage space

I thought the purpose of 4k was to reduce the number of blocks so the
wear leveling has to handle less data.

MfG
        Goswin
