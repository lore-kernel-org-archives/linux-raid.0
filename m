From: Nix <nix@esperi.org.uk>
Subject: Re: Recommended filesystem for RAID 6
Date: Wed, 12 Aug 2020 15:07:33 +0100
Message-ID: <87wo24arfe.fsf@esperi.org.uk>
References: <CAF-KpgYcEF5juR9nFPifZunPPGW73kWVG9fjR3=WpufxXJcewg@mail.gmail.com>
        <1381759926.21710099.1597158389614.JavaMail.zimbra@karlsbakk.net>
        <4a7bfca8-af6e-cbd1-0dc4-feaf1a0288be@fritscher.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4a7bfca8-af6e-cbd1-0dc4-feaf1a0288be@fritscher.net> (Michael
        Fritscher's message of "Tue, 11 Aug 2020 21:19:07 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Michael Fritscher <michael@fritscher.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11 Aug 2020, Michael Fritscher told this:
> ext4 is fine. In my experience, it is rock-solid, and also fsck.ext4 is
> fairly qick (don't know what Roy is doing that it is so slow - do you
> really made a full-fledged ext4 with journal or a old ext2 file system?^^)

I note that modern mkext2fs leaves whole block groups uninitialized if
it can, and any block groups that end up with no files in again get
marked uninitalized once more (as of e2fsprogs 1.43). If an older
e2fsprogs than that is in use, or if this is an fs too old to support
unintialized block groups, or if the fs simply doesn't have uninit_bg
enabled (which requires explicit action at creation time, these days),
e2fsprogs will be massively slower than if it can exploit the
uninitialized bgs to (basically) skip huge chunks of the fsck work on
most of the fs that is known to be empty.

Without this optimization, one component of fsck time is linear in the
total size of the fs: with it, it's linear in the *allocated* space used
on the fs. (There are other passes that scale as number of allocated
inodes, number of directories, etc.)

-- 
NULL && (void)
