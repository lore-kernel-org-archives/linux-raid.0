From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid 6 - TLER/CCTL/ERC
Date: Wed, 06 Oct 2010 07:57:58 -0400
Message-ID: <4CAC6446.3080204@turmel.org>
References: <556404795.674.1286344296358.JavaMail.root@mail.networkmayhem.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <556404795.674.1286344296358.JavaMail.root@mail.networkmayhem.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Zieba <pzieba@networkmayhem.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/06/2010 01:51 AM, Peter Zieba wrote:
> Hey all,
> 
> I have a question regarding Linux raid and degraded arrays.
> 
> My configuration involves:
>  - 8x Samsung HD103UJ 1TB drives (terrible consumer-grade)
>  - AOC-USAS-L8i Controller
>  - CentOS 5.5 2.6.18-194.11.1.el5xen (64-bit)
>  - Each drive has one maximum-sized partition.
>  - 8-drives are configured in a raid 6.
> 
> My understanding is that with a raid 6, if a disk cannot return a given sector, it should still be possible to get what should have been returned from the first disk, from two other disks. My understanding is also that if this is successful, this should be written back to the disk that originally failed to read the given sector. I'm assuming that's what a message such as this indicates:
> Sep 17 04:01:12 doorstop kernel: raid5:md0: read error corrected (8 sectors at 1647989048 on sde1)
> 
> I was hoping to confirm my suspicion on the meaning of that message.
> 
> On occasion, I'll also see this:
> Oct  1 01:50:53 doorstop kernel: raid5:md0: read error not correctable (sector 1647369400 on sdh1).
> 
> This seems to involved the drive being kicked from the array, even though the drive is still readable for the most part (save for a few sectors).

[snip /]

Hi Peter,

For read errors that aren't permanent (gone after writing to the affected sectors), a "repair" action is your friend.  I used to deal with occasional kicked-out drives in my arrays until I started running the following script in a weekly cron job:

#!/bin/bash
#
for x in /sys/block/md*/md/sync_action ; do
        echo repair >$x
done


HTH,

Phil
