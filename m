From: Francois Barre <francois.barre@gmail.com>
Subject: Raid5 over sbp2 : sbp2 command abort
Date: Mon, 30 Jan 2006 14:50:03 +0100
Message-ID: <fd8d0180601300550k7316bb14t@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello all,

This is a cross-post (sorry for that), but I don't know where it comes =
from yet.
A. The setup
VIA EPIA 10k Nehemiah, OHCI with VIA
4 sbp2 250Go IDE drives
Vanilla 2.6.15.1 kernel, mdadm 2.2, superblock 0.90
ohci1394+sbp2 in kernel (default params : serialize_io=3D1, ...), raid5
as a module.

B. The tests
Test0 : Creating a 4-drive raid5 with 1 drive missing, copying the 4th
drive content to the raid5, works great.
Stress-testing multiple drive copy seems to be ok (Test0 + various
tests), very responsive, absolutely no error, but Test1 has a lot of
'command abort' errors, which blocks io for seconds, then starts
again.

Test1 : Building from scratch the raid5 with 4 drives (i.e. none
missing), causes 'sbp2 : command abort' messages.
At the end of Test1, raid5 is not created : one drive is set faulty.

C. The questions :
How could I run a parano=EFd/degraded bandwidth mode ? I tried playing
with /proc/sys/dev/raid/speed_limit_max, reducing to far away from
highest bandwidth, but it did not have the expected behaviour : io
runs to highest bw for seconds, then stops, then runs again at highest
rate, ...
Is there a way to avoid write back at sbp2 level ? I could not find
any way to do so...

What kernel version should I rather use ? Seems like scsi on 2.6.15.x
is not really trustworthy, should I run 2.6.14.x ?

Best regards,

=46.-E.B.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
