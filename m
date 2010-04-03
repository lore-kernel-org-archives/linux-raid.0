From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Check/repair RAID-5 with hints?
Date: Sat, 03 Apr 2010 02:06:38 +0100
Message-ID: <4BB6949E.2020205@anonymous.org.uk>
References: <4BB5D9B1.8070000@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB5D9B1.8070000@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/04/2010 12:49, John Robinson wrote:
> I have just replaced one of the drives in my RAID-5 array which was 
> showing offline uncorrectable and current pending sectors. I took the 
> system down into single-user mode, failed the disc out of the array, 
> dd_rescue'd the disc to a fresh one, and added the new disc back into 
> the array. During the dd_rescue, 68k of 1TB failed, about 1MB from the 
> end of the disc. My array has a write-intent bitmap so the resync was 
> very quick. So now I have an active, theoretically synchronised RAID-5, 
> and I know some 68k on one of the discs is likely rubbish.

Turns out not to be a problem. I ran a 
check>/sys/block/md1/md/sync_action and got no mismatches, which I guess 
means there isn't a problem. This probably means it was an unused 
portion of the disc so 00 ^ 00 == 00 or whatever.

I'd still be interested in a solution to this in case something similar 
comes up again.

Cheers,

John.

