From: Norbert Preining <preining@logic.at>
Subject: Is data on a `failed-disk' secure after a reboot? (raid1)
Date: Thu, 11 Mar 2004 12:10:57 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040311111057.GG16350@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I have set up a raid1 on our server with hda and hdc, but the partition=
s
of hda are marked as failed-disk in /etc/raidtab.
Then I did mkraid all the devices, mke2fs (-j) and copied all the files=
=2E
This worked all very well.

Now: What will happen when I reboot?

Using the persistent superblock option will linux (2.4.25) start syncin=
g
hdc onto hda or will it treat hda still as failed-disk?

I will/would reboot with lilo options
        root=3D/dev/md0
but the kernel is on hda1 (for now, until hda is added to the raid)

Reason for the question: I want to run several tests before completely
switching and want to be able to go back to normal hda behaviour.

In case you need these data:
linux-2.4.25 (self compiled)
debian/woody
raidtools2 0.90.20010914-15
(no I am not using mdadm ATM, because all the howtos were written for
raidtools. I will switch to mdadm, lateron)

Please Cc: me any answer, thanks a lot.


Best wishes

Norbert

-----------------------------------------------------------------------=
--------
Norbert Preining <preining AT logic DOT at>         Technische Universi=
t=E4t Wien
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 0=
9C5 B094
-----------------------------------------------------------------------=
--------
KIRBY MISPERTON (n.)
One who kindly attempts to wipe an apparent kirby (q.v.) off another's
face with a napkin, and then discovers it to be a wart or other
permanent fixture, is said to have committed a 'kirby misperton'.
			--- Douglas Adams, The Meaning of Liff
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
