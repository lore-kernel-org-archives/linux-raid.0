From: "Dan" <dan@korstad.net>
Subject: RE: new features time-line
Date: Fri, 13 Oct 2006 19:14:50 -0500
Message-ID: <000b01c6ef25$c498bb50$eb00000a@mine3ad5e808fe>
References: <45300FC5.80806@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45300FC5.80806@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mike Hardy' <mhardy@h3c.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good to hear.  

I think when I first built my RAID (a few years ago) I did some research on
this;
http://www.google.com/search?hl=en&q=bad+block+replacement+capabilities+mdad
m

And found stories where bit errors were an issue.
http://www.ogre.com/tiki-read_article.php?articleId=7

After your email, I went out and researched it again.  Eleven months ago a
patch to address this was submitted for RAID5, I would assume RAID6
benefited from it too? 

_______________________________________
http://kernel.org/pub/linux/kernel/v2.6/testing/ChangeLog-2.6.15-rc1 

Author: NeilBrown <neilb@suse.de>
Date:   Tue Nov 8 21:39:22 2005 -0800

    [PATCH] md: better handling of readerrors with raid5.
    
    This patch changes the behaviour of raid5 when it gets a read error.
    Instead of just failing the device, it tried to find out what should
have
    been there, and writes it over the bad block.  For some media-errors,
this
    has a reasonable chance of fixing the error.  If the write succeeds, and
a
    subsequent read succeeds as well, raid5 decided the address is OK and
    conitnues.
    
    Instead of failing a drive on read-error, we attempt to re-write the
block,
    and then re-read.  If that all works, we allow the device to remain in
the
    array.
    
    Signed-off-by: Neil Brown <neilb@suse.de>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>
_________________________________________________


So the vulnerability would exist only if the bad bit stuck at the some
parity information and another at a data sector that needed that exact
parity information which is next to impossible and closer to impossible with
RAID6 since there would need to be loss the data sector and both the same p
and q parity information at the same time.

Thus less benefit for splitting up the drives in sections for logical
volumes is less useful.  And RAID6 provides the added benefit for bit errors
during a single drive degraded array as opposed to RAID5. 

Nevertheless, I would still use the LVM system to split the new replacement
drives if I had a method to utilize the extra drive space of the few new
replacements prior to replacing all of them.  Otherwise I suppose practice
patients and wait until they are all replaced to use the current grow -G -z
max feature.

Thanks,
Dan.



-----Original Message-----
From: Mike Hardy [mailto:mhardy@h3c.com] 
Sent: Friday, October 13, 2006 5:14 PM
To: Dan
Subject: Re: new features time-line


Not commenting on your overall premise, but I believe bit errors are
already logged and rewritten using parity info by md

-Mike

Dan wrote:
> I am curious if there are plans for either of the following;
> -RAID6 reshape
> -RAID5 to RAID6 migration
> 
> Here is why I ask, and sorry for the length.
> 
> I have an aging RAID6 with eight 250G drives as a physical volume in a
> volume group.  It is at about 80% capacity.  I have had a couple drives
fail
> and replaced them with 500G drives.  I plan to migrate the rest over time
as
> they drop out.  However this could be months or years.
> 
> I could just be patient and wait until I have replaced all the drives and
> use the -G -z max  to grow the RAID to resize the array to the maximum
> space.  But I could use the extra space sooner.
> 
> Since I already have the existing RAID (md0) as a physical volume in a
> volume group, I though why not just use the other half of the drives and
> create another RAID6 (md1) add that to the same volume group and so on as
I
> grow. md0 made from devices=/dev/sd[abcdefgh]1; md1 made from
> devices=/dev/sd[abcdefgh]2; and so on (I could have the md number match
the
> partition number for aesthetics I suppose)...  
> 
> By doing this I further protect myself from possible bit error rate on
> increasingly large drives.  So if there are suddenly three bit errors I
have
> a chance as long as they are not all on the same partition number.  Mdadm
> will only kick out the bad partitions and not the whole drive. (I know I
am
> already doing RAID6, what are the chances of three!).
> 
> To get to my point, I would like to split the new half of the drives into
a
> new physical volume and would 'like' to try to start using some of the
> drives before I have replace all the existing 250G drives.  If RAID6
reshape
> was an option I could start once I have replaced at least three of the old
> drives (built it as a RAID6 with one missing).  But it is not available,
> yet.  Or, since RAID5 reshape is an option, I could again start when I
have
> replaced three (built it as a RAID5) than grow it to until I get to the
> eighth drive and migrate to the final desired RAID6.  But that is not an
> option, yet.
> 
> Thoughts?
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



