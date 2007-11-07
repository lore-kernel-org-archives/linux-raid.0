From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: Implementing low level timeouts within MD
Date: Wed, 07 Nov 2007 09:47:27 +0100
Message-ID: <873avil9wg.fsf@informatik.uni-tuebingen.de>
References: <1193418753.4771.17.camel@w100>
	<1193425254.10336.290.camel@firewall.xsintricity.com>
	<1193521561.7690.14.camel@w100>
	<1193529329.10336.366.camel@firewall.xsintricity.com>
	<1193552822.6541.8.camel@w100>
	<1193678521.10336.486.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193678521.10336.486.camel@firewall.xsintricity.com> (Doug
	Ledford's message of "Mon, 29 Oct 2007 13:22:01 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Alberto Alonso <alberto@ggsys.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford <dledford@redhat.com> writes:

> On Sun, 2007-10-28 at 01:27 -0500, Alberto Alonso wrote:
>> Even if the default timeout was really long (ie. 1 minute) and then
>> configurable on a per device (or class) via /proc it would really help.
>
> It's a band-aid.  It's working around other bugs in the kernel instead
> of fixing the real problem.

Checks and balances.

Don't trust anyone.

Also some things are broken in hardware. I have external raid boxes
connected via scsi but when I just power-down one of the boxes it
never gives an I/O error or timeout. It seems to just hang. Should I
start fixing the scsi controler firmware to give errors?

A general timeout in the md layer would fix the problems independent
of what controler card I use. A real nifty band-aid. Call it a saftey
blanket.

>> > Generally speaking, most modern drivers will work well.  It's easier to
>> > maintain a list of known bad drivers than known good drivers.
>> 
>> That's what has been so frustrating. The old PATA IDE hardware always
>> worked and the new stuff is what has crashed.
>
> In all fairness, the SATA core is still relatively young.  IDE was
> around for eons, where as Jeff started the SATA code just a few years
> back.  In that time I know he's had to deal with both software bugs and
> hardware bugs that would lock a SATA port up solid with no return.  What
> it sounds like to me is you found some of those.

There will always be bugs. I've seen scsi crash on error often enough
due to totaly broken drivers. You always run into that one odd race
condition the author never thought about when it really counts [MURPHY].

MfG
        Goswin
