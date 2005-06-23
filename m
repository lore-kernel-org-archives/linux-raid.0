From: "Preben Mikael Bohn" <preben@chin.dk>
Subject: Detection of drive failure using external USB2/firewire disks
Date: Thu, 23 Jun 2005 13:29:44 +0200 (CEST)
Message-ID: <31298.193.163.1.105.1119526184.squirrel@mail.chin.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all, I'm completely new to RAID but I think I have understood the
basics. :-)

I am thinking about setting up a home-server with SW-RAID-1 on two
external USB2 (or firewire) drives. Only var and home (and possibly tmp)
will be mounted on these drives.

My main objective is to have a low-cost, reliable (but not necessarily
fast) system at home; with USB2 devices it is also easy to swap drives
without opening the box. I have spent too many hours restoring from
backups due to failed mechanical hardware. The only mechanical hardware
left in my system now are these two harddrives (and the backup harddrive).

I don't see any problems using external USB2 drives for RAID-1 in normal
operation (am I wrong here?). However my question is: How does the RAID SW
detect a drive failure on such external drives? _Will_ it be able to
detect which drive is failing if for example one of the drives simply
starts to send out garbage data? I assume that most USB<->ATA bridges
implements some kind of minimal set of commands used for normal operation,
but failing drives are not "normal" as such...

If the RAID SW is not able to detect which drive is failing I can just as
well avoid using RAID...

Any thoughts?

Best regards Preben

