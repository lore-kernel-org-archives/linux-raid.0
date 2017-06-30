From: Phil Turmel <philip@turmel.org>
Subject: Re: Disk Monitoring
Date: Fri, 30 Jun 2017 10:35:38 -0400
Message-ID: <94fcf340-4924-2f01-e616-a9b6ba172459@turmel.org>
References: <20170628131917.BF1911235B6@gemini.denx.de>
 <CAJH6TXhJ8HoH=tnxreZ4EAFYQYDh05KHAQxwoLqp1f7zQM4N0g@mail.gmail.com>
 <2113365.0QvyMCaQ9I@matkor-lenovo>
 <CAJH6TXiONYigcX1CtQw86ZXUgeOLvzD_+2couNfxSwL9hHj1gA@mail.gmail.com>
 <59550FCB.4090508@youngman.org.uk>
 <CAJH6TXg+xf0giY5bC_ug4jm+t88LzHkTVJq_BYeYzxEKedF2OA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXg+xf0giY5bC_ug4jm+t88LzHkTVJq_BYeYzxEKedF2OA@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/30/2017 08:35 AM, Gandalf Corvotempesta wrote:
> 2017-06-29 16:33 GMT+02:00 Wols Lists <antlists@youngman.org.uk>:
>> In other words, a patrol check looks for a failing disk. A consistency
>> check looks for corrupt data. (A consistency check does a patrol check
>> as a side effect, but you might not want to do just that, as it is
>> computationally much more expensive. You might want to do a patrol check
>> every day, and a consistency check of a weekend.)
> 
> Ok, so, if resources are not a problem, someone could only run a
> consistency check and totally skip the patrol check. Right ?

Hardware raid and MD raid are not directly comparable.  Based on your
description, patrol read and consistency check are separate functions in
your hardware raid.  (I don't do hardware raid, myself.)

In MD raid, you have a "check" scrub which reads all member devices to
find and rewrite any UREs (patrol read), while comparing mirrors/parity
for mismatches.  You end up with a "mismatch count" in sysfs when done.

You also have a "repair" scrub which also reads all data blocks in
parity arrays and first mirrors and write all parity and other mirrors.
This is only recommended when a "check" scrub finds mismatches, as this
type of scrub can miss developing bad sectors on parity blocks and other
mirrors.  (Drives can only *detect* failing sectors on *read*, and can
only relocate them on *write* *after* detection.)

> What about md reliability? There are many detractors out there.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=99171

That's hardly a great case.  Changing data in a chunk of memory in one
thread while another thread is writing it out is undefined behavior and
MD will give you back something that was there at the time of actual
write.  Do that with hardware raid and you will gain consistency, but
you'll still have jumbled data.  Real applications don't do this or they
have much bigger problems than raid mirror mismatches.

> One of the most common complaint is the absence of write-back cache,
> and if you force a "writeback" you'll risk data loss in case of
> unclean shutdown (power failure and so on)

The only good reason for hardware raid, in my opinion.  Balanced against
vendor lock-in, limited layout options, and a plethora of management
interfaces.

Phil
