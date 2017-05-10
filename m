From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: RFC - Raid error detection and auto-recovery (was Fault
 tolerance with badblocks)
Date: Wed, 10 May 2017 19:07:44 +0200
Message-ID: <20170510170744.GB2925@lazy.lzy>
References: <591314F4.2010702@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <591314F4.2010702@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>, Nix <nix@esperi.org.uk>
List-Id: linux-raid.ids

On Wed, May 10, 2017 at 02:26:12PM +0100, Wols Lists wrote:
> This discussion seems to have become a bit heated, but I think we have
> the following:
> 
> FACT: linux md raid can do error detection but doesn't. Why not? It
> seems people are worried about the performance hit.
> 
> FACT: linux md raid can do automatic error correction but doesn't. Why
> not? It seems people are more worried about the problems it could cause
> than the problems it would fix.
> 
> OBSERVATION: The kernel guys seem to get fixated on kernel performance
> and miss the bigger picture. At the end of the day, the most important
> thing on the computer is the USER'S DATA. And if we can't protect that,
> they'll throw the computer in the bin. Or replace linux with Windows. Or
> something like that. And when there's a problem, it all too often comes
> over that the kernel guys CAN fix it but WON'T. The ext2/3/4 transition
> is a case in point. The current frustration where the kernel guys say
> "user data is the application's problem" but the postgresql guys are
> saying "how can we guarantee integrity when you won't give us the tools
> we need to guarantee our data is safe".
> 
> This situation smacks of the same arrogance, sorry. "We can save your
> data but we won't".
> 
> FURTHER FACTUAL TIDBITS:
> 
> The usual response seems to be to push the problem somewhere else. For
> example "The user should keep backups". BUT HOW? I've investigated!
> 
> Let's say I buy a spare drive for my backup. But I installed raid to
> avoid being at the mercy of a single drive. Now I am again because my
> backup is a single drive! BIG FAIL.
> 
> Okay, I'll buy two drives, and have a backup raid. But what if my backup
> raid is reporting a mismatch count too? Now I have TWO copies where I
> can't vouch for their integrity. Double the trouble. BIG FAIL.
> 
> Tape is cheap, you say? No bl***ding way!!! I've just done a quick
> investigation, and for the price of a tape drive I could probably turn
> my 2x3TB raid-1 into a 3x3TB raid-5, AND buy sufficient disks to
> implement a raid-based grandfather/father/son backup procedure, and
> STILL have some change left over. (I am using cheapie desktop drives,
> but I could probably afford cheap NAS drives with that money.)
> 
> PROPOSAL: Enable integrity checking.
> 
> We need to create something like /sys/md/array/verify_data_on_read. If
> that's set to true and we can check integrity (ie not raid-0), rather
> than reading just the data disks, we read the entire stripe, check the
> mirror or parity, and then decide what to do. If we can return
> error-corrected data obviously we do. I think we should return an error
> if we can't, no?
> 
> We can't set this by default. The *potential* performance hit is too
> great. But now the sysadmin can choose between performance or integrity,
> rather than the present state where he has no choice. And in reality, I
> don't think a system like mine would even notice! Low read/write
> activity, and masses of spare ram. Chances are most of my disk activity
> is cached and doesn't go anywhere near the raid code.
> 
> The kernel code size impact is minimal, I suspect. All the code required
> is probably there, it just needs a little "re-purposing".
> 
> PROPOSAL: Enable automatic correction
> 
> Likewise create /sys/md/array/correct_data_on_read. This won't work if
> verify_data_on_read is not set, and likewise it will not be set by
> default. IFF we need to reconstruct the data from a 3-or-more raid-1
> mirror or a raid-6, it will rewrite the corrected stripe.
> 
> RATIONALE:
> 
> NEVER THROW AWAY USER DATA IF YOU CAN RECONSTRUCT IT !!!
> 
> This gives control to the sysadmin. At the end of the day, it should be
> *his* call, not the devs', as to whether verify-on-read is worth the
> performance hit. (Successful reconstructions should be logged ...)
> 
> Likewise, while correct_data_on_read could mess up the array if the
> error isn't actually on the drive, that should be the sysadmin's call,
> not the devs'. And because we only rewrite if we think we have
> successfully recreated the data, the chances of it messing up are
> actually quite small. Because verify_data_on_read is set, that addresses
> Neil's concern of changing the data underneath an app - the app has been
> given the corrected data so we write the corrected data back to disk.
> 
> NOTES:
> 
> >From Peter Anvin's paper it seems that the chance of wrongly identifying
> a single-disk error is low. And it's even lower if we look for the clues
> he mentions. Because we only correct those errors we are sure we've
> correctly identified, other sources of corruption shouldn't get fed back
> to the disk.
> 
> This makes an error-correcting scrub easy :-) Run as an overnight script...
> cat 1 > /sys/md/root/verify_data_on_read
> cat 1 > /sys/md/root/correct_data_on_read
> tar -c / > /dev/null
> cat 0 > /sys/md/root/correct_data_on_read
> cat 0 > /sys/md/root/verify_data_on_read
> 
> 
> Coders and code welcome ... :-)

I just would like to stress the fact that
there is user-space code (raid6check) which
perform check, possibily repair, on RAID6.

bye,

> 
> Cheers,
> Wol
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
