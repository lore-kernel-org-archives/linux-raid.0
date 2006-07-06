From: Neil Brown <neilb@suse.de>
Subject: Re: zeroing old superblocks & upgrading...
Date: Fri, 7 Jul 2006 09:09:08 +1000
Message-ID: <17581.38932.532010.388731@cse.unsw.edu.au>
References: <17581.36135.379062.709693@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from John Stoffel on Thursday July 6
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday July 6, john@stoffel.org wrote:
> 
> Neil,
> 
> First off, thanks for all your hard work on this software, it's really
> a great thing to have.
> 
> But I've got some interesting issues here.  Though not urgent.  As
> I've said in other messages, I've got a pair of 120gb HDs mirrored.
> I'm using MD across partitions, /dev/hde1 and /dev/hdg1.  Works
> nicely.
> 
> But I see that I have an old superblock sitting around on /dev/hde
> (notice, no partition here!) which I'd like to clean up.
> 
...
> 
> I can't seem to zero it out:
> 
>   # mdadm --misc --zero-superblock /dev/hde
>   mdadm: Couldn't open /dev/hde for write - not zeroing
> 
> Should I just ignore this, or should I break off /dev/hde from the
> array and scrub the disk and then re-add it back in?

You could ignore it - it shouldn't hurt.
But if you wanted to (and were running a fairly recent kernel) you
could
  mdadm --grow --bitmap=internal /dev/md0
  mdadm /dev/md0 --fail /dev/hde1 --remove /dev/hde1
  mdadm --zero-superblock /dev/hde
  mdadm /dev/md0 --add /dev/hde1
  mdadm --grow --bitmap=none /dev/md0

and it should work with minimal resync...

Though thinking about it - after the first --grow, check that the
unwanted bitmap is still there.  It is quite possible that the
internal bitmap will over-write the unwanted superblock (depending on
the exact size and aligment of hde1 compared with hde).
If it is gone, then don't bother with the rest of the sequence. 


> 
> Also, can I upgrade my superblock to the latest version with out any
> problems?

The only problem with superblock version numbers is that they are
probably confusing.  If you don't worry about them, they should just
do the right thing.

NeilBrown
