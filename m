From: Asdo <asdo@shiftmail.org>
Subject: Re: Question about raid robustness when disk fails
Date: Wed, 27 Jan 2010 10:22:36 +0100
Message-ID: <4B6005DC.7070701@shiftmail.org>
References: <1262972385.8962.159.camel@kije>
 <87hbqeyua9.fsf@frosties.localdomain>
 <7d86ddb91001261619kbb77697t2660e5b8cc44535d@mail.gmail.com>
 <4877c76c1001262022p369eac60s639d87cad743ff94@mail.gmail.com>
 <87vden2a2a.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <87vden2a2a.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Michael Evans <mjevans1983@gmail.com>, Ryan Wagoner <rswagoner@gmail.com>, Tim Bock <jtbock@daylight.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> Michael Evans <mjevans1983@gmail.com> writes:
>   
>> Why doesn't the kernel issue a pessimistic alternate 'read' path (on
>> the other drives needed to obtain the data) if the ideal method is
>> late.  It would be more useful for time-sensitive/worst case buffering
>> to be able to customize when to 'give up' dynamically.
>>     
>
> That is a verry good question. I look forward to seeing patches for this
> from you. :) I think it isn't done because nobody has bothered to write
> the code yet but maybe I'm wrong and it would make the code too
> complicated.
>   

This is probably more complicated than allowing a timeout to be set at 
the MD layer or block-device layer, isn't it?

Which would be just as good I think.

Is it possible to cancel a SATA/SCSI command that is being executed by 
the drive?
(it's probably feasible only with NCQ disabled anyway, but it's easy to 
disable NCQ)


It's a pity we have to rely on TLER, this narrows the choice of drives a 
lot...
