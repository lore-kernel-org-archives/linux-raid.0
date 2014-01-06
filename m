From: Phil Turmel <philip@turmel.org>
Subject: Re: Looking for some advice on best way to identify drives / recover
 from issues
Date: Mon, 06 Jan 2014 11:54:51 -0500
Message-ID: <52CADFDB.5060605@turmel.org>
References: <CAJrqPH9FNtomPygu1XPm2VQpJg3MKX1zUPCt0AOnzQ4GO7YEEQ@mail.gmail.com>	<52C9A5BB.4090803@turmel.org> <21194.53857.185374.195036@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21194.53857.185374.195036@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Dylan Distasio <interzone@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/06/2014 10:57 AM, John Stoffel wrote:
>>>>>> "Phil" == Phil Turmel <philip@turmel.org> writes:
> 
> Phil> I created a script for precisely this type of documentation task, keyed
> Phil> to drive serial numbers and UUIDs wherever identifiable.
> 
> Phil> https://github.com/pturmel/lsdrv
> 
> Phil,
> 
> Thanks for the script, it looks good, but I wanted to poke you about
> the continuation and corner vars, which are defined with funky graphic
> chars.  Would it be hard to put in simpler plain ASCII graphics there
> by default, and offer a switch for UTF-8 (???) output?

I'll take patches that make the script locale-aware using python2's
normal methods.  I hadn't bothered to figure out how to do so since
distros have been installing with utf-8 by default for years now.  I do
not want to give up the utf-8 line drawing characters for the majority.

> Also, I wonder if having it going the other way, which is from mount
> point down to the device(s) would make sense as well?  Now I just need
> to find the time to hack your code and see what I can do.

Shouldn't be hard.

I chose not to go in that direction as it would leave out unmounted
devices.  My intent is to document the relationships amongst everything
present (with SNs and UUIDs) to the fullest extent possible.

Thanks for the feedback.

Phil
