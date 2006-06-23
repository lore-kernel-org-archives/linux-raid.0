From: Paul Davidson <Paul.Davidson@anu.edu.au>
Subject: Re: Is shrinking raid5 possible?
Date: Fri, 23 Jun 2006 12:17:19 +1000
Message-ID: <449B4F2F.40707@anu.edu.au>
References: <44960C45.9050407@anu.edu.au> <17558.10906.59066.196870@cse.unsw.edu.au> <449B3A80.4070602@tmr.com> <17563.17224.85968.572754@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17563.17224.85968.572754@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> In short, reducing a raid5 to a particular size isn't something that
> really makes sense to me.  Reducing the amount of each device that is
> used does - though I would much more expect people to want to increase
> that size.
> 
> If Paul really has a reason to reduce the array to a particular size
> then fine.  I'm mildly curious, but it's his business and I'm happy
> for mdadm to support it, though indirectly.  But I strongly suspect
> that most people who want to resize their array will be thinking in
> terms of the amount of each device that is used, so that is how mdadm
> works.

By way of explanation, I was doing exactly what you thought - I had a
single ext3 filesystem on a raid5 device, and wanted to split it into
two filesystems. I'm not using LVM since it appears to affect read
performance  quite severely. I guess there may be other ways of doing
this but this seemed the most straightforward.

Incidentally, it wasn't clear to me what to do after shrinking the
raid5 device. My initial try at taking it offline and repartitioning
all the disks at once didn't work - I think because the superblocks
became 'lost'. I eventually realized I should go through a
fail-remove-repartition-add-recover cycle for each disk in turn with
the array online. It took a long time but worked in the end.

Would repartitioning them all at once have worked if I had chosen to
have the superblocks at the beginning of the partitions (v1.1 or 1.2
superblocks)?

As for Bill's comment about the mdadm interface, what probably would
have helped me the most is if the man page had had "from each drive"
in bold, flashing and preferably two-foot tall letters :-).

A more practical suggestion is if the error message had not been
    "No space left on device"
but something like
    "Maximum space available on each device is xxxxxxxx"
then I would have quickly realized my mistake.  As Neil points out,
you have to 'do the math' anyway when partitioning.

Cheers,
Paul
