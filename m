From: George Duffield <forumscollective@gmail.com>
Subject: Rebuilding a RAID5 array after drive (hardware) failure
Date: Thu, 22 May 2014 06:31:58 +0200
Message-ID: <CAG__1a52uiLi8PAm6deHyx14yQ8JfOmaiOicEn86kYBqJG_1HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a RAID5 array comprised of 4 x 3TB Seagate 7200 RPM SATAII
drives.    The array was created on Ubuntu Server running on a HP
Microserver N54L using the following command:

sudo mdadm --create --verbose /dev/md0 --raid-devices=3D4 --level=3D5
/dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1

=46ormatted using:
mkfs.ext4 -b 4096 -E stride=3D128,stripe-width=3D384 /dev/md0

The array is mounted in /etc/fstab by reference to its UUID and is now
near full.

A few days back I turned on the server to access some of the files
stored on it when I found the server was not present on the network.
Inspecting the actual server (connected kb & monitor) I noticed that
the machine had not progressed beyond the BIOS post screen =E2=80=93 on=
e of
the drives had become damaged (2nd drive in same slot in same
Microserver to be damaged the same way =E2=80=93 drive spins up fine, m=
achine
knows it's there, but can't communicat successfully with the drive).
In any event, suffice it to say the drive is history =E2=80=93 it and t=
he
Microserver will be RMAd when this is over.

So, I'm now left with a degraded array comprising 3x3TB drives. I've
purchased a replacement drive (same make and model) in the interim
(and I've yet to boot this machine with the old drive removed or the
new one inserted i.e. from an OS standpoint Ubuntu/mdadm does not yet
know the array is degraded).

As I've lost complete faith in the Microserver (and it may very well
damage the new drive during recovery of the array) I've also purchased
and assembled a 2nd machine with 6 on board SATA ports rather than
rely on another Microserver.  My intention is to remove the drives
from the Microserver and install them in the new machine (which I'll
boot off the same USB flash drive I used to boot the Microserver from
[to further complicate things it seems my flash drive may also be
corrupted, so I may have to recover from a fresh Ubuntu install and
reassemble the array]).

A few questions if I may:
- Is moving the array to another computer and recovering it on the new
computer running Ubuntu Server likely to present any particular
challenges?

- Does the order/ sequence of connection of the drives to the
motherboard matter?

Another way of asking the aforementioned question is whether mdadm
would care if one swapped drives in Microserver backplane/ PC SATA
ports such that the physical backplane slot/ SATA port that one/more
of the drives occupies differs from that it occupied when the array
was created?

- How would I best approach rebuilding the array, my current thinking
is as follows:
=3D Identify with certainty which drive has failed - this will be done
by removing the OS flash drive from the Microserver and disconnecting
all drives from the backplane other than the one I believe is faulty
(first slot on backplane) and booting the machine.  The failed drive
causes a POST failure and is thus easily identified.
=3D Remove all drives from the Microserver and install into new PC
referenced above, at the same time replacing the failed drive with the
replacement I purchased
=3D Powering new PC via UPS
=3D Booting the PC from the flash drive
=3D Allowing the degraded array to be assembled by mdadm when prompted =
at boot
=3D Adding the replacement drive to the array and allowing the array to
be re-synchronized
=3D If I'm not able to access the flash drive I will create a fresh
install of Ubuntu Server and attempt to recreate the array in the
fresh install.

All thoughts/ comments/ guidance much appreciated.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
