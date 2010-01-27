From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Question about raid robustness when disk fails
Date: Wed, 27 Jan 2010 11:25:53 +0100
Message-ID: <87wrz3zvwu.fsf@frosties.localdomain>
References: <1262972385.8962.159.camel@kije>
	<87hbqeyua9.fsf@frosties.localdomain>
	<7d86ddb91001261619kbb77697t2660e5b8cc44535d@mail.gmail.com>
	<4877c76c1001262022p369eac60s639d87cad743ff94@mail.gmail.com>
	<87vden2a2a.fsf@frosties.localdomain> <4B6005DC.7070701@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B6005DC.7070701@shiftmail.org> (asdo@shiftmail.org's message of
	"Wed, 27 Jan 2010 10:22:36 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Michael Evans <mjevans1983@gmail.com>, Ryan Wagoner <rswagoner@gmail.com>, Tim Bock <jtbock@daylight.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Asdo <asdo@shiftmail.org> writes:

> Goswin von Brederlow wrote:
>> Michael Evans <mjevans1983@gmail.com> writes:
>>
>>> Why doesn't the kernel issue a pessimistic alternate 'read' path (on
>>> the other drives needed to obtain the data) if the ideal method is
>>> late.  It would be more useful for time-sensitive/worst case buffering
>>> to be able to customize when to 'give up' dynamically.
>>>
>>
>> That is a verry good question. I look forward to seeing patches for this
>> from you. :) I think it isn't done because nobody has bothered to write
>> the code yet but maybe I'm wrong and it would make the code too
>> complicated.
>>
>
> This is probably more complicated than allowing a timeout to be set at
> the MD layer or block-device layer, isn't it?

There is a timeout at various levels already but for example the scsi
specs alow for quite some time till you give up, as in a minute. You
would certainly want something much much smaller here.

So from the top of my head here is what I imagine you need: You would
need to set a timeout for reading a block. Then once the timeout is
reached you need to read the rest of the stripe if not available
already. Do you ready every block in a stripe or just enough to get the
data? You might not need all blocks, e.g. a 3 way raid1 or a raid6
doesn't need all blocks. But then you have another timeout situation
there.

So lets say we read all blocks for simplicity sake. Then you might have
scheduled more reads than you need and when enough reads were
successfull you should not wait for the rest but return the data
imediatly. Late arrivals from extra reads (or the original) you then
have to also handle. Or do you cancel them? Also the original read might
succeed before the extra reads return.

It might also be wise to notice when additional reads are slower than
the original and if that happens often then increase the initial timeout
slightly. But a warning for the admin would do to so he can adjust the
timeout himself.


I don't think setting the timeout for the initial read will be
complicated but handling the alternatives will be not trivial. If yo
implement it you probably find more problems along the way.

> Which would be just as good I think.
>
> Is it possible to cancel a SATA/SCSI command that is being executed by
> the drive?
> (it's probably feasible only with NCQ disabled anyway, but it's easy
> to disable NCQ)

Do you want to do that? I would rather have the drive keep trying and
return an error if it can't read so the raid layer rewrites the blocks
causing it to be remapped. I do not want to wait for that but I want it
to happen.

> It's a pity we have to rely on TLER, this narrows the choice of drives
> a lot...

I don't. I just acknowledge the limitation and accept the downtime to
find and remove a broken but not properly failed disk. I use raid so I
don't loose my data when a disk fails, not primarily for availability.
So far I had one case in 10 years where a failing disk took down my
system.

MfG
        Goswin
