From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Bad blocks are killing us!
Date: Tue, 16 Nov 2004 09:27:17 +1100
Message-ID: <16793.11589.337840.541169@cse.unsw.edu.au>
References: <200411150522.iAF5MNN18341@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Guy Watkins on Monday November 15
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <guy@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday November 15, guy@watkins-home.com wrote:
> Neil,
> 	This is a private email.  You can post it if you want.
snip
> 
> 	Anyway, in the past there have been threads about correcting bad
> blocks automatically within md.  I think a RAID1 patch was created that will
> attempt to correct a bad block automatically.  Is it likely that you will
> pursue this for RAID5 and maybe RAID6?  I hope so.

My current plans for md are:

 1/ incorporate the "bitmap resync" patches that have been floating
    around for some months.  This involves a reasonable amount of
    work as I want them to work with raid5/6/10 as well as raid1.
    raid10 is particularly interesting as resync is quite different
    from recovery there.

 2/ Look at recovering from failed reads that can be fixed by a
    write.  I am considering leveraging the "bitmap resync" stuff for
    this.  With the bitmap stuff in place, you can let the kernel kick
    out a drive that has a read error, let user-space have a quick
    look at the drive and see if it might be a recoverable error, and
    then give the drive back to the kernel.  It will then do a partial
    resync based on the bitmap information, thus writing the bad
    blocks, and all should be fine.  This would mean re-writing
    several megabytes instead of a few sectors, but I don't think that
    is a big cost.  There are a few issues that make it a bit less
    trivial than that, but it will probably be my starting point.
    The new "faulty" personality will allow this to be tested easily. 

 3/ Look at background data scans - i.e. read the whole array and
    check that parity/copies are correct.  This will be triggered and
    monitored by user-space.  If a read error happens during the scan,
    we trip the recovery code discussed above.

While these are my current intentions, there are no guarantees and
definitely no time frame.
I get to spend about 50%-60% of my time on this at the moment, so
there is hope.

> 	About RAID6, you have fixed a bug or 2 in the last few weeks.  Would
> you consider RAID6 stable (safe) yet?

I'm not really in a position to answer that.

The code is structurally very similar to raid5, so there is a good
chance that there are no races or awkward edge cases (unless there
still are some in raid5).
The "parity" arithmetic has been extensively tested out of the kernel
and seems to be reliable.
Basic testing seems to show that it largely works, but I haven't done
more than very basic testing myself.

So it is probably fairly close to stable.  What it really needs is
lots of testing.
Build a filesystem on a raid6 and then in a loop:
  mount / do metadata-intensive stress test  / umount / fsck -f

while that is happening, fail, remove, and re-add various drives. 
Try to cover all combinations of failing active drives and
spaces-being-rebuilt while 0, 1, or 2 drives are missing.

Try using a "faulty" device and causing it to fail as well as just 
"mdadm --set-faulty".

If you cannot get it to fail, you will have increased your confidence
of it's safety.

NeilBrown
