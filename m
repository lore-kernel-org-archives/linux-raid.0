From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: Fast (intelligent) raid1
Date: Tue, 11 Feb 2003 21:36:22 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302112036.h1BKaMV30242@oboe.it.uc3m.es>
References: <20030211201728.GA18346@willow.seitz.com>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030211201728.GA18346@willow.seitz.com> from Ross Vandegrift at
 "Feb 11, 2003 03:17:28 pm"
To: Ross Vandegrift <ross@willow.seitz.com>
Cc: "Peter T. Breuer" <ptb@it.uc3m.es>, Ingo Molnar <mingo@redhat.com>, neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"A month of sundays ago Ross Vandegrift wrote:"
> On Tue, Feb 11, 2003 at 08:47:04PM +0100, Peter T. Breuer wrote:
> > I've  now built the technology into the kernel raid1 code. It's
> > available from
> > 
> >    ftp://oboe.it.uc3m.es/pub/Programs/fr1-2.0.tgz
> 
> How much testing has this recieved?  I'd love to try it out, but it

Oh, virtually none. Why not try it on a couple of 4M loop devices
first. Thus:

    dd if=/dev/zero bs=1024k of=/tmp/foo0 count=4
    dd if=/dev/zero bs=1024k of=/tmp/foo1 count=4

    losetup /dev/loop0 /tmp/foo0
    losetup /dev/loop1 /tmp/foo1

raidtab:
    raiddev /dev/md0
      raid-level     1
      nr-raid-disks  2
      nr-spare-disks 0
      persistent-superblock 0
      chunk-size     4
      device         /dev/loop0
      raid-disk      0
      device         /dev/loop1
      raid-disk      1

and off you go ...

> might take me a bit to setup an array that could stand data loss.  On
> the other hand, if it's stable, I'd move to it pretty quickly.  This is
> a way cool feature.

I have had a headache understanding the current raid code. I don't
pretend to understand it all, and the effort I have made so far is
directed at letting the kernel raid authors see how to integrate the
extra technology into THEIR code, by putting up my best attempt. The
result works for me, but I would appreciate communication from this
list and the raid authors on what should be done.

Have a look at the patch in the .tgz. I tried to make it as clean as I
could. Every change I made in the md.c code is commented. There are 4
"hunks" of changes to md.c, to allow hotadd after setfaulty, and about
ten significant hunks of changes to raid1.c, inserting the extra
technology. There is some extra debugging code in that, which I can
remove if a minimal patch is required. The rest of the support is given
in a separate, new, bitmap.c file, which supplies infrastructure.

Peter

