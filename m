From: Neil Brown <neilb@suse.de>
Subject: Re: recovery from mkswap on mounted raid1 ext3 filesystem?
Date: Tue, 16 May 2006 12:41:44 +1000
Message-ID: <17513.15336.921542.232057@cse.unsw.edu.au>
References: <87hd3qu2xu.fsf@uwo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Christensen on Monday May 15
Sender: linux-raid-owner@vger.kernel.org
To: Dan Christensen <jdc@uwo.ca>
Cc: linux-raid@vger.kernel.org, Adrian Bunk <bunk@stusta.de>
List-Id: linux-raid.ids

On Monday May 15, jdc@uwo.ca wrote:
> I accidentally ran mkswap on an md raid1 device which had a mounted
> ext3 filesystem on it.  I also did a swapon, but I don't think
> anything was written to swap before I noticed the mistake.  How much
> of the partition is toast, and is it something e2fsck might fix?

oh dear....

I think (and an strace seems to confirm) that mkswap only writes in
the first 4k of the device.  This will have held the superblock, but
there is always at least one backup - I think it is as block 8193.
But 'fsck -n' should help you out, though you might need
'fsck.ext2 -n' as 'fsck' might think it is a swap device...

Ofcourse, if the filesystem is mounted, then unmounting the filesystem
should write the superblock, which might fix any corruption you
caused..

I'm very surprised that swapon worked if the fs was mounted - there
should be mutual exclusion there.

> 
> Moreover, shouldn't the mkswap command check whether a device is in
> use before overwriting it?

Yes, but before 2.6 this was very hard to do (in 2.6 it is easy, just
open with O_EXCL).  I doubt mkswap has seen much maintenance
later.... not since Dec 2004 in fact.  And the only checks it does is
to make sure you aren't running mkswap on /dev/hda or /dev/hdb !!!

Adrian:  You seem to be the MAINTAINER of mkswap.. any chance of 
opening for O_EXCL as well as O_RDWR.  That would make it a lot safer.

NeilBrown
