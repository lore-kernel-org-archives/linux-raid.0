From: Jeff Wiegley <jeffw@csun.edu>
Subject: Why would a recreation cause a different number of blocks??
Date: Thu, 24 Apr 2014 15:25:45 -0700
Message-ID: <53598F69.5070700@csun.edu>
References: <20140424070548.445497dd@netstation>	<20140424194832.2d0a867f@netstation>	<CAK_KU4a+Ep7=F=NSbb-hqN6Rvayx4QPWm-M2403OHn5-LVaNZw@mail.gmail.com>	<20140424203506.5fdee0d3@netstation>	<CAK_KU4Zh-azXEEzW4f1m=boCZDKevqaSHxW0XoAgRdrCbm2PkA@mail.gmail
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK_KU4ZDi7qUNKft7+GH8mLcKG0yq1KBg6hn1DV9jgc=BN02tw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Still trying to restore my large storage system with out
total screwing up. There are two different raid md devices.
both had their superblocks wiped and one of the six drives
is screwed (the other 5 are fine).

Before the human failure: (OS reinstall and I only deleted
the MD devices in the ubuntu installer. I think this just
zeros the md superblocks of the affected partitions)

Personalities : [raid6] [raid5] [raid4] [raid1] [linear] [multipath]
[raid0] [raid10]
md3 : active raid6 sda1[0] sdc1[2] sde1[4] sdb1[1] sdd1[6]
       1073735680 blocks super 1.2 level 6, 512k chunk, algorithm 2 [6/5]
[UUUUU_]

I recreated the device with:

mdadm --create --assume-clean --level=6 --raid-devices=6 /dev/md0
/dev/sdd1 /dev/sdb1 /dev/sde1 /dev/sdc1 /dev/sda1 missing

and now it reports:
root@nas:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sda1[4] sdc1[3] sde1[2] sdb1[1] sdd1[0]
       1073215488 blocks super 1.2 level 6, 512k chunk, algorithm 2 [6/5]
[UUUUU_]

Why did my block counts change? The disk partitions weren't touched
or changed at any point. Shouldn't I have gotten the same size?

The created device isn't work. There is suppose to be luks encrypted
volume there but luksOpen reports there is no luks header. (and there
use to be). Would the odd change in size indicate total corruption?

- Jeff


