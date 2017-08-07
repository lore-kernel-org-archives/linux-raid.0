From: Felix Koop <fdp@fkoop.de>
Subject: mdadm will only start root device degraded
Date: Mon, 07 Aug 2017 09:51:05 +0200
Message-ID: <1502092265.23002.9.camel@fkoop.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have the following problem: /dev/md2 is my root device. This is a
raid1 device consisting of 2 partitions (sdg1 and sdf1). Booting in
this configuration worked fine.

When I decided to encrypt those partitions, I started to encrypt one of
them (sdg1). Now the array always starts degraded with the encrypted
sdg1 (cryptorootg) missing. I am asked during boot process for the
password and the encrypted device is unlocked successfully. But the
raid is not set up correctly. I have to run after every boot

mdadm /dev/md2 --add /dev/mapper/cryptorootg

and then device is sync'ing and working fine until next reboot. An
entry in /etc/crypttab was created.

What do I have to configure differently to have mdadm recognising the
raid device correctly during boot?



-- 
Mit freundlichen Grüßen

Felix Koop
fkoop@fkoop.de
