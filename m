From: Nix <nix@esperi.org.uk>
Subject: Re: Encrypted software RAID1 with Debian Stretch
Date: Wed, 13 Sep 2017 00:30:27 +0100
Message-ID: <87y3pjv6jw.fsf@esperi.org.uk>
References: <28c61e8c14f44ec6727b8f3fb3c80c98@riseup.net>
        <59A92C91.7010508@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59A92C91.7010508@youngman.org.uk> (Wols Lists's message of "Fri,
        1 Sep 2017 10:46:57 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: commentsabout@riseup.net, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1 Sep 2017, Wols Lists stated:

> On 01/09/17 00:58, commentsabout@riseup.net wrote:
>> I am trying to build a home backup system. The system (Debian Stretch) 
>> will be on a SSD. For the time being, I only have one pair of HDDs (the 
>> "Today" column in the picture) ; in the future (the "Future" column), I 
>> would like to add other pairs of HDD to store other kind of data. 
>> 
>> This backup system will only be turned on when needed, I don't plan on 
>> using it as some sort of server or a NAS. 
>> 
> Okay. Personal preference (and I don't do it myself, but I'd have to
> rebuild my system to do it) I would use btrfs for the filesystems. Yes
> it has a bad rep for its inbuilt raid, but if all you're doing is backup
> snapshots it should be great. Each backup cycle consists of "take a
> snapshot, do an in-place rsync", so if only 10MB of live data has
> changed, the backup only uses an extra 10MB on the backup drives.

This sounds like downright dangerous advice to me. Surely what matters
for backup is stability? Use something old and boring and stable. btrfs
is the very last thing you should be thinking of for this application.
After all, you'll only need the backups when things are already going
wrong: the last thing you want to find is that you've been using a
filesystem that has betrayed you at the last.

ext2 is probably too old (it's not maintained much any more), but ext4
with the default mkfs options is certainly good enough, or xfs likewise.
If you want deduplicated backups, use something that's torture-tested
for that (there are many choices: my personal preference is bup, but
there are other perfectly good options now), not a bleeding-edge
filesystem that still has data loss bugs reported fairly frequently and
data corruption bugs reported at not-especially-rare intervals.

> Note also, I've really only covered the raid aspect. I don't know lvm, I
> don't know btrfs.

I can tell. if you did, you wouldn't be recommending it for this
application. btrfs is cool and all, but it's also new, and in filesystem
land new means dangerous.

> I don't know LUKS. But this is exactly how I would set up a backup
> server.

FWIW, my current backup configuration is a pair of encrypted USB disks.

One is attached to my largest server, one is attached to an odroid at
the top of the house that does nothing else and is exported via the
network block device. Shortly after server boot, on first interactive
ssh to the server, I do a 'ykchalresp -H -2 backup' to provide the
passphrase via OATH-HOTP from my Yubikey. (I have passphrases stored in
two keyslots, matching two Yubikeys, in case one key fails.). I store
the resulting passphrase in a root-only-readable ramfs (not tmpfs: I
don't want the thing swapped out). The drives are *not* decrypted at
this stage: attackers who get root on the machine can wipe the backup
drives, but can only decrypt them if this is a targetted attack and they
know where the ramfs is.

Each backup drive's decrypted content is an ext4 fs with metadata csums
enabled: at backup time, the main backup drive (the one attached to the
server) is mounted on /mnt/backup in a separate filesystem namespace (so
it never appears mounted to normal users) and a bup index / bup save is
run. There are three classes of backup:

 - hourly. This runs every three hours and backs up all directories with
   a .backup file in them (and all subdirs): the .backup file is a bup
   exclusions file (a set of Python regexps) which can prohibit hourly
   backup of subsets of that dir. Only files under 500MiB are
   considered. I use this for home directories: they get a separate
   index, and are recorded as separate backup sets. This takes about
   two minutes a time, even though one of my home directories has
   multiple kernel source trees, GCC source trees and the like in it.
   (Lots of RAM to cache the entire FS tree is what counts here.)

   Only the server with homedirs on it runs this type of backup.

 - daily. This runs once a day and backs up everything not denoted in
   /etc/backup-exclusions and which is not a network filesystem, tmpfs,
   etc, and is not on the transient store (a fast RAID-0 array I use for
   stuff I can easily regenerate). Again, only files under 500MiB are
   considered. This takes about half an hour a time, almost entirely
   filesystem walking and index merging (bup's least efficient chunk of
   code). It runs on every machine I own, even the home cinema.

 - weekly. This runs once a week (duh) and backs up everything the daily
   backup does plus files >500MiB in size. It does a second 'bup save'
   to the second backup drive sitting upstairs, which is my offsite
   drive and is regularly swapped out to another locale. If the house
   burns down, I'll at least have weekly backups starting at the last
   time I swapped this out. If the house floods, well, that's why it's
   sitting upstairs. The nice thing about bup is that even though this
   does two backups, it only needs to do one filesystem walk :)

Every day at 5am (or, for the offsite backup, every week), we wake up
and generate par2 redundancy information for all new backup files,
because the problem with deduplication is that one bitflip can be
disastrous. Adding a bit of controlled redundancy back helps there.

The only way I could make this better, I think, is something I've
blathered about before, which is to do all backups on another machine
that does nothing else other than run my authentication services and
that is not even sshable into without special measures (a bang on the
door with a yubikey, roughly), then have that machine pull backups from
the other boxes. Hopefully this would have a smaller attack surface and
thus be harder for a sufficiently malicious attacker to break into and
wipe the drives. (Even that attacker would find it hard to wipe the
swapped-out offsite drive: it's powered off!)

-- 
NULL && (void)
