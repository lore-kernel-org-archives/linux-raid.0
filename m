From: Stephan van Hienen <stephan@a2000.nu>
Subject: powersupply for 16disks +dual xeon
Date: Sat, 1 Feb 2003 18:32:16 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0302011823430.6789@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

today tried to put 16 disks (15*ide7200 +1*scsi7200) in a intel sc5200
case
(which has an 450W powersupply)

when i try to powerup the system, the powersupply goes off after 3 seconds
i think this is because off the spinupp for the disks

any tips how to fix this ?
(as far as i know there is no spinup delay for ide disks)
maximum powersupply i found is 550W, not much more than i have in my
system

(i need an 24pin xeon powersupply)

(disks are WD180GB (which asks 15W for spinup)
