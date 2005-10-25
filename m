From: Jeff Breidenbach <jeff@jab.org>
Subject: Re: split RAID1 during backups?
Date: Mon, 24 Oct 2005 20:37:03 -0700
Message-ID: <E1EUFcV-0005s3-00@toko.jab.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Ok... thanks everyone!

David, you said you are worried about failure scenarios
involved with RAID splitting. Could you please elaborate?
My biggest concern is I'm going to accidentally trigger
a rebuild no matter what I try but maybe you have something
more serious in mind.

Brad, your suggestion about kernel 2.6.13 and intent logging and
having mdadm pull a disk sounds like a winner. I'm going to to try it
if the software looks mature enough. Should I be scared?

Dean, the comment about "write-mostly" is confusing to me.  Let's say
I somehow marked one of the component drives write-mostly to quiet it
down. How do I get at it? Linux will not let me mount the component
partition if md0 is also mounted. Do you think "write-mostly" or
"write-behind" are likely enough to be magic bullets that I should
learn all about them?

Bill, thanks for the suggestion to use nbd instead of netcat.  Netcat
is solid software and very fast, but does feel a little like duct
tape. You also suggested putting a third drive (local or nbd remote)
temporarily in the RAID1. What does that buy versus the current
practice of using dd_rescue to copy the data off md0? I'm not
imagining any I/O savings over the current approach.

John, I'm using 4KB blocks in reiserfs with tail packing. All sorts of
other details are in the dmesg output [1]. I agree seeks are a major
bottleneck, and I like your suggestion about putting extra spindles
in. Master-slave won't work because the data is continuously changing.
I'm not going to argue about the optimality of millions of tiny files
(go talk to Hans Reiser about that one!) but I definitely don't foresee
major application redesign any time soon.

Most importantly, thanks for the encouragement. So far it sounds like
there might be some ninja magic required, but I'm becoming
increasingly optimistic that it will be - somehow - possible manage
disk contention in order to dramatically raise backup speeds.

Cheers,
Jeff

[1] http://www.jab.org/dmesg
