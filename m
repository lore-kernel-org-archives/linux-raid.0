From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm RAID6 "active" with spares and failed disks; need help
Date: Fri, 27 Mar 2015 21:59:38 -0400
Message-ID: <55160B0A.1090405@turmel.org>
References: <54ABEE54.6020707@sympatico.ca> <BLU436-SMTP156F9ECC68035EAC3DFB5F181460@phx.gbl> <BLU437-SMTP96782B2C74C634FDED13D681420@phx.gbl> <54B305B2.6000702@lentijn.sess.ink> <54B3F7ED.1000809@youngman.org.uk> <BLU436-SMTP1430CA88C11B0E46F15BB3F81480@phx.gbl> <54C0C73A.4080409@lentijn.sess.ink> <BLU437-SMTP28725520E940DA3707A62F81090@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU437-SMTP28725520E940DA3707A62F81090@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Callaghan <matt_callaghan@sympatico.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Matt,

On 03/27/2015 07:48 PM, Matt Callaghan wrote:
> Back at it with fresh brain and fresh hardware. (several months ago I
> got part-way through Valentine's ideas but not all the way -- decided to
> get a clean setup before progressing further)
> 
> I have built a new (fresh/clean) server, and compiled+installed the
> latest mdadm v3.3.2.
> The 8x drives from this RAID6 array have also been moved to the new
> temporary server.
> 
> Now of course, in the new server, the device labels are different.
> I need to map the previous "known labels" in the old server (/dev/sdX)
> to the "new labels" in order to get the drive ordering for re-assembly
> right.
> http://www.linuxquestions.org/questions/linux-server-73/mdadm-raid6-active-with-spares-and-failed-disks%3B-need-help-4175530127/

I read through this.  Given all of the destructive actions you took, I
am doubtful you will ever get your data.  Like mounting "readonly".
That gives you a readonly filesystem, but it writes to the device.
Possibly a great deal if there's a journal to replay.  You also trimmed
much useful data with "grep" that probably would help us save you now.

However, in the hope you might have useful data that can be correlated
with current status, start with lsdrv [1].  Paste the output in your
reply with word wrap turned off.  That'll at least give us a correlation
between device name and serial number.

> e.g. before I had:
> {{{
> /dev/sd[nmlpiokj]1
> }}}

FWIW, it is not safe to use square bracket notation when order matters.

> , and now I have:
> {{{
> /dev/sd[abcdefghi]1
> }}}

The linux 'sd' driver has never guaranteed consistent device names.
It's merely an artifact of boot timing that makes it look that way.
Which is why array members have superblocks that record the roles.  You
absolutely *must* have accurate role numbers to get your data back.

Show complete 'mdadm -E' output for all of your member partitions as
they stand now.

> Unfortunately I don't have any smartctl output saved from the previous
> server and I can't find a way to map device drive label to serial numbers.
> Any thoughts how I could do this based on the data I have saved in that
> forum post?

Please show current 'smartctl -x' output for all of these devices, too.
 Just paste it all in your reply (with word wrap turned off).

Phil

[1] https://github.com/pturmel/lsdrv
