From: Billy Crook <billycrook@gmail.com>
Subject: Re: raid-0 with mdadm vs lvm striping
Date: Wed, 12 Aug 2009 11:00:51 -0500
Message-ID: <a43edf1b0908120900u32226a01w16edc9075282ee9f@mail.gmail.com>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B2E99EDBB63@SE-EX008.groupinfra.com>
	<c268e4660908111435x81d080fva423c5ea78605fc2@mail.gmail.com>
	<3ECBDC05781B3D48ABD520A01ABF2F9B2E9A0485D5@SE-EX008.groupinfra.com>
	<87vdkt4e5x.fsf@frosties.localdomain> <3ECBDC05781B3D48ABD520A01ABF2F9B2E9A048A82@SE-EX008.groupinfra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3ECBDC05781B3D48ABD520A01ABF2F9B2E9A048A82@SE-EX008.groupinfra.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Henry, Andrew" <andrew.henry@logica.com>
Cc: "goswin-v-b@web.de" <goswin-v-b@web.de>, Drew <drew.kay@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Aug 12, 2009 at 04:14, Henry, Andrew<andrew.henry@logica.com> w=
rote:
> That's what my question was: =A0Will raid0 (striping) be faster or ea=
sier to manage than lvm striping

LVM striping won't change performance for small files. (That is files,
smaller than the extent size.)  To be fair, RAID-0 striping won't
accelerate file access for files smaller than the stripe size either.
However, traditionally, raid0 stripe sizes are much much smaller than
LVM extent sizes.  Both are however adjustable.

Either way, you will be reading from one disk and then another, and
then another, etc.  The smaller the stripe size, the more likely
multiple disks will be doing their seeks and dma transfers at the same
time.  For this reason, I would recommend RAID-0 if you don't need
uptime, and you keep backups elsewhere, and all you need is the most
speed you can get.

LVM is more about flexibility than performance.  I don't use LVM
striping, but if I did, I would be using it to distribute wear between
multiple raid arrays; not for performance.

LVM on top of RAID is exceptionally common.  Use RAID for performance
and availability, then use LVM for flexibility.

"Easier to manage"?  Stop managing.  Start using.  With LVM on top of
raid, you can hot-move the logical volume off the raid0 array for
maintenance to the raid0 array.  You can extend it onto new raid0
arrays.  I'm fairly sure you can grow an existing raid0 array even
while it is in use onto additional disks.

But if you're playing with raid0 or lvm striping, I wouldn't as much
worry about being able to manage it while its in use.  Just do your
managing when you replace a failed disk (and have to recreate the
entire array or logical volume).
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
