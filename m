From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Setting up md-raid5: observations, errors, questions
Date: Mon, 03 Mar 2008 00:56:29 +0300
Message-ID: <47CB228D.5020709@msgid.tls.msk.ru>
References: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>	 <47CAC5BF.6060600@msgid.tls.msk.ru>	 <bb145bd20803020832x744c2674nd0a6a30e445b5453@mail.gmail.com>	 <47CAF30F.7040502@msgid.tls.msk.ru> <bb145bd20803021319o28df011sab954aa58a1c01be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20803021319o28df011sab954aa58a1c01be@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Christian Pernegger wrote:
[]
>>  First, try to disable bitmaps on the raid array

It has been pointed out recently here on linux-raid that internal bitmap
doesn't work well:

Message-ID: <47C44DDB.3050201@free.fr>
Date:	Tue, 26 Feb 2008 18:35:23 +0100
From:	Hubert Verstraete <hubskml@free.fr>
To:	Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
Subject: internal bitmap size

Hi Neil,

Neil Brown wrote:
 > For now, you will have to live with a smallish bitmap, which probably
 > isn't a real problem.  With 19078 bits, you will still get a
 > several-thousand-fold increase it resync speed after a crash
 > (i.e. hours become seconds) and to some extent, fewer bits are better
 > and you have to update them less.
 >
 > I've haven't made any measurements to see what size bitmap is
 > ideal... maybe someone should :-)

I've made some tries with a 4 250GB disks RAID-5 array and the write
speed is really ugly with the default internal bitmap size.
Setting a bigger bitmap chunk size (16 MB for example) creates a small
bitmap. The write speed is then almost the same as when there is no
bitmap, which is great. And as you said, the resync is a matter of
seconds (or minutes) instead of hours (without bitmap).
With such a setting, I've got both a nice write speed and a nice resync
speed. That's where I would look at to find MY ideal bitmap size.
....


> Maybe I did that by accident for the various vmstat data for different
> RAID levels I posted previously. At least I forgot to explicitely
> specify a bitmap for those tests (see above).
> 
> It's my understanding that the bitmap is a raid chunk level journal to
> speed up recovery, correct? Doing that reduces the window during which
> a second disk can die with catastrophic consequences -> bitmaps are a
> good thing, especially on an array where a full rebuild takes hours.
> Seeing as the primary purpose of the raid5 is fault tolerance I could
> live with a performance penalty but why is it *that* slow?

Umm..  You mixed it all ;)

Bitmap is a place (stored somewhere... ;) where each equally-sized
block of the array has a single bit of information - namely, if that
block has been written recently (which means it was dirty) or not.
So for each block (which is in no way related to chunk size etc!)
we've an on/off switch, telling us if the said block has to be
re-syncronized if we need to perform re-syncronisation of data -
for example, in case of power loss -- only those blocks marked
"dirty" in the bitmap needs to be recalculated and rewritten,
not the whole array.

This has nothing to do with window between first and second disk
failure.  Once first disk fails, bitmap is of no use anymore,
because you will need a replacement disk, which has to be
resyncronized in whole, because it's shiny new.  Bitmap only
helps for unclean shutdown, and only if there was no recent write
activity (which hasn't been "comitted" by md layer and the array
hasn't been re-marked as clean - it happens every 0.21 sec by
default - see /sys/block/mdN/md/safe_mode_delay).

> If I put the bitmap on an external drive it will be a lot faster - but
> what happens, when the bitmap "goes away" (because that disk fails,
> isn't accessible, etc)?
> Is it goodbye array or is the worst case a full resync? How well is
> the external bitmap supported?
> (That same consideration kept me from using external journals for ext3.)

If the bitmap is unaccessible, it's handled as there was no bitmap
at all - ie, if the array was dirty, it will be resynced as a whole;
if it was clean, nothing will be done.  Bitmap gives a set of blocks
to OMIT from resyncronisation, and if that information is unavailable...

Yes, external bitmaps are supported and working.  It doesn't mean
they're faster however - I tried placing a bitmap into a tmpfs (just
for testing) - and discovered about 95% drop in speed compared to the
case with internal bitmap (ie, only 5% speed when bitmap is on tmpfs -
bitmap size was the same).  It was long (more than a year) ago so things
may have changed already.


I highly doubt chunk size makes any difference.  Bitmap is the primary
suspect here.

/mjt
