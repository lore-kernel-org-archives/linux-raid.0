From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: Recent drive errors
Date: Tue, 19 May 2015 10:07:49 -0600
Message-ID: <34123545.0U2U7Wo4pc@balsa>
References: <3296560.sGbn0HyrQY@balsa> <2278721.7NtVspC26F@balsa> <555B4E0F.9020306@turmel.org>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <555B4E0F.9020306@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue 19 May 2015 10:51:59 AM you wrote:
> On 05/19/2015 10:32 AM, Thomas Fjellstrom wrote:
> > On Tue 19 May 2015 09:23:20 AM Phil Turmel wrote:
> >> Depends.  In a properly functioning array that gets scrubbed
> >> occasionally, or sufficiently heavy use to read the entire contents
> >> occasionally, the UREs get rewritten by MD right away.  Any UREs then
> >> only show up once.
> > 
> > I have made sure that it's doing regular scrubs, and regular SMART scans.
> > This time...
> 
> Yes, and this drive was kicked out.  Because it wouldn't be listening
> when MD tried to write over the error it found.

I didn't actually re-install this drive after the last time it was kicked out, 
which was when i didn't have regular scrubs (actually, it may have been, as it 
was probably the only thing that would cause activity on that array for many 
many months) or smart tests set up. I noticed the high start stop count, and 
the 5 errors, and decided to keep it out of the new array. I seem to recall 
one or more drives having suspiciously high start stop counts that then went 
on to fail, but it seems that isn't true, one of them is still in use (64k 
start stop events apparently, or it maxed out the counter).

Basically, I had an unused array of 3TB seagates, it sat doing virtually 
nothing but spinning its platters for quite a long time due to lack of time on 
my part, and some time between last summer and winter, it kicked out two 
drives all on its own. It was probably the monthly scrub. After I got back 
from a three month long trip, I rebuilt that array (and my main NAS, which 
also kicked out two drives... But thats a story for another time) with four of 
the old Seagates, and one new WD red. It was this drive that I removed at that 
time because it looked suspicious. Sadly, about a month or two later, a second 
drive got kicked out and was unambiguously faulty (thousands, if not 10k+ 
reallocated sectors), so I replaced it with two new WD Reds, and reshaped to a 
raid6. After that, I just decided to re-check the first drive to drop out, 
just to be safe, and here we are...

I'm running a badblocks -w on the drive as we speak, it'll probably be done in 
a day or two. We'll see if it changes anything. It's not exactly writing 
noise, but it aught to do the trick.

> I posted this link earlier, but it is particularly relevant:
> http://marc.info/?l=linux-raid&m=133665797115876&w=2
> 
> >> Interesting.  I suspect that if you wipe that disk with noise, read it
> >> all back, and wipe it again, you'll have a handful of relocations.
> > 
> > It looks like each one of the blocks in that display is 128KiB. Which i
> > think means those red blocks aren't very far apart. Maybe 80MiB apart?
> > Would it reallocate all of those? That'd be a lot of reallocated sectors.
> 
> Drives will only reallocate where a previous read failed (making it
> pending), then write and follow-up verification fails.  In general,
> writes are unverified at the time of write (or your write performance
> would be dramatically slower than read).

Right. I was just thinking about how you mentioned that I'd get a handful of 
reallocations based on the latency shown in the image I posted. It's a lot of 
sectors that seem to be affected by the latency spikes, so I assumed (probably 
wrongly) that many of them may be reallocated afterwards.

If this drive ends up not reallocating a single sector, or only a few, I may 
just keep it around as a hot spare, though i feel that's not the best idea, if 
it is degrading, then when it actually goes to use that disk it has a higher 
chance of failing.

> >> You have it backwards.  If you have WD Reds, they are correct out of the
> >> box.  It's when you *don't* have ERC support, or you only have desktop
> >> ERC, that you need to take special action.
> > 
> > I was under the impression you still had to enable ERC on boot. And I
> > /thought/ I read that you still want to adjust the timeouts, though not
> > the
> > same as for consumer drives.
> 
> Desktop / consumer drives that support ERC typically ship with it
> disabled, so they behave just like drives that don't support it at all.
>  So a boot script would enable ERC on drives where it can (and not
> already OK), and set long driver timeouts on the rest.
> 
> Any drive that claims "raid" compatibility will have ERC enabled by
> default.  Typically 7.0 seconds.  WD Reds do.  Enterprise drives do, and
> have better URE specs, too.

Good to know.

> >> If you have consumer grade drives in a raid array, and you don't have
> >> boot scripts or udev rules to deal with timeout mismatch, your *ss is
> >> hanging in the wind.  The links in my last msg should help you out.
> > 
> > There was some talk of ERC/TLER and md. I'll still have to find or write a
> > script to properly set up timeouts and enable TLER on drives capable of it
> > (that don't come with it enabled by default).
> 
> Before I got everything onto proper drives, I just put what I needed
> into rc.local.

It's going to be a long time before I can swap out the rest of the seagates. I 
just can't justify the cost atm, especially as its the backup for my main nas 
which used to be all 2TB seagates, but has since been retrofitted with two WD 
reds as two had thousands of reallocated sectors, funny thing is one of the 
seagates had already been replaced prior to that, so 3 out of 5 of the 
original setup failed. And before that, at least two 1TB seagates have failed 
on me (out of 7ish), I think maybe one 640G one went, and a couple 320s went. 
I won't blame the two 80s that I had that failed on seagate though, that was a 
power supply fault. Took out two drives out of five (total), memory, and made 
the motherboard a bit flaky.

Just a little bit jaded when it comes to seagates these days, but i still 
can't just up and swap them all out, even if its a good idea. If I had the 
money, I wouldn't mind just replacing them all with enterprise/nearline or NAS 
drives, and slap the seagates in a big zfs pool or something for some scratch 
space or just sell them...

> Chris Murphy posted some udev rules that will likely work for you.  I
> haven't tried them myself, though.
> 
> https://www.marc.info/?l=linux-raid&m=142487508806844&w=3

Thanks :)

> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
