From: Phil Turmel <philip@turmel.org>
Subject: Re: Recent drive errors
Date: Tue, 19 May 2015 09:23:20 -0400
Message-ID: <555B3948.1030602@turmel.org>
References: <3296560.sGbn0HyrQY@balsa> <555B2DEF.60905@turmel.org> <84264713.v03zHsT0Cj@balsa>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84264713.v03zHsT0Cj@balsa>
Sender: linux-raid-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/19/2015 08:50 AM, Thomas Fjellstrom wrote:
> On Tue 19 May 2015 08:34:55 AM Phil Turmel wrote:

>> Based on the smart report, this drive is perfectly healthy.  A small
>> number of uncorrectable read errors is normal in the life of any drive.
> 
> Is it perfectly normal for the same sector to be reported uncorrectable 5 
> times in a row like it did?

Yes, if you keep trying to read it.  Unreadable sectors stay unreadable,
generally, until they are re-written.  That's the first opportunity the
drive has to decide if a relocation is necessary.

> How many UREs are considered "ok"? Tens, hundreds, thousands, tens of 
> thousands?

Depends.  In a properly functioning array that gets scrubbed
occasionally, or sufficiently heavy use to read the entire contents
occasionally, the UREs get rewritten by MD right away.  Any UREs then
only show up once.

In a desktop environment, or non-raid, or improperly configured raid,
the UREs will build up, and get reported on every read attempt.

Most consumer-grade drives claim a URE average below 1 per 1E14 bits
read.  So by the end of their warranty period, getting one every 12TB
read wouldn't be unusual.  This sort of thing follows a Poisson
distribution:

http://marc.info/?l=linux-raid&m=135863964624202&w=2

> These drives have been barely used. Most of their life, they were either off, 
> or not actually being used. (it took a while to collect enough 3TB drives, and 
> then find time to build the array, and set it up as a regular backup of my 
> 11TB nas).

While being off may lengthen their life somewhat, the magnetic domains
on these things are so small that some degradation will happen just
sitting there.  Diffusion in the p- and n-doped regions of the
semiconductors is also happening while sitting unused, degrading the
electronics.

>>  It has no relocations, and no pending sectors.  The latency spikes are
>> likely due to slow degradation of some sectors that the drive is having
>> to internally retry to read successfully.  Again, normal.
> 
> The latency spikes are /very/ regular and theres quite a lot of them.
> See: http://i.imgur.com/QjTl6o3.png

Interesting.  I suspect that if you wipe that disk with noise, read it
all back, and wipe it again, you'll have a handful of relocations.

Your latency test will show different numbers then, as the head will
have to seek to the spare sector and back whenever you read through one
of those spots.

Or the rewrites will fix them all, and you'll have no further problems.
 Hard to tell.  Bottom line is that drives can't fix any problems they
have unless they are *written* in previously identified problem areas.

>> I own some "DM001" drives -- they are unsuited to raid duty as they
>> don't support ERC.  So, out of the box, they are time bombs for any
>> array you put them in.  That's almost certainly why they were ejected
>> from your array.
>>
>> If you absolutely must use them, you *must* set the *driver* timeout to
>> 120 seconds or more.
> 
> I've been planning on looking into the ERC stuff. I now actually have some 
> drives that do support ERC, so it'll be interesting to make sure everything is 
> set up properly.

You have it backwards.  If you have WD Reds, they are correct out of the
box.  It's when you *don't* have ERC support, or you only have desktop
ERC, that you need to take special action.

If you have consumer grade drives in a raid array, and you don't have
boot scripts or udev rules to deal with timeout mismatch, your *ss is
hanging in the wind.  The links in my last msg should help you out.

Also, I noticed that you used "smartctl -a" to post a complete report of
your drive's status.  It's not complete.  You should get in the habit of
using "smartctl -x" instead, so you see the ERC status, too.

Phil
