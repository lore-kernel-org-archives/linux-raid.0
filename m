From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Filesystem corruption MD (imsm) Raid0 via 2 SSD's + discard
Date: Wed, 20 May 2015 20:12:31 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1505201918570.4751@praktifix.dwd.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I had a terrible weekend recovering my home system. Always when files
where deleted some data got corrupted. At first I did not notice it,
but when I rebooted the system would not come up again, systemd crashed
with SIGSEGV and that was it. Booting from an USB stick I saw that
some glibc lib had a different size from that in the original RPM. So
all I did reinstalled that lib from USB stick and everything was fine
after rebooting from Raid 0. But I then wanted to make sure that
no other files where corrupted so I checked and found more. So again I
reinstalled those RPM's and rebooted. To my big surprise the system was
again broken and failed to boot. I again tried to recover my system
from USB stick, but this time did not manage to recover the system. So
decided to reinstall the system completely from DVD. Everything looked good
until that moment when I had activated the discard option in /etc/fstab.
After doing some more work (adding and removing things) I rebooted and
again the system failed to boot. Booting from the USB stick I saw that
the /etc/fstab was all filled with NULL's. This gave me the clue that
there must be some problem with discard (trim). My system is using
a software raid 0 IMSM (intel 'fake' raid) on two Samsung SSD 840 pro.

A window system on the same disks (that is why I am using IMSM raid)
was not effected by this problem. I have checked the ram with memtest86
and everything is ok. The kernel I was running when I discovered the
problem was 4.0.2 from kernel.org. However, after reinstalling from DVD
I updated to Fedora's lattest kernel, which was 3.19.? (I do not remember
the last numbers). So that kernel seems also effected, but I assume it
contains many 'fixes' from 4.0.x. As filesystem I use ext4, distribution
is Fedora 21 and hardware is: Xeon E3-1275, 16GB ECC Ram.

My system seems to be now running stable for some days with kernel.org
kernel 4.0.3 and with discard DISABLED. But I am still unsure what could
be the real cause.

Regards,
Holger
