From: Nix <nix@esperi.org.uk>
Subject: Re: Encrypted software RAID1 with Debian Stretch
Date: Thu, 14 Sep 2017 16:02:31 +0100
Message-ID: <87wp51qq60.fsf@esperi.org.uk>
References: <28c61e8c14f44ec6727b8f3fb3c80c98@riseup.net>
        <59A92C91.7010508@youngman.org.uk> <87y3pjv6jw.fsf@esperi.org.uk>
        <3a85ea27-602a-3f5b-3537-d4159a56c2ed@thelounge.net>
        <87377qvh7t.fsf@esperi.org.uk> <59B95891.9040809@youngman.org.uk>
        <87r2v9sfkm.fsf@esperi.org.uk> <59BA6FAF.9020501@youngman.org.uk>
        <878thhsa0w.fsf@esperi.org.uk> <20170914183932.001ffe25@natsu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170914183932.001ffe25@natsu> (Roman Mamedov's message of "Thu,
        14 Sep 2017 18:39:32 +0500")
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14 Sep 2017, Roman Mamedov said:

> On Thu, 14 Sep 2017 14:08:15 +0100
> Nix <nix@esperi.org.uk> wrote:
>
>> Backups based on not-yet-reliable filesystems are, uh, less effective.
>
> You're just grasping for straws at this point. Single-device Btrfs and
> its core features like snapshotting and compression are very solid, it is
> silly trying to "cast doubt" on those.

I'm not grasping for straws, but I do think I'm a lot more conservative
than you where backups are concerned!

I've experienced total data loss on btrfs owing to -ENOSPC with
outstanding snapshots (saved by... backups! On a separate filesystem, of
course). It *was* two years ago, but backup-medium filesystems are
long-lived: two years isn't actually that long: some of mine are fifteen
years old. "Haven't lost data in the last two years" is not really good
enough for a backup filesystem in my view. Snapshotting was not solid
then: though it might be now, a mere two years' experience is not enough
to be sure enough of it for backups, at least not for me. (It's only
recently I moved off unjournalled ext2 for my backups, when the
five-year mark since I experienced data loss on ext4 passed -- and I was
unsure whether five years was too soon.)

>                                        Thousands of people use Btrfs for their
> primary storage, it is certainly more than stable enough to be used for
> backups (which by definition are just a copy of stuff also existing elsewhere).

Another way of putting it is that by the time you need backups they are
probably your *only copy* of your data and you have probably just
experienced some sort of data-loss disaster. It *is* certain that every
occurrence of such a disaster *will* be followed by a need for your
backups. They have to be *more* reliable than your primary filesystem,
not *less* reliable.

> And yeah rsync+Btrfs snapshotting are an amazing combination, it works really
> well for backups, and the easiness of the workflow to access older versions of
> a file or the whole dir tree is unsurpassed by anything imaginable.

I dunno, I find 'bup fuse mnt; cd mnt/backup/latest/blah/blah' to be
more or less the same, workflow-wise. (It just has more dependencies, to
wit FUSE.)

I would never consider snapshots on the same filesystem to be a backup
of anything, except possibly as a defence against 'oh whoops I rm'ed the
wrong tree'. If you btrfs send them somewhere else, perhaps... and of
course btrfs *does* make that easy, and you can store the result on any
filesyste you like, including via deduplicating backup programs that
don't rely on btrfs :) now *that* is a tempting model. btrfs send | bup split,
hmmm :)

... though of course if you do that it's useful only as a mass restore
system: you can't use it for individual-file restoration. However, bup
being what it is, you can combine a btrfs send | bup split with a normal
bup index/bup save at rarer intervals and get deduplication of the whole
lot, with restores of individual files at 'bup save' frequency (where
the backups pay the cost of a 'bup index' filesystem walk), and far
higher-frequency backups that are suitable for full image restores but
do not pay the cost of any sort of filesystem walk at all and can be
done every half hour if you wanted to :) with full deduplication against
all the other backups.

-- 
NULL && (void)
