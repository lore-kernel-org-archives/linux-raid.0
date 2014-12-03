From: =?UTF-8?Q?Csord=C3=A1s_Csaba?= <cscsordas@gmail.com>
Subject: RAID1 + power fail + unwanted activation
Date: Wed, 3 Dec 2014 17:20:05 +0100
Message-ID: <CABpXQ7bb4Sz7DZshAsry_+XO1x0p3jaSR3diYNj3t3CqCYV5pA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

after a power fail I was afraid so I was thinking about making a full
gzipped image with dd from both members of my level1 array to be able
to go back to the "original" (before the crash) state in case if
*something* goes wrong during rebuild/lvm activation/fsck.

The other machine I put the disk in unfortunately also had mdadm
installed which automatically activated the degraded array (only one
member of the array was connected) at boot time.

Now, if i just put the disks back in the crashed machine, will the
right thing happen while the kernel is resyncing the blocks between
the devices? The internal bitmap was turned on, but the event counter
on the mistakenly activated member of the array might have changed. I
don't know how this -or other things I am not aware of- relates to the
actual reassembly of my RAID1 array. I'm looking for an authoritative
answer to understand the situation.


Csord=C3=A1s Csaba
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
