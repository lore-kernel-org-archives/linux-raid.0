From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Fast (intelligent) raid1
Date: Mon, 17 Feb 2003 14:07:41 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15952.20989.131713.951636@notabene.cse.unsw.edu.au>
References: <200302112305.h1BN5nu16695@oboe.it.uc3m.es>
	<200302141133.h1EBX6D22963@oboe.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter T. Breuer on Friday February 14
To: ptb@it.uc3m.es
Cc: Ross Vandegrift <ross@willow.seitz.com>, Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday February 14, ptb@it.uc3m.es wrote:
> I'll compress this down to an even more abstract summary ...
> 
> "Peter T. Breuer wrote:"
> > "Peter T. Breuer wrote:"
> > > Have a look at the patch in the .tgz. I tried to make it as clean as I
> > > could. Every change I made in the md.c code is commented. There are 4
> > > "hunks" of changes to md.c, to allow hotadd after setfaulty, and about
> > > ten significant hunks of changes to raid1.c, inserting the extra
> > > technology. There is some extra debugging code in that, which I can
> > 
> > In fact - I'll publish and go through the patch here. Here we go.
> 
>   1) change hotadd function in md.c with the objective of permitting
>      hotadd after setfaulty ("hotrepair") which should preserve a
>      bitmap which has been previously added to the disk metadata in
>      the main array (during setfaulty).
> 
>   2) change write code in raid1.c to mark the bitmap of every mirror
>      component disk which is marked not operational, if it has a bitmap.

Can I suggest a somewhat different approach?

Rather than having several bitmaps, have just one.  Normally it is
full of zero and isn't touched.
When a write fails, or when a write is sent to some-but-not-all
devices, set the relevant bit in the bitmap.
The first time you set a bit, record the current 'event' number with
the bitmap.

The interpretation of this bit map is 'only the blocks that are
flagged in this bitmap have changed since event X'.

On hot-add, read the old superblock.  If it looks valid and matches
the current array, and has an event counter of X or more, then ignore
blocks that have their bits set in the bitmap which reconstructing,
otherwise do a full reconstruction.

When we have a full compliment of devices again, clear the bitmap and
the event record.

The advantages of this include:
  - only need one bitmap
  - don't need the hot_repair concept - what we have is more general.
  - don't need to update the bitmap (which would have to be a
    bus-locked operation) on every write.
Disadvantages:
  - if two devices fail, will resync some blocks on the later one that
    don't require it.


As for ths other bits about a block device 'fixing itself' - I think
that belongs in user-space.  Have some program monitoring things and
re-adding the device to the array when it appears to be working again.

NeilBrown
