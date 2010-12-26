From: Carl Cook <CACook@quantum-sci.com>
Subject: Is It Hopeless?
Date: Sun, 26 Dec 2010 10:19:55 -0800
Message-ID: <201012261019.56481.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I went in to turn on my home theater system today, and found a blank screen.  I rebooted and it would not mount /home, which is a 4TB RAID10 array with every movie and show I've recorded over the past two years.  I try to mount it manually, and "wrong fs or bad superblock".  The array is getting set up fine, but the filesystem seems to be destroyed.  

Unbelievable.  This isn't supposed to happen.  It happened once before when I wasn't using RAID, but that was the BTRFS filesystem and I blamed it for being pre-release.  But now it's RAID10 with JFS.

The only sign of trouble:
Dec 25 16:14:56 cygnus shutdown[2180]: shutting down for system reboot
Dec 25 16:14:58 cygnus kernel: [16607.840197] md: md2 stopped.
Dec 25 16:14:58 cygnus kernel: [16607.840210] md: unbind<sdb3>
Dec 25 16:14:58 cygnus kernel: [16607.852029] md: export_rdev(sdb3)
Dec 25 16:14:58 cygnus kernel: [16607.852083] md: unbind<sdc3>
Dec 25 16:14:58 cygnus kernel: [16607.864031] md: export_rdev(sdc3)
Dec 25 16:14:58 cygnus kernel: [16607.864092] md2: detected capacity change from 1913403736064 to 0
Dec 25 16:15:00 cygnus kernel: Kernel logging (proc) stopped.

Reboot:
Dec 25 16:15:48 cygnus kernel: [    1.156657] Uniform CD-ROM driver Revision: 3.20
Dec 25 16:15:48 cygnus kernel: [    1.464298] md: raid10 personality registered for level 10
Dec 25 16:15:48 cygnus kernel: [    1.469307] md: md2 stopped.
Dec 25 16:15:48 cygnus kernel: [    1.470540] md: bind<sdc3>
Dec 25 16:15:48 cygnus kernel: [    1.470642] md: bind<sdb3>
Dec 25 16:15:48 cygnus kernel: [    1.471381] raid10: raid set md2 active with 2 out of 2 devices
Dec 25 16:15:48 cygnus kernel: [    1.476048] md2: bitmap initialized from disk: read 14/14 pags, set 0 bits
Dec 25 16:15:48 cygnus kernel: [    1.476050] created bitmap (223 pages) for device md2
Dec 25 16:15:48 cygnus kernel: [    1.488465] md2: detected capacity change from 0 to 1913403736064
Dec 25 16:15:48 cygnus kernel: [    1.488942]  md2: unknown partition table
Dec 25 16:15:48 cygnus kernel: [    1.597375] PM: Starting manual resume from disk
Dec 25 16:15:48 cygnus kernel: [    1.650832] kjournald starting.  Commit interval 5 seconds
