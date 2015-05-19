From: Phil Turmel <philip@turmel.org>
Subject: Re: Recent drive errors
Date: Tue, 19 May 2015 10:51:59 -0400
Message-ID: <555B4E0F.9020306@turmel.org>
References: <3296560.sGbn0HyrQY@balsa> <84264713.v03zHsT0Cj@balsa> <555B3948.1030602@turmel.org> <2278721.7NtVspC26F@balsa>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2278721.7NtVspC26F@balsa>
Sender: linux-raid-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/19/2015 10:32 AM, Thomas Fjellstrom wrote:
> On Tue 19 May 2015 09:23:20 AM Phil Turmel wrote:

>> Depends.  In a properly functioning array that gets scrubbed
>> occasionally, or sufficiently heavy use to read the entire contents
>> occasionally, the UREs get rewritten by MD right away.  Any UREs then
>> only show up once.
> 
> I have made sure that it's doing regular scrubs, and regular SMART scans. This 
> time...

Yes, and this drive was kicked out.  Because it wouldn't be listening
when MD tried to write over the error it found.

I posted this link earlier, but it is particularly relevant:
http://marc.info/?l=linux-raid&m=133665797115876&w=2

>> Interesting.  I suspect that if you wipe that disk with noise, read it
>> all back, and wipe it again, you'll have a handful of relocations.
> 
> It looks like each one of the blocks in that display is 128KiB. Which i think 
> means those red blocks aren't very far apart. Maybe 80MiB apart? Would it 
> reallocate all of those? That'd be a lot of reallocated sectors.

Drives will only reallocate where a previous read failed (making it
pending), then write and follow-up verification fails.  In general,
writes are unverified at the time of write (or your write performance
would be dramatically slower than read).

>> You have it backwards.  If you have WD Reds, they are correct out of the
>> box.  It's when you *don't* have ERC support, or you only have desktop
>> ERC, that you need to take special action.
> 
> I was under the impression you still had to enable ERC on boot. And I 
> /thought/ I read that you still want to adjust the timeouts, though not the 
> same as for consumer drives.

Desktop / consumer drives that support ERC typically ship with it
disabled, so they behave just like drives that don't support it at all.
 So a boot script would enable ERC on drives where it can (and not
already OK), and set long driver timeouts on the rest.

Any drive that claims "raid" compatibility will have ERC enabled by
default.  Typically 7.0 seconds.  WD Reds do.  Enterprise drives do, and
have better URE specs, too.

>> If you have consumer grade drives in a raid array, and you don't have
>> boot scripts or udev rules to deal with timeout mismatch, your *ss is
>> hanging in the wind.  The links in my last msg should help you out.
> 
> There was some talk of ERC/TLER and md. I'll still have to find or write a 
> script to properly set up timeouts and enable TLER on drives capable of it 
> (that don't come with it enabled by default).

Before I got everything onto proper drives, I just put what I needed
into rc.local.

Chris Murphy posted some udev rules that will likely work for you.  I
haven't tried them myself, though.

https://www.marc.info/?l=linux-raid&m=142487508806844&w=3

Phil
