From: "Phantazm" <phantazm@phantazm.nu>
Subject: Re: [PATCH md 0 of 9] Introduction
Date: Fri, 18 Feb 2005 15:25:35 +0100
Message-ID: <cv4tne$o06$1@sea.gmane.org>
References: <20050218111131.790.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Would you recommend to apply this package 
http://neilb.web.cse.unsw.edu.au/~neilb/patches/linux-devel/2.6/2005-02-18-00/patch-all-2005-02-18-00
To a 2.6.10 kernel?

Thank you for a bery good raid tool :)

"NeilBrown" <neilb@cse.unsw.edu.au> skrev i meddelandet 
news:20050218111131.790.patches@notabene...
>
> 9 patches for md in 2.6.11-rc3-mm2 follow.
>
> 1 - tightens up some locking to close a race that is extremely unlikely
>    to happen (famous last words).  It can only happen when failed devices 
> are
>    being removed.
> 2 - Fixes a resync related problem for raid5 and raid6 arrays that have
>    lost more devices than they can cope with.
> 3 - Fixes a clumsy test that has very little real effect (just a printk).
>
> These three can be considered stable.
>
> 4,5 Improve handling of 'safemode' which is where we mark the superblock
>    clean whenever there have been no writes for a little while, and mark
>    it dirty before the next write.
> 6-9 Introduce "bitmap based intent logging" which allows a file to
>    store - as a bitmap - all block that may have been written recently.
>    This allow resync to be optimised, which is more important as drives
>    get larger.
>
> These should not be considerred stable - certainly actually using
> the bitmap mode (which requires a 2.0 series version of mdadm) should
> be seen as 'experimental'.
>
> mdadm-2.0-devel-1  was released today.
>
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



