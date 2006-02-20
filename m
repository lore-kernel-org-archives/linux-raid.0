From: Janos Farkas <jf-ml-k3-raid@lk8rp.mail.xeon.eu.org>
Subject: Re: raid1 with 1.2 superblock never marked healthy?
Date: Mon, 20 Feb 2006 10:13:40 +0100
Message-ID: <privx$1140425087.koan@lk8rp.mail.xeon.eu.org>
References: <priv$1140364975.koan@shadow.banki.hu> <17400.61822.230666.23651@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17400.61822.230666.23651@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On 2006-02-20 at 09:30:22, Neil Brown wrote:
> If you use an 'internal' bitmap (which is mirrored across all drives
> much like the superblock) then you don't need to specify a file name.
> However if you want the bitmap on a separate file, you have to have
> that name 'hard coded' in mdadm.conf (or similar).

I was under the impression that mdadm.conf is not extended for this :)
That would be a nice place compared to /etc/rc.d/whatever..

I was considering using external bitmap only because I've been bitten a
few times with journaling filesystems vs. cheap hard disks.  I'm not
sure if a few hard disks are a significant sample, but some of them
started developing bad sectors where the journal is stored.  I hoped
that having an external bitmap would reduce the wear on the mirrored
parts.  This way, if the bitmap (even on the same hard disk) is getting
flawed, probably both of the whole mirrors are intact enough for a last
(additional) backup.

> > I remember stopping/starting the array correctly does a resync again,
> > even without a reboot.
> Hmm... it seems to work for me... How exactly to you start it again.

Oops, I did not mean resync, but that spare confusion stuff.  When I do
mdadm -S /dev/md0, and then mdadm -A /dev/md0, I get:
"raid1: raid set md0 active with 1 out of 2 mirrors"
And I have to -r /dev/hda3, -a /dev/hda3, and that results in another
resync.

> No.  mdadm does not record the name of the bitmap file in the
> superblock.  Just like it does not record the names of component
> devices in the superblock.

Would it be a bad idea (apart from someone having to do the work :)?
(But probably a bit better would be doing it as the jfs/ext3 external
journals store uuid connecting the journal with the device itself).

> >    Array State : uu 1 failed
> Something is definitely wrong here... hda3 looks like a spare, but
> isn't.... I'll have a look and see what I can find out.

The only "unusual" thing is how it got set up, because on a semi-live
system, I started with the magic "missing" component to create another
half mirror while the previous one is running. "Unusual" because I never
thought of it as a bad idea, but maybe somehow it did cause what I'm
seeing.

The original command (then, trying to use bitmaps :) was:

# mdadm --create /dev/md1 --level 1 -n 2 -d 4 -e 1.2 \
  -b /etc/md/test1.bin --bitmap-chunk 64 missing /dev/hdc3

At some later time, I added /dev/hda3, which is the troubling "spare"
now.

Janos
