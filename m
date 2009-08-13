From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: max number of devices in raid6 array
Date: Thu, 13 Aug 2009 16:22:55 +1200
Message-ID: <4A83951F.1020604@sauce.co.nz>
References: <20090812090600.GF21118@nfs-rbx.ovh.net>	<55226.78.86.108.203.1250069920.squirrel@www.yuiop.co.uk>	<20090812121911.GG21118@nfs-rbx.ovh.net>	<87ab259j8m.fsf@frosties.localdomain>	<60099.78.86.108.203.1250094780.squirrel@www.yuiop.co.uk> <87zla44e9a.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87zla44e9a.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Goswin von Brederlow wrote:

> On top of that the stress of rebuilding usualy greatly increases the
> chances. And with large raids and todays large disks we are talking
> days to weeks or rebuild time. As you said, the 433 years are assuming
> that one drive failure doesn't cause another one to fail. In reality
> that seems to be a real factor though.

I am intrigued as to what this extra stress actually is.

I could understand if the drives were head thrashing for hours, but as I 
understand it, a rebuild just has all drives reading/writing in an 
orderly cylinder by cylinder fashion, so while the read/write 
electronics are being exercised continuously, mechanically there is not 
much going on, except I guess for the odd remapped sector that would 
involve a seek.

I figure that by far the more common reason for the array to fail due to 
another disc being kicked out, is due to undiscovered uncorrectable read 
errors.

The risk of striking these can be reduced by regularly performing md 
"check" or "repairs" - echo check > /sys/block/mdX/md/sync_action.

Regards,

Richard
