From: Jon Lewis <jlewis@lewis.org>
Subject: RE: raid5 won't resync
Date: Tue, 31 Aug 2004 04:08:27 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0408310401070.1949@web1.mmaero.com>
References: <200408310408.i7V48p307444@watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408310408.i7V48p307444@watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org, aaron@america.com
List-Id: linux-raid.ids

On Tue, 31 Aug 2004, Guy wrote:

> I have read where someone else had a similar problem.
> The slowdown was caused by a bad hard disk.
>
> Do a dd read test of each disk in the array.
>
> Example:
> time dd if=/dev/sdj of=/dev/null bs=64k

All of these finished at about the same time with no read errors reported.

> Someone else has said:
> Performance can be bad if the disk controller is sharing an interrupt with
> another device.
> It is ok for 2 of the same model cards to share 1 interrupt.

Since it's an SMP system, IO APIC gives us lots of IRQs and there is no
sharing.

           CPU0       CPU1
  0:     739040    1188881    IO-APIC-edge  timer
  1:        173        178    IO-APIC-edge  keyboard
  2:          0          0          XT-PIC  cascade
 14:     355893     353513    IO-APIC-edge  ide0
 15:    1963919    1944260    IO-APIC-edge  ide1
 20:       7171       7690   IO-APIC-level  eth0
 21:          2          3   IO-APIC-level  eth1
 23:    1540742    1537849   IO-APIC-level  qlogicfc
 27:    1540624    1539874   IO-APIC-level  qlogicfc

Since the recovery had stopped making progress, I decided to fail the
drive it had brought in as the spare with mdadm /dev/md2 -f /dev/sdf1.
That worked as expected.  mdadm /dev/md2 -r /dev/sdf1 seems to have hung.
It's in state D and I can't terminate it.  Trying to add a new spare,
mdadm can't get a lock on /dev/md2 because the previous one is stuck.

I suspect at this point, we're going to have to just reboot again.

----------------------------------------------------------------------
 Jon Lewis                   |  I route
 Senior Network Engineer     |  therefore you are
 Atlantic Net                |
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
