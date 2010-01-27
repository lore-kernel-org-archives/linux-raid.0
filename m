From: Asdo <asdo@shiftmail.org>
Subject: Re: Question about raid robustness when disk fails
Date: Wed, 27 Jan 2010 11:43:56 +0100
Message-ID: <4B6018EC.7090805@shiftmail.org>
References: <1262972385.8962.159.camel@kije>
 <87hbqeyua9.fsf@frosties.localdomain>
 <7d86ddb91001261619kbb77697t2660e5b8cc44535d@mail.gmail.com>
 <4877c76c1001262022p369eac60s639d87cad743ff94@mail.gmail.com>
 <87vden2a2a.fsf@frosties.localdomain> <4B6005DC.7070701@shiftmail.org>
 <87wrz3zvwu.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <87wrz3zvwu.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
>> Is it possible to cancel a SATA/SCSI command that is being executed by
>> the drive?
>> (it's probably feasible only with NCQ disabled anyway, but it's easy
>> to disable NCQ)
>>     
>
> Do you want to do that? I would rather have the drive keep trying and
> return an error if it can't read so the raid layer rewrites the blocks
> causing it to be remapped. I do not want to wait for that but I want it
> to happen.
>   
So you want that to happen in the background?
Not that much benefit for that to happen in the background, imho.
Why not just having an error returned after a timeout, and normal MD 
read-error-recovery procedure kicking in? (recomputation from parity and 
rewrite of the damaged block)

>> It's a pity we have to rely on TLER, this narrows the choice of drives
>> a lot...
>>     
>
> I don't. I just acknowledge the limitation and accept the downtime 
The time might be so long that MD or the controller can drop the entire 
drive.
It didn't happen to me but I think I read something like this on this ML...
> to
> find and remove a broken but not properly failed disk. I use raid so I
> don't loose my data when a disk fails, not primarily for availability.
> So far I had one case in 10 years where a failing disk took down my
> system.
>   

