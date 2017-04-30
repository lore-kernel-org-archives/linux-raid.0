From: Nix <nix@esperi.org.uk>
Subject: Re: Recovery on new 2TB disk: finish=7248.4min (raid1)
Date: Sun, 30 Apr 2017 17:10:22 +0100
Message-ID: <87fugpkhap.fsf@esperi.org.uk>
References: <590117CD.1000009@tesco.net>
        <22785.65375.947842.648174@quad.stoffel.home>
        <5492628.c8B43Z4h0G@matkor-lenovo>
        <22786.16524.435313.304834@quad.stoffel.home>
        <87o9veje3v.fsf@esperi.org.uk> <20170430182134.0e8c6dc0@natsu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170430182134.0e8c6dc0@natsu> (Roman Mamedov's message of "Sun,
        30 Apr 2017 18:21:34 +0500")
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: John Stoffel <john@stoffel.org>, Mateusz Korniak <mateusz-lists@ant.gliwice.pl>, Ron Leach <ronleach@tesco.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30 Apr 2017, Roman Mamedov spake thusly:

> On Sun, 30 Apr 2017 13:04:36 +0100
> Nix <nix@esperi.org.uk> wrote:
>
>> Aside: the storage server I've just set up has a different rationale for
>> having multiple mds. There's one in the 'fast part' of the rotating
>> rust, and one in the 'slow part' (for big archival stuff that is rarely
>> written to); the slow one has an LVM PV directly atop it, but the fast
>> one has a bcache and then an LVM PV built atop that. The fast disk also
>> has an md journal on SSD. Both are joined into one LVM VG. (The
>> filesystem journals on the fast part are also on the SSD.)
>
> It's not like the difference between the so called "fast" and "slow" parts is
> 100- or even 10-fold. Just SSD-cache the entire thing (I prefer lvmcache not
> bcache) and go.

I'd do that if SSDs had infinite lifespan. They really don't. :)

lvmcache doesn't cache everything, only frequently-referenced things, so
the problem is not so extreme there -- but the fact that it has to be
set up anew for *each LV* is a complete killer for me, since I have
encrypted filesystems and things that *have* to be on separate LVs and I
really do not want to try to figure out the right balance between
distinct caches, thanks (oh and also you have to get the metadata size
right, and if you get it wrong and it runs out of space all hell breaks
loose, AIUI). bcaching the whole block device avoids all this pointless
complexity. bcache just works.

>> So I have a chunk of 'slow space' for things like ISOs and video files
>> that are rarely written to (so a RAID journal is needless) and never
>> want to be SSD-cached, and another (bigger) chunk of space for
>> everything else, SSD-cached for speed and RAID-journalled for powerfail
>> integrity.
>> 
>> (... actually it's more complex than that: there is *also* a RAID-0
>> containing an ext4 sans filesystem journal at the start of the disk for
>> transient stuff like build trees that are easily regenerated, rarely
>> needed more than once, and where journalling the writes or caching the
>> reads on SSD is a total waste of SSD lifespan. If *that* gets corrupted,
>> the boot machinery simply re-mkfses it.)
>
> You have too much time on your hands if you have nothing better to do than
> to babysit all that b/s.

This is a one-off with tooling to manage it: from my perspective, I just
kick off the autobuilders etc and they'll automatically use transient
space for objdirs. (And obviously this is all scripted so it is no
harder than making or removing directories would be: typing 'mktransient
foo' to automatically create a dir in transient space and set up a bind
mount to it -- persisted across boots -- in the directory' foo' is
literally a few letters more than typing 'mkdir foo'.)

Frankly the annoyance factor of having to replace the SSD years in
advance because every test build does several gigabytes of objdir writes
that I'm not going to care about in fifteen minutes would be far higher
than the annoyance factor of having to, uh, write three scripts about
fifteen lines long to manage the transient space.

-- 
NULL && (void)
