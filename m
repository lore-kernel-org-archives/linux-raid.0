From: Neil Brown <neilb@suse.de>
Subject: Re: recovering data on a failed raid-0 installation
Date: Wed, 29 Mar 2006 16:31:33 +1100
Message-ID: <17450.7093.694274.976614@cse.unsw.edu.au>
References: <200603282208.47214.technomage-hawke@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Technomage on Tuesday March 28
Sender: linux-raid-owner@vger.kernel.org
To: Technomage <technomage-hawke@cox.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 28, technomage-hawke@cox.net wrote:
> ok,
> here's the situation in a nutshell.
> 
> one of the 2 HD's in a linux raid-0 installation has failed.
> 
> Fortunately, or otherwise, it was NOT the primary HD.

What do you mean by "primary HD".  All drives in a raid-0 are equal.

> 
> problem is, I need to recover data from the first drive but appear to be 
> unable to do so because the raid is not complete. the second drive only had 
> 193 MB written to it and I am fairly certain that the data I would like to 
> recover is NOT on that drive.

Why do you think only 193MB was written to the second drive?  raid0
will normally write equal amounts to all drives.

> 
> can anyone offer any solutions to this?
> 
> the second HD is not usable (heat related failure issues). 
> 
> The filesystem used on the md0 partition (under mdadm) was xfs. now I have 
> tried the xfs_check and xfs_repair tools and they are not helpful at this 
> point.
> 
> The developer (of mdadm) suggested I use the following commands in an attempt 
> to recover:
> 
>   mdadm -C /dev/md0 -l0 -n2 /dev/......
>   fsck -n /dev/md0
> 
> However, the second one was a no go.

Exactly how was it a "no go"?
However if the second drive is really not usable, then your data is
gone.

> 
> I am stumped as to how to proceed here. I need the data off the first drive, 
> but do not appear to have any way (other than using cat to see it) to get at 
> it.

Your data isn't on the first drive.  It is half on the first drive and
half on the second drive.
However if you really really think most of the data is on the first
drive, you could try getting another blank drive, combining it with
the working drive in a raid0, and xfs_check/xfs_repair that.

Sorry we cannot be more helpful, but raid0 provide zero protection
against device failure.

> 
> some help would be greatly appreciated.
> 
> technomage
> 
> p. here is the original response sent back to me from the developer
> of mdadm:

For future reference, it is generally considered bad form to post a
privately received mail message to a public list.  Not that I have
particular problems with it in this case, but it is best to avoid
things that are considered "bad form".

NeilBrown
