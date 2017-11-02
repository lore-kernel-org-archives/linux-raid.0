From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: [sucess] upgrading LSI SAS9211-8i fw IR->IT
Date: Thu, 2 Nov 2017 21:51:05 +1100
Message-ID: <34e5cc74-2cb2-5059-0e11-8f26a8bee223@eyal.emu.id.au>
References: <08feefcc-14d0-e7ec-aa23-927ecbb63ac3@eyal.emu.id.au>
 <f268a7a1-6a73-8c9f-b4c8-1e8190f54850@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f268a7a1-6a73-8c9f-b4c8-1e8190f54850@eyal.emu.id.au>
Content-Language: en-AU
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26/10/17 14:31, Eyal Lebedinsky wrote:
> On 24/10/17 22:47, Eyal Lebedinsky wrote:

[trimmed the story of reflashing the LSI to the latest IT fw]

> As a final test I plan to boot the actual server with this card and 3 sacrificial
> disks (now all zeroed) attached, to confirm that nothing is written to the disks.

For the record, in closing this thread:
- I did the above test and confirmed that the disks are not written to by the driver.
- I replaced the HighPoint HBA with the LSI and simply moved the SFF-8087 across.
   The array came up without issue.
- I ran a full raid 'check' - zero mismatches.
   This was a good surprise because I had three cases of full array failures with the HighPoint and
   expected some corruption.

What I noted so far:
- the heat sink feels very hot even after short usage.
- the disks were now in a different order, pretty much reverse order.
   I am not sure the order will remain fixed (by port number?) or variable (as the disks spin up).

I thank all who responded, I found it very helpful.

cheers
	Eyal

> As an aside, I now do not see the text corruption I mentioned earlier, so it was
> probably the BIOS causing it and not FreeDOS.
> 
> cheers
 >	Eyal

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
