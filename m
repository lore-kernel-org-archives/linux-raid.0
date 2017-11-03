From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: [sucess] upgrading LSI SAS9211-8i fw IR->IT
Date: Fri, 3 Nov 2017 13:31:43 +1100
Message-ID: <c12a2a32-2321-1ed7-e1de-ce0e408552e1@eyal.emu.id.au>
References: <08feefcc-14d0-e7ec-aa23-927ecbb63ac3@eyal.emu.id.au>
 <f268a7a1-6a73-8c9f-b4c8-1e8190f54850@eyal.emu.id.au>
 <34e5cc74-2cb2-5059-0e11-8f26a8bee223@eyal.emu.id.au>
 <31706ffc-3a81-b844-261e-a84dd8c01deb@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <31706ffc-3a81-b844-261e-a84dd8c01deb@fnarfbargle.com>
Content-Language: en-AU
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/11/17 11:54, Brad Campbell wrote:
> On 02/11/17 18:51, Eyal Lebedinsky wrote:
> 
>> What I noted so far:
>> - the heat sink feels very hot even after short usage.
> 
> Yeah, they do get warm. Best to make sure you have a bit of airflow over them. It doesn't take much air movement to keep temps in check.
> 
>> - the disks were now in a different order, pretty much reverse order.
>>    I am not sure the order will remain fixed (by port number?) or variable (as the disks spin up).
> 
> The driver scans them in port/slot order, and apparently in order of increasing pci address in the case of multiple cards. In my case where I have staggered spinup enabled it spins them up in groups and then waits for them in order, so things don't tend to move around unless you shift hardware about or a drive fails.

I have only one card. However, I did not reconnect the drives to the SFF-8087 but merely moved the two harnesses
to the new card.

I recorded the S/N of the disks that were detected as c,d,e,f,g,h,i and recorded their physical
location (I had many disk failures/replacements in the 4 years life of this array).

Now, with the LSI, looking at the S/N I see the disks detected as h,g,f,e,d,c,i. I would understand
if two 4-way connectors were swapped, but this (mostly) reverse order?

I expect that the two sockets on the card are in different order, and the four lanes on each SFF
are also in reverse order.

BTW, sdi was always very slow to spin up so maybe this is why it is last rather than before sdd
if it followed the same reverse ordering.

> Make sure you do a periodic lsdrv just for records sake, but as yet I've not needed it. I keep a spreadsheet which lists which drive S/N is in which physical slot so when something happens I can just look up which drive needs to be popped without risk of pulling the wrong disk.

The HighPoint had a habit of resetting a nearby disk when hot-removing another so I always did the swapping
offline. Maybe the LSI is better? My 7 disk array (4TB WD blacks) had 11 replacements so far (4 years) ...

> I swapped out a set of highpoint controllers for these LSI units back in 2011 and it was the best thing I ever did for storage speed and reliability.

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
