From: Jeff Hill <jhill@hronline.com>
Subject: Re: Removing a Raid Partition? How-to?
Date: Wed, 15 May 2002 11:48:29 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.0.14.0.20020514195224.01f7cd18@205.233.215.4>
References: <message from Jeff Hill on Tuesday May 14>
 <Pine.LNX.4.31L.02.0205141604120.12302-100000@linux2.gl.umb c.edu>
 <5.1.0.14.0.20020514171826.01f64070@205.233.215.4>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15585.38640.715130.181439@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you. I tried the zero-superblock before but must have done something 
wrong because it worked this time.

For academic interest, raidstart was not being run at boottime; nothing was 
starting raid except the kernel (2.4.16). I tried changing the partition 
types to both standard Linux partitions and to Windows partitions, and I 
tried doing it with and without  the /etc/raidtab file It didn't seem to 
make any difference. The systems were originally built as Debian (Woody and 
Sid) with the raidtools2 packages.

I thought of trying to boot with a non-raid kernel, but that would have 
been a mess when it came to doing this on a production machine where all 
partitions are raid autodetect.

Thanks for the assist (and thanks to Gernot Weber too),

Jeff Hill


At 09:00 AM 15/05/2002 +1000, Neil Brown wrote:
>On Tuesday May 14, jhill@hronline.com wrote:
> > Oddly, it seems I can't change the partitions of a previously formatted
> > raid disk.  When I use fdisk to repartition a drive previously formatted
> > with the type set to Linux autoraid detect, I reboot only to find the
> > autoraid partitions are still there. I have stopped the raid devices, but
> > it seems I can't kill the persistent superblock. I tried reformatting with
> > mke2fs and of course that failed to do the trick.
>
>If you change the partition type to something else, it really
>shouldn't autodetect any more.. Do you have an /etc/raidtab describing
>the array, and is raidstart being run at boottime by some script?
>
>In any case,
>    mdadm --zero-superblock /dev/hda1
>
>will zero the md/raid superblock on /dev/hda1
>
>NeilBrown
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

