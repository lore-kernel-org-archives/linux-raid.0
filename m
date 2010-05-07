From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Spare drive won't spin down
Date: Thu, 6 May 2010 22:07:35 -0700
Message-ID: <i2j4877c76c1005062207t8c8729av6d1a1d36b9ec9365@mail.gmail.com>
References: <922812.29139.qm@web31703.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <922812.29139.qm@web31703.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Bryant <tenminjoe@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 6, 2010 at 10:49 AM, Joe Bryant <tenminjoe@yahoo.com> wrote=
:
> Hello -
>
> I hope some kind soul is able to help. I have configured a RAID1 arra=
y - two mirrored drives, one spare. My understanding is that the spare =
disk should =A0be allowed to spin down, but it won't.
>
> When I searched for troubleshooting information, I found talk of work=
 that had been done specifically to allow the spare to spin down - to d=
o with decrementing the event counter instead of incrementing it. So, I=
'm surprised this doesn't seem to be working in my case.
>
> If I poll /proc/diskstats, I see writes to the spare drive (sdb1) eve=
ry few seconds.
>
> If I remove the drive from the RAID array, the writes stop and it is =
able to spin down.
>
> If I do "mdadm --examine /dev/sdb1", I can see the event counter is i=
ncreasing every two or three seconds.
>
> The kernel is 2.6.32-21-generic - a new Ubuntu 10.04 install.
>
> /proc/mdstat yields:
>
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] =
[raid4] [raid10]
> md0 : active raid1 sdb1[2](S) sda1[0](W) sdc1[1]
> =A0 =A0 =A029295552 blocks [2/2] [UU]
>
> md1 : active raid1 sdb5[2](S) sda5[0](W) sdc5[1]
> =A0 =A0 =A01951680 blocks [2/2] [UU]
>
> unused devices: <none>
>
> Other facts that I don't think should be relevant but you may know be=
tter:
>
> - You can see that in fact I have two RAID arrays - md0 is the
> troublesome one.
>
> - md0 contains LVM, which contains ext4, which contains root filesyst=
em.
>
> - sdc is an SSD drive. sda and sdb are spinning disks.
>
> - If I do "cat /sys/block/md0/md/safe_mode_delay" I get "0.210".
>
> - I briefly had write-intent bitmaps set up for both md0 and md1, but=
 I have since removed them.
>
> This box is a fresh build and can be rebuilt if that's necessary to f=
ix
> or diagnose the problem.
>
> Thanks in advance for any help. Linux software RAID is just terrific =
- I report this minor issue largely because, as I said, it seems like t=
his is something that is *supposed* to work.
>
> --
> Joe Bryant
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

So you want a near-line spare, or whatever the term is.

Not quite a 'hot' spare; which is what you have now (and with RAID1
makes no sense as an additional mirror improves performance,
distributes load, and keeps a ready backup for almost the same cost).
Nor a 'cold' spare; sitting on a shelf out of the box.

More of a 'warm' spare; in the box, ready to kick in as soon as needed
but otherwise spun down and idled.

I'm unsure if the mdadm framework currently supports it.  If it does
you should look in to creating a 'spare group' and having the 'spare'
in that group (which should only change when it's pulled out and added
to a different group/array).  It would thus be able to idle the drive
but keep the non-moving parts responsive to the system.

Or at least that's how I'd guess it works.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
