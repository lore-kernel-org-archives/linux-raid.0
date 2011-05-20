From: Phil Turmel <philip@turmel.org>
Subject: Re: Software raid, booting and bios
Date: Fri, 20 May 2011 15:32:59 -0400
Message-ID: <4DD6C1EB.1030907@turmel.org>
References: <9067914580344941270@unknownmsgid>	<ir58vs$9qp$1@dough.gmane.org> <20110520145623.749b4781@natsu> <ir5ci1$uc6$1@dough.gmane.org> <4DD65A66.5030904@turmel.org> <ir62p0$b5o$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ir62p0$b5o$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Paul van der Vlis <paul@vandervlis.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

{do use reply-to-all on kernel.org lists... not everyone is subscribed}

On 05/20/2011 11:53 AM, Paul van der Vlis wrote:
> Op 20-05-11 14:11, Phil Turmel schreef:
>> (Just to show what's out there.)  The embedded boards I use
>> occasionally have the equivalent of this soldered to their
>> motherboards.
>>
>> The best DMA capable CF cards are usually found in markets that cater
>> to industrial designers or to professional photographers.
> 
> Do you think the risk of a problem with a CF card (or something like
> that) is much lower then the risk of a problem with a harddisk?

the big deal is the lack of moving parts:  No spindle bearing, no head positioner gear train.  On top of that, when set up to support your boot tasks only, there's no write activity to wear it out.

> And what about booting from an USB stick?

Just as good, technically, IMHO.  If mounted internally, just as good, period.  Plugged into an external port, I'd be wary of some uninformed soul pulling it out.  CF cards look like they "belong".

I like Ed W's suggestions, as well, with the caveat that their usefulness would make them more likely to be "borrowed".  Even by yourself, in a pinch.

Phil
