From: Redeeman <redeeman@metanurb.dk>
Subject: Re: detection/correction of corruption with raid6
Date: Fri, 19 Dec 2008 14:10:35 +0100
Message-ID: <1229692235.22331.134.camel@localhost>
References: <33141855.1229676046422.JavaMail.ngmail@webmail11.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <33141855.1229676046422.JavaMail.ngmail@webmail11.arcor-online.net>
Sender: linux-raid-owner@vger.kernel.org
To: piergiorgio.sartor@nexgo.de
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2008-12-19 at 09:40 +0100, piergiorgio.sartor@nexgo.de wrote:
> Hi,
> 
> thanks for the answer.
> I've still some comments on the topic, see below.
> 
> > Suppose we agree that bit flips don't happen (undetected) on drive
> > media.  But that bit flips can happen elsewhere (memory.  IO Buss
> > etc).
> > 
> > And then suppose we discover that a bit-flip has happened.  What does
> > that tell us?
> > Maybe it tells us that our hardware is dodgey.  So it cannot be
> > trusted to reliably do anything we tell it.  So maybe we shouldn't
> > tell it to do anything. ??
> 
> Maybe I should try to clarify the concept.
> There are *two* use cases.
> One is the "check" and one is the "repair".
> As I already wrote, I do agree that "repair" needs some deeper
> thinking. It is easy to see cases where it could produce more
> damages.
> The "check" case is another story.
> In case of RAID-6 I would like, as RFE, to have in the logs some
> report on which "drive" or "data path" the mismatch occurs, when
> detectable.
> So, if the mismatch count says there are 1024 mismatches, then
> would be nice to know if they belong all to the same drive or not.
> In this case, it would be possible to fail/remove that one and
> check the hardware (change drive/cable/connector/etc.).
> 
> Ideally, at the end of the "check", the log should report how
> many mismatches, how many are "undeterminable" (multiple
> drive), how many could belong to a specific drive.
> This will help to to diagnose a problem, maybe reported by
> the CRC in the filesystem.

Agreed :)

> This is for the "check", about the "repair", the only possible
> change I could see is to offer the user, and we could check
> in this mailing list how many would like to have the possibility,
> the option to "reset the parity" of the array or "recalculate the
> data", with the warning that the second one can do more
> damage than already has.
Yes, there is ofcourse the possibility to do damage, but i think if its
2 vs 1, thats something most people would bet on, atleast if its
multiple occourances all with the same "1".

:)

> 
> Conclusion, for me, is that the "check" should be more
> clever, with RAID-6, and "repair/resync" *might* be more
> flexible (with warnings).


> 
> I take the opportunity to wish you all Merry Christmas
> and Happy New Year.

And to you too!
> 
> bye,
> 

