From: Andrew Nelson <freeandy@gmail.com>
Subject: Re: will mdadm work with a raid created using raidtools
Date: Thu, 16 Feb 2006 11:31:06 -0600
Message-ID: <dt2csr$gac$1@sea.gmane.org>
References: <43F37BFB.4030908@gmail.com> <17395.45134.227188.527148@cse.unsw.edu.au> <dt24uh$fv8$1@sea.gmane.org> <20060216171413.GG8762@intoxicatedmind.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060216171413.GG8762@intoxicatedmind.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Frank Blendinger wrote:
> On Thu, Feb 16, 2006 at 09:15:27AM -0600, Andrew Nelson wrote:
> 
>>Feb 14 21:58:36 localhost kernel: hde: dma_timer_expiry: dma status == 0x21
>>Feb 14 21:58:46 localhost kernel: hde: DMA timeout error
>>Feb 14 21:58:46 localhost kernel: hde: dma timeout error: status=0x51 { DriveRea
>>dy SeekComplete Error }
>>Feb 14 21:58:46 localhost kernel: hde: dma timeout error: error=0x40 { Uncorrect
>>ableError }, LBAsect=1594001, high=0, low=1594001, sector=1593535
>>Feb 14 21:58:46 localhost kernel: end_request: I/O error, dev hde, sector 159353
>>5
>>
>>Does anyone have any idea what I'm doing wrong?
> 
> 
> It's probably not your fault - blame /dev/hde! This sounds like a bad
> error on the disk - you should really get a new one, and try to copy
> /dev/hde to the new disk (with dd_rescue for example). This _might_ save
> the data.
> 
> Then you can try to create the array with the new disk and hope that
> it will work.
> 


I thought the whole idea of a raid 1 was that if one drive went bad I could just
plug a new drive in and the raid would rebuild without problems.

What have I done wrong so that this isn't possible?

//andy

