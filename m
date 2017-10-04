From: Phil Turmel <philip@turmel.org>
Subject: Re: hung grow
Date: Wed, 4 Oct 2017 17:53:00 -0400
Message-ID: <d21f169e-0546-aa00-ce19-b6688ba74da6@turmel.org>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
 <a528459f-8bf5-3e47-9c9a-7c040ad7ab81@youngman.org.uk>
 <CADg2FGYPENaUb7oDhOUu08VMhzygE365mqw=Lw332jBGbe1dGQ@mail.gmail.com>
 <0001704a-fe2f-e164-7694-f294a427ed83@gmail.com>
 <CADg2FGYRGYww6fTCYJCYRQvnrW70nZx-tTYpBP1+cyvzvTSpgA@mail.gmail.com>
 <cdf0fd70-ec6d-8e9d-6abd-6d9937b6a709@gmail.com>
 <d1bd0e82-9415-b6f4-2ffa-6e17bf636f34@youngman.org.uk>
 <CADg2FGaNtjN7=wYe6f07xEZ=mW2QFZdjtBFjQLDthn9w3Jw=NA@mail.gmail.com>
 <3173c10a-fbd9-f563-4c90-a9f63e020773@youngman.org.uk>
 <CADg2FGbSyvLykThXBpMd4MOuHgh2Q_-zPGm-HFxdYW2z4qsNDQ@mail.gmail.com>
 <c583e62d-f4c1-755e-3985-a37164910c2e@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c583e62d-f4c1-755e-3985-a37164910c2e@youngman.org.uk>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>, Curt <lightspd@gmail.com>
Cc: Joe Landman <joe.landman@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Curt,

Let me endorse Wol's prescription, with a few comments:

On 10/04/2017 05:08 PM, Anthony Youngman wrote:
> On 04/10/17 21:01, Curt wrote:

{ Side note: what possessed you to do a grow operation? }

>> I'll be doing a ddrescue on the drives tonight, but will wait till
>> Phil or someone chimes in with my next steps after I do that.

I haven't seen complete mdadm -E reports for all of these devices, nor
mdadm -D for the array itself.  Please do so now.  If you have any of
that from before the crash, please post that too.  Run mdadm -E on the
two earliest failed drives.

Post the uncut output inline here on the list, in plain text mode, with
line wrap disabled, please.

> If you've got enough to ddrescue all of those five original drives, then
> that's absolutely great.
> 
> Remember - if we can't get five original drives (or copies thereof) the
> array is toast.
>>
>> lol, chalk one more up for FML. "SCT Error Recovery Control command
>> not supported".  I'm guessing this is a real bad thing now?  I didn't
>> buy these drives or org set it up.
>>
> I'm not sure whether this is good news or bad. Actually, it *could* be
> great news for the rescue! It's bad news for raid though, if you don't
> deal with it up front - I guess that wasn't done ...

It is mixed news.  It is almost certainly the reason you've had drives
bumped out of your arrays.  I suspect these drives all report *PASSED*
from smartctl.  Which means that the drives really are good, just
suffering from ordinary uncorrected errors.

You'll certainly have to use the 180 second driver timeout work-around
to get through this crisis.

In the meantime, please run "smartctl -iA -l scterc" on each of your
drives, including the failed ones, and post the uncut output here.
{ Include the device name with each }

> Go and read the wiki - the "When Things Go Wrogn" section. That will
> hopefully help a lot and it explains the Error Recovery stuff (the
> timeout mismatch page). Fix that problem and your dodgy drives will
> probably dd without trouble at all.

Let me emphasize this.  The timeout mismatch problem is so prevalent and
your experience so common that I thought to myself "I bet this one is
timeout mismatch" when I read your first mail.

> Hopefully with all copied drives, but if you have to mix dd'd and
> original drives you're probably okay, you should now be able to assemble
> a working array with five drives by doing an

As already noted, you definitely need to use ddrescue on the third
drive that failed.  You may also need to ddrescue your four remaining
good drives if they also have "Pending Sector" counts.

> mdadm --assemble blah blah blah --update=revert-reshape
> 
> That will put you back to a "5 drives out of 7" working array. The
> problem with this is that it will be a degraded, linear array.

This is the correct next step, after all required ddrescues.

> I'm not sure whether a --display will list the failed drives - if it
> does you can now --remove them. So you'll now have a working, 7-drive
> array, with two drives missing.

This is the time to grab any backups you need of critical content.  Do
*not* write to the array at this point.  Get all your data off.

Then:

> Now --add in the two new drives. MAKE SURE you've read the section on
> timeout mismatch and dealt with it! The rebuild/recovery will ALMOST
> CERTAINLY FAIL if you don't! Also note that I am not sure about how
> those drives will display while rebuilding - they may well display as
> being spares during a rebuild.

The timeout mismatch fixes won't help your case.  You have no redundancy
left, so the kickout scenarios involved no longer apply.  They applied
when your first two drives were kicked out.  When timeouts are not
mismatched, MD raid *fixes* the occasional bad sector.

> Lastly, MAKE SURE you set up a regular scrub. There's a distinct
> possibility that this problem wouldn't have arisen (or would have been
> found quicker) if a scrub had been in place. And if you can set up a
> trigger that emails you the contents of /proc/mdstat every few days.
> It's far too easy to miss a failed drive if you don't have something
> shoving it in your face every few days.

If you have a timeout mismatch problem, one's array will die much sooner
with scrubs.  Because MD raid will fail to fix UREs, and it will find
them right away.

But again, get us the detailed reports, and we'll help make sure your
commands are correct.

Phil
