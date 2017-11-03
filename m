From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: [sucess] upgrading LSI SAS9211-8i fw IR->IT
Date: Fri, 3 Nov 2017 14:39:59 +1100
Message-ID: <ff083a20-71e3-1888-71fc-33142fa20f27@eyal.emu.id.au>
References: <08feefcc-14d0-e7ec-aa23-927ecbb63ac3@eyal.emu.id.au>
 <f268a7a1-6a73-8c9f-b4c8-1e8190f54850@eyal.emu.id.au>
 <34e5cc74-2cb2-5059-0e11-8f26a8bee223@eyal.emu.id.au>
 <31706ffc-3a81-b844-261e-a84dd8c01deb@fnarfbargle.com>
 <c12a2a32-2321-1ed7-e1de-ce0e408552e1@eyal.emu.id.au>
 <7c6c1f27-c0c4-b9d3-4027-470d89377122@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7c6c1f27-c0c4-b9d3-4027-470d89377122@fnarfbargle.com>
Content-Language: en-AU
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/11/17 14:03, Brad Campbell wrote:
> On 03/11/17 10:31, Eyal Lebedinsky wrote:
> 
>> The HighPoint had a habit of resetting a nearby disk when hot-removing another so I always did the swapping
>> offline. Maybe the LSI is better? My 7 disk array (4TB WD blacks) had 11 replacements so far (4 years) ...
>>
> 
> I've swapped out everything from individual disks to entire arrays with the machine running. If possible and I care about the disk I'll take care to spin it down with hdparm first, but regardless the LSI controllers have behaved flawlessly.
> 
> The only issue I see periodically is when a smart poll coincides with some seriously heavy activity I might get one or more messages like the following in dmesg :
> 
> [1936062.640198] mpt2sas_cm0: log_info(0x31120303): originator(PL), code(0x12), sub_code(0x0303)
> 
> Generally I only see those during my monthly array scrub where every disk in every array is going hammer and tongs simultaneously and I've never seen an issue related to those messages.

I will keep an eye on such messages.

A message I saw once is this one:
	kernel: mpt3sas 0000:01:00.0: invalid short VPD tag 00 at offset 1
which a web search suggests is effectively a warning.
It coincides with an 'lspci' that runs nightly.

On another machine I do at times see the same from a NIC:
	kernel: r8169 0000:04:00.0: invalid short VPD tag 00 at offset 1
Again, probably from 'lspci'.

> Unrelated an with regard to SSD, for TRIM to work you need "returns deterministic" *and* "returns zero" set for the card to enable trim. I have some intel 330's that do, and some Samsung 830s that don't. Apparently the 840Pro was the only Samsung drive that did the business.
> 
> When I do my next SSD upgrade (these are only 60% gone after 6 years) I'll seek out drives that have the right features.
> 
> I recently upgraded one of my base servers and had to replace an 8 port LSI with a 16 port (2x2008 with 1x2016). I did the same firmware upgrade and there have been no performance or reliability issues. I really like the LSI cards.
> 
> Odd to hear of your disk issues. I just swapped out 7 WD Green drives with 6 years on them. I started with 10 and lost 1 to early life, and 2 to grown defects in the last year or so (classic bathtub curve). They were early units though that still had TLER enabled on them. The only drives I've had mass attrition on were Seagate/Maxtor 1TB 7200.11, and they were known as not great units.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
