From: Nix <nix@esperi.org.uk>
Subject: Re: Recovery on new 2TB disk: finish=7248.4min (raid1)
Date: Sun, 30 Apr 2017 13:04:36 +0100
Message-ID: <87o9veje3v.fsf@esperi.org.uk>
References: <590117CD.1000009@tesco.net>
        <22785.65375.947842.648174@quad.stoffel.home>
        <5492628.c8B43Z4h0G@matkor-lenovo>
        <22786.16524.435313.304834@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22786.16524.435313.304834@quad.stoffel.home> (John Stoffel's
        message of "Thu, 27 Apr 2017 15:03:40 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Mateusz Korniak <mateusz-lists@ant.gliwice.pl>, Ron Leach <ronleach@tesco.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27 Apr 2017, John Stoffel spake thusly:
> No, big MD devices are sync'd in parallel assuming MD thinks they're
> on seperate devices.  Now in this case I admit I might have jumped the
> gun, but I'm mostly commenting on the use of multiple MD RAID setups
> on a single pair of disks.
>
> It's inefficient.  It's a pain to manage.  You lose flexibility to
> resize.

Aside: the storage server I've just set up has a different rationale for
having multiple mds. There's one in the 'fast part' of the rotating
rust, and one in the 'slow part' (for big archival stuff that is rarely
written to); the slow one has an LVM PV directly atop it, but the fast
one has a bcache and then an LVM PV built atop that. The fast disk also
has an md journal on SSD. Both are joined into one LVM VG. (The
filesystem journals on the fast part are also on the SSD.)

So I have a chunk of 'slow space' for things like ISOs and video files
that are rarely written to (so a RAID journal is needless) and never
want to be SSD-cached, and another (bigger) chunk of space for
everything else, SSD-cached for speed and RAID-journalled for powerfail
integrity.

You can't do that with one big md array, since you can't have one array
which is partially journalled and partially not. (You *can*, with the
aid of dm, have one array which is partially bcached and partially not,
but frankly messing about with direct dm linears seemed pointlessly
painful. It's annoying enough to set up an md->bcache->LVM setup at
boot: adding dmsetup to that as well seemed like pain beyond the call of
duty.)

(... actually it's more complex than that: there is *also* a RAID-0
containing an ext4 sans filesystem journal at the start of the disk for
transient stuff like build trees that are easily regenerated, rarely
needed more than once, and where journalling the writes or caching the
reads on SSD is a total waste of SSD lifespan. If *that* gets corrupted,
the boot machinery simply re-mkfses it.)

-- 
NULL && (void)
