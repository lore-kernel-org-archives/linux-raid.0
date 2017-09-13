From: Nix <nix@esperi.org.uk>
Subject: Re: Encrypted software RAID1 with Debian Stretch
Date: Wed, 13 Sep 2017 14:52:22 +0100
Message-ID: <87377qvh7t.fsf@esperi.org.uk>
References: <28c61e8c14f44ec6727b8f3fb3c80c98@riseup.net>
        <59A92C91.7010508@youngman.org.uk> <87y3pjv6jw.fsf@esperi.org.uk>
        <3a85ea27-602a-3f5b-3537-d4159a56c2ed@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3a85ea27-602a-3f5b-3537-d4159a56c2ed@thelounge.net> (Reindl
        Harald's message of "Wed, 13 Sep 2017 03:34:21 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Wols Lists <antlists@youngman.org.uk>, commentsabout@riseup.net, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 13 Sep 2017, Reindl Harald uttered the following:

> Am 13.09.2017 um 01:30 schrieb Nix:
>> ext2 is probably too old (it's not maintained much any more)
>
> sorry, but when you are talking about betrayed filesystems above and
> then take ext2, a non journaled filesystem which takes ages for fsck,

On slow links like USB2, the overhead of throwing heaps of metadata into
the journal across such a slow link often dominates any overhead from
fsck, particularly if the filesystem is usually unmounted (as is often
also true of backup filesystems) so is unlikely to benefit from a
journal anyway. Of course this depends on the backup model. bup doesn't
trigger many metadata updates (a few huge files): the late lamented
obnam and rdiff-backup trigger lots.

Nonetheless, fs/ext2 is almost unmaintained these days, and bugs are
slowly creeping back in. fs/ext4 can take up its duties perfectly well
these days, reading and writing both ext4-sans-journal and traditional
ext2 filesystems perfectly well.

One person having no problems with a filesystem as new as btrfs does not
mean the filesystem is reliable enough to use for backup. The
reliability bar for such filesystems is far higher than that for fses in
daily use! (The required-feature bar is often also much lower. All they
have to do is store stuff that rarely changes and not lose it!)

> in your mouth....

Oh yes, it's Reindl, destroyer of mailing list civility everywhere. How
wonderful it isn't to find you here.

I can't even tell what 'in your mouth' *means* in this context, but I'm
fairly sure it's meant to be offensive, simply because *everything* you
say is meant that way. Are you arguing that ext2 is well-maintained,
and thus should be used, or that it is unjournalled and thus should not
be used, or that it is unjournalled and thus less reliable, or that fsck
is slow and therefore the filesystem is unreliable?

God knows, and I'll never find out... because you are going back in my
otherwise-empty killfile. However *did* you get out? (Probably it
happened after you became the first person in the history of the
spamassassin list to go into a moderation queue.)

I encourage everyone else who's had enough of Reindl to killfile him as
well. 80% of what he says is wrong, spoken in tones of great authority,
but thankfully he undermines his misinformation by being so thoroughly
unpleasant that nobody wants to follow his instructions. The real
problem is that he's just as viciously nasty to newbies seeking help,
and they won't know to killfile him...
