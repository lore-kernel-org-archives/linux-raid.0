From: Nix <nix@esperi.org.uk>
Subject: Re: Recovery on new 2TB disk: finish=7248.4min (raid1)
Date: Tue, 02 May 2017 00:26:58 +0100
Message-ID: <87mvawi2f1.fsf@esperi.org.uk>
References: <590117CD.1000009@tesco.net>
        <22785.65375.947842.648174@quad.stoffel.home>
        <5492628.c8B43Z4h0G@matkor-lenovo>
        <22786.16524.435313.304834@quad.stoffel.home>
        <87o9veje3v.fsf@esperi.org.uk> <20170430182134.0e8c6dc0@natsu>
        <87fugpkhap.fsf@esperi.org.uk> <20170430214729.2a02cce5@natsu>
        <8737cojn54.fsf@esperi.org.uk> <20170502024657.6d33fd88@natsu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170502024657.6d33fd88@natsu> (Roman Mamedov's message of "Tue,
        2 May 2017 02:46:57 +0500")
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: John Stoffel <john@stoffel.org>, Mateusz Korniak <mateusz-lists@ant.gliwice.pl>, Ron Leach <ronleach@tesco.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1 May 2017, Roman Mamedov outgrape:

> On Mon, 01 May 2017 22:13:59 +0100
> Nix <nix@esperi.org.uk> wrote:
>> I'd be more worried about the complexity required to just figure out the
>> space needed for half a dozen sets of lvmcache metadata and cache
>> filesystems.
>
> Metadata can be implicitly created and auto-managed in recent lvm versions 
> http://fibrevillage.com/storage/460-how-to-create-lvm-cache-logical-volume
> ("Automatic pool metadata LV"). If not, the rule of thumb suggested everywhere

Useful.

> is 1/1000 of the cache volume size; I doubled that just in case, and looks
> like I didn't have to, as my metadata partitions are only about 9.5% full each.

Still seems like something that shouldn't need to be in a separate LV at
all (though .1% is not something to be worried about: it just seems
inelegant to me).

> As for half a dozen sets, I'd reconsider the need for those, as well as the
> entire fast/slow HDD tracks separation, just SSD-cache everything and let it
> figure out to not cache streaming writes on your video transcodes, or even bulk
> writes during your compile tests (while still caching the filesystem metadata).
> 
> However the world of pain begins if you want to have multiple guest VMs each
> with its disk as a separate LV. One solution (that doesn't sound too clean but
> perhaps could work), is stacked LVM, i.e. a PV of a different volume group made
> on top of a cached LV.

Yeah. Or, as I have, multiple LVs for encrypted filesystems with
distinct passphrases and mount lifetimes, all of which I want to cache.
(And I want the cache to cache the *encrypted* data, obviously, but both
LVM and bcache will do that.)

I think LVM needs something like bcache's cache sets -- i.e. the ability
to have one cache for multiple LVs (this would be even more flexible
than doing it at the VG level, since you retain the current ability to
cache only some LVs without having to figure out how much cache each
needs).

-- 
NULL && (void)
