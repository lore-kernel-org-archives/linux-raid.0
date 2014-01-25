From: Dag Nygren <dag@newtech.fi>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Sat, 25 Jan 2014 12:23:18 +0200
Message-ID: <1731429.tcuHV4H7OX@eseries.newtech.fi>
References: <20140121171943.GC6553@blisses.org> <52E2C5A3.1050803@turmel.org> <4ACB5D8F-CC0F-4CF2-96C7-03D05E40C89A@colorremedies.com>
Reply-To: dag@newtech.fi
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ACB5D8F-CC0F-4CF2-96C7-03D05E40C89A@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday 24 January 2014 13:54:35 Chris Murphy wrote:
> 
> On Jan 24, 2014, at 12:57 PM, Phil Turmel <philip@turmel.org> wrote:
> 
> > On 01/24/2014 02:32 PM, Chris Murphy wrote:
> >>>> So a URE is either 4096 bits nonrecoverable, or 32768 bits 
> >>>> nonrecoverable, for HDDs. Correct?
> >>> 
> >>> Yes.  Note that the specification is for an *event*, not for a
> >>> specific number of bits lost.  The error rate is not "bits lost per
> >>> bits read", it is "bits lost event per bits read".
> >> 
> >> I don't understand this. You're saying it's a "1 URE event in 10^14
> >> bits read" spec? Not a "1 bit nonrecoverable in 10^14 bits read"
> >> spec?
> >> 
> >> It seems that a nonrecoverable read error rate of 1 in 2 would mean,
> >> 1 bit nonrecoverable per 2 bits read. Same as 512 bits nonrecoverable
> >> per 1024 bits read. Same as 1 sector nonrecoverable per 2 sectors
> >> read.
> > 
> > I don't know what more to say here.  Your "seems" is not.
> 
> Please define "bits lost event" and cite some reference. Google returns exactly ONE hit on that, which is this thread. If we cannot agree on the units, we aren't talking about the same thing, at all, with a commensurately huge misunderstanding of the problem and thus the solution.
> 
> So please to not merely respond to the 2nd paragraph you disagree with. Answer the two questions above that paragraph.
> 
> If the spec is "1 URE event in 1E14 bits read" that is "1 bit nonrecoverable in 2.4E10 bits read" for a 512 byte physical sector drive, and hilariously becomes far worse at "1 bit nonrecoverable in 3E9 bits read" for 4096 byte physical sector drives.
> 
> A very simple misunderstanding should have a very simple corrective answer rather than hand waiving and giving up.

I don't see your problem?

1. 1 bit unrecoverable = Data is wrong
2. 1 URE = Data is wrong

They are the same thing! And that will give you the average probablility
of getting a read error?

Best
Dag
