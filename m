From: Lemur Kryptering <gottail@lemurdude.com>
Subject: Re: Raid 6 - TLER/CCTL/ERC
Date: Wed, 6 Oct 2010 09:12:12 -0500 (CDT)
Message-ID: <24774572.41286374326875.JavaMail.SYSTEM@ninja>
References: <30914146.21286374217265.JavaMail.SYSTEM@ninja>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <30914146.21286374217265.JavaMail.SYSTEM@ninja>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'll definitely give that a shot when I rebuild this thing.

In the meantime, is there anything that I can do to convince md not to kick the last disk (running on 6 out of 8 disks) when reading a bad spot? I've tried setting the array to read-only, but this didn't seem to help.

All I'm really trying to do is dd data off of it using "conv=sync,noerror". When it hits the unreadable spot, it simply kicks the drive from the array, leaving 4/8 disks active, taking down the array.

Again, I don't understand why md would take this action. It would make a lot more sense if it simply reported an IO error to whatever made the request.

Peter Zieba
312-285-3794

----- Original Message -----
From: "Phil Turmel" <philip@turmel.org>
To: "Peter Zieba" <pzieba@networkmayhem.com>
Cc: linux-raid@vger.kernel.org
Sent: Wednesday, October 6, 2010 6:57:58 AM GMT -06:00 US/Canada Central
Subject: Re: Raid 6 - TLER/CCTL/ERC

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
