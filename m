From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID 1 failure on single disk causes disk subsystem to lock up
Date: Mon, 31 Mar 2008 15:12:35 -0400 (EDT)
Message-ID: <alpine.DEB.1.00.0803311510590.17765@p34.internal.lan>
References: <47F020C6.1060809@tigertech.com> <alpine.DEB.1.00.0803310600330.10181@p34.internal.lan> <47F11FC2.6000401@tigertech.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47F11FC2.6000401@tigertech.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert L Mathews <lists@tigertech.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 31 Mar 2008, Robert L Mathews wrote:

> Justin Piszcz wrote:
>
>> Did you have swap on the RAID1 as well?
>
> Yes, although swap usage on these machines is generally zero (they have 4 GB 
> of RAM and there's rarely anything in swap at all).
>
> Even if there was some swap usage, though, that shouldn't cause this problem, 
> should it? The point of putting swap on RAID is to avoid exactly this kind of 
> issue.
Trying to recall, I don't know if my host froze up or not but it was 
lagging and being unresponsive, I have had this happen twice, once with a 
74gb raptor and once with a 150gb raptor, I know the second time I had to 
reboot to make it kickout the bad disk.  The first time though I do not 
recall if the host froze up but it was acting very strange.

74gb raptor was on a PCI system (no PCI-e) (i875p chipset i believe?)
150gb raptor was on a 965 chipset

