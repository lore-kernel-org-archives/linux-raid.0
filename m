From: Neil Brown <neilb@suse.de>
Subject: Re: raid10f2. mismatch_cnt=128. 'repair' does nothing.
Date: Sat, 18 Sep 2010 15:37:17 +1000
Message-ID: <20100918153717.75821cb6@notabene>
References: <AANLkTik5y-83xR=wR3=weXxLOegOeub3=jCuMMV5umjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik5y-83xR=wR3=weXxLOegOeub3=jCuMMV5umjw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 17 Sep 2010 22:40:54 -0500
Jon Nelson <jnelson-linux-raid@jamponi.net> wrote:

> I have a raid10f2 across 2 drives.
> I happened to note (only by chance!) that mismatch_cnt was 128, after
> a periodic 'check' (/sys/block/md0/md/sync_action).
> A quick google seemed to suggest that a 'repair' was in order.
> mismatch_cnt reset to 0, and I waited 2 hours.
> mismatch_cnt is now 128 again, but *no* kernel messages about the
> repair were output, except:
> 
> [463639.341245] md: requested-resync of RAID array md0
> [463639.341252] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [463639.341257] md: using maximum available idle IO bandwidth (but not
> more than 200000 KB/sec) for requested-resync.
> [463639.341266] md: using 128k window, over a total of 483401728 blocks.
> [470612.805202] md: md0: requested-resync done.
> 
> This does not seem to be right.
> 
> Kernel: 2.6.34.4-0 from openSUSE 11.3 x86_64.
> 

Depends on what you mean by "right".

mismatch count is increased by both 'check' and 'repair'.  So 'repair'
confirms that it found the same things that 'check' found (or the same number
of them).
raid10 does not report any mismatches found or corrected in the kernel logs,
though it would report if it failed to correct something.
So the conclusion we can draw is that  raid10 attempted to correct all the
inconsistencies it found, and no error was reported during that correction.

So it is fairly likely that the inconsistency is actually corrected.

The best way to be sure is to run another 'check'.


Maybe raid10 (and other levels) should report inconsistencies when they are
found - I'm not sure.  Certainly they shouldn't during an initial sync, but
that is fairly easy to detect.  Equally any reports should be carefully
rate-limited so as not to produce too much noise, but that is fairly easy
too.  All that is required (assuming this is actually a good idea) is for
someone to do the work. :-)

NeilBrown
