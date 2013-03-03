From: "Dragon" <Sunghost@gmx.de>
Subject: Possible to rescue SW Raid5 with 2 missing Disks
Date: Sun, 03 Mar 2013 22:59:23 +0100
Message-ID: <20130303215923.186450@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
i had the idea to check old mails and found that:
active raid5 sda4[0] sdf4[5] sde4[4] sdd4[3](F) sdc4[2] sdb4[1], after that i see that sf4 fails too. 
So all looks like the sdd4 fails first. Now is the question which steps i have to make for rescue - blocks sizes etc. - now i would do "mdadm --create --level 5 -n 6 --chunk=512 --assume-clean /dev/md2 /dev/sd{a,b,c,f,e}4 missing" and than mount the raid into the mountpoint to look to the files. is that the way?

need help.
