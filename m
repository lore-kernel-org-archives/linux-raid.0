From: Dave Gomboc <dave_gomboc@acm.org>
Subject: Re: raid10 recovery assistance requested
Date: Mon, 23 Sep 2013 12:57:50 +0000
Message-ID: <CA+dwz-0Y6+778sPHKn90B6dPNUyC7E__vhzR3BpeKaUgJQumqg@mail.gmail.com>
References: <CA+dwz-3hWizOmbzBDBV3K4DPM1D3WUPRn_d63-FhS+5RZ-ffvQ@mail.gmail.com>
 <CA+dwz-2DUsx6JK=TYfKc8eGbAiHo2orhnBQv5HfOTNXAi9hv7g@mail.gmail.com>
 <523A7DB9.9070600@hardwarefreak.com> <CA+dwz-1=VQE1pgCctrdbvw99Qq2c_me1aYUJGU0E2sJ2Y-JdpA@mail.gmail.com>
 <CA+dwz-27furxUt=vQAhN8Va_gk3v545in3=kQVMG4eO5SqdCrQ@mail.gmail.com>
 <523F6692.9090407@turmel.org> <CA+dwz-36m6KDKbh9Gwxne8o-UyZuR2e5Z5-dKtOPS1XkA518yA@mail.gmail.com>
 <523F7C62.4040305@turmel.org> <CA+dwz-0eskPSQ44v0vgwfjwRpTbQaokQ3Q258Em1W2eRi1SO4w@mail.gmail.com>
 <523FAD81.9070005@turmel.org> <CA+dwz-2Me3g3udQh90k6EjCMjr+uqyoujCdMM9=tsKEnsmkzdA@mail.gmail.com>
 <523FB511.5070001@turmel.org> <CA+dwz-31yG3Y4xzmUoiMNtLw=q1pE_GTyNqSk5WBAsGDCGT9iw@mail.gmail.com>
 <523FBAB2.7070506@turmel.org> <CA+dwz-2qqYbL1uFmL+vnS=ht6ZHxMDkRRBUYPz0KFQZNZkeK-A@mail.gmail.com>
 <523FBFAA.3050705@turmel.org> <CA+dwz-2CMaoquRso8d=FZ1X5cEWE0vz7ceR6zhwzR2xM=1FM9A@mail.gmail.com>
 <524034D2.4010407@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <524034D2.4010407@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, mailinglists@websitemanagers.com.au
List-Id: linux-raid.ids

> Good morning Dave,

Good morning!

>> It should be ext3, not NTFS.
>
> Since you are sure it is ext3, then you should use "fsck.ext3 -y" to fix
> it.  I usually try that operation first with "-n" instead of "-y", but
> your mount attempts show that the "-n" would be superfluous.  If fsck
> scrambles that volume worse, then you'll have to recopy from your
> backups and redo the forced assembly.  Or try with the other two disks.

I'm pretty darn sure it's ext3.  I guess there is a small chance that
all of them were upgraded to ext4 from ext3.

I saw Adam's post before yours, so I did first try various
command-lines using -n:

fsck.ext3 -n /dev/mapper/teramooch-srv
e2fsck 1.42.7 (21-Jan-2013)
ext2fs_open2: Bad magic number in super-block
fsck.ext3: Superblock invalid, trying backup blocks...
fsck.ext3: Bad magic number in super-block while trying to open
/dev/mapper/teramooch-srv

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>

[man fsck.ext3 mentions a backup superblock possibly being located at
8193, 16384, or 32768].

root@sysresccd /root % fsck.ext3 -n -b 8193 /dev/mapper/teramooch-srv
e2fsck 1.42.7 (21-Jan-2013)
fsck.ext3: Bad magic number in super-block while trying to open
/dev/mapper/teramooch-srv

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>

root@sysresccd /root % fsck.ext3 -n -b 16384 /dev/mapper/teramooch-srv
e2fsck 1.42.7 (21-Jan-2013)
fsck.ext3: Bad magic number in super-block while trying to open
/dev/mapper/teramooch-srv

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>

root@sysresccd /root % fsck.ext3 -n -b 32768 /dev/mapper/teramooch-srv
e2fsck 1.42.7 (21-Jan-2013)
fsck.ext3: Bad magic number in super-block while trying to open
/dev/mapper/teramooch-srv

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>

[The same commands, except using fsck.ext4 instead of fsck.ext3, also
gave the same generic output.  Finally, I tried the -y:]

root@sysresccd /root % fsck.ext3 -y /dev/mapper/teramooch-srv
e2fsck 1.42.7 (21-Jan-2013)
ext2fs_open2: Bad magic number in super-block
fsck.ext3: Superblock invalid, trying backup blocks...
fsck.ext3: Bad magic number in super-block while trying to open
/dev/mapper/teramooch-srv

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>

The above output was also returned instantaneously, despite the use of -y.

I have to head to work, but I would be happy to make further attempts
when I'm home again.

Dave
