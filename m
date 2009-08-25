From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Raid 5 - not clean and then a failure.
Date: Tue, 25 Aug 2009 14:47:05 +0100
Message-ID: <4A93EB59.3060408@anonymous.org.uk>
References: <264077.82481.qm@web51303.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <264077.82481.qm@web51303.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25/08/2009 09:40, Jon Hardcastle wrote:
> --- On Tue, 25/8/09, Robin Hill <robin@robinhill.me.uk> wrote:
>> On Tue Aug 25, 2009 at 12:54:49AM -0700, Jon Hardcastle wrote:
>>> I have been having some problems with my arrays that I think i have
>>> nailed down to a pci controller (well I say that - it is always the
>>> drives connected to *a* controller but I have tried 2!) anyway the
>>> latest saga is i was trying some new kernel options last night - which
>>> didn't work.
>>
>> Did they have the same chipset?  I had problems with PCI controllers on
>> one of my systems, which turned out to be some sort of conflict between
>> the onboard chipset and the chipset on the controllers.  I found a PCI
>> card with a different chipset and have had no issues since.
> 
> They are/were cheapy little via ones

That's your problem right there. Well, in my experience and therefore 
opinion, VIA stuff is all too often junk, or at least iffy enough never 
to be trusted with anything professional or important.

[...]
> I have a pci express controller but my kernel doesnt (yet!) support pci express.

*How old* is your kernel?

Cheers,

John.
